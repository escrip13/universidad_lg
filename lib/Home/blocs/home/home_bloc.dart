import 'package:universidad_lg/Home/services/services.dart';

class HomeBloc {
  HomeService homeService = HomeService();

  Future<List> getHomeContent({String token, String uid}) async {
    return await homeService.servicegetHomeContent(uid, token);
  }
}
