FROM alpine:3.5
MAINTAINER Vladimir Marchenko <vladimir.v.marchenko@gmail.com>

RUN apk update --no-cache --allow-untrusted && apk upgrade --no-cache --allow-untrusted  && \
    apk add --no-cache --allow-untrusted  openjdk8-jre-base curl && \
     for i in "certs" "conf" "logs" "data"; do mkdir -p /app/$i ; done

WORKDIR /app

ENV BLYNK_SERVER_RELEASE 0.22.0
RUN curl -L "https://github.com/blynkkk/blynk-server/releases/download/v${BLYNK_SERVER_RELEASE}/server-${BLYNK_SERVER_RELEASE}.jar" > /app/server.jar

# Download latest version from github
#RUN curl -L  https://github.com/blynkkk/blynk-server/releases/download/v$(curl -s https://github.com/blynkkk/blynk-server/releases/latest | awk -F'<a href="' '{print $2}' | awk -F'">' '{print $1}' | awk -F'releases/tag/v' '{print $2}')/server-$(curl -s https://github.com/blynkkk/blynk-server/releases/latest | awk -F'<a href="' '{print $2}' | awk -F'">' '{print $1}' | awk -F'releases/tag/v' '{print $2}').jar > /app/server.jar

COPY ./app/certs /app/certs
COPY ./app/conf /app/conf

RUN apk del --no-cache curl && rm -rf /var/cache/apk/*

# IP port listing:
# 8443: Application mutual ssl/tls port
# 8442: Hardware plain tcp/ip port
# 8441: Hardware ssl/tls port (for hardware that supports SSL/TLS sockets)
# 8081: Web socket ssl/tls port
# 8082: Web sockets plain tcp/ip port
# 9443: HTTPS port
# 8080: HTTP port
# 7443: Administration UI HTTPS port
EXPOSE 7443 8080 8081 8082 8441 8442 8443 9443

VOLUME [ "/app/data", "/app/logs" ]

CMD java -jar /app/server.jar  -dataFolder /app/data -serverConfig /app/conf/server.properties

#-Djava.awt.headless=true
