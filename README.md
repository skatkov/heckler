# Heckler

**Heckler** is a tool to identify wording or spelling mistakes in ruby codebase: filenames, class names, method names, property names and more. Spelling correction is powered by [GNU Aspell](https://en.wikipedia.org/wiki/GNU_Aspell) and originally started as a ruby port of [Peck](https://github.com/peckphp/peck).

## Installation

```bash
bundle add heckler
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install heckler
```

## Dependencies
Heckler requires Aspell to be present on a system to function.

### MacOS
`brew install aspell`

### Linux
- Debian/Ubuntu: `sudo apt-get install aspell aspell-en`
- Fedora: `sudo dnf install aspell aspell-en`
- Arch Linux: `sudo pacman -S aspell aspell-en`
- openSUSE: `sudo zypper install aspell aspell-en`
- Alpine: `sudo apk add aspell aspell-en`

## Usage

Start off by creating a configuration file, by running:
`heckler init`

Run spelling check with `heckler`


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/skatkov/heckler.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
