build:
	docker build -t malev/mysql-backup-s3 .

dev:
	docker-compose up

run:
	docker run --network mysql-backup-s3_default \
				-e MYSQL_HOST=db \
				-e MYSQL_USER=root \
				-e MYSQL_PASSWORD=password \
				-e MYSQL_PORT=3306 \
				-e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
				-e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
				-e AWS_DEFAULT_REGION=$AWS_REGION \
				-e AWS_BUCKET_URI=s3://$AWS_BUCKET \
				-e AWS_BUCKET_PATH=databases \
				-e DATABASES=wordpress malev/mysql-backup-s3
