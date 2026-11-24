# PDL ML, Data Engineering & GPU Architecture (Design Sketch)

This document sketches the layered architecture for the `PDL::ML::*`, `PDL::IO::*`, and `Alien::*` ecosystem following `PDLPorters` feedback (see also `PDLPorters/pdl#562` and `PDLPorters/pdl#349`).

---

## 1. Three-Layer Separation for Heavy Native Backends (`libtorch`, `ggml`)

Rather than conflating native library discovery, low-level GPU/HPC compute, and high-level ML training/inference into a single top-level distribution, split them into three clean layers:

### Layer 1: Native Library Discovery & Packaging (`Alien::*`)
* **`Alien::GGML`** (target: `PDLPorters`):
  * Cross-platform (`Linux`, `macOS`, `Windows`) discovery/build of `libggml` + backend plugins (CPU, Vulkan, Metal, CUDA).
  * Unlocks both `PDL::ML::*` inference and `PDL`'s proposed pluggable `cgraph` broadcastloop.
* **`Alien::LibTorch`** (or `Alien::PyTorch`):
  * Cross-platform discovery of `libtorch` via `$ENV{LIBTORCH}`, system `libtorch-dev`, `pkg-config`, Python `torch`, or prebuilt LibTorch archive download.
  * Exposes `cflags` and `libs` cleanly so downstream `Makefile.PL` files never duplicate path-hunting logic.
* **`Alien::OpenBLAS` / `Alien::LAPACK`** (target: `PDLPorters`):
  * Supports `FlexiBLAS` and `PDL::LinearAlgebra` linking against already-compiled dynamic libraries.

### Layer 2: Uniform ML Engine Interface (`PDL::ML::Engine::*`)
All ML engines share a consistent, PDL-idiomatic interface so users can swap backends easily:

* **`PDL::ML::Engine::Torch`** (built on `Alien::LibTorch`):
  * **Inference:** Load and execute TorchScript models (`torch::jit::load()` / `forward($input_pdl)`).
  * **Training & Autograd:** `requires_grad`, `backward()`, `grad()`, built-in losses (`mse_loss`, `cross_entropy`), and optimizer step (`sgd_step` / `adam_step`), verified by a full end-to-end training-loop tutorial test (mirroring PyTorch's C++ `libtorch` tutorial).
  * **Devices & Precision:** `cpu`, `cuda` (including Blackwell `sm_110` FP16/BF16/FP8), `mps`, `rocm`; deterministic VRAM release via Perl `DESTROY`.
* **`PDL::ML::Engine::XGBoost`** (`libxgboost`): GBDT `DMatrix`, `train`, `predict`, `save_model`/`load_model`.
* **`PDL::ML::Engine::ONNX`** (`libonnxruntime`): Cross-framework `.onnx` inference across CPU/CUDA/Dnnl/Xnnpack execution providers.
* **`PDL::ML::Engine::MLPack`** (`libmlpack` / Armadillo): Classical ML (`linear_regression`, `kmeans`, etc.).

### Layer 3: GPU / HPC Broadcastloop Integration (Long-Term, `PDLPorters`)
* Once `PDL` gains pluggable `cgraph` broadcastloops (`PDLPorters/pdl#349`), `Alien::GGML` (and optionally `Alien::LibTorch`) can register as a broadcastloop backend that inspects a `cgraph` and accepts or declines execution based on supported ops and tensor size — keeping `PDL` itself vendor-agnostic and cross-platform.

---

## 2. Supporting Ecosystem Layers

| Layer | Distributions |
| :--- | :--- |
| **Columnar & Weight I/O** | `PDL::IO::Arrow`, `PDL::IO::Protobuf`, `PDL::IO::DuckDB`, `PDL::IO::Safetensors`, `PDL::IO::GGUF` |
| **Vector Search** | `PDL::ML::Vector::FAISS` |
| **Tokenisation** | `PDL::ML::Token::Tokenisers`, `PDL::ML::Token::SentencePiece` |
| **Preprocessing & Metrics** | `PDL::ML::Preprocess`, `PDL::ML::Metrics` |
| **RAG Orchestration** | `PDL::ML::RAG` |

---

## 3. PDL Binding Best Practices (For Humans & Coding Agents)

1. **Versioning:** Use 3-decimal-place versions (`0.011`, `0.012`, ...) for monotonic CPAN/BackPAN compatibility.
2. **XS & Build Hygiene:**
   * Use `XSMULTI => 1` for pure-XS distributions so `.xs` sits alongside `.pm`.
   * Hard-depend on `ExtUtils::CppGuess` for C++ extensions; list C++ objects in `OBJECT`.
   * Preserve quotes in `PDL::Core::Dev::PDL_INCLUDE()` (never strip `"` — breaks paths with spaces).
   * Fail loudly (`die`) in `Makefile.PL` when required native libraries are missing (no silent `exit 0` or `has_xs` fallbacks).
3. **Documentation & Tests:**
   * Follow `PDL::Doc` style (`=head2 name` with `=for ref`, `=for usage`, `=for example`).
   * Include an explicit `=head1 TYPES` section stating supported PDL types and whether `cfloat`/`cdouble` are supported.
   * Drive tests and `SYNOPSIS` examples from real-world tutorials for the underlying native library.
