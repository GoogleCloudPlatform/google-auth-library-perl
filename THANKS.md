# THANKS

This project benefits from the contributions and feedback of many individuals.

We would like to especially thank:

*   **Gilbert Morgan** ([@bimokh](https://github.com/bimokh)) - For initiating the AWS WIF credentials support (ECS Task Roles and IMDSv2 discovery) in the Google Auth library.

*   **Paul Evans** ([@LeoNerd](https://github.com/LeoNerd)) - For authoring and maintaining the `Future` module, which serves as the foundational async primitive for our Pluggable Transport Architecture, enabling non-blocking modernization across the SDK.

*   **Max Maischein** ([@Corion](https://github.com/Corion)) - For his extensive work on asynchronous patterns in `WWW::Mechanize::Chrome`. Our collaboration on that project inspired the interest in producing a functional async implementation here, driving our modernization goals alongside the primitives provided by Paul Evans.

*   **John Napiorkowski** - For his work on `Net::HTTP2::nghttp2` bindings which demonstrated beautiful HTTP/2 handling and inspired modern low-level transport integration.
