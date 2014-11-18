#!/bin/bash

SCRIPT_NAME=$0
SCRIPT_PATH=$(readlink -m "$SCRIPT_NAME")

AUDIO_FILE=
IMAGE_FILE=
VIDEO_FILE=

AUDIO_RATE_BIT=128k
AUDIO_RATE_SAMPLE=44100

addImageToAudio_showUsage ()
{
  cat<<EOF
  usage: ${SCRIPT_NAME}
    -
EOF
}

###
# Parse any arguments provided via command line
###
while getopts ":a:i:v:h" opt; do
	case $opt in
	  a) ;;
	  i) ;;
	  v) ;;
	  h)
	    addImageToAudio_showUsage
	    exit 0
	    ;;
		\?)
			echo "Invalid option: -${OPTARG}" 1>&2
			echo "Run '$SCRIPT_NAME -h' for usage..." 1>&2
			exit 1
			;;
		:)
			echo "Option -${OPTARG} requires an argument." 1>&2
			echo "Run '$SCRIPT_NAME -h' for usage..." 1>&2
			exit 1
			;;
	esac
done

###
# Sanity provided arguments
# @TODO Validate image & audio file types
###
if [ -z "$AUDIO_FILE" ]; then
    echo "No audio file provided" >&2
    exit 1
elif [ -z "$IMAGE_FILE" ]; then
    echo "No image file provided" >&2
    exit 1
elif [ -z "$VIDEO_FILE" ]; then
    echo "No output file specified" >&2
    exit 1
elif [ ! -e "$AUDIO_FILE" ]; then
    echo "Audio file does not exist" >&2
    exit 2
elif [ -z "$IMAGE_FILE" ]; then
    echo "Image file does not exist" >&2
    exit 2
elif [ -e "$VIDEO_FILE" ]; then
    echo "Cannot overwrite output file" >&2
    exit 3
fi

###
# Execute the composition/transcoding job
###
ffmpeg \
    -loop 1 -i ${IMAGE_FILE} -i ${AUDIO_FILE} \
    -c:v libx264 -tune stillimage -b:v 1m \
    -strict experimental \
    -acodec libvo_aacenc -ab ${AUDIO_RATE_BIT} -ar ${AUDIO_RATE_SAMPLE} \
    -pix_fmt yuv420p -shortest \
    ${VIDEO_FILE}
