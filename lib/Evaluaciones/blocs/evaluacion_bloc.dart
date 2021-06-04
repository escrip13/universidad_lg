import 'package:universidad_lg/Evaluaciones/models/evaluacion_model.dart';
import 'package:universidad_lg/Evaluaciones/models/single_evaluacion_model.dart';
import 'package:universidad_lg/Evaluaciones/services/services.dart';

class EvaluacionBloc {
  EvaluacionService entrenamintoService = EvaluacionService();

  Future<Evaluacion> getEvaluaionesContent({String token, String uid}) async {
    return await entrenamintoService.servicegetEvaluacionesContent(uid, token);
  }

  Future<SingleEvaluacion> getSingleEvaluaionesContent(
      {String token, String uid, String nid}) async {
    return await entrenamintoService.servicegetSingleEvaluacionesContent(
        uid, token, nid);
  }

  Future<SingleEvaluacion> sendEvaluacion(
      {String token, String uid, String nid, Map data}) async {
    return await entrenamintoService.sendEvaluacion(uid, token, nid, data);
  }
}
