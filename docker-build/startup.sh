#!/bin/bash

app_dir="/app"

rm -f /output/*.apk
rm -f /app/platforms/android/app/build/outputs/bundle/release/*.aab

# Check if /app directory is empty
if [ -z "$(ls -A $app_dir)" ]; then
  echo "n" | cordova create app "$APP_ID" "$APP_NAME"
  cd /app
  cordova platform add android
else
    echo "The directory $app_dir is not empty."
fi

cd /app

# =================

config_file="/app/config.xml"
resource_line='<resource-file src="my-release-key.keystore" target="/my-release-key.keystore" />'

if [ ! -e "$config_file" ]; then
    echo "Error: $config_file does not exist."
    exit 1
fi

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

if [ ! -e "/app/platforms/android/app/build/outputs/bundle/release/app-release.aab" ]; then
    echo "Error: app-release.aab does not exist. Maybe build with error."
    exit 1
fi

# =================

echo "password" | java -jar /bundletool.jar build-apks --bundle=/app/platforms/android/app/build/outputs/bundle/release/app-release.aab --output=/output/my-apks.apks
java -jar /bundletool.jar extract-apks --apks=/output/my-apks.apks --output-dir=/output --device-spec=/device.json 

# =================

mv /output/base-master.apk /output/base-master.tmp
rm -rf /output/*.apks
rm -rf /output/*.apk
mv /output/base-master.tmp /output/app.apk