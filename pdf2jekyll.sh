#!/bin/bash

. ./output.cfg

if [ $# -ne 1 ]; then
	echo "Please input one pdf filepath only."
	exit 1
fi

PDF_PATH="$(realpath "$1")"
# This is how Jekyll likes its filenames.
POST_FILENAME="${DATE}-${TITLE//" "/"-"}.md"
ASSETS_FOLDER_PATH="${OUTPUT}/${ASSETS_FOLDER}"
POSTS_FOLDER_PATH="${OUTPUT}/${POSTS_FOLDER}"
POST_PATH="${OUTPUT}/${POSTS_FOLDER}/${POST_FILENAME}"

if [ ! -d "$ASSETS_FOLDER_PATH" ]; then
	mkdir -p "$ASSETS_FOLDER_PATH"
fi

if [ ! -d "$POSTS_FOLDER_PATH" ]; then
	mkdir -p "$POSTS_FOLDER_PATH"
fi

echo "Creating ${POST_FILENAME}..."
touch "$POST_PATH"

echo "---" >> "$POST_PATH"
echo "layout: post" >> "$POST_PATH"
echo "title: ${TITLE}" >> "$POST_PATH"
echo "date: ${DATE}" >> "$POST_PATH"
echo "categories: ${CATEGORIES}" >> "$POST_PATH"
echo "---" >> "$POST_PATH"
echo >> "$POST_PATH"

cd "$ASSETS_FOLDER_PATH"
echo "Creating PDFs into ${ASSETS_FOLDER_PATH} from ${PDF_PATH}..."
pdftoppm "$PDF_PATH" slide -png
cd "$OLDPWD"

counter=1
for FILE in $(cd ${ASSETS_FOLDER_PATH};ls -1 ${FILE});
do
	echo "![Page ${counter}](/${ASSETS_FOLDER}/${FILE})" >> "$POST_PATH"
	((counter=counter+1))
done


echo "Finished! Copy the contents of ${OUTPUT} directly into the root of your jekyll project!"

