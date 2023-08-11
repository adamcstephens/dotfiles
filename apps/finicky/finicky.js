module.exports = {
  // get bundle id: mdls /Applications/Firefox.app/ | grep kMDItemCF
  defaultBrowser: [
    "org.mozilla.firefoxdeveloperedition",
    "org.mozilla.firefox",
    "Safari",
  ],
  options: {
    hideIcon: false,
    urlShorteners: [
      "applications.zoom.us",
      "bit.ly",
      "github.co",
      "t.co",
      "nam11.safelinks.protection.outlook.com",
    ],
  },
  rewrite: [
    // { // debug stanza
    //   match(all) {
    //     finicky.log(JSON.stringify(all, null, 2));
    //     return false;
    //   },
    //   url: ({ url }) => url,
    // },
    {
      match: /^https?:\/\/([a-z]+\.)?bluejeans\.com\/[0-9]+/,
      url({ url }) {
        var path = url.pathname.replace(/([0-9]+)/, "id/$1");
        return {
          ...url,
          host: "meet",
          pathname: path,
          protocol: "bjnb",
        };
      },
    },
    {
      // strip tracking params
      match: ({ url }) => url.search.includes("utm_"),
      url({ url }) {
        const search = url.search
          .split("&")
          .filter((part) => !part.startsWith("utm_") || part == "t");
        return {
          ...url,
          search: search.join("&"),
        };
      },
    },
    {
      match: ({ url }) => url.host === "teams.microsoft.com",
      url({ url }) {
        // Build the URL string manually so we get the required single "/" between "msteams:" and "l/meetup-join…"
        return "msteams:" + decodeURI(url.pathname) + "?" + url.search;
      },
    },
  ],
  handlers: [
    {
      match:
        /^https:\/\/insiders.liveshare.vsengsaas.visualstudio.com\/join\?[A-Z0-9]$/,
      browser: "Visual Studio Code",
    },
    {
      match: /bjnb:\/\/meet\/id/,
      browser: "BlueJeans",
    },
    {
      match: /zoom.us\/j\//,
      browser: "us.zoom.xos",
    },
    {
      match: finicky.matchDomains("open.spotify.com"),
      browser: "Spotify",
    },
    {
      match: ({ url }) => url.protocol === "msteams",
      browser: "Microsoft Teams",
    },
  ].concat(
    [
      /github.com/,
      /reddit.com/,
      /twitter.com/,
      /youtube.com/,
      /steampowered.com/,
      /steamcommunity.com/,
    ].map((x) => {
      return { match: x, browser: "org.mozilla.firefoxdeveloperedition" };
    }),

    [/instructure.com/, /kent.edu/, /qualtrics.com/].map((x) => {
      return {
        match: x,
        browser: ({ urlString }) => ({
          name: "org.mozilla.firefox",
          args: ["-P", "Kent", `${urlString}`],
        }),
      };
    })
  ),
};
