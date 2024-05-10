#!/bin/bash

display_notification() {
    osascript -e "display notification \"$2\" with title \"$1\" sound name \"hero\""
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
            display_notification "$title" "$message"
            sleep 2
        done <<< "$(echo "$data" | grep -o '{[^}]*}')"
    else
        echo "Failed to fetch data from API. HTTP Status Code: $response"
    fi
}
call_api_and_display_notifications
