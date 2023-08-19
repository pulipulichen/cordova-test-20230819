#!/bin/bash

app_dir="/app"

# Check if /app directory is empty
if [ -z "$(ls -A $app_dir)" ]; then
  cordova create app "$APP_ID" "$APP_NAME"
  cd /app
  cordova platform add android
else
    echo "The directory $app_dir is not empty."
fi

# =================

config_file="/app/config.xml"
resource_line='<resource-file src="my-release-key.keystore" target="/my-release-key.keystore" />'

# Check if the resource line exists in config.xml
if ! grep -qF "$resource_line" "$config_file"; then
    # Append the resource line just before </widget>
    sed -i -e "s#</widget>#$resource_line\n</widget>#" "$config_file"
    echo "Resource line added to $config_file"
else
    echo "Resource line already exists in $config_file"
fi

# =================

cd /app
echo "n" | cordova build android --release

# =================

echo "password" | java -jar /bundletool.jar build-apks --bundle=/app/platforms/android/app/build/outputs/bundle/release/app-release.aab --output=/output/my-apks.apks
java -jar /bundletool.jar extract-apks --apks=/output/my-apks.apks --output-dir=/output --device-spec=/device.json 

# =================

mv /output/base-master.apk /output/base-master.tmp
rm -rf /output/*.apks
rm -rf /output/*.apk
mv /output/base-master.tmp /output/app.apk