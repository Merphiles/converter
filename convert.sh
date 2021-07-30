#!/bin/sh
set -e
FILES=$(find ./ -name '*video.mjr')
FILESOPUS=$(find ./ -name '*audio.mjr')
set +e
for video in $FILES
do
  filename=$(echo $video | awk -F"-" '{print $1"-"$2"-"$3"-"$4"-"$5}')
  echo $video
  janus-pp-rec $video $filename"-video".webm >/dev/null 2>&1
for audio in $FILESOPUS
do
  echo $audio
  filename=$(echo $audio | awk -F"-" '{print $1"-"$2"-"$3"-"$4"-"$5}')
  janus-pp-rec $audio $filename"-audio".opus >/dev/null 2>&1
done
done
