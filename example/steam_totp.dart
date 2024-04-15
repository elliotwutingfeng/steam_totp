import 'package:steam_totp/steam_totp.dart';

void main() {
  final SteamTOTP steamtotp =
      SteamTOTP(secret: 'OJZ2BP7STWSLUD7I23Q5AYZELZB5OAFU');

  // By default, the current epoch time will be used.
  String code = steamtotp.generate();
  print(code); // OUTPUT: 5-character alphanumeric string.

  // This behavior can be overridden by passing in [unixSeconds] explicitly.
  final int unixSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  code = steamtotp.generate(unixSeconds);
  print(code); // OUTPUT: 5-character alphanumeric string.
}
