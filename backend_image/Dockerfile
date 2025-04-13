FROM tomcat:8.5-jre8

# Устанавливаем зависимости
RUN apt-get update && apt-get install -y curl unzip bash && rm -rf /var/lib/apt/lists/*

# Скачиваем и распаковываем AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ls -l aws/dist/aws  # Проверяем исходный бинарник

# Устанавливаем AWS CLI и сразу проверяем
RUN ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update && \
    ls -l /usr/local/bin/aws && \
    /usr/local/bin/aws --version && \
    echo "AWS CLI установлен и работает после установки"

# Удаляем временные файлы и проверяем снова
RUN rm -f awscliv2.zip && rm -rf aws && \
    ls -l /usr/local/bin/aws && \
    /usr/local/bin/aws --version && \
    echo "AWS CLI всё ещё работает после очистки"

# Копируем скрипт
COPY add_to_dynamodb.sh /usr/local/bin/add_to_dynamodb.sh
RUN chmod +x /usr/local/bin/add_to_dynamodb.sh

# Запускаем скрипт как точку входа
CMD ["/usr/local/bin/add_to_dynamodb.sh"]
