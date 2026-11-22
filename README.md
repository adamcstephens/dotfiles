# adamcstephens dotfiles

## Installation

```sh
git clone <repo you're viewing> ~/.dotfiles
cd ~/.dotfiles
./install
```

## Rolling back past the standalone checkout-link cutover

Standalone Home Manager uses smfh for the links into `~/.dotfiles`. To
activate a generation from before the cutover, first release those links
from the current checkout:

```sh
state="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/smfh.json"
nix shell --impure --expr \
  '(builtins.getFlake (toString ./.)).inputs.nixpkgs.legacyPackages.${builtins.currentSystem}.smfh' \
  --command smfh deactivate "$state" &&
  rm -- "$state"
```

If deactivation reports a modified target, inspect and move it aside before
retrying. Once deactivation succeeds, run the old Home Manager generation's
`activate` script. No manual handoff is needed between generations that both
use smfh.
