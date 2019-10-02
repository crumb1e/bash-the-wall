#!/bin/bash

category=$1
categories=$@
url="https://source.unsplash.com/6000x4000/?"

# don't output a comma before the first argument. There is probably a better way to do this.
comma=""
for i in ${categories}; do
    url="${url}${comma}$i"
    comma=","
done

image_url="${url}"


image=$(wget --output-document=$HOME/.wallpaper/temp_image.jpeg ${image_url}) &&

mv ~/.wallpaper/temp_image.jpeg ~/.wallpaper/image.jpeg &&
rm -rf ~/.wallpaper/temp_image.jpeg

feh --bg-scale ~/.wallpaper/image.jpeg
