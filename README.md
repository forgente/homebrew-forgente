# Forgente: Homebrew

[![Join the chat at https://img.shields.io/discord/322538954119184384.svg](https://img.shields.io/discord/322538954119184384.svg)](https://discord.gg/NsatcWJ)

Homebrew repository to install Forgente and tools on macOS.
Soft fork of [gitea/homebrew-gitea](https://gitea.com/gitea/homebrew-gitea).

## Prepare

```bash
brew tap forgente/tap https://github.com/forgente/homebrew-forgente
```

## Install

### forgente

```bash
brew install forgente
forgente -h
```

Use `brew install forgente-head` for the nightly build instead.

### tea

```bash
brew install tea
tea -h
```

### act_runner

```bash
brew install act_runner
act_runner -h
```

### changelog

```bash
brew install changelog
changelog -h
```

## Upgrade

In case you installed Gitea before v1.8.3, you still might have the old tap. In that case, you need to remove it and add the new tap via

```bash
brew untap go-gitea/gitea
brew tap gitea/tap https://gitea.com/gitea/homebrew-gitea
```

Once you updated the tap, you can upgrade via

```bash
brew update && brew upgrade gitea tea changelog act_runner
```

## Uninstall

You can uninstall Gitea with

```bash
brew uninstall gitea tea changelog act_runner
```

Note that this will only uninstall the gitea binary. Your repositories, configuration, database, logs etc. are still kept in their locations (to check which folders Gitea is using, see `Site administration` -> `Configuration`).

## Contributing

Fork -> Patch -> Push -> Pull Request

## Authors

* [Maintainers](https://gitea.com/org/gitea/members)
* [Contributors](https://github.com/go-gitea/gitea/graphs/contributors)

## License

This project is under the MIT License. See the [LICENSE](LICENSE) file for the
full license text.

## Copyright

```sh
Copyright (c) 2016 The Gitea Authors <https://gitea.io>
```
