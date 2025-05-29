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
      expect(SteamTOTP(secret: 'JBSWY3DPEHPK3PXP').generate(42), '2YXGV');
      expect(SteamTOTP(secret: 'MZXW6YTBOI======').generate(42), 'GFY7Q');
      expect(
        SteamTOTP(secret: 'ORUGKIDROVUWJZG66A=').generate(1747839733),
        'C8T3D',
      );
      expect(
        SteamTOTP(secret: 'ORUGKIDROVUWJZG66A=').generate(1747839800),
        'RMPTG',
      );
    });
    test('Current epoch time', () {
      expect(SteamTOTP(secret: 'ORUGKIDROVUWJZG66A=').generate().length, 5);
    });
  });
}
