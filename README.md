# Google Auth Library for Perl

This repository contains the Perl implementation of the Google Authentication Library.

## Overview

The `Google::Auth` module (located in the `google-auth/` directory) provides mechanisms for authenticating to Google Cloud Platform services.

This library also includes a modified version of the Protocol Buffers library for Perl, located in the `protobuf/` directory as a git submodule. This version uses the UPB C library for efficient Protocol Buffer parsing and serialization.

## Features (Google::Auth)

*   Supports various Google authentication methods.
*   Automatic token refreshing.
*   Easy integration with Google Cloud client libraries.

## Installation

1.  Clone the repository:
    ```bash
    git clone https://github.com/GoogleCloudPlatform/google-auth-library-perl.git
    cd google-auth-library-perl
    ```

2.  Initialize and update the submodules:
    ```bash
    git submodule update --init --recursive
    ```

3.  Install the `Protobuf` dependency:
    ```bash
    cd protobuf/perl
    cpanm --installdeps .
    perl Makefile.PL
    make
    make test
    sudo make install
    cd ../..
    ```

4.  Install the `Google::Auth` library:
    ```bash
    cd google-auth
    cpanm --installdeps .
    perl Makefile.PL
    make
    make test
    sudo make install
    cd ..
    ```

## Usage Example (Google::Auth)

```perl
use strict;
use warnings;
use Google::Auth;

# Example usage (will vary based on auth method)
# my $auth = Google::Auth->new(...);
# my $token = $auth->get_access_token();

# print "Access Token: $token
";
```

## Development and Contributing

Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details on how to contribute, set up your development environment, and run tests.

## Protobuf Submodule

The `protobuf/` directory contains a fork of the official Protocol Buffers repository, currently based on tag `v22.3`. The Perl-specific implementation (XS and PM files) is primarily located within `protobuf/perl/`. This module is a dependency for `Google::Auth`.

Our intention is to regularly rebase these Perl modifications onto future releases of the official Protocol Buffers repository. The ultimate goal is to have the Perl support merged into the upstream Protocol Buffers project.

## License

This library is licensed under the Apache License, Version 2.0. See the [LICENSE](google-auth/LICENSE) file for more details.
