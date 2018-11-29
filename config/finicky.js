// default is chrome which we never want
finicky.setDefaultBrowser('org.mozilla.firefox');

finicky.onUrl(function(url, opts) {
  // azure should go to chrome
  if (url.match(/^https?:\/\/portal\.azure\.com/) || url.match(/^https:\/\/microsoft.com\/devicelogin/)) {
    return {
      bundleIdentifier: "com.google.Chrome"
    };

  } else if (url.match(/^https?:\/\/(covermymeds.)?bluejeans\.com\/[0-9]+/)) {
    // modify the bluejeans URL for what the app wants
    var url = url.replace(
      /^https?:\/\/(covermymeds.)?bluejeans\.com/,
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
        "org.mozilla.firefox",
        "com.apple.Safari",
        "com.google.Chrome"
      ]
    };
  }
});
