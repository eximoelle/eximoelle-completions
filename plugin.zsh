#!/bin/zsh
# Lightweight local completions collection.

# Put this plugin's functions dir at the front of $fpath so our completions win
# over system or Homebrew ones.
local plugin_dir=${${(%):-%x}:A:h}
local fn
fpath=($plugin_dir/functions $fpath)

# Autoload and compdef every _*-style completion in this plugin.
for fn in $plugin_dir/functions/_*~*.zwc(.N); do
  autoload -Uz ${fn:t}
  # Let znap's compdef stub record this; after compinit runs the real compdefs
  # will be applied. If compinit already ran, compinit -C will refresh _comps.
  compdef ${fn:t} ${${fn:t}#_}
done

# Keep yt-dlp options grouped like the manpage in completion menus.
zstyle ':completion:*:*:yt-dlp:*' group-order \
  general network geo selection download filesystem thumbnail shortcut \
  verbosity workarounds format subtitles auth postproc sponsorblock extractor \
  arguments

# If compinit already ran, register immediately.
if [[ -v _comps ]]; then
  compinit -C
fi
