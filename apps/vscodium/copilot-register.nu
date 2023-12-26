#!/usr/bin/env nu

let vscode_client_id = "01ab8ac9400c4e429b23"

let initial_query = http post https://github.com/login/device/code $"client_id=($vscode_client_id)&scope=user:email"
let user_code = $initial_query | split row "&" | find user_code | first | str replace --regex ".*=" ""
let device_code = $initial_query | split row "&" | find device_code | first | str replace --regex ".*=" ""

echo "Login: https://github.com/login/device"
echo $"Code: ($user_code)"

input "Press enter to continue after logging in... " out> /dev/null

let registration = http post https://github.com/login/oauth/access_token $"client_id=($vscode_client_id)&scope=user:email&device_code=($device_code)&grant_type=urn:ietf:params:oauth:grant-type:device_code"
let access_token = $registration | split row "&" | find access_token | first | str replace --regex ".*=" ""

echo ("Access Token: " ++ $access_token)
