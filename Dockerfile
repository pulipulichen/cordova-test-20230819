FROM beevelop/cordova:v2023.04.1

COPY docker-build/startup.sh /startup.sh
WORKDIR /

CMD [ "bash", "/startup.sh" ]