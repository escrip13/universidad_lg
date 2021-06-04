import 'package:universidad_lg/Entrenamiento/models/entrenamiento_model.dart';
import 'package:universidad_lg/Entrenamiento/models/cursopreview_model.dart';
import 'package:universidad_lg/Entrenamiento/services/services.dart';

class EntrenamientoBloc {
  EntrenamientoService entrenamientoService = EntrenamientoService();

  Future<Entrenamiento> getEntrenamientoContent(
      {String token, String uid}) async {
    return await entrenamientoService.servicegetEntrenamientoContent(
        uid, token);
  }

  Future<CursoPreview> getCursoPreviewContent(
      {String token, String uid, String curso}) async {
    return await entrenamientoService.serviceGetCursoPreviewContent(
        uid, token, curso);
  }
}
