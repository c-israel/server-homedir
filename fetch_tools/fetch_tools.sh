#!/bin/bash

set -euo pipefail

. ./urls-env.sh

[ -d ./work ] && rm -r ./work
[ -d ./target ] && rm -r ./target
WORK_DIR=$(realpath ./work)
TARGET_DIR=$(realpath ./target)

mkdir -p "$WORK_DIR"
mkdir -p "$TARGET_DIR/.local/bin/man/man1"
mkdir -p "$TARGET_DIR/.local/share/bash-completion/completions"
mkdir -p "$TARGET_DIR/.local/share/nvim/lazy"
mkdir -p "$TARGET_DIR/.config/nvim"

cd "$WORK_DIR"

mkdir -p "$WORK_DIR/lsd"
wget "$LSD_URL" -O - | tar -xzvf - --strip-components=1 -C "$WORK_DIR/lsd"
mv "$WORK_DIR/lsd/lsd" "$TARGET_DIR/.local/bin/lsd"
mv "$WORK_DIR/lsd/lsd.1" "$TARGET_DIR/.local/bin/man/man1/lsd.1"
mv "$WORK_DIR/lsd/autocomplete/lsd.bash-completion" "$TARGET_DIR/.local/share/bash-completion/completions/lsd"
rm -r "$WORK_DIR/lsd"

mkdir -p "$WORK_DIR/bat"
wget "$BAT_URL" -O - | tar -xzvf - --strip-components=1 -C "$WORK_DIR/bat"
mv "$WORK_DIR/bat/bat" "$TARGET_DIR/.local/bin/bat"
mv "$WORK_DIR/bat/bat.1" "$TARGET_DIR/.local/bin/man/man1/bat.1"
mv "$WORK_DIR/bat/autocomplete/bat.bash" "$TARGET_DIR/.local/share/bash-completion/completions/bat"
rm -r "$WORK_DIR/bat"

wget "$JQ_URL" -O "$TARGET_DIR/.local/bin/jq"
wget "$JQ_MAN_URL" -O "$TARGET_DIR/.local/bin/man/man1/jq.1"

mkdir -p "$WORK_DIR/delta" 
wget "$DELTA_URL" -O - | tar -xzvf - --strip-components=1 -C "$WORK_DIR/delta"
mv "$WORK_DIR/delta/delta" "$TARGET_DIR/.local/bin/delta"
wget "$DELTA_COMPLETIONS_URL" -O "$TARGET_DIR/.local/share/bash-completion/completions/delta"
wget "$DELTA_MANPAGE_URL" -O - | gunzip > "$TARGET_DIR/.local/bin/man/man1/delta.1"
rm -r "$WORK_DIR/delta"

# wget "$BASH_URL" -O "$TARGET_DIR/.local/bin/bash" # maybe let's not include that
# wget "$BUSYBOX_URL" -O "$TARGET_DIR/.local/bin/busybox" # not this either

wget "$CURL_URL" -O - | tar -xJvf - && mv curl "$TARGET_DIR/.local/bin/curl"

mkdir -p "$WORK_DIR/erd" 
wget "$ERD_URL" -O - | tar -xzvf - -C "$WORK_DIR/erd"
"$WORK_DIR/erd/erd" --completions bash > "$TARGET_DIR/.local/share/bash-completion/completions/erd"
mv "$WORK_DIR/erd/erd" "$TARGET_DIR/.local/bin/erd"
rm -r "$WORK_DIR/erd"

wget "$LNAV_URL" -O lnav.zip && unzip -j lnav.zip "*/lnav" && mv "$WORK_DIR/lnav" "$TARGET_DIR/.local/bin/lnav" && rm lnav.zip


mkdir -p "$WORK_DIR/rg"
wget "$RG_URL" -O - | tar -xzvf - --strip-components=1 -C "$WORK_DIR/rg"
mv "$WORK_DIR/rg/rg" "$TARGET_DIR/.local/bin/rg"
mv "$WORK_DIR/rg/doc/rg.1" "$TARGET_DIR/.local/bin/man/man1/rg.1"
mv "$WORK_DIR/rg/complete/rg.bash" "$TARGET_DIR/.local/share/bash-completion/completions/rg"
rm -r "$WORK_DIR/rg"


mkdir -p "$WORK_DIR/fzf" 
wget "$FZF_URL" -O - | tar -xzvf - -C "$WORK_DIR/fzf"
mv "$WORK_DIR/fzf/fzf" "$TARGET_DIR/.local/bin/fzf"
wget "$FZF_COMPLETION_URL" -O "$TARGET_DIR/.local/share/bash-completion/completions/fzf"
wget "$FZF_KEYBINDS_URL" -O "$TARGET_DIR/.fzf-keybindings.bash"
wget "$FZF_MANPAGE_URL" -O "$TARGET_DIR/.local/bin/man/man1/fzf.1"
rm -r "$WORK_DIR/fzf"


wget "$STARSHIP_URL" -O - | tar -xzvf - && mv starship "$TARGET_DIR/.local/bin/starship"

wget "$NVIM_URL" -O - | tar -xzvf - && mv nvim-linux-x86_64 "$TARGET_DIR/.local/share/"
cd "$TARGET_DIR/.local/bin/"
ln -s "../share/nvim-linux-x86_64/bin/nvim" nvim
cd "$WORK_DIR"

wget "$STYLUA_URL" -O "$WORK_DIR/stylua.zip" && unzip "$WORK_DIR/stylua.zip" && mv stylua "$TARGET_DIR/.local/bin/stylua" && rm "$WORK_DIR/stylua.zip"

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
