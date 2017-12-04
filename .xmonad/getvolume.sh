#!/bin/sh
mute=`amixer sget Master | grep -o -m 1 '\[[[:alpha:]]*\]' | tr -d '[]'`
vol=`amixer sget Master | grep -o -m 1 '[[:digit:]]*%' | tr -d '%'`

if [ "$mute" == "off" ]; then
  echo "[----!!----] $vol"
  exit 0
fi

level=`expr $vol / 10`
bars=$level

case $bars in
  0)  bar="[----------] $vol" ;;
  1)  bar="[|---------] $vol" ;;
  2)  bar="[||--------] $vol" ;;
  3)  bar="[|||-------] $vol" ;;
  4)  bar="[||||------] $vol" ;;
  5)  bar="[|||||-----] $vol" ;;
  6)  bar="[||||||----] $vol" ;;
  7)  bar="[|||||||---] $vol" ;;
  8)  bar="[||||||||--] $vol" ;;
  9)  bar="[|||||||||-] $vol" ;;
  10) bar="[||||||||||] $vol" ;;
  *)  bar="[----!!----] $vol" ;;
esac
echo $bar

exit 0
