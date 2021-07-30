#!/bin/sh
set -e
FILES=$(find ./ -name '*video.mjr')
FAILED=""
if [ ! -x "$(command -v ffmpeg)" ]; then
  printf "\033[31mERROR\033[0m This script requires \033[1mffmpeg\033[0m\n"
  exit 1
fi

if [ ! -x "$(command -v janus-pp-rec)" ]; then
  printf "\033[31mERROR\033[0m This script requires \033[1mjanus-pp-rec\033[0m\n"
  exit 1
fi

set +e
for video in $FILES
do
  filename=$(echo $video | awk -F"-" '{print $1"-"$2"-"$3"-"$4"-"$5}')
  if [ -f $filename"-audio.mjr" ]; then
    printf "\033[36mProcessing\033[0m $filename\n"
    printf "  -> \033[35mExtracting video\033[0m\n"
    janus-pp-rec $video $filename.webm >/dev/null 2>&1
    RESULT=$?
    printf "  -> \033[35mExtracting audio\033[0m\n"
    janus-pp-rec $filename"-audio.mjr" $filename.opus >/dev/null 2>&1
    RESULT=$?
    if [ $RESULT -eq 0 ]; then
      printf "  -> \033[32mComplete\033[0m\n"
    else
      rm -rf "$filename"*.webm
      rm -rf "$filename"*.opus
      FAILED="$FAILED "$filename
      printf "  -> \033[31mFailed\033[0m\n"
    fi
  fi
done
