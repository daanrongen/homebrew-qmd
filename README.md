# homebrew-qmd

Unofficial [Homebrew](https://brew.sh) tap for [`qmd`](https://github.com/tobi/qmd), not affiliated with its author.

```sh
brew trust daanrongen/qmd
brew install daanrongen/qmd/qmd
```

`Formula/qmd.rb` installs the published `@tobilu/qmd` npm package with its dependencies (native modules included) into the formula's own `libexec`, and runs it under Homebrew's `node`. Nothing qmd needs lives in `~/.cache/qmd` or `~/.config/qmd`, so clearing them never breaks the install. Pushing a tag such as `v2.8.4` runs [`update.yml`](.github/workflows/update.yml), which points the formula at that npm release, installs and tests it, and commits. Edit the formula by hand only for changes other than url and sha256.

Report qmd bugs upstream at [tobi/qmd](https://github.com/tobi/qmd/issues), and packaging problems here.
