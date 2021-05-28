import 'package:universidad_lg/Entrenamiento/models/models.dart';
import 'package:universidad_lg/Entrenamiento/services/services.dart';

class EntrenamientoBloc {
  EntrenamientoService entrenamintoService = EntrenamientoService();

  Future<Entrenamiento> getEntrenamintoContent(
      {String token, String uid}) async {
    return await entrenamintoService.servicegetEntrenamientoContent(uid, token);
  }
}
