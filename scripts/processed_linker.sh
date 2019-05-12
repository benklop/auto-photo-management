#!/bin/bash
WORK_FOLDER="/data_storage/photo_storage/Shoots/Personal"
DEST_FOLDER="/data_storage/photo_storage/Processed"
touch /var/run/photo_processing/running

if [ -e /var/run/photo_processing/last_run ]; then
        OPT="-newer /var/run/photo_processing/last_run"
else
        OPT="-ctime -7"
fi

#processes all xmps
while IFS=  read -r -d $'\0'; do
    xmp_name="${REPLY##*/}"
    file_num="${xmp_name/.*}"
    dest_folder="${REPLY%/*}/../Processed"
    dest_name="$dest_folder/$file_num.jpg"

    #true if the green label is added to the xmp
    process='false'
    if [ "$(xidel -s "$REPLY" -e "//*[local-name()='colorlabels']/rdf:Seq/rdf:li/text()")" == '2' ]; then
        process='true'
    elif [ -e "$dest_name" ] && [ "$dest_name" -ot "$xmp_name" ]; then 
	process=true
	echo "WARNING: '$xmp_name' not tagged for processing, but processing anyway, since '$file_num.jpg' exists but is out of date!"
    fi

    if [ "$process" == 'true' ]; then
        file_name="${REPLY%/*}/$(xidel -s "$REPLY" -e "//rdf:Description/@xmpMM:DerivedFrom")"

        if [ ! -e "$dest_name" ] || [ "$dest_name" -ot "$xmp_name" ]; then
            echo "processing '$xmp_name' on '$file_name' to '$file_num.jpg"
            #darktable-cli --overwrite "$file_name" "$REPLY" "$dest_name"
	else
            echo "'$file_num.jpg' is up to date with '$xmp_name'"
        fi
    else	
        echo "'$xmp_name' not marked to be processed and no existing '$file_num.jpg'"
    fi
done < <(find "$WORK_FOLDER" -type f -name "*.xmp" -print0)

mv /var/run/photo_processing/running /var/run/photo_processing/last_run
while IFS=  read -r -d $'\0'; do
    JOB="$(realpath "$REPLY/..")"
    JOB="${JOB##*/}"
    YEAR="$(realpath "$REPLY/../..")"
    YEAR="${YEAR##*/}"
    DEST="$DEST_FOLDER/$YEAR/$JOB"
    if [ ! -L "$DEST" ]; then
        echo "Linking $JOB"
        mkdir -p "$DEST_FOLDER/$YEAR"
        ln -s "$REPLY" "$DEST_FOLDER/$YEAR/$JOB"
    fi
done < <(find "$WORK_FOLDER" -type d -name "Processed" -print0)
