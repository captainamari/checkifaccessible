#!/bin/bash
# Define color constants
RED='\033[0;31m'
GREEN='\033[0;32m'
PLAIN='\033[0m'
function checkOpenAIAccessible() {
    # Check https://auth0.openai.com/
    if [[ $(curl --max-time 10 -sS https://auth0.openai.com/ -I | grep "HTTP/1.1") != *"200 OK"* ]]; then
        echo -e "auth0.openai.com   : ${RED}No${PLAIN}"
        echo -e "chat.openai.com    : ${RED}Skipped${PLAIN} (auth0.openai.com not accessible)"
        return
    else
        echo -e "auth0.openai.com   : ${GREEN}Yes${PLAIN}"
        return
    fi

    # Check https://chat.openai.com/
    local countryCode="$(curl --max-time 10 -sS https://chat.openai.com/cdn-cgi/trace | grep "loc=" | awk -F= '{print $2}')";
    if [ -z "$countryCode" ]; then
        echo -e "chat.openai.com    : ${RED}Failed to get country code${PLAIN}"
        return
    fi
    if [[ $(curl --max-time 10 -sS https://chat.openai.com/ -I | grep "text/plain") != "" ]];
    then
        echo -e "chat.openai.com    : ${GREEN}Yes (Region: ${countryCode})${PLAIN}"
        return
    else
        echo -e "chat.openai.com    : ${RED}No (Region: ${countryCode})${PLAIN}"
        return
    fi
}

checkOpenAIAccessible