FROM alpine:3.19
RUN apk add --no-cache mysql-client aws-cli

COPY ./backup.sh /
RUN chmod +x /backup.sh

CMD ["sh", "/backup.sh"]