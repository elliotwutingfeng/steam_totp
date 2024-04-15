import 'package:steam_totp/steam_totp.dart';
import 'package:test/test.dart';

void main() {
  group('SteamTOTP', () {
    test('Empty secret.', () {
      expect(() => SteamTOTP(secret: ''), throwsArgumentError);
    });
    test('secret is not valid base32.', () {
      expect(() => SteamTOTP(secret: 'A'), throwsArgumentError);
    });
    test('unixSeconds out of range.', () {
      expect(() => SteamTOTP(secret: 'AA').generate(-1), throwsArgumentError);
    });
    test('Correct TOTP code.', () {
      expect(SteamTOTP(secret: 'AA').generate(42), 'DR2DK');
    });
  });
}
