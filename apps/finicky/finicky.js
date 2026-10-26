const slackMessagePath =
  /^\/(?:archives\/([A-Z0-9]+)\/p(\d{7,})|messages\/([A-Z0-9]+)\/convo\/[A-Z0-9]+-(\d+\.\d{6}))\/?$/;

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
      match: ({ url }) =>
        url.host === "bitfreighter.slack.com" &&
        slackMessagePath.test(url.pathname),
      url({ url }) {
        const [, archiveChannel, archiveTimestamp, channel, timestamp] =
          url.pathname.match(slackMessagePath);
        const message =
          timestamp ??
          `${archiveTimestamp.slice(0, -6)}.${archiveTimestamp.slice(-6)}`;
        return `slack://channel?team=T011H44Q50D&id=${channel ?? archiveChannel}&message=${message}`;
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
      match: ({ url }) => url.protocol === "slack",
      browser: "Slack",
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
      browser: "com.google.Chrome",
    },
    {
      match: (url, { opener }) =>
        url.hostname === "linear.app" && opener?.bundleId !== "com.linear",
      browser: "Linear",
    },
  ],
};
