# MySQL Backup S3

Docker image that performs a MySQL backup and uploads the result to S3.

## Usage

Create a file called `cron-job.yaml` with the following content:

```
apiVersion: batch/v1
kind: CronJob
metadata:
  name: mysql-backup
spec:
  schedule: "0 4 * * *" # At 04:00 AM-CT
  timeZone: "America/Chicago"
  jobTemplate:
    spec:
      template:
        spec:
          restartPolicy: Never
          containers:
            - name: mysql-backup
              image: malev/mysql-backup-s3
              imagePullPolicy: IfNotPresent
              env:
                - name: AWS_ACCESS_KEY_ID
                  value:
                - name: AWS_SECRET_ACCESS_KEY
                  value:
                - name: AWS_DEFAULT_REGION
                  value:
                - name: AWS_BUCKET_URI
                  value:
                - name: AWS_BUCKET_PATH
                  value:
                - name: MYSQL_HOST
                  value:
                - name: MYSQL_PORT
                  value:
                - name: DATABASES
                  value:
                - name: MYSQL_USER
                  value:
                - name: MYSQL_PASSWORD
                  value:
```

- `kubectl apply -f cron-job.yaml`
- `kubectl create job --from=cronjob/mysql-backup mysql-backup-test`

## Development

1. Build the image with `docker build -t malev/mysql-backup-s3 .`
2. Setup a local database to test: `docker-compose up`
3. Run:

```
docker run \
 --network mysql-backup-s3_default \
 -e MYSQL_HOST=db \
 -e MYSQL_USER=root \
 -e MYSQL_PASSWORD=password \
 -e MYSQL_PORT=3306 \
 -e AWS_ACCESS_KEY_ID=YOUR-ACCESS-KEY-ID \
 -e AWS_SECRET_ACCESS_KEY=YOUR-SECRET-ACCESS-KEY \
 -e AWS_DEFAULT_REGION=YOUR-REGION \
 -e AWS_BUCKET_URI=s3://YOUR-BUCKET \
 -e AWS_BUCKET_PATH=YOUR-BUCKET-PATH \
 -e DATABASES=wordpress,joomla malev/mysql-backup-s3
```

## TODO

- Compress file before upload.
- Notify results
- Add better instructions on how to run it
- Add instructions on how to setup the S3 bucket
- Manager releases
