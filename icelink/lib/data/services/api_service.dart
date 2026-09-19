import 'package:dio/dio.dart';

class ApiService {
  ApiService()
    : dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 8),
          receiveTimeout: const Duration(seconds: 8),
          sendTimeout: const Duration(seconds: 8),
          headers: const {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

  final Dio dio;

  // Backend endpoint is not decided yet. Add baseUrl and request methods here
  // when the login API contract is fixed.
}
