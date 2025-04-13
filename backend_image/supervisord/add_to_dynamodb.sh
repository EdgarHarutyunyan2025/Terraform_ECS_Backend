#!/bin/bash

if ! command -v aws >/dev/null 2>&1; then
    mkdir /usr/local/tomcat/webapps/ROOT/
    echo "NOT AWS CLI" > /usr/local/tomcat/webapps/ROOT/index.html
    exit 1
fi

aws dynamodb put-item \
  --table-name my-table \
  --item '{"id": {"S": "tomcat-test"}, "name": {"S": "Test from Tomcat"}, "value": {"S": "123"}}' \
  --region eu-central-1

if [ $? -eq 0 ]; then
    mkdir /usr/local/tomcat/webapps/ROOT/
    echo "YES db"  > /usr/local/tomcat/webapps/ROOT/index.html
    aws dynamodb scan --table-name my-table >> /usr/local/tomcat/webapps/ROOT/index.html || echo "CHEXAV" >> /usr/local/tomcat/webapps/ROOT/index.html

else
    mkdir /usr/local/tomcat/webapps/ROOT/
    echo "NOT DB" > /usr/local/tomcat/webapps/ROOT/index.html
    exit 1
fi
