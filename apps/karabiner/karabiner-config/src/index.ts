import { map, rule, writeToProfile } from "karabiner.ts";
import { hrm } from "karabiner.ts-greg-mods";

writeToProfile("Default profile", [
  rule("Home row mods").manipulators(
    hrm(
      new Map([
        ["a", "l⌥"],
        ["d", "l⌃"],
        ["f", "l⇧"],
        ["s", "l⌘"],
        ["j", "r⇧"],
        ["k", "r⇧"],
        ["l", "r⌘"],
        ["k", "r⌃"],
        [";", "r⌥"],
      ]),
    ).build(),
  ),
  rule("caps lock -> control or escape").manipulators([
    map({
      key_code: "caps_lock",
      modifiers: { optional: ["any"] },
    })
      .to({ key_code: "left_control" })
      .toIfAlone({ key_code: "escape" }),
  ]),
]);
