FROM beevelop/cordova:v2023.04.1

COPY docker-build/bundletool.jar /bundletool.jar
COPY docker-build/my-release-key.keystore /my-release-key.keystore
COPY docker-build/device.json /device.json

WORKDIR /

CMD [ "bash", "/startup.sh" ]

COPY docker-build/startup.sh /startup.sh