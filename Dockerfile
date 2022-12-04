FROM mysql:5.7.22

# Install AWS CLI
RUN	apt-get update \
  && apt-get install -y \
  python3-pip \
  screen \
  && pip3 install awscli \
  && chmod 777 /run/screen \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir /app

COPY run-mysqldump-to-s3.sh /app

RUN chmod +x /app/*.sh
