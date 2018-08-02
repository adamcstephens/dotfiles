// default is chrome which we never want
finicky.setDefaultBrowser('com.apple.Safari');

finicky.onUrl(function(url, opts) {
  if (url.match(/^https?:\/\/portal\.azure\.com/)) {
    return {
      bundleIdentifier: "com.google.Chrome"
    };

  } else if (url.match(/^https?:\/\/bluejeans\.com/)) {
    // modify the bluejeans URL for what the app wants
    var url = url.replace(
      /^https?:\/\/bluejeans\.com/,
      "bjnb://meet/id"
    );
    return {
      bundleIdentifier: "com.bluejeansnet.Blue",
      url: url
    };

  } else if (url.match(/^https?:\/\/open\.spotify\.com/)) {
    return {
      bundleIdentifier: "com.spotify.client"
    };

  } else {
    // if the default browser isn't open, choose an open one
    return {
      bundleIdentifier: [
        "com.apple.Safari",
        "org.mozilla.firefox",
        "com.google.Chrome"
      ]
    };
  }
});
