FROM ubuntu:22.04

RUN apt update && apt install -y \
    python3 python3-pip \
    libcurl4-openssl-dev libssl-dev curl

WORKDIR /app

COPY requirements.txt .
RUN pip3 install -r requirements.txt

COPY . .

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]