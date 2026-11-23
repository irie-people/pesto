# Pesto

Pesto is a company's copy of Irie made for one job: testing how Irie ports to a company (Irie's `docs/proposals/company-copies.md`, DESIGN §2.10). It is Irie's live build renamed with `tools/rebrand.sh`:

| | Pesto's |
|---|---|
| Name, tagline | Pesto, "Fresh basil for your agents." |
| Command, folders | `pesto`; `~/.config/pesto`, `~/.local/share/pesto`, `~/.local/state/pesto` |
| Variables, tmux server | `PESTO_SESSION`, `PESTO_SOCKET`, ...; tmux `-L pesto` |
| Mac app | `~/Applications/Pesto.app`, `com.example.pesto` |
| Bar | tips, not cheer |
| Plugins left out | privacy, writing, markets, mail, Terms in short, browser extension, Yoink, founding documents, Jammin: not built, and not in the source (`tools/prune`) |
| Arch agents | Guard, Priority, Medic and Planner (Irie's Mikael, Gabriel, Raphael and Raguel), each spoken of as "it" |
| VPN | Cisco Secure Client only, at vpn.example.com |

This clone is the copy's source, published at github.com/irie-people/pesto (remote `origin`). It takes Irie from the remote `irie`, which it never pushes to: on the owner's Mac that is the Irie checkout beside it, whose `live` branch is the installed build; elsewhere, github.com/irie-people/irie and its `main`.

## Bring it up to Irie's live build

    sh pesto.sh

It merges Irie's `live` (or `main`, from Irie's public repository), renames again where Irie's brand file changed, runs the copy's own checks (all of Irie's tests, as Pesto) and installs `pesto` and, once it is there, Pesto.app, with `tools/live.sh`. The first time, `sh pesto.sh --app` also builds Pesto.app and puts it in `~/Applications`. Nothing starts by itself.

## Open it

Open Pesto.app from Finder or Spotlight. Don't start `pesto` from an Irie session's terminal: Irie's `IRIE_` variables would follow it in, and Pesto's agents would carry an Irie session's name.

## Beside Irie

The two copies keep their own folders, socket, tmux server and variables, but a few parts of a core look at the whole Mac. `~/.config/pesto/config.toml` keeps Pesto off Irie's agents and servers: Gabriel slows nothing outside Pesto's own sessions (`arch.gabriel.outside = false`), Raguel holds no council (it starts a real Claude Code session), and Pesto's local model servers use ports 11445 and 11446, not Irie's. Still:

- Pesto's list shows Irie's agents among the sessions outside it. Don't move one in: that ends it in Irie.
- Raphael may offer to stop a busy Irie process. Say no.
- Pesto's VPN plugin drives the Mac's one VPN, as Irie's does.

## What to look at

- Every name a person reads says Pesto: the title bar, menus, Settings, the welcome, the sidebar, the help (`pesto help`).
- The left-out plugins leave nothing behind: no menus, panes, settings or words (`pesto plugins`, `pesto skills`).
- The VPN offers Cisco Secure Client and nothing else.
- The strip under the terminal shows tips.
- What macOS asks the first time (privacy, Background Items): Pesto is signed with the same local identity as Irie (`git config irie.sign`), so it asks once, not after every install.
