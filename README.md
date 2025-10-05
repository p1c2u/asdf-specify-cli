# asdf-specify-cli

[![Build](https://github.com/p1c2u/asdf-specify-cli/actions/workflows/build.yml/badge.svg)](https://github.com/p1c2u/asdf-specify-cli/actions/workflows/build.yml)

Specify CLI plugin for the [asdf version manager](https://asdf-vm.com).

Specify CLI is part of [Spec Kit](https://github.com/github/spec-kit) from GitHub. It helps you work with API specifications and validate OpenAPI documents.

## Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Dependencies

- `bash`, `curl`, `tar`: generic POSIX utilities
- `python3`: Python 3.x
- `pip`: Python package installer (usually comes with Python)

## Install

Plugin:

```shell
asdf plugin add specify-cli https://github.com/p1c2u/asdf-specify-cli.git
```

specify-cli:

```shell
# Show all installable versions
asdf list-all specify-cli

# Install specific version
asdf install specify-cli latest

# Set a version globally (on your ~/.tool-versions file)
asdf global specify-cli latest

# Now specify-cli commands are available
specify --help
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to install & manage versions.

## Usage

After installation, you can use the `specify` command:

```shell
# Get help
specify --help

# Initialize a new project
specify init

# Check required tools
specify check
```

For more information about Specify CLI usage, visit the [official documentation](https://speckit.org).

## Contributing

Contributions of any kind welcome! See the [contributing guide](CONTRIBUTING.md).

## License

See [LICENSE](LICENSE) © [Artur Czepiel](https://github.com/p1c2u/)
