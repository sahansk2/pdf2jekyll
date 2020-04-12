#!/bin/bash

. ./output.cfg

if [ $# -ne 1 ]; then
	echo "Please input one pdf filepath only."
	exit 1
fi

PDFPATH="$(realpath "$1")"
# This is how Jekyll likes its filenames.
POSTFILENAME="${DATE}-${TITLE//" "/"-"}.md"
ASSETSFOLDERPATH="${OUTPUT}/${ASSETSFOLDER}"
POSTFOLDERPATH="${OUTPUT}/${POSTSFOLDER}"
POSTPATH="${OUTPUT}/${POSTSFOLDER}/${POSTFILENAME}"

if [ ! -d "$ASSETSFOLDERPATH" ]; then
	mkdir -p "$ASSETSFOLDERPATH"
fi

if [ ! -d "$POSTFOLDERPATH" ]; then
	mkdir -p "$POSTFOLDERPATH"
fi

echo "Creating ${POSTFILENAME}..."
touch "$POSTPATH"

echo "---" >> "$POSTPATH"
echo "layout: post" >> "$POSTPATH"
echo "title: ${TITLE}" >> "$POSTPATH"
echo "date: ${DATE}" >> "$POSTPATH"
echo "categories: ${CATEGORIES}" >> "$POSTPATH"
echo "---" >> "$POSTPATH"
echo >> "$POSTPATH"

cd "$ASSETSFOLDERPATH"
echo "Creating PDFs into ${ASSETSFOLDERPATH} from ${PDFPATH}..."
pdftoppm "$PDFPATH" slide -png
cd "$OLDPWD"

counter=1
for FILE in $(cd ${ASSETSFOLDERPATH};ls -1 ${FILE});
do
	echo "![Page ${counter}](/${ASSETSFOLDER}/${FILE})" >> "$POSTPATH"
	((counter=counter+1))
done


echo "Finished! Copy the contents of ${OUTPUT} directly into the root of your jekyll project!"

