# Pesto

Pesto is [Irie](https://github.com/irie-people/irie), renamed the way a company would rename it for a product of its own. It was made to test how well Irie ports to a company. It is a test copy, not a product.

Everything here is Irie's code, under Irie's licence (Apache-2.0), with two changes made by Irie's own tools: `tools/rebrand.sh` rewrote `internal/brand/brand.go`, and `tools/prune` took out the code of every plugin Pesto leaves out. That gives Pesto:

- its own name, command (`pesto`), folders, variables, tmux server and bundle ID (`com.example.pesto`);
- tips under the terminal rather than words of encouragement;
- none of the personal plugins (privacy, writing, markets, mail, Terms in short, the browser extension, Yoink, the founding documents, Jammin). Their code is out of its builds and its source; what stays is the settings and messages Irie's core shares with them, and stand-ins that say a plugin isn't in this build;
- arch agents named for their work: Guard, Priority, Medic and Planner, each spoken of as "it";
- one VPN, Cisco Secure Client.

## What it showed

- Texts, cards, help and setup lines in Irie that assumed Irie's own names. They are fixed in Irie.
- Irie's tests pass under another name as they do under Irie's. Irie's CI checks this on every push, with a copy renamed to Pesto.
- A copy can leave a plugin out of its source, not only its builds. Each plugin's Go and Swift code is marked as its own, and Irie's `tools/prune` takes out what a copy's tags leave out.
- A copy can name the arch agents for their work.
- Pesto runs on a Linux server beside an Irie, with sessions of its own on Claude Code.
- What is still open, such as two copies sharing one machine, is in Irie's [company copies proposal](https://github.com/irie-people/irie/blob/main/docs/proposals/company-copies.md).

## Build it

    go build -tags "$(sh tools/brand.sh --tags)" -o pesto ./cmd/irie

`PESTO.md` says what to look at. `pesto.sh` brings a checkout up to Irie's latest build and installs it beside Irie. It needs Irie as a remote: `git remote add irie https://github.com/irie-people/irie`.

## A copy of your own

To make a company's copy of Irie, run `tools/rebrand.sh NAME` in a clone of Irie, as Pesto did. Irie's DESIGN §2.10 says what the name reaches and what a copy changes by hand. Pesto's own GitHub Actions are off: Irie's CI runs the same checks under the Pesto name.
