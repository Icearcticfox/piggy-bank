#!/bin/bash

#RESULT=$(ping -c 1 192.168.1.101 | grep "100.0%")
#echo $RESULT
for ((i; i<10; i++)); do
#  RESULT=$(ping -c 1 192.168.1.101)
#  echo $RESULT
  RESULT=$(ping -c 1 192.168.1.101 | grep "100.0%")
  if [[ -z "$RESULT" ]]; then
    echo "Host ping" >> .ping.log
  else
    echo "Host not ping!" >> .ping.log
  fi
done
