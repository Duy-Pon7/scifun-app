import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sci_fun/core/network/check_token_interceptor.dart';

class DioClient {
  final CheckTokenInterceptor checkTokenInterceptor;
  late final Dio _dio;

  DioClient({required this.checkTokenInterceptor})
      : _dio = Dio(
          BaseOptions(
            baseUrl: dotenv.get('BASE_URL'),
            headers: {
              'X-TOKEN-ACCESS': dotenv.get('API_KEY'),
              'Accept': 'application/json',
            },
            responseType: ResponseType.json,
            // Increase timeouts to handle slow networks / cold starts
            sendTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
          ),
        )..interceptors.addAll(
            [checkTokenInterceptor],
          );

  // POST
  Future<Response> post({
    required String url,
    dynamic data, // ✅ Cho phép truyền FormData
    Options? options, // ✅ Cho phép custom headers như multipart
  }) async {
    try {
      print("DioClient POST URL: $url");
      print("DioClient POST Data: $data");
      print("DioClient POST Options: $options");
      final res = await _dio.post(
        url,
        data: data,
        options: options,
      );
      return res;
    } on DioException {
      rethrow;
    }
  }

  // PUT
  Future<Response> put({
    required String url,
    dynamic data, // Cho phép truyền FormData hoặc Map
    Options? options, // Cho phép custom headers như multipart
  }) async {
    try {
      final res = await _dio.put(
        url,
        data: data,
        options: options,
      );
      return res;
    } on DioException {
      rethrow;
    }
  }

  // GET
  Future<Response> get({required String url}) async {
    try {
      final res = await _dio.get(url);
      return res;
    } on DioException {
      rethrow;
    }
  }

  //DELETE
  Future<Response> delete({
    required String url,
    Map<String, dynamic>? data,
    Options? options,
  }) async {
    try {
      final res = await _dio.delete(
        url,
        data: data,
        options: options,
      );
      return res;
    } on DioException {
      rethrow;
    }
  }
}
