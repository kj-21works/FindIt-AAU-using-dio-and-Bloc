import 'package:dio/dio.dart';
import '../utils/constants.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(milliseconds: AppConstants.connectTimeout),
        receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Logging interceptor for debugging
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (obj) => print('[DIO] $obj'),
      ),
    );
  }

  /// GET /items
  Future<List<dynamic>> getItems() async {
    try {
      final response = await _dio.get(AppConstants.itemsEndpoint);
      if (response.data is List) {
        return response.data as List<dynamic>;
      }
      return [];
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// POST /items
  Future<Map<String, dynamic>> createItem(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(AppConstants.itemsEndpoint, data: data);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// PUT /items/:id
  Future<Map<String, dynamic>> updateItem(
      String id, Map<String, dynamic> data) async {
    try {
      final response =
          await _dio.put('${AppConstants.itemsEndpoint}/$id', data: data);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// DELETE /items/:id
  Future<void> deleteItem(String id) async {
    try {
      await _dio.delete('${AppConstants.itemsEndpoint}/$id');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppConstants.timeoutError;
      case DioExceptionType.connectionError:
        return AppConstants.networkError;
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 404) return 'Item not found.';
        if (statusCode == 500) return 'Server error. Please try again later.';
        return 'Unexpected error (${statusCode ?? 'unknown'}).';
      default:
        return AppConstants.unknownError;
    }
  }
}
