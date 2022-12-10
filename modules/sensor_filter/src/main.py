"""sensor filter module"""

import asyncio
import os
import random
import uuid

from azure.iot.device.aio import IoTHubModuleClient
from azure.iot.device import Message
from iot.edge.logger import init_logging

from version import __version__

TEMPERATURE = 20.0
MESSAGES = 10

# setup logging
logger = init_logging(module_name="sensor_filter")


async def main() -> None:
    """iot edge device module entrypoint"""
    logger.info("IoT Edge Module - sensor_filter")
    logger.info(f"running module v{__version__}")

    cnx_string = os.getenv("DEV_IOTHUB_DEVICE_CONNECTION_STRING")
    if cnx_string:
        if cnx_string == "change_me":
            logger.error(
                "the IoT hub device connection string has not been defined...\n"
                "please set this connection string in the docker-compose.yml file "
                "if you are developing locally"
            )
            return
        client = IoTHubModuleClient.create_from_connection_string(cnx_string)
    else:
        client = IoTHubModuleClient.create_from_edge_environment()

    # connect the client
    await client.connect()

    async def send_test_message(i: int) -> None:
        """send a device to cloud message"""
        logger.info(f"sending message #{i}")
        msg = Message(f"raspberry pi cpu temperature {i}")
        msg.message_id = uuid.uuid4()
        msg.correlation_id = "correlation-1234"
        msg.custom_properties["temperature"] = str(TEMPERATURE + (random.random() * 15))
        await client.send_message(msg)
        logger.info(f"done sending message #{i}")

    # send `messages_to_send` in parallel
    await asyncio.gather(*[send_test_message(i) for i in range(1, MESSAGES + 1)])

    # shut down the client
    await client.shutdown()


if __name__ == "__main__":
    asyncio.run(main())
