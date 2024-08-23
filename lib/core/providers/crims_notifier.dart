import 'package:alerta_criminal/core/di/dependency_injection.dart';
import 'package:alerta_criminal/data/models/crim_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CrimsNotifier extends StateNotifier<List<CrimModel>> {
  CrimsNotifier() : super(const []);

  Future<void> getCrims() async {
    try {
      final crims = await DependencyInjection.crimUseCase.getCrimsRef().get();
      final crimsList = crims.docs.map((crim) => crim.data()).toList();
      state = crimsList;
    } catch (e) {
      print('Error fetching crims: $e');
    }
  }
}


final crimsProvider = StateNotifierProvider<CrimsNotifier, List<CrimModel>>(
  (ref) => CrimsNotifier(),
);
