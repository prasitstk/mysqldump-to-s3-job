# mysqldump-to-s3-job

This is a simple project to run mysqldump to archive MySQL database into a zipped .sql file and upload into a S3 bucket

&nbsp;

### Create a new Amazon ECR private repository

Go to `AWS Console` (Select a region) > `Amazon ECR` > `Repositories` > `Private` > Press `Create repository` button > `Create repository` page.

Set up the repository as follows:
- Visibility settings = `Private`
- Repository name = `<aws-account-id>.dkr.ecr.<aws-region>.amazonaws.com/mysqldump-to-s3-job`
- (Other settings are left default)

---

&nbsp;

## Build the Docker image

Build the Docker image locally by the following command:

```sh
# Make sure your current directory is on the same directory that the Dockerfile exist. Then:
docker build -t <aws-account-id>.dkr.ecr.<aws-region>.amazonaws.com/mysqldump-to-s3-job .
```

---

&nbsp;

### Run the Docker image locally

Run the Docker image locally to perform its task by:

```sh
docker run -e AWS_ACCESS_KEY_ID='<AWS_ACCESS_KEY_ID>' \
  -e AWS_SECRET_ACCESS_KEY='<AWS_SECRET_ACCESS_KEY>' \
  -e AWS_REGION='<AWS_REGION>' \
  -e MYSQL_ALLOW_EMPTY_PASSWORD='<yes|no>' \
  -e MYSQL_HOST='<MYSQL_HOST>' \
  -e MYSQL_DB_NAME='<MYSQL_DB_NAME>' \
  -e MYSQL_PORT='<MYSQL_PORT>' \
  -e MYSQL_USERNAME='<MYSQL_USERNAME>' \
  -e MYSQL_PASSWORD='<MYSQL_PASSWORD>' \
  -e MYSQL_SSL_MODE='<MYSQL_SSL_MODE>' \
  --name mysqldump_to_s3_job
  <aws-account-id>.dkr.ecr.<aws-region>.amazonaws.com/mysqldump-to-s3-job \
  /app/run-mysqldump-to-s3.sh
```

Then remove the stopped container to clean up your local environment:

```sh
docker rm mysqldump_to_s3_job
```

---

&nbsp;

### Push the Docker image into the newly created Amazon ECR private repository

Push the Docker image to the remote repository by the following commands:

```sh
# Login the Amazon ECR with your temporarily credentials.
aws ecr get-login-password --region <aws-region> | docker login --username AWS --password-stdin <aws-account-id>.dkr.ecr.<aws-region>.amazonaws.com

# Now you are allowed to push the Dokcer image to it.
docker push <aws-account-id>.dkr.ecr.<aws-region>.amazonaws.com/mysqldump-to-s3-job
```

---
