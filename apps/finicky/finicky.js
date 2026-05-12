export default {
  // get bundle id: mdls /Applications/Firefox.app/ | grep kMDItemCF
  defaultBrowser: () => {
    const running = [
      "org.mozilla.firefoxdeveloperedition",
      "org.mozilla.firefox",
      "Safari",
      "org.chromium.Chromium",
    ].find((browser) => finicky.isAppRunning(browser));

    const powerInfo = finicky.getPowerInfo();
    const myDefault = powerInfo.isConnected ? "org.mozilla.firefox" : "Safari";

    return running == undefined ? myDefault : running;
  },
  options: {
    hideIcon: false,
    urlShorteners: ["applications.zoom.us", "bit.ly", "github.co", "t.co"],
  },
  rewrite: [
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
      match: /zoom.us\/j\//,
      browser: "us.zoom.xos",
    },
    {
      match: ({ url }) => url.protocol === "msteams",
      browser: "Microsoft Teams",
    },
    {
      match: /meet\.google\.com/,
      browser: "Chromium",
    },
  ],
};
