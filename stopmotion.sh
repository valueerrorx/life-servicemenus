#!/bin/bash
#last update: 04.05.2018

TIMESTAMP=$(date +"%H-%M-%S")
Location=$(dirname "${1}")
DIR="${Location}/stopmotion";



if [ ! -d "$DIR" ];then
    mkdir "$DIR"
fi



FRAMERATE=$(kdialog --title "stopmotion" --combobox "Welche Framerate soll das Video haben?" "1" "2" "4" "6" "8" "12" "16" "24" "30" --default "6" );
if [ "$?" = 1 ]; then exit 0; fi;
SIZE=$(kdialog --title "Resize Images" --radiolist "Original Bilder skalieren ?" continue "Größe beibehalten" on 1080 "1080p Full HD"  off 720 "720p HD"  off 480 "480p" off );
if [ "$?" = 1 ]; then exit 0; fi;




if [[ (! $SIZE = "continue" ) && (! $SIZE = "") ]];then
    for i in "$@";do
        if [ -f "$i" ];then
            FILE="$i"
            convert -resize x${SIZE} "$FILE" "$FILE";
        fi;
    done
fi



# resize format MUST BE divisable by 2 - therefore as a precaution we round an rezize every image (by 1px max)
ORIGHEIGHT=$(identify -format "%[fx:h]" $1)    #$1 should be an image in any case   
ORIGWIDTH=$(identify -format "%[fx:w]" $1)
CROPHEIGHT=$(( ($ORIGHEIGHT/2)*2 ))    #this rounds the image height
CROPWIDTH=$(( ($ORIGWIDTH/2)*2 ))


for i in "$@";do
    if [ -f "$i" ];then
        FILE="$i"
        convert -crop ${CROPWIDTH}x${CROPHEIGHT}+0+0 $FILE "$FILE"    # round and resize and convert to PNG
        #echo "$FILE - ${CROPWIDTH}x${CROPHEIGHT}"
    fi;
done


# some pictures do not deliver the necessary information [image2pipe @ 0x1d1f580] Could not find codec parameters 
# setting the codec to PNG or MJPEG helps

IMAGECODEC=$(identify -format "%m" $1)

if [[ ( $IMAGECODEC = "PNG" ) ]];then
    CODEC="png"
else
    CODEC="mjpeg"
fi;

# pipe every single image to ffmpeg in order to convert it to an mpeg (-y overwrite output files -pix_fmt use widespread mediaplayer friendly format -r 30 simulate 30fps for subborn mediaplayers
cat "$@" | ffmpeg -y -c:v $CODEC -f image2pipe -framerate $FRAMERATE -i - -c:v libx264 -r 30 -pix_fmt yuv420p "${DIR}/stopmotion-${TIMESTAMP}.mp4"



#just a small fix for the final information dialog
if [[ ( $SIZE = "continue" ) ]];then
   SIZE="original"
fi



kdialog --title "stopmotion" --msgbox "Größe: $SIZE\nDas Video wurde im Ordner $DIR gespeichert."
