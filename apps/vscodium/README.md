# vscodium

## Use copilot with vscodium

use vscode client_id to request a token

```sh
curl https://github.com/login/device/code -X POST -d 'client_id=01ab8ac9400c4e429b23&scope=user:email'
```

extract user_code and login at [https://github.com/login/device/]

get access token using device code from first step

```sh
curl https://github.com/login/oauth/access_token -X POST -d 'client_id=01ab8ac9400c4e429b23&scope=user:email&device_code=YOUR_DEVICE_CODE&grant_type=urn:ietf:params:oauth:grant-type:device_code'
```
