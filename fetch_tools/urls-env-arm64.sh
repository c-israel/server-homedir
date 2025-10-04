#!/bin/sh

# ls-deluxe
LSD_URL="https://github.com/lsd-rs/lsd/releases/download/v1.1.5/lsd-v1.1.5-aarch64-unknown-linux-musl.tar.gz"

# bat + manpage + completion
# contains binary+manpage+completions
BAT_URL="https://github.com/sharkdp/bat/releases/download/v0.25.0/bat-v0.25.0-aarch64-unknown-linux-musl.tar.gz"

# jq + manpage
# is binary
JQ_URL="https://github.com/jqlang/jq/releases/download/jq-1.8.1/jq-linux-arm64"
JQ_MAN_URL="https://raw.githubusercontent.com/jqlang/jq/refs/tags/jq-1.8.1/jq.1.prebuilt"


# delta + manpage + completion
# contains only binary and readme
DELTA_URL="https://github.com/dandavison/delta/releases/download/0.18.2/delta-0.18.2-aarch64-unknown-linux-gnu.tar.gz"
DELTA_COMPLETIONS_URL="https://raw.githubusercontent.com/dandavison/delta/refs/tags/0.18.2/etc/completion/completion.bash"
DELTA_MANPAGE_URL="https://manpages.ubuntu.com/manpages.gz/noble/man1/delta.1.gz"

FD_URL="https://github.com/sharkdp/fd/releases/download/v10.3.0/fd-v10.3.0-aarch64-unknown-linux-musl.tar.gz"

# # static bash build. Probably a bad idea, since I would have to provide access to the Corresponding Source
# BASH_URL="https://github.com/robxu9/bash-static/releases/download/5.2.015-1.2.3-2/bash-linux-x86_64"

# # same issue here - I would have to package the source in.
# BUSYBOX_URL="https://busybox.net/downloads/binaries/1.35.0-x86_64-linux-musl/busybox"

# contains binary
CURL_URL="https://github.com/stunnel/static-curl/releases/download/8.16.0/curl-linux-aarch64-musl-8.16.0.tar.xz"


# erd + completion
# contains binary and readme
# completions outputted by binary (--completions bash)
ERD_URL="https://github.com/solidiquis/erdtree/releases/download/v3.1.2/erd-v3.1.2-aarch64-unknown-linux-musl.tar.gz"


# lnav
# contains binary and readme
# LNAV_URL="https://github.com/tstack/lnav/releases/download/v0.12.0/lnav-0.12.0-linux-musl-x86_64.zip"
LNAV_URL="https://github.com/tstack/lnav/releases/download/v0.13.2/lnav-0.13.2-linux-musl-arm64.zip"
# LNAV_MANPAGE_URL="https://github.com/tstack/lnav/blob/v0.12.0/lnav.1"
LNAV_MANPAGE_URL="https://raw.githubusercontent.com/tstack/lnav/refs/tags/v0.13.2/lnav.1"

# rg + manpage + completion
# contains binary, manpage and completions
RG_URL="https://github.com/BurntSushi/ripgrep/releases/download/14.1.1/ripgrep-14.1.1-aarch64-unknown-linux-gnu.tar.gz"


# fzf + manpage + completion
# contains only binary
FZF_URL="https://github.com/junegunn/fzf/releases/download/v0.65.2/fzf-0.65.2-linux_arm64.tar.gz"
FZF_MANPAGE_URL="https://raw.githubusercontent.com/junegunn/fzf/v0.65.2/man/man1/fzf.1"
FZF_COMPLETION_URL="https://raw.githubusercontent.com/junegunn/fzf/v0.65.2/shell/completion.bash"
FZF_KEYBINDS_URL="https://raw.githubusercontent.com/junegunn/fzf/refs/tags/v0.65.2/shell/key-bindings.bash"

# starship
# contains only binary
# completions outputted by binary (starship completions bash)
STARSHIP_URL="https://github.com/starship/starship/releases/download/v1.23.0/starship-aarch64-unknown-linux-musl.tar.gz"

# nvim
# contains binary, libs and manpage
NVIM_URL="https://github.com/neovim/neovim/releases/download/v0.11.4/nvim-linux-arm64.tar.gz"

STYLUA_URL="https://github.com/JohnnyMorganz/StyLua/releases/download/v0.20.0/stylua-linux-aarch64.zip"

TMUX_URL="https://github.com/mjakob-gh/build-static-tmux/releases/download/v3.1d/tmux.linux-arm64.gz"

## don't include spell files - difficult to meet GPL source distribution requirements.
#SPELL_BASEURL="https://ftp.nluug.nl/pub/vim/runtime/spell"