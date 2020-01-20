#!/bin/bash





DIR="$1";


kdialog --title "Resize Images" --yesnocancel "Do you want to replace exisiting files ?"
case $? in
	0)	# Replace exisiting files !
		choice=`kdialog --title "Resize Images" --radiolist "target size:" 1 "1024px"  on 2 "800px"  off 3 "640px" off 4 "480px"  off`;
		FILE=""
		let "nbfiles = $#" 
		dbusRef=`kdialog --progressbar "Initialising ..." $nbfiles`
		qdbus $dbusRef showCancelButton true 
		compteur=0
		for i in "$@";do
			if [ -f "$i" ];then
				#test if cancel button has been pushed
				if [[ "$(qdbus $dbusRef wasCancelled)" == "true" ]] ; then
					qdbus $dbusRef close
					exit 1
				fi
				FILE="$i"
				let "compteur +=1"
				case "$choice" in 
					1)
					qdbus $dbusRef setLabelText "Scaling image `basename "$FILE"`"
					qdbus $dbusRef org.freedesktop.DBus.Properties.Set org.kde.kdialog.ProgressDialog value $compteur
					convert -resize 1024x1024 "$FILE" "$FILE";;
					2) 
					qdbus $dbusRef setLabelText "Scaling image `basename "$FILE"`"
					qdbus $dbusRef org.freedesktop.DBus.Properties.Set org.kde.kdialog.ProgressDialog value $compteur
					convert -resize 800x800 "$FILE" "$FILE";;
					3) 
					qdbus $dbusRef setLabelText "Scaling image `basename "$FILE"`"
					qdbus $dbusRef org.freedesktop.DBus.Properties.Set org.kde.kdialog.ProgressDialog value $compteur
					convert -resize 600x600 "$FILE" "$FILE";;
					4) 
					qdbus $dbusRef setLabelText "Scaling image `basename "$FILE"`"
					qdbus $dbusRef org.freedesktop.DBus.Properties.Set org.kde.kdialog.ProgressDialog value $compteur
					convert -resize 300x300 "$FILE" "$FILE";;
					*)
					qdbus $dbusRef close;
					rm -rf "$TMPDIR"
					exit 0;;
				esac
			fi;
		done
		qdbus $dbusRef close;;
		
		
	1)
		choice=`kdialog --title "Resize Images" --radiolist "target size:" 1 "1024px"  on 2 "800px"  off 3 "640px" off 4 "480px"  off`;
		FILE=""
		let "nbfiles = $#" 
		dbusRef=`kdialog --progressbar "Initialising ..." $nbfiles`
		qdbus $dbusRef showCancelButton true 
		compteur=0
		for i in "$@";do
			if [ -f "$i" ];then
				#test if cancel button has been pushed
				if [[ "$(qdbus $dbusRef wasCancelled)" == "true" ]] ; then
					qdbus $dbusRef close
					exit 1
				fi
				FILE="$i"
				let "compteur +=1"
				case "$choice" in 
					1)
					qdbus $dbusRef setLabelText "Scaling image `basename "$FILE"`"
					qdbus $dbusRef org.freedesktop.DBus.Properties.Set org.kde.kdialog.ProgressDialog value $compteur
					convert -resize 1024x1024 "$FILE" $DIR/1024_"`basename "$FILE"`";;
					2) 
					qdbus $dbusRef setLabelText "Scaling image `basename "$FILE"`"
					qdbus $dbusRef org.freedesktop.DBus.Properties.Set org.kde.kdialog.ProgressDialog value $compteur
					convert -resize 800x800 "$FILE" $DIR/800_"`basename "$FILE"`";;
					3) 
					qdbus $dbusRef setLabelText "Scaling image `basename "$FILE"`"
					qdbus $dbusRef org.freedesktop.DBus.Properties.Set org.kde.kdialog.ProgressDialog value $compteur
					convert -resize 640x640 "$FILE" $DIR/640_"`basename "$FILE"`";;
					4) 
					qdbus $dbusRef setLabelText "Scaling image `basename "$FILE"`"
					qdbus $dbusRef org.freedesktop.DBus.Properties.Set org.kde.kdialog.ProgressDialog value $compteur
					convert -resize 480x480 "$FILE" $DIR/480_"`basename "$FILE"`";;
					*)
					qdbus $dbusRef close;
					rm -rf "$TMPDIR"
					exit 0;;
				esac
			fi;
		done
		qdbus $dbusRef close;;
	
	2) 
		exit 0;;
esac;




















