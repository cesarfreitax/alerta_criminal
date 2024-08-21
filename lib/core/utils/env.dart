import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
final class Env {
  @EnviedField(varName: 'MAPS_API_KEY', obfuscate: true)
  static const String mapsApiKey = _Env.mapsApiKey;
}