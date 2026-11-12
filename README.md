# hemel

hemel is a terminal client for Bluesky, built around code snippets. Its home is
[hemel.app](https://hemel.app).

[![hemel in a terminal: a thread with a highlighted TypeScript snippet over the timeline](https://hemel.app/og.png)](https://hemel.app)

This repository holds the releases, the Homebrew tap and the public issue tracker. It
holds no source code.

## Install

With Homebrew, on macOS and Linux:

```sh
brew tap nhack/hemel https://github.com/nhack/hemel
brew install nhack/hemel/hemel
```

The full name trusts the formula on its own. To trust the whole tap instead, run
`brew trust nhack/hemel` once; then `brew install hemel` works too.

Or download the archive of your machine from the
[releases page](https://github.com/nhack/hemel/releases), `hemel-<version>-<target>.tar.gz`:
it unpacks into one folder of the same name, holding `hemel`, `hemel-mcp`, `LICENSE` and
`THIRD-PARTY-NOTICES.txt`. Put the two binaries in a folder on your `PATH`. Windows: run
the `linux-x64` binary in WSL until native support lands.

On macOS the binaries are not signed. A file downloaded through a browser carries the
quarantine flag, and macOS then refuses to open it. Clear the flag once, in the unpacked
folder; a brew install needs no such step:

```sh
xattr -d com.apple.quarantine hemel hemel-mcp
```

## First start

```sh
hemel
```

The first start shows the sign-in screen: enter your handle and approve the sign-in in
the browser. Over SSH, open the address it shows in a local browser and paste back the
address the browser ended on. `ctrl+p` switches to an
[app password](https://bsky.app/settings/app-passwords). The next start resumes the
session. `?` shows the keys, `:` opens the command palette and `q` quits.

```sh
hemel --profile mock          # look around on mock data, no account needed
hemel login                   # sign in without the screen
hemel login --app-password    # the same with an app password
hemel logout                  # sign out and delete the stored session
hemel post --file main.rs     # post a snippet of a file (below)
hemel --version               # print the version and the commit it was built from
hemel --help                  # every command, option and environment variable
```

In the command palette, `:about` shows the version, the feedback doors and where this
machine keeps its data, `:logout` signs out, and `:bots` hides and shows the posts of
bot accounts and the posts an agent wrote.

## Post a snippet from the shell

```sh
hemel post --file src/main.rs --lines 10-20 --text "retry with backoff"
```

`hemel post` makes a snippet post of a file, or of a line range of it (`--lines 12` for
one line), and posts it to the signed-in account. It prints the account, the file, the
lines, the language and what bsky.app will show, then asks `Post it? [y/N]`. The language
comes from the file's extension; `--lang` names another. `--title` adds a title, and
`--yes` posts without asking, for scripts. `--account <name>` posts from another account
slot. Nothing is posted unless the answer is `y` or `yes`, and every error exits non-zero.

A snippet post is a normal Bluesky post plus a record with the code, the language and an
optional file name, under the lexicon `app.hemel.snippet`. Each release carries the
lexicon as `app.hemel.snippet.json`.

## Agent access (MCP)

`hemel-mcp` lets a coding agent read the network through the Model Context Protocol:
timelines, threads, profiles, follows, notifications, search, and the full code of every
snippet post. It reads as the account signed in to hemel on this machine (`hemel login`),
or public data when nobody is signed in. It never signs in by itself, and it writes only
when started with a write mode (see "Writes" below).

Register it with Claude Code:

```sh
claude mcp add hemel -- hemel-mcp
```

`hemel-mcp --help` lists every option and environment variable of the server.
`--profile mock` (or `HEMEL_PROFILE=mock`) serves mock data instead. After a login or a
logout in hemel, restart the server so it picks up the session. `--account <name>` (or
`HEMEL_ACCOUNT`) on both binaries opens a second stored session, a slot, while your own
session stays where it is.

A host that speaks MCP resources can attach a feed or a thread without a tool call:
`atproto://feed/following` (or a feed generator's `at://` URI after `atproto://feed/`),
`atproto://author/<handle or DID>` and `atproto://thread/<bsky.app post URL or at:// URI>`
answer the same JSON as the tools, and the server lists the signed-in account's pinned
feeds.

Every string a tool or a resource returns was written by someone on the network; the
server says so in each description and result, so an agent treats it as data, not
instructions.

### Writes

Writes are off by default: the server registers no write tool, so a host that approves
tools automatically cannot post. Start it with a write mode to add `create_post`,
`create_snippet_post`, `like`, `unlike`, `repost`, `unrepost`, `follow`, `unfollow` and
`delete_post`:

```sh
claude mcp add hemel -- hemel-mcp --writes assistant
```

| Flag                          | Variable             | Values                                   | Default          |
| ----------------------------- | -------------------- | ---------------------------------------- | ---------------- |
| `--writes <mode>`             | `HEMEL_WRITES`       | `off`, `assistant`, `bot`                | `off`            |
| `--account <name>`            | `HEMEL_ACCOUNT`      | lowercase letters, digits and dashes     | the unnamed slot |
| `--interact <rule>`           | `HEMEL_INTERACT`     | `addressed`, `any` (assistant mode only) | `addressed`      |
| `--write-budget <hour>/<day>` | `HEMEL_WRITE_BUDGET` | two whole numbers, at most `1000/7000`   | `30/150`         |

A flag wins over its variable; the interact and budget variables are ignored while
writes are off, the flags are refused.

- **Assistant mode** writes as your own account, the one signed in to hemel. Every post
  the agent writes carries the self-label `bot` in its record, so any client that reads
  labels can tell it apart; your profile is never labeled.
- **Bot mode** runs as a separate account on its own slot, and labels that account's
  profile as a bot the first time it starts:

  ```sh
  hemel login --account bot
  claude mcp add hemel-bot -- hemel-mcp --account bot --writes bot
  ```

- **The addressed rule.** The agent replies to, likes or reposts only a post that mentions
  the account, replies to one of its posts, sits under one of its posts, or is its own; it
  follows only an account that follows it. Top-level posts and undos are never gated. A
  refused write is the tool error `not_addressed`. In assistant mode, `--interact any`
  lifts the rule for that server run; bot mode keeps it.
- **The budget.** Records are the unit: a post, a like, a repost, a follow, an undo or a
  delete is one, a snippet post two. The default is 30 an hour and 150 a day, far below
  the network's limits, kept in `write-ledger.json` beside the secrets file (per slot on a
  slot) and shared by every server process on the account. Over budget, a write fails
  with `rate_limited` before anything is sent; every write result and `whoami` carry the
  budget left.
- **What the server refuses at startup**, each with a one-line reason: `--writes bot`
  without `--account` (a bot is never your own slot), `--interact any` in bot mode or
  with writes off, `--interact` or `--write-budget` typed with writes off, a budget over
  `1000/7000` or with a day under the hour, and writes on while signed out, where the
  hint names the slot to sign in (`hemel login --account bot`).
- After a `network` failure a write may or may not have landed: the units stay spent,
  the error says so, and the agent should read the author feed before retrying.

## Where the session is kept

- **macOS:** in the login keychain, under the service `hemel`. Over SSH the login
  keychain is locked: a session signed in there goes to the file below instead.
- **Linux:** in the Secret Service through `secret-tool`, under the service `hemel`.
  This needs the `secret-tool` command (the `libsecret-tools` package on Debian and
  Ubuntu, `libsecret` on Fedora and Arch) and a running keyring, such as GNOME Keyring or
  KWallet. Without them, for example on a headless server, the session goes to the file
  below.
- **The file:** `~/.config/hemel/secrets.json` (or `$XDG_CONFIG_HOME/hemel/secrets.json`),
  readable by you alone (mode 0600). The search history sits beside it.

`hemel logout` deletes the session from the keychain and from the file.

## Feedback

- Report a bug or ask for a feature: [open an issue](https://github.com/nhack/hemel/issues).
- Post on Bluesky and mention [@hemel.app](https://bsky.app/profile/hemel.app).
- Write to hello@hemel.app.

In the app, `:about` shows all three.

## License

Freeware: hemel is free to use for any purpose and free to pass on unchanged, but it may
not be sold, changed or reverse engineered, and its source is not published. The full
terms are in [LICENSE](LICENSE), the hemel Freeware License. The third-party parts inside
the binaries keep their own licenses, listed in the `THIRD-PARTY-NOTICES.txt` of every
archive; each release also carries `hemel-bundle-<version>.tar.gz` and `RELINK.md`, the
materials to relink hemel with a modified runtime, as section 5 of the license promises.
