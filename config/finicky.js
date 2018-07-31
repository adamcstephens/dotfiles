finicky.onUrl(function(url, opts) {
  if (url.match(/^https?:\/\/.*azure\.portal\.com.*/)) {
    return {
      bundleIdentifier: "com.google.Chrome"
    };
  }

  return {
    bundleIdentifier: [
      "com.apple.Safari",
      "org.mozilla.firefox",
      "com.google.Chrome"
    ]
  };
});
