#!/bin/bash

# Configuration section
URL="https://example.com"                   # The URL of the website to check
THRESHOLD=2.0                               # Load time threshold in seconds
SLACK_WEBHOOK_URL="https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX"  # Slack webhook URL
SLACK_CHANNEL="#alerts"                     # Slack channel to send the alert to
SLACK_USERNAME="LoadTimeBot"                # Username that will appear on Slack

# Function to send alert to Slack
send_slack_alert() {
    local load_time=$1
    local message=":warning: Load time alert: $URL took $load_time seconds to load, which exceeds the threshold of $THRESHOLD seconds."
    
    curl -X POST -H 'Content-type: application/json' --data "{
        \"channel\": \"$SLACK_CHANNEL\",
        \"username\": \"$SLACK_USERNAME\",
        \"text\": \"$message\"
    }" $SLACK_WEBHOOK_URL
}

# Main section: Check the website load time
load_time=$(curl -o /dev/null -s -w %{time_total} $URL)

# Check if the load time exceeds the threshold
if (( $(echo "$load_time > $THRESHOLD" |bc -l) )); then
    send_slack_alert $load_time
    echo "Alert sent! Load time: $load_time seconds."
else
    # If load time is within threshold, print a message (optional)
    echo "Website load time is within the acceptable range: $load_time seconds."
fi
