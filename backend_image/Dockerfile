FROM tomcat:8.5-jre8

RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    bash  \
    supervisor &&  rm -rf /var/lib/apt/lists/*

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip

RUN ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update && \
    /usr/local/bin/aws --version 

RUN rm -f awscliv2.zip && rm -rf aws && \
    /usr/local/bin/aws --version 

COPY add_to_dynamodb.sh /usr/local/bin/add_to_dynamodb.sh
RUN chmod +x /usr/local/bin/add_to_dynamodb.sh

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord"]
