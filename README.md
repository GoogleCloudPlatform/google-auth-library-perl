# Google Cloud Client Libraries for Perl
<!-- Google Cloud Client Libraries for Perl -->

[![Multi-OS Monorepo CI](https://github.com/LLC-Technologies-Collier/google-auth-library-perl/actions/workflows/ci.yml/badge.svg)](https://github.com/LLC-Technologies-Collier/google-auth-library-perl/actions/workflows/ci.yml)

The official client library monorepo providing Google Cloud Platform (GCP) SDKs, high-performance gRPC transport engines, native C/XS Protocol Buffer codecs, authentication mechanisms, and code generation tooling for Perl.

This monorepo supports Google Cloud's core infrastructure, data analytics, networking, security, and machine learning services: **BigQuery, BigQuery Storage, Spanner, Dataproc, Dataflow, Pub/Sub, Storage (GCS), Compute Engine (GCE), IAM, Secret Manager, Cloud Build, Certificate Authority Service (Private CA), Secure Web Proxy (SWP), Cloud SQL, and Dataproc Metastore**.

---

## Key Features

- **Dual-Engine gRPC Transport (`Google::gRPC`)**: High-performance C/XS `nghttp2` bindings with automatic 100% Pure-Perl fallback (`Protocol::HTTP2`). Supports 5-byte gRPC wire framing, HTTP/2 multiplexed streams, deadlines, and exponential backoff retries.
- **Client-Side Connection Pooling & Load Balancing (`Google::gRPC::ChannelPool`)**: Round-robin subchannel distribution across resolved DNS IP addresses with per-socket request/byte metrics tracking.
- **Native Protobuf Serialization (`Protobuf`)**: Accelerated C/XS `upb` engine supporting Protocol Buffer Well-Known Types (WKTs: `Any`, `Duration`, `Timestamp`, `FieldMask`, `Struct`, `Wrappers`).
- **Unified GCP Authentication (`Google::Auth`)**: Application Default Credentials (ADC), Service Account JSON JWT signing, and Compute Engine Metadata Server integration with automatic token refresh.
- **Code Generation Tooling (`Module::Starter::Protobuf`)**: Automated `protobuf-starter` CLI tool for generating Type::Tiny-backed Perl SDKs from Google API proto definitions.

---

## Stack Architecture

```
┌──────────────────────────────────────────────────────────────────────────┐
│ [Layer 6] Service Client Libraries                                       │
│ • Google-Cloud-NetworkServices-V1  - Secure Web Proxy (SWP) Gateways     │
│ • Google-Cloud-NetworkSecurity-V1  - Gateway Security Policies & Rules   │
│ • Google-Cloud-PrivateCA-V1        - Certificate Authority Service (CAS) │
│ • Google-Cloud-SQL-V1              - Cloud SQL Admin                     │
│ • Google-Cloud-Metastore-V1        - Dataproc Metastore (DPMS)           │
│ • Google-Cloud-SecretManager-V1    - Secret Manager                      │
│ • Google-Cloud-Build-V1            - Cloud Build CI/CD Triggers          │
│ • Google-Cloud-IAM-V1              - Identity & Access Management (IAM) │
│ • Google-Cloud-Compute-V1          - Google Compute Engine (GCE)         │
│ • Google-Cloud-Storage-V2          - Google Cloud Storage (GCS)          │
│ • Google-Cloud-Dataproc-V1         - Cloud Dataproc (Spark / Hadoop)     │
│ • Google-Cloud-PubSub-V1           - Cloud Pub/Sub Messaging             │
│ • Google-Cloud-Composer-V1         - Cloud Composer (Managed Airflow)    │
│ • Google-Cloud-Dataflow-V1Beta3    - Cloud Dataflow (Apache Beam)        │
│ • Google-Cloud-Dataplex-V1         - Cloud Dataplex Data Governance      │
│ • Google-Cloud-DataFusion-V1       - Cloud Data Fusion (ETL Pipelines)   │
│ • Google-Cloud-BigQuery-Storage-V1- Cloud BigQuery Storage API (Arrow)   │
│ • Google-Cloud-Bigquery-V2         - Cloud BigQuery V2 Data Warehouse    │
│ • Google-Cloud-Spanner-V1          - Cloud Spanner Relational Database   │
├──────────────────────────────────────────────────────────────────────────┤
│ [Layer 5] Code Generator Tooling                                         │
│ • Module-Starter-Protobuf          - GAPIC protobuf-starter CLI generator│
├──────────────────────────────────────────────────────────────────────────┤
│ [Layer 4] gRPC Transport Layer                                          │
│ • Google-gRPC                      - Dual-Engine (nghttp2 C/XS + PP)     │
│                                    - ChannelPool DNS Load Balancer       │
├──────────────────────────────────────────────────────────────────────────┤
│ [Layer 3] Google API Common Metadata                                    │
│ • Google-Api-Common                - google.api.* & google.type.* types  │
├──────────────────────────────────────────────────────────────────────────┤
│ [Layer 2] Authentication & Security                                     │
│ • google-auth                      - Google::Auth (ADC, Service Account) │
├──────────────────────────────────────────────────────────────────────────┤
│ [Layer 1] Serialization & Wire Codec                                     │
│ • Protobuf                         - Native C/XS upb engine + WKTs       │
└──────────────────────────────────────────────────────────────────────────┘
```

---

## Monorepo Distributions

| Directory | CPAN Package | Version | Layer | Description |
| :--- | :--- | :---: | :--- | :--- |
| **`Protobuf/`** | `Protobuf` | `0.05` | Codec | C/XS `upb` binary serialization codec and Protocol Buffer WKTs (`google.protobuf.*`). |
| **`google-auth/`** | `Google::Auth` | `0.02` | Security | Application Default Credentials (ADC), Service Account JSON keyfiles, GCE metadata server, and token caching. |
| **`Google-Api-Common/`** | `Google::Api::Common` | `0.01` | Common | Google API common annotations and types (`google.api.http`, `google.rpc.Status`, `google.type.Date`). |
| **`Google-gRPC/`** | `Google::gRPC` | `0.02` | Transport | `nghttp2` C/XS bindings, 100% Pure-Perl fallback (`Protocol::HTTP2`), DNS `getaddrinfo` load balancing, deadlines, and retries. |
| **`Module-Starter-Protobuf/`** | `Module::Starter::Protobuf` | `0.01` | Tooling | `protobuf-starter` CLI generator and `protoc-gen-perl-pb` integration. |
| **`Google-Cloud-Bigquery-V2/`** | `Google::Cloud::Bigquery::V2` | `0.01` | Service Client | Cloud BigQuery V2 Data Warehouse API client. |
| **`Google-Cloud-BigQuery-Storage-V1/`** | `Google::Cloud::BigQuery::Storage::V1` | `0.01` | Service Client | Cloud BigQuery Storage API client for high-throughput Arrow streaming. |
| **`Google-Cloud-Spanner-V1/`** | `Google::Cloud::Spanner::V1` | `0.01` | Service Client | Cloud Spanner V1 relational database client. |
| **`Google-Cloud-Dataproc-V1/`** | `Google::Cloud::Dataproc::V1` | `0.01` | Service Client | Cloud Dataproc V1 API client (GCE clusters & Serverless Spark). |
| **`Google-Cloud-PubSub-V1/`** | `Google::Cloud::PubSub::V1` | `0.01` | Service Client | Cloud Pub/Sub V1 messaging API client. |
| **`Google-Cloud-Storage-V2/`** | `Google::Cloud::Storage::V2` | `0.01` | Service Client | Cloud Storage V2 API client. |
| **`Google-Cloud-Compute-V1/`** | `Google::Cloud::Compute::V1` | `0.01` | Service Client | Compute Engine V1 API client. |
| **`Google-Cloud-IAM-V1/`** | `Google::Cloud::IAM::V1` | `0.01` | Service Client | Identity & Access Management (IAM) V1 API client. |
| **`Google-Cloud-Build-V1/`** | `Google::Cloud::Build::V1` | `0.01` | Service Client | Cloud Build V1 API client. |
| **`Google-Cloud-SecretManager-V1/`** | `Google::Cloud::SecretManager::V1` | `0.01` | Service Client | Secret Manager V1 API client. |
| **`Google-Cloud-Metastore-V1/`** | `Google::Cloud::Metastore::V1` | `0.01` | Service Client | Dataproc Metastore (DPMS) V1 API client. |
| **`Google-Cloud-SQL-V1/`** | `Google::Cloud::SQL::V1` | `0.01` | Service Client | Cloud SQL Admin V1 API client. |
| **`Google-Cloud-PrivateCA-V1/`** | `Google::Cloud::PrivateCA::V1` | `0.01` | Service Client | Certificate Authority Service (Private CA) V1 API client. |
| **`Google-Cloud-NetworkSecurity-V1/`** | `Google::Cloud::NetworkSecurity::V1` | `0.01` | Service Client | Gateway Security Policies & Rules V1 API client. |
| **`Google-Cloud-NetworkServices-V1/`** | `Google::Cloud::NetworkServices::V1` | `0.01` | Service Client | Secure Web Proxy (SWP) Gateways V1 API client. |
| **`Google-Cloud-Composer-V1/`** | `Google::Cloud::Composer::V1` | `0.01` | Service Client | Cloud Composer V1 API client (Managed Airflow). |
| **`Google-Cloud-Dataflow-V1Beta3/`** | `Google::Cloud::Dataflow::V1Beta3` | `0.01` | Service Client | Cloud Dataflow V1Beta3 API client (Apache Beam). |
| **`Google-Cloud-DataFusion-V1/`** | `Google::Cloud::DataFusion::V1` | `0.01` | Service Client | Cloud Data Fusion V1 API client. |
| **`Google-Cloud-Dataplex-V1/`** | `Google::Cloud::Dataplex::V1` | `0.01` | Service Client | Cloud Dataplex V1 API client. |

---

## Code Examples

### 1. BigQuery Query Execution

```perl
use strict;
use warnings;
use Google::Auth;
use Google::Cloud::Bigquery::V2;
use Google::Cloud::Bigquery::V2::Job::QueryRequest;
use Google::Protobuf::Wrappers;

my $auth = Google::Auth->default();
my $bq   = Google::Cloud::Bigquery::V2->new( credentials => $auth );

my $request = Google::Cloud::Bigquery::V2::Job::QueryRequest->new(
    query          => 'SELECT COUNT(*) as total FROM `perl-cloud-ci.samples.users`',
    use_legacy_sql => Google::Protobuf::Wrappers::BoolValue->new( value => 0 ),
);

my $response = $bq->query(
    project_id    => 'perl-cloud-ci',
    query_request => $request,
);

print "Query executed successfully. Result rows: " . scalar(@{$response->rows()}) . "\n";
```

### 2. Spanner Round-Robin Load Balancing

```perl
use strict;
use warnings;
use Google::gRPC::ChannelPool;
use Google::gRPC::Client;

# Create subchannel pool across resolved DNS endpoints
my $pool = Google::gRPC::ChannelPool->new(
    target       => 'spanner.googleapis.com:443',
    resolved_ips => ['10.0.0.1', '10.0.0.2', '10.0.0.3'],
);

my $client = Google::gRPC::Client->new( channel_pool => $pool );

# Dispatch streaming RPC across round-robin channels
my $stream = $client->stream(
    service => 'google.spanner.v1.Spanner',
    method  => 'ExecuteSql',
    type    => 'unary',
);

print "Dispatched stream to target: " . $stream->channel->target . "\n";
```

---

## Installation & Quickstart

Build and install the distributions in dependency order using `cpanm`:

```bash
# 1. Install Core Infrastructure & Transport Stack
cpanm ./Protobuf
cpanm ./google-auth
cpanm ./Google-Api-Common
cpanm ./Google-gRPC
cpanm ./Module-Starter-Protobuf

# 2. Install Service Clients
cpanm ./Google-Cloud-Bigquery-V2
cpanm ./Google-Cloud-BigQuery-Storage-V1
cpanm ./Google-Cloud-Spanner-V1
cpanm ./Google-Cloud-Dataproc-V1
cpanm ./Google-Cloud-PubSub-V1
cpanm ./Google-Cloud-Storage-V2
cpanm ./Google-Cloud-Compute-V1
cpanm ./Google-Cloud-IAM-V1
cpanm ./Google-Cloud-Build-V1
cpanm ./Google-Cloud-SecretManager-V1
cpanm ./Google-Cloud-Metastore-V1
cpanm ./Google-Cloud-SQL-V1
cpanm ./Google-Cloud-PrivateCA-V1
cpanm ./Google-Cloud-NetworkSecurity-V1
cpanm ./Google-Cloud-NetworkServices-V1
cpanm ./Google-Cloud-Composer-V1
cpanm ./Google-Cloud-Dataflow-V1Beta3
cpanm ./Google-Cloud-DataFusion-V1
cpanm ./Google-Cloud-Dataplex-V1
```

---

## License

Apache License, Version 2.0. See [LICENSE](LICENSE) for details.
