import type { ExtensionAPI } from "@oh-my-pi/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  const prime = async (_event, ctx) => {
    const { stdout } = await pi.exec("veans", ["prime"], { cwd: ctx.cwd });

    pi.sendMessage(
      {
        customType: "veans-prime",
        content: stdout,
        display: false,
      },
      { deliverAs: "nextTurn" },
    );
  };

  pi.on("session_start", prime);
  // pi.on("session_before_compact", prime);
}
