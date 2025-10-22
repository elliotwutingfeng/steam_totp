import 'dart:typed_data';

import 'package:hashlib/codecs.dart';
import 'package:hashlib/hashlib.dart';

/// [SteamTOTP] generates 5-character alphanumeric Steam TOTP codes.
/// Possible characters can be found in [SteamTOTP.steamChars].
class SteamTOTP {
  final String secret;
  final Uint8List _sharedSecretArray;

  static const String steamChars = '23456789BCDFGHJKMNPQRTVWXY';

  const SteamTOTP._({
    required this.secret,
    required final Uint8List sharedSecretArray,
  }) : _sharedSecretArray = sharedSecretArray;

  factory SteamTOTP({required final String secret}) {
    if (secret.isEmpty) {
      throw ArgumentError('secret must not be empty.');
    }
    final Uint8List secretArray;
    try {
      secretArray = fromBase32(secret, codec: Base32Codec.standard);
      if (secretArray.isEmpty) {
        throw Exception();
      }
    } catch (_) {
      throw ArgumentError('secret must be valid base32.');
    }
    return SteamTOTP._(secret: secret, sharedSecretArray: secretArray);
  }

  /// By default, the current epoch time will be used.
  /// This behavior can be overridden by passing in [unixSeconds] explicitly.
  String generate([final int? unixSeconds]) {
    int time = unixSeconds ?? DateTime.now().millisecondsSinceEpoch ~/ 1000;
    if (time < 0) {
      throw ArgumentError('unixSeconds must be non-negative.');
    }
    time ~/= 30; // Period is 30 seconds.

    final Uint8List timeArray = Uint8List(8);
    for (int i = 8; i > 0; i--) {
      timeArray[i - 1] = time & 0xFF;
      time = time >> 8;
    }

    final Uint8List hmac = HMAC(
      sha1,
    ).by(_sharedSecretArray).convert(timeArray).bytes;
    final int b = (hmac[19] & 0xF) % 0xFF;
    int codePoint =
        (hmac[b] & 0x7F) << 24 |
        (hmac[b + 1] & 0xFF) << 16 |
        (hmac[b + 2] & 0xFF) << 8 |
        (hmac[b + 3] & 0xFF); // Maximum possible value: 2147483647

    final List<String> codeArray = List.filled(5, '');
    for (int i = 0; i < 5; i++) {
      codeArray[i] = steamChars[codePoint % steamChars.length];
      codePoint = codePoint ~/ steamChars.length;
    }
    return codeArray.join();
  }
}
