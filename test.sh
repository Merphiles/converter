#!/bin/sh
set -e
FILES=$(find ./ -name '*video.mjr')
set +e
for video in $FILES
do
  echo $video
done
