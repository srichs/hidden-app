# Hidden App Calculator

A Flutter calculator that doubles as a secure launcher for a hidden
application when the correct numeric code is entered.

## Getting Started

1. Install [Flutter](https://docs.flutter.dev/get-started/install) and run
   `flutter pub get` inside this project directory.
2. Launch the application with `flutter run` on your preferred device or
   emulator.

## Changing the Hidden Code

The default hidden code is `424242`. To change it:

1. Open `lib/security/secret.dart` and create a new hashed secret with
   `SecretValidator.fromPlainSecret('your code')` in a Dart console, or use
   any SHA-256 utility.
2. Replace the `_kHashedSecret` constant in `lib/main.dart` with the new
   hash.

Storing only the hashed secret avoids exposing the hidden code directly in
source control and mitigates basic reverse engineering efforts. The
`SecretValidator` compares the input using a constant-time algorithm to limit
information leaks via timing analysis.

## Building the Hidden Application

* Replace the placeholder widget in `lib/hidden/hidden_app.dart` with your
  own Flutter widgets.
* Keep the hidden application self-contained and avoid sharing state with the
  calculator UI to maintain clean separation of responsibilities.
* Consider additional hardening such as biometric checks or encrypted local
  storage if your hidden experience requires stronger security guarantees.

## Style and Lints

The project follows Flutter's Material 3 design defaults and adheres to the
Google Dart style guide through idiomatic naming, const constructors, and the
`flutter_lints` ruleset defined in `pubspec.yaml`.
