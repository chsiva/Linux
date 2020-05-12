#!/bin/bash

# User need to enter the start & end time time here
echo "Type the start time for the meeting, followed by [ENTER]:"
read starttime
echo "Type the end time, followed by [ENTER]:"
read endtime

#search for the start & end time requirement which search for each floor, if there is multiple floors it search for the maximum availability for the satrt and the end time

egrep "$starttime|$endtime" room.txt | awk -F, '$2 >= "4"' | grep $starttime | grep $endtime | awk -F, '{print $1}'
