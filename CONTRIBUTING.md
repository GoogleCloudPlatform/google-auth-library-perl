# Contributing to Google Auth Library for Perl

First off, thank you for considering contributing!

## Bug Reports

If you find a bug, please file an issue on the GitHub repository. Include as much detail as possible, such as:

*   Perl version
*   Operating system
*   Version of this library
*   Steps to reproduce
*   Expected behavior
*   Actual behavior
*   Any relevant logs or error messages

## Feature Requests

Feature requests are welcome! Please file an issue on GitHub describing the feature and why it would be useful.

## Pull Requests

We actively welcome your pull requests.

1.  Fork the repository.
2.  Create a new branch for your feature or bug fix:
    ```bash
    git checkout -b my-new-feature
    ```
3.  Make your changes.
4.  **Add tests!** Your patch won't be accepted if it doesn't have tests.
5.  Ensure all tests pass. For the `Google::Auth` library itself:
    ```bash
    # From the google-auth-library-perl/google-auth directory
    perl Makefile.PL
    make
    make test
    ```
    If you made changes to the underlying Protobuf library in `protobuf/perl`:
    ```bash
    # From the google-auth-library-perl/protobuf/perl directory
    perl Makefile.PL
    make
    make test
    ```
6.  Commit your changes. Follow the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) specification.
7.  Push to your fork and submit a pull request.

## Development Setup

To set up your development environment:

1.  Clone the repository.
2.  Initialize and update the submodule:
    ```bash
    git submodule update --init --recursive
    ```
3.  Install dependencies for the `Google::Auth` library:
    ```bash
    # From the google-auth-library-perl/google-auth directory
    cpanm --installdeps .
    ```
4.  Install dependencies for the `Protobuf` library:
    ```bash
    # From the google-auth-library-perl/protobuf/perl/ directory
    cpanm --installdeps .
    ```

## Code Style

Please adhere to the existing code style. We use `perlcritic` to help enforce this. Run `perlcritic` before submitting:

```bash
# From the google-auth-library-perl/google-auth directory
perlcritic lib/ t/

# From the google-auth-library-perl/protobuf/perl directory
perlcritic lib/ t/
```

## Protobuf Dependency

Note that this library depends on a modified version of Protocol Buffers, included as a submodule in the `protobuf` directory. Changes to the core Protobuf C/UPB/XS layer should be made within `protobuf/perl`.

Thank you for your contributions!
