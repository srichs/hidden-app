import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Provides constant-time validation for the hidden application secret.
class SecretValidator {
  SecretValidator({required this.hashedSecret});

  /// Creates a validator by hashing a plain-text secret using SHA-256.
  factory SecretValidator.fromPlainSecret(String secret) {
    final normalized = _normalizeSecret(secret);
    final digest = sha256.convert(utf8.encode(normalized)).toString();
    return SecretValidator(hashedSecret: digest);
  }

  /// The SHA-256 digest of the normalized secret input.
  final String hashedSecret;

  /// Returns `true` when [input] matches the stored secret.
  bool isSecretInput(String input) {
    final normalized = _normalizeSecret(input);
    if (normalized.isEmpty) {
      return false;
    }
    final digest = sha256.convert(utf8.encode(normalized)).toString();
    return _constantTimeEquals(digest, hashedSecret);
  }

  static String _normalizeSecret(String value) => value.replaceAll(RegExp(r'\s+'), '');

  static bool _constantTimeEquals(String a, String b) {
    if (a.length != b.length) {
      return false;
    }
    var result = 0;
    for (var i = 0; i < a.length; i++) {
      result |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return result == 0;
  }
}
