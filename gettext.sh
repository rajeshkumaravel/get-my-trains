#!/bin/bash

usage() {
    echo "Usage: $0 path and api_key"
    echo "Example: $0 /user/desktop qwer123"
    exit 1
}

if [ "$#" -ne 2 ]; then
    usage
fi

api_key="$2"
emailPhone="$3"
curl -sSfLJ "https://raw.githubusercontent.com/rajeshkumaravel/get-my-trains/main/textMyTrain.sh" > "$1/textMyTrain.sh"
if [ "$?" -ne 0 ]; then
    echo "Failed to download the script."
    exit 1
fi

chmod +x "$1/textMyTrain.sh"
sed -i '' "s/custom_header=\"x-api-key: .*\"/custom_header=\"x-api-key: $api_key\"/" $1/textMyTrain.sh
sed -i '' "s/emailPhone/$emailPhone/g" $1/textMyTrain.sh

# Add cron jobs to run the script at different times
cronjob1="15 14 * * 1-5 /bin/bash $1/textMyTrain.sh >/dev/null 2>&1"
cronjob2="15 15 * * 1-5 /bin/bash $1/textMyTrain.sh >/dev/null 2>&1"
cronjob3="45 15 * * 1-5 /bin/bash $1/textMyTrain.sh >/dev/null 2>&1"

{ crontab -l; echo "$cronjob1"; echo "$cronjob2"; echo "$cronjob3"; } | crontab -

echo "Setup complete. You will receive notifications every weekday at 2:15pm, 3:15pm and 3:45pm"
