#!/usr/bin/env bash

set nounset
set pipefail
set noglob

script_dir="$( cd "$( dirname "$0" )" && pwd )"

piano_data="${script_dir}/pianodata"
mkdir -p "${piano_data}"

sleep_time=30

function listen_to_piano() {
    aseqdump -p "Digital Piano"
}

while : # Repeat until interrupt
do
    while read -r line; do
	# Logging time spent practicing
        if [[ "${line}" == *"Note on"* ]]; then
	    #echo "Saw note"
	    todays_date=$(date +"%Y-%m-%d")
	    current_time=$(date +"%H:%M")
	    #current_time=$(date +"%T")
            today_file="${piano_data}/${todays_date}"
	    touch "${today_file}"
	    if [ "$(grep -c "${current_time}" "${today_file}")" -eq "0" ];
            then
                echo "${current_time}" >> "${today_file}"
	        echo "Writing ${current_time} to ${today_file}"
            fi
        elif [[ "${line}" =~ "Port unsubscribed" ]]; then
	    echo "Piano turned off, retrying connection"
            break
        elif [[ "${line}" =~ "Invalid port" ]]; then
	    echo "Piano not connected, retrying"
            break
        fi

	if [[ ("${line}" == *"Note"*) || ("${line}" == *"Control change"*) ]]; then
	    ms_epoch=$(date +%s%3N)
            today_file="${piano_data}/${todays_date}_raw"
            logmsg="${ms_epoch} >>> ${line}"
            echo "${logmsg}" >> "${today_file}"
            echo "${logmsg}"
	fi

    done < <(listen_to_piano)

    sleep "${sleep_time}"
done
