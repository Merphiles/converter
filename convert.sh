#!/bin/sh
set -e
FILES=$(find ./ -name '*video.mjr')
set +e
for video in $FILES
do
  printf "\033[36mProcessing\033[0m $filename\n"
  printf "  -> \033[35mExtracting video\033[0m\n"
  janus-pp-rec $video $video.webm >/dev/null 2>&1
  filename=$(echo $video | awk -F"-" '{print $1"-"$2"-"$3"-"$4"-"$5}')
  printf "  -> \033[35mExtracting audio\033[0m\n"
  janus-pp-rec $filename"-audio.mjr" $filename"-audio".opus >/dev/null 2>&1
done