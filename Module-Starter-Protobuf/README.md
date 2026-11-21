# Module-Starter-Protobuf

Code generation scaffolding (`protobuf-starter`) and `Module::Starter` plugin
(`Module::Starter::Protobuf`) for generating `Moo` + `Type::Tiny` Google Cloud
gRPC and REST Perl SDKs from `.proto` service definitions.

## Usage

```bash
perl bin/protobuf-starter \
  --module=Google::Cloud::Dataproc::V1 \
  --protos="${PROTO_ROOT}/google/cloud/dataproc/v1/clusters.proto" \
  --import-path="${PROTO_ROOT}" \
  --grpc-target="dataproc.googleapis.com:443" \
  --dir=./Google-Cloud-Dataproc-V1
```

Within Google3 Blaze builds, prefer the native `perl_proto_library` rule in
`//enterprise/support/cloud/troubleshooting/tools/data_analytics/cjproc/proto_codegen`,
which compiles `proto_library` descriptor sets hermetically during `blaze
build`.

## License and Copyright

Copyright 2026 Google LLC

Licensed under the Apache License, Version 2.0 (the "License"); you may not use
this file except in compliance with the License. See `../LICENSE` for the full
license text.
