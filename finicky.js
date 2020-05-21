module.exports = {
  defaultBrowser: ["Firefox", "Google Chrome", "Safari"],
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
    },
    {
      match: ({ url }) => (url.search.includes("utm_")),
      url({ url }) {
        const search = url.search.split('&').filter(part => !part.startsWith("utm_"));
        return {
          ...url,
          search: search.join('&')
        }
      }
    },
    {
      match: finicky.matchDomains(["amazon.com"]),
      url: ({ url }) => ({
        ...url,
        host: "smile.amazon.com"
      })
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
      match:  /zoom.us\/j\//,
      browser: "us.zoom.xos"
    },
    {
      match: finicky.matchDomains("open.spotify.com"),
      browser: "Spotify"
    }
  ]
};
