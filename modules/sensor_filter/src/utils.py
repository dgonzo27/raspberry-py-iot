"""sensor filter utils"""

import asyncio
import logging
import os
import random
import uuid
from typing import Union

from azure.iot.device.aio import IoTHubModuleClient
from azure.iot.device import Message

TEMPERATURE_THRESHOLD: Union[int, str] = float(os.getenv("TEMPERATURE_THRESHOLD"))
MESSAGE_INTERVAL: Union[int, str] = int(os.getenv("MESSAGE_INTERVAL"))


async def filter_temperature_message(
    client: IoTHubModuleClient, logger: logging.Logger
) -> None:
    """send a device to cloud message if the temperature crosses the threshold"""
    await client.connect()

    while True:
        logger.debug("checking raspberry pi cpu temperature...")
        temperature = (TEMPERATURE_THRESHOLD - 14.0) + (random.randint(0, 10) * 15.0)
        if temperature > TEMPERATURE_THRESHOLD:
            logger.warning("temperature is above threshold!")
            id = uuid.uuid4()
            msg = Message(f"raspberry pi cpu temperature above threshold ({id})!")
            msg.message_id = id
            msg.correlation_id = f"correlation-{id}"
            msg.custom_properties["temperature"] = str(temperature)
            await client.send_message(msg)
            logger.info(f"done sending message ({id})")
        logger.debug("--------------------------------------------------\n\n")
        await asyncio.sleep(MESSAGE_INTERVAL)
