module.exports = {
  defaultBrowser: "Firefox",
  rewrite: [
    {
      match: /^https?:\/\/([a-z]+\.)?bluejeans\.com\/[0-9]+/,
      url({ url }) {
        var path = url.pathname.replace(/([0-9]+)/, "id/$1");
        return {
          ...url,
          host: "meet",
          pathname: path,
          protocol: "bjnb"
        }
      }
    }
  ],
  handlers: [
    {
      match: /^https:\/\/insiders.liveshare.vsengsaas.visualstudio.com\/join\?[A-Z0-9]$/,
      browser: "Visual Studio Code"
    },
    {
      match: /bjnb:\/\/meet\/id/,
      browser: "BlueJeans"
    },
    {
      match: finicky.matchDomains("open.spotify.com"),
      browser: "Spotify"
    }
  ]
};