import 'package:universidad_lg/Home/models/home_model.dart';
import 'package:universidad_lg/Home/services/services.dart';

class HomeBloc {
  HomeService homeService = HomeService();

  Future<Home> getHomeContent({String token, String uid}) async {
    return await homeService.servicegetHomeContent(uid, token);
  }
}
