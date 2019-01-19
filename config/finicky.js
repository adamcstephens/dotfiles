// default is chrome which we never want
finicky.setDefaultBrowser('org.mozilla.firefox');

finicky.onUrl(function(url, opts) {
  if (url.match(/^https?:\/\/([a-z]+\.)?bluejeans\.com\/[0-9]+/)) {
    // modify the bluejeans URL for what the app wants
    var url = url.replace(
      /^https?:\/\/([a-z]+\.)?bluejeans\.com/,
      "bjnb://meet/id"
    );
    return {
      bundleIdentifier: "com.bluejeansnet.Blue",
      url: url
    };

  } else if (url.match(/^https:\/\/insiders.liveshare.vsengsaas.visualstudio.com\/join\?[A-Z0-9]$/)) {
    return {
      bundleIdentifier: "com.microsoft.VSCode"
    };


  } else if (url.match(/^https?:\/\/open\.spotify\.com/)) {
    return {
      bundleIdentifier: "com.spotify.client"
    };

  } else {
    // if the default browser isn't open, choose an open one
    return {
      bundleIdentifier: [
        "org.mozilla.firefox",
        "com.apple.Safari",
        "com.google.Chrome"
      ]
    };
  }
});
