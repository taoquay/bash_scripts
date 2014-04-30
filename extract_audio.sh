#!/bin/bash
#
# TO-DO LIST
# 1. output how many successes at end
# 2. fix problem with Conversion of "*.mp4" completed.
# 3. Only output conversion success on success
# 4. Create "Done folder" if does not exist
# 5. Split code into functions
# 6. Add logic for overwriting existing mp3 file

# Extract AAC audio from flv file and convert into MP3 with same quality settings
for i in *.{flv,mp4}; do
	AUDIO_TYPE=`ffprobe "$i" 2>&1 | grep -o 'Audio: \w\{3\}'`
	AUDIO_TYPE=${AUDIO_TYPE: -3}
	FREQUENCY=`ffprobe "$i" 2>&1 | grep -o '.\{6\}Hz' | head -c 5`

	BITRATE=`ffprobe "$i" 2>&1 | grep -o '\d\{2,3\} kb\/s (default)' | grep -o '^\d\{2,3\}'`

	# Set minimum bitrate to 64 kb/s
	if [ $BITRATE -lt "64" ]
	then
		BITRATE="64"
	fi
	BITRATE="${BITRATE}k"

	M4A_FILE="${i%.*}.m4a"
	MP3_FILE="${i%.*}.mp3"

	if [ $AUDIO_TYPE == "aac" ]
	then
		ffmpeg -i "$i" -vn -acodec copy "$M4A_FILE" 2>/dev/null \
		&& ffmpeg -i "$M4A_FILE" -acodec libmp3lame -ab $BITRATE -ar $FREQUENCY "$MP3_FILE" 2>/dev/null \
		&& mv "$i" ./done \
		&& rm "$M4A_FILE" \
		&& ECHO "`date +%T`: Conversion of \"$i\" completed."
	else
		ffmpeg -i "$i" -vn -acodec copy "$MP3_FILE" 2>/dev/null \
		&& mv "$i" ./done \
		&& ECHO "`date +%T`: Conversion of \"$i\" completed."
	fi
done
