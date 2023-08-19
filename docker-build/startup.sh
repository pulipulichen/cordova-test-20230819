#!/bin/bash

cordova create app com.example.hello HelloWorld
cd app
cordova platform add android
cordova build