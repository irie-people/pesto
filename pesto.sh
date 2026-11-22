#!/bin/sh
# Brings Pesto up to Irie's live build and installs it beside Irie
# (PESTO.md): merges Irie's live into this clone, renames it again with
# tools/rebrand.sh, then installs pesto with tools/live.sh, after the
# copy's own checks, and Pesto.app with it once Pesto.app is in
# ~/Applications. It starts nothing: open Pesto.app yourself.
#
#   sh pesto.sh          merge, rename, check and install
#   sh pesto.sh --app    the same, and build and install Pesto.app the
#                        first time
set -eu
cd "$(dirname "$0")"
export TZ=UTC
tagline="Fresh basil for your agents."

git fetch -q irie live
if ! git merge -q --signoff --no-edit irie/live; then
	# Only the brand's two files may conflict: take Irie's and rename them
	# again.
	other=$(git diff --name-only --diff-filter=U | grep -v -e '^internal/brand/brand.go$' -e '^mac/Sources/Irie/Brand.swift$' || true)
	if [ -n "$other" ]; then
		echo "pesto.sh: the merge of Irie's live conflicts in $other; merge it by hand" >&2
		exit 1
	fi
	git checkout --theirs internal/brand/brand.go mac/Sources/Irie/Brand.swift
	sh tools/rebrand.sh --tagline "$tagline" Pesto >/dev/null
	git add internal/brand/brand.go mac/Sources/Irie/Brand.swift
	git commit -q --signoff --no-edit
fi
# Irie's brand.go may have changed where the merge kept Pesto's lines.
sh tools/rebrand.sh --tagline "$tagline" Pesto >/dev/null
if ! git diff --quiet; then
	git commit -q --signoff -am "chore(brand): rename Pesto again after Irie's brand changed"
fi

# Beside Irie, a few settings keep Pesto off Irie's agents and servers.
conf=${XDG_CONFIG_HOME:-$HOME/.config}/pesto/config.toml
if [ ! -e "$conf" ]; then
	mkdir -p "$(dirname "$conf")"
	cat >"$conf" <<'EOF'
# Pesto runs beside Irie on this Mac, to test how Irie ports to a company's
# copy (PESTO.md in its clone). These keep it off Irie's agents and servers.

[arch.gabriel]
# Pesto takes Irie's agents for apps outside it: never slow them.
outside = false

[arch.raguel]
# His council starts a real Claude Code session.
on = false

[local]
# Its own Ollama and llama.cpp servers, never Irie's on 11435 and 11436.
port = 11445
llama_port = 11446
EOF
fi

sh tools/live.sh

app=$HOME/Applications/Pesto.app
if [ "${1:-}" = --app ] && [ ! -d "$app" ]; then
	IRIE_MAC_INSTALL=1 mac/build.sh
	mkdir -p "$(dirname "$app")"
	ditto mac/build/Pesto.app "$app"
	/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$app" 2>/dev/null || true
	# What tools/live.sh reads to know the app is current.
	git rev-parse HEAD >"${XDG_DATA_HOME:-$HOME/.local/share}/pesto/bin/app.commit"
	echo "pesto.sh: Pesto.app is in $app; open it yourself"
fi
