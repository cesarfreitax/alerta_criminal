import 'package:envied/envied.dart';
part 'env.g.dart';

@Envied()
abstract class Env {
  @EnviedField(varName: 'MAPS_API_KEY', defaultValue: '')
  static String mapsApiKey = _Env.mapsApiKey;
}