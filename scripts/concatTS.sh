#!/bin/bash

PATH_RESULTS=~/Drive/results/rois90
PATH_RESULTS_CONCAT=~/Drive/results/rois90_concat
ls $PATH_RESULTS | awk -F "_" '{ print $1 }' | uniq | while read line; do
   if [[ ! -e "${PATH_RESULTS_CONCAT}/${line}_ts_rois90.txt" ]] ; then
      paste $PATH_RESULTS/${line}_[0-9][0-9]_rois90.txt > ${PATH_RESULTS_CONCAT}/${line}_ts_rois90.txt
      echo concatenated $line
   fi
done

