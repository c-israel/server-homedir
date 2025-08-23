#!/bin/bash

set -euo pipefail

# shellcheck source=./urls-env.sh
. ./urls-env"${ARCH:=}".sh

[ -d ./target ] && rm -r ./target
TARGET_DIR=$(realpath ./target)
mkdir -p "$TARGET_DIR"/.local/{bin/man/man1,share/bash-completion/completions}
BIN_TARGET="$TARGET_DIR/.local/bin"
MAN_TARGET="$TARGET_DIR/.local/bin/man/man1"
COMP_TARGET="$TARGET_DIR/.local/share/bash-completion/completions"

mkdir -p "$TARGET_DIR/.local/bin/man/man1"
mkdir -p "$TARGET_DIR/.local/share/bash-completion/completions"
mkdir -p "$TARGET_DIR/.local/share/nvim/lazy"
mkdir -p "$TARGET_DIR/.config/nvim"


wget -O - "$LSD_URL" | tee \
    >(tar -xzvf - --to-stdout --wildcards '*/lsd' > "$BIN_TARGET/lsd") \
    >(tar -xzvf - --to-stdout --wildcards '*/lsd.1' > "$MAN_TARGET/lsd.1") \
    >(tar -xzvf - --to-stdout --wildcards '*/autocomplete/lsd.bash-completion' > "$COMP_TARGET/lsd") \
    >/dev/null

wget -O - "$BAT_URL" | tee \
    >(tar -xzvf - --to-stdout --wildcards '*/bat' > "$BIN_TARGET/bat") \
    >(tar -xzvf - --to-stdout --wildcards '*/bat.1' > "$MAN_TARGET/bat.1") \
    >(tar -xzvf - --to-stdout --wildcards '*/autocomplete/bat.bash' > "$COMP_TARGET/bat") \
    >/dev/null

wget "$JQ_URL" -O "$TARGET_DIR/.local/bin/jq"
wget "$JQ_MAN_URL" -O "$TARGET_DIR/.local/bin/man/man1/jq.1"

wget "$DELTA_URL" -O - | tar -xzvf - --to-stdout --wildcards '*/delta' > "$BIN_TARGET/delta"
wget "$DELTA_COMPLETIONS_URL" -O "$COMP_TARGET/delta"
wget "$DELTA_MANPAGE_URL" -O - | gunzip > "$MAN_TARGET/delta.1"

# wget "$BASH_URL" -O "$TARGET_DIR/.local/bin/bash" # maybe let's not include that
# wget "$BUSYBOX_URL" -O "$TARGET_DIR/.local/bin/busybox" # not this either

wget "$CURL_URL" -O - | tar -xJvf - --exclude SHA256SUMS -C "$BIN_TARGET"

wget "$ERD_URL" -O - | tar -xzvf - --to-stdout 'erd' > "$BIN_TARGET/erd"

wget "$LNAV_URL" -O - | tee \
  >(busybox unzip -p - '*/lnav' > "$BIN_TARGET/lnav") \
  >(busybox unzip -p - '*/lnav.1' > "$MAN_TARGET/lnav.1") \
  >/dev/null

wget "$RG_URL" -O - | tee \
  >(tar -xzvf - --to-stdout --wildcards '*/rg' > "$BIN_TARGET/rg") \
  >(tar -xzvf - --to-stdout --wildcards '*/doc/rg.1' > "$MAN_TARGET/rg.1") \
  >(tar -xzvf - --to-stdout --wildcards '*/complete/rg.bash' > "$COMP_TARGET/rg") \
  >/dev/null


wget "$FZF_URL" -O - | tar -xzvf - --to-stdout 'fzf' > "$BIN_TARGET/fzf"
wget "$FZF_COMPLETION_URL" -O "$COMP_TARGET/fzf"
wget "$FZF_KEYBINDS_URL" -O "$TARGET_DIR/.fzf-keybindings.bash"
wget "$FZF_MANPAGE_URL" -O "$MAN_TARGET/fzf.1"

wget "$STARSHIP_URL" -O - | tar -xzvf - --to-stdout 'starship' > "$BIN_TARGET/starship"

mkdir -p "$TARGET_DIR/.local/share/nvim-dist"
wget "$NVIM_URL" -O - | tar -xzvf - --strip-components=1 -C "$TARGET_DIR/.local/share/nvim-dist"
(cd "$TARGET_DIR/.local/bin/"; ln -s "../share/nvim-dist/bin/nvim" nvim)

wget "$STYLUA_URL" -O - | busybox unzip -p - 'stylua' > "$BIN_TARGET/stylua"

wget "$TMUX_URL" -O - | gunzip > "$BIN_TARGET/tmux"

## don't include spell files - difficult to meet GPL source distribution requirements.
# mkdir -p "$TARGET_DIR/.config/nvim/spell"
# for spellfile in {de,en}.utf-8.{spl,sug};
# do
#   wget "$SPELL_BASEURL/$spellfile" -O "$TARGET_DIR/.config/nvim/spell/$spellfile"
# done

for file in "$TARGET_DIR"/.local/bin/*;
do
    echo chmod +x "$file"
    chmod +x "$file"
done