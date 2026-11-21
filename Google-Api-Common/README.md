# Google-Api-Common

Core HTTP/REST client base and pluggable HTTP/1.1 + HTTP/2 transport layer for
Google Cloud Perl SDKs:

- **`Google::Cloud::ClientBase`** & **`Google::Cloud::ClientBase::Stream`**:
  Payload serialization (`json` and `protobuf` wire formats) and asynchronous
  streaming wrappers.
- **`Google::Cloud::REST::Client`**: Retry-aware JSON/REST transport built on
  `Future` and `Google::Cloud::ClientBase`.
- **`Google::Cloud::Transport::Adapter::{LWP,NetCurl,Nghttp2}`**: Pluggable
  transport adapters supporting HTTP/1.1 (`LWP::UserAgent`), `libcurl`
  (`Net::Curl`), and native multiplexed HTTP/2 (`Net::HTTP2::nghttp2`).

## Automatic `.proto` Schema Generation

Per Google3 generated-code policy (`go/generated-code`), `.proto`-derived
`googleapis` schema modules (`Google::Api::*`, `Google::Longrunning::*`,
`Google::Rpc::*`, and `Google::Type::*`) are generated automatically at build
time rather than checked into source control:

- **Blaze Builds (Default in Google3)**: Built automatically from live Google3
  `proto_library` targets via `perl_proto_library` in
  `//enterprise/support/cloud/troubleshooting/tools/data_analytics/cjproc/proto_codegen`.
  No manual steps are required.
- **Standalone `ExtUtils::MakeMaker` Builds**: Running `perl Makefile.PL &&
  make` automatically invokes `protoc` with `protoc-gen-perl-pb` into
  `blib/lib` whenever `PROTO_ROOT` and `protoc-gen-perl-pb` are present.

## Testing

```bash
prove -j"$(nproc)" -Ilib t/
```

## License and Copyright

Copyright 2026 Google LLC

Licensed under the Apache License, Version 2.0 (the "License"); you may not use
this file except in compliance with the License. See `../LICENSE` for the full
license text.
