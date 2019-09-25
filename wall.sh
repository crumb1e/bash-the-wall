#!/bin/bash

category=$1
url="https://source.unsplash.com/6000x4000/?"

image_url="${url}${category}"

image=$(wget --output-document=image.png ${image_url})

gsettings set org.gnome.desktop.background picture-uri $PWD/image.png
