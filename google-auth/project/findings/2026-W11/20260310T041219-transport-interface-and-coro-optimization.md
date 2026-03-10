# Finding: Pluggable Transport Interface and Coro Optimization (2026-W11/20260310T041219)

## Discovery
The original architecture of the Perl port hardcoded `LWP::UserAgent` inside authentication and ID token classes. This created a blocking dependency on OS-level I/O when used in a `Coro` cooperative multitasking environment. By analyzing the Python and Ruby Google Auth libraries, it was confirmed that a pluggable transport interface is the standard way to decouple auth logic from the HTTP client.

## Solution / Rule
- **Transport Interface:** All classes that perform HTTP requests MUST accept a `$transport` object (duck-typed or implementing `Google::Auth::Transport`).
- **Standard Signature:** The transport's `request()` method must accept `(url, method, headers, body, timeout)` and return a response object with `(status, headers, data)`.
- **Coro Compatibility:**
    - Avoid using `Mutex` or standard `Thread::Semaphore` objects as they block the entire process under `Coro`. Cooperative multitasking naturally handles state safety between I/O points (yield points).
    - Prefer epoch integers (`time()`) over `DateTime` for simple calculations to reduce overhead and minimize dependencies.
    - Leverage `Coro::LWP` by passing a custom-configured `LWP::UserAgent` into the `Google::Auth::Transport::LWP` adapter.
- **Decomposition:** Large files like `KeySources.pm` that aggregate multiple concerns (interfaces, base classes, implementations, and wrappers) should be split into smaller, more maintainable modules following the namespace hierarchy.
