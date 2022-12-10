"""sensor filter module"""

import os
import signal
import threading
from typing import Any, Dict, Optional

from azure.iot.device.aio import IoTHubModuleClient
from iot.edge.logger import init_logging

from version import __version__

# setup logging
logger = init_logging(module_name="sensor_filter")

RECEIVED_MESSAGES = 0


def create_client(dev: Optional[bool] = False) -> IoTHubModuleClient:
    """instantiate module client and listener"""
    if dev:
        client = IoTHubModuleClient.create_from_connection_string(
            os.getenv("DEV_IOTHUB_DEVICE_CONNECTION_STRING")
        )
    else:
        client = IoTHubModuleClient.create_from_edge_environment()

    def receive_message_handler(message: Dict[str, Any]) -> None:
        global RECEIVED_MESSAGES

        # this function only handles messages sent to "input1"
        if message.input_name == "input1":
            RECEIVED_MESSAGES += 1
            logger.info("Message received on input1")
            logger.info(f"  Data: <<{message.data}>>")
            logger.info(f"  Properties: {message.custom_properties}")
            logger.info(f"  Total calls received: {RECEIVED_MESSAGES}")
            logger.info("Forwarding message to output1...")

            client.send_message_to_output(message, "output1")
            logger.info("Message successfully forwarded!")
        else:
            logger.info(f"Message received on unknown input: {message.input_name}")

    try:
        client.on_message_received = receive_message_handler
    except:
        client.shutdown()
    return client


def main() -> None:
    """iot edge device module entrypoint"""
    logger.info("IoT Edge Module - sensor_filter")
    logger.info(f"running module v{__version__}")

    # event indicating client stop
    stop_event = threading.Event()

    def module_termination_handler(signal: signal, frame: signal.SIGTERM) -> None:
        """cleanup module when terminated by edge"""
        print("module stopped by edge")
        stop_event.set()

    # set the edge termination handler
    signal.signal(signal.SIGTERM, module_termination_handler)

    dev = False  # running locally?
    if os.getenv("DEV_IOTHUB_DEVICE_CONNECTION_STRING"):
        cnx_string = os.getenv("DEV_IOTHUB_DEVICE_CONNECTION_STRING")
        if cnx_string == "change_me":
            logger.error(
                "the IoT hub device connection string has not been defined...\n"
                "please set this connection string in the docker-compose.yml file "
                "if you are developing locally"
            )
            return
        dev = True  # yes, we are running locally

    # instantiate client
    client = create_client(dev=dev)

    try:
        # this will be triggered by Edge termination signal
        logger.info("module is listening for invocations")
        stop_event.wait()
    except Exception as ex:
        logger.exception(f"unexpected exception occurred: {ex}")
        logger.error("unable to listen for invocations")
        raise
    finally:
        logger.info("shutting down module listener...")
        client.shutdown()


if __name__ == "__main__":
    main()
