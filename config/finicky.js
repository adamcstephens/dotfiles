finicky.onUrl(function(url, opts) {
  if (url.match(/^https?:\/\/portal\.azure\.com/)) {
    return {
      bundleIdentifier: "com.google.Chrome"
    };
  } else if (url.match(/^https?:\/\/bluejeans\.com/)) {
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
    return {
      bundleIdentifier: [
        "com.apple.Safari",
        "org.mozilla.firefox",
        "com.google.Chrome"
      ]
    };
  }
});
