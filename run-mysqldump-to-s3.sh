#!/bin/bash

# NOTE: Also required to set the following environment variables in addition to what we use below:
# - MYSQL_ALLOW_EMPTY_PASSWORD=yes
# - AWS_ACCESS_KEY_ID=<AWS_ACCESS_KEY_ID>
# - AWS_SECRET_ACCESS_KEY=<AWS_SECRET_ACCESS_KEY>

# create db dump
echo $(date -u '+%Y-%m-%d %H:%M:%S') - Start creating MySQL dump file from "'$MYSQL_DB_NAME'" database ...
export MYSQL_PWD=$MYSQL_PASSWORD
mysqldump -P $MYSQL_PORT -h $MYSQL_HOST -u $MYSQL_USERNAME --ssl-mode=$MYSQL_SSL_MODE $MYSQL_DB_NAME > /tmp/dump.sql
echo $(date -u '+%Y-%m-%d %H:%M:%S') - Finish creating MySQL dump file.

# gzip
echo $(date -u '+%Y-%m-%d %H:%M:%S') - Start gzipping the dump file...
gzip /tmp/dump.sql
echo $(date -u '+%Y-%m-%d %H:%M:%S') - Finish gzipping the dump file.

# upload to S3 bucket
echo $(date -u '+%Y-%m-%d %H:%M:%S') - Start uploading the dump file to "'$AWS_S3_BUCKET_NAME'" bucket...
aws s3api put-object --bucket $AWS_S3_BUCKET_NAME --key "db-dumps/db-dump_${MYSQL_DB_NAME}_$(date -u '+%Y-%m-%d_%H-%M-%S')-sql.gz" --body /tmp/dump.sql.gz
echo $(date -u '+%Y-%m-%d %H:%M:%S') - Finish uploading the dump file.
