import 'package:dio/dio.dart';

class QrCodeService {
  static Dio dio = Dio(BaseOptions(
    baseUrl: 'http://45.32.20.80:2022/api/',
  ));

  Future<Response> getQrAmountByUser({String userId}) async {
    return await dio.get('getQrAmountByUser/$userId');
  }

  Future<Response> updateQrAmount({String userId, int amount}) async {
    return await dio.post('updateQrAmount', data: {"userId": userId, "amount": amount});
  }
}
