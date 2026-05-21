#!/usr/bin/env bash

currentAttemptCount=0
wifiTest() {
  while ! ping -W 2 -c 2 google.com; do
  	clear
  	currentAttemptCount=$((currentAttemptCount= + 1))
  	echo -e "Error: No Network Connection Established\nAttempting Again, Current Attempt Count: $currentAttemptCount"
  	sleep 1
		if [[ $currentAttemptCount == 100 ]]; then
			echo -e "No Connection after 100 Attempts, Exiting."
			return 0
		fi
  done
  if ping -W 2 -c 2 google.com > /dev/null; then
      echo -e "\nSuccessfully Connected!"
  else
      echo -e "\nError Connecting!"
  fi
	return 0
}
