#!/bin/bash

echo "Запуск скрипта для добавления данных в DynamoDB..."

# Проверяем наличие AWS CLI
if ! command -v aws >/dev/null 2>&1; then
    echo "Ошибка: AWS CLI не найден!"
    exit 1
fi

# Добавляем данные в DynamoDB
aws dynamodb put-item \
  --table-name my-table \
  --item '{"id": {"S": "tomcat-test"}, "name": {"S": "Test from Tomcat"}, "value": {"S": "123"}}' \
  --region eu-central-1

if [ $? -eq 0 ]; then
    echo "Данные успешно добавлены в DynamoDB!"
else
    echo "Ошибка при добавлении данных в DynamoDB!"
    exit 1
fi

# Запускаем Tomcat
echo "Запуск Tomcat..."
exec /usr/local/tomcat/bin/catalina.sh run
