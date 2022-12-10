"""sensor filter module"""

import asyncio
import os
from typing import Union

from azure.iot.device.aio import IoTHubModuleClient
from iot.edge.logger import init_logging

from utils import filter_temperature_message
from version import __version__

DEV_IOTHUB_DEVICE_CONNECTION_STRING: str = os.getenv(
    "DEV_IOTHUB_DEVICE_CONNECTION_STRING"
)

# setup logging
logger = init_logging(module_name="sensor_filter")


def create_client() -> Union[IoTHubModuleClient, None]:
    """instantiate an IoT Hub client"""
    try:
        if DEV_IOTHUB_DEVICE_CONNECTION_STRING is not None:
            if DEV_IOTHUB_DEVICE_CONNECTION_STRING == "change_me":
                logger.error(
                    "the IoT hub device connection string has not been defined...\n"
                    "please set this connection string in the docker-compose.yml file "
                    "if you are developing locally"
                )
                return None
            client = IoTHubModuleClient.create_from_connection_string(
                DEV_IOTHUB_DEVICE_CONNECTION_STRING
            )
        else:
            client = IoTHubModuleClient.create_from_edge_environment()
        return client
    except Exception as ex:
        logger.exception(f"unexpected exception occurred: {ex}")
        logger.error("unable to instantiate client")
        return None


def main() -> None:
    """iot edge device module entrypoint"""
    logger.info("IoT Edge Module - sensor_filter")
    logger.info("enter ctrl-c to exit")
    logger.info(f"running module v{__version__}\n\n")

    client = create_client()
    loop = asyncio.get_event_loop()
    try:
        loop.run_until_complete(filter_temperature_message(client, logger))
    except KeyboardInterrupt:
        logger.info("sensor_filter module stopped by user")
    finally:
        logger.warning("shutting down sensor_filter module")
        loop.run_until_complete(client.shutdown())
        loop.close()


if __name__ == "__main__":
    main()
