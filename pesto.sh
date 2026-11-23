#!/bin/sh
# Brings Pesto up to Irie's live build and installs it beside Irie
# (PESTO.md): merges Irie's live into this clone, renames it again with
# tools/rebrand.sh, takes out the plugins it leaves out with tools/prune,
# then installs pesto with tools/live.sh, after the copy's own checks, and
# Pesto.app with it once Pesto.app is in ~/Applications. It starts
# nothing: open Pesto.app yourself.
#
#   sh pesto.sh          merge, rename, check and install
#   sh pesto.sh --app    the same, and build and install Pesto.app the
#                        first time
set -eu
cd "$(dirname "$0")"
export TZ=UTC
tagline="Fresh basil for your agents."

# The Irie checkout beside this one has live, the installed build; Irie's
# public repository has main.
ref=live
git ls-remote --exit-code --heads irie live >/dev/null 2>&1 || ref=main
git fetch -q irie "$ref"
if ! git merge -q --signoff --no-edit "irie/$ref"; then
	# Two kinds of conflict are Pesto's own: the brand's two files, which
	# take Irie's and are renamed again, and files Pesto took out that Irie
	# changed, which stay out (tools/prune takes out what is new below).
	# Any other conflict is for a person.
	for f in $(git diff --name-only --diff-filter=U); do
		case $f in
		internal/brand/brand.go | mac/Sources/Irie/Brand.swift)
			git checkout --theirs -- "$f"
			git add -- "$f"
			;;
		*)
			if git ls-files -u -- "$f" | awk '{print $3}' | grep -qx 2; then
				echo "pesto.sh: the merge of Irie's $ref conflicts in $f; merge it by hand" >&2
				exit 1
			fi
			git rm -q -- "$f"
			;;
		esac
	done
	git commit -q --signoff --no-edit
fi
# Irie's brand.go may have changed where the merge kept Pesto's lines.
sh tools/rebrand.sh --tagline "$tagline" Pesto >/dev/null
if ! git diff --quiet; then
	git commit -q --signoff -am "chore(brand): rename Pesto again after Irie's brand changed"
fi
# The plugins Pesto leaves out go from its source too, whatever the merge
# brought of them.
go run ./tools/prune
git add -A
if ! git diff --cached --quiet; then
	git commit -q --signoff -m "chore(copy): take out what Irie's merge brought of the plugins Pesto leaves out"
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
# Planner's council starts a real Claude Code session.
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
