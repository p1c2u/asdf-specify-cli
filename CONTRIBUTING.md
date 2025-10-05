# Contributing

Thanks for considering contributing to asdf-specify-cli!

## Issues

Feel free to submit issues and enhancement requests.

## Contributing

1. Fork the repo
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -am 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Create a new Pull Request

## Testing

Before submitting a PR, please test your changes:

```bash
# Test listing versions
asdf plugin test specify-cli https://github.com/p1c2u/asdf-specify-cli.git "specify --help"
```

## Code Style

- Use shellcheck for bash scripts
- Follow existing code style
- Keep it simple and maintainable
