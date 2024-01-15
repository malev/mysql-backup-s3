#/bin/sh

for MYSQL_DATABASE in ${DATABASES//,/ }
do
    NOW="$(date +"%Y-%m-%d")"
    STARTTIME=$(date +"%s")
    BACKUP_FILE=${MYSQL_DATABASE}_${NOW}.sql

    echo "Backing up $MYSQL_DATABASE at $NOW"
    if output=$(mysqldump -u $MYSQL_USER -p$MYSQL_PASSWORD -h $MYSQL_HOST -P $MYSQL_PORT $MYSQL_DATABASE 2>&1 > /tmp/$BACKUP_FILE)
    then
        echo -e "Success: The backup for $MYSQL_DATABASE has been created."
    else
        echo -e "Failure: The backup for $MYSQL_DATABASE has failed."
        echo $output
        exit 0
    fi

    if output=$(aws s3 cp /tmp/$BACKUP_FILE $AWS_BUCKET_URI/$AWS_BUCKET_PATH/$MYSQL_DATABASE/$BACKUP_FILE 2>&1)
    then
        echo -e "Success: $BACKUP_FILE has been uploaded to $AWS_BUCKET_URI/$AWS_BUCKET_PATH/$MYSQL_DATABASE/."
    else
        echo -e "Failure: $BACKUP_FILE was not uploaded to $AWS_BUCKET_URI/$AWS_BUCKET_PATH/$MYSQL_DATABASE/."
        echo $output
        exit 0
    fi
    ENDTIME=$(date +%s)
    echo "Elapsed Time: $(($ENDTIME-$STARTTIME)) seconds"
done

echo "All done"