#!/bin/sh


ANS=1
PRINT=1
echo "<?xml version='1.0' encoding='UTF-8'?>"
echo "<osm version='0.0' generator='PRIVAT'>"
while read LINE; do
  ANS=$(echo $LINE | grep -q "<relation ";echo $?)
  if [ $ANS -eq 0 ]; then 
     PRINT=0; 
  fi

  ANS=$(echo "$LINE" | grep -q "</relation>";echo $?)

  if [ $PRINT -eq 0 ]; then echo "$LINE"; fi

  if [ $ANS -eq 0 ]; then PRINT=1; fi

done 

echo "</osm>"
