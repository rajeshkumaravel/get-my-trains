#!/bin/bash

display_notification() {
    local message=$1
    local phone_number=$2
    osascript -e "tell application \"Messages\" to send \"$message\" to buddy \"$phone_number\""
}


call_api_and_display_notifications() {
    api_url="https://skane-api.vercel.app/getMyTrain"

    custom_header="x-api-key: 123"
    response=$(curl -s -o /dev/null -w "%{http_code}" -H "$custom_header" "$api_url")
    if [ "$response" -eq 200 ]; then
        data=$(curl -s -H "$custom_header" "$api_url")
        while IFS= read -r line; do
            title=$(echo "$line" | grep -o '"title": *"[^"]*"' | cut -d'"' -f4)
            message=$(echo "$line" | grep -o '"message": *"[^"]*"' | cut -d'"' -f4)
            multi_line_message=$(printf "%s\n%s" "$title" "$message")
            display_notification "$multi_line_message" "emailPhone"
            sleep 2
        done <<< "$(echo "$data" | grep -o '{[^}]*}')"
    else
        echo "Failed to fetch data from API. HTTP Status Code: $response"
    fi
}
call_api_and_display_notifications
