# pull official base image
FROM python:3.10-slim-bullseye

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# set working directory
WORKDIR /opt

# copy application dependencies
COPY ./requirements.txt .

# install application dependencies
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# copy application
COPY . .

# run application
CMD ["python3", "/opt/src/main.py"]
