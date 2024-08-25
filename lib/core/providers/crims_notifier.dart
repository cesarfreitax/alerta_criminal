import 'package:alerta_criminal/core/di/dependency_injection.dart';
import 'package:alerta_criminal/data/models/crime_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CrimsNotifier extends StateNotifier<List<CrimeModel>> {
  CrimsNotifier() : super(const []);

  Future<void> getCrims() async {
    try {
      DependencyInjection.crimUseCase.getCrimsRef().snapshots().listen((snapshot) {
        final crimsList = snapshot.docs.map((doc) => doc.data()).toList();
        state = crimsList;
      });
    } catch (e) {
      print('Error fetching crims: $e');
    }
  }

  CrimeModel getCrim(String id) => state.firstWhere((crime) => crime.id == id);

}

final crimsProvider = StateNotifierProvider<CrimsNotifier, List<CrimeModel>>(
  (ref) => CrimsNotifier(),
);
