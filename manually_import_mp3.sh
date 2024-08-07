#!/bin/bash

# Check if a folder path is provided as an argument
if [ $# -eq 0 ]; then
        echo "The proper usage is shown below, by running the script and then placing a folder after it."
    echo "Usage: $0 <folder_path>"
    exit 1
fi

folder="$1"

if find "$folder" -name "*.mp3" | grep -q .; then
# Iterates over files in the directory supplied
        for file in "$folder"/*.mp3

        do

        echo "Original file name:"
        echo $file


        # Pulls the metadata from the file
        # This does so much, pulls metadata, pulls main artist, pulls the part after the colon,
        # switches '/' to ' & ' using tr then sed due to weird quirks, then replaced '?' with an emoji,
        # then removes characters that can't be used in folders

        #Tries to get the album artist, which is better for sorting
        ARTIST=$(id3v2 -l "$file" | grep -oP 'TPE2 \([^)]*\): \K.*' | tr '/' '&' | sed 's/&/ & /g' | tr -d '?' | tr '/\\:*"<>|' '_')

        # Check if ARTIST is empty or not and if so then it'll pick the song artist (more likely to be combos of artists, which is worse for sorting and folders)
        if [ -z "$ARTIST" ]; then
                # Check if ARTIST is empty or not set
                ARTIST=$(id3v2 -l "$file" | grep "TPE1" | awk -F ": " '{print $2}' | tr '/' '&' | sed 's/&/ & /g' | tr -d '?' | tr '/\\:*"<>|' '_')
        fi

        ALBUM=$(id3v2 -l "$file" | grep "TALB" | awk -F ": " '{print $2}' | tr -d '?' | tr '/\\:*"<>|' '_')

        YEAR=$(id3v2 -l "$file" | grep "TCOP" | awk -F ": " '{print $2}' | sed -E 's/[^0-9]*([0-9]{4}).*/\1/' | tr '/\\:*?"<>|' ' ')

        TRACK_NUM=$(id3v2 -l "$file" | grep "TRCK" | awk -F ": " '{print $2}' | cut -d'/' -f1 )
        # Add leading zero if one digit
        if [ ${#TRACK_NUM} -eq 1 ]; then
            TRACK_NUM="0$TRACK_NUM"
        fi

        TRACK_NAME=$(id3v2 -l "$file" | grep "TIT2" | awk -F ": " '{print $2}' | tr '/\\:*"<>|' '_')

        # Makes a variable for the folder path to make for the file
        directory="/desired/music/directory/$ARTIST/$ALBUM ($YEAR)"

        echo "Moved to the following place:"
        echo "$directory/${TRACK_NUM} - ${TRACK_NAME}.mp3"
        echo

        # Makes the directory if it doesn't already exist (might conflict a bit with beet organization =\)
        if [ ! -d "$directory" ]; then
            mkdir -p "$directory"
        fi

        # Moves the file
        mv "$file" "$directory/${TRACK_NUM} - ${TRACK_NAME}.mp3"

        echo "$directory/${TRACK_NUM} - ${TRACK_NAME}.mp3" >> "$folder"/imported_files.txt

        done
        # This will delete the directory, which may be useful, but isn't on by default
        #rm -r "$1"
else
    echo "No MP3 files found in $folder"
fi
