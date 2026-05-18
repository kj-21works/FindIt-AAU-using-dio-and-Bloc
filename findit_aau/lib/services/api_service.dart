import 'package:dio/dio.dart';
import 'package:flutter/material.dart' show debugPrint;
import '../utils/constants.dart';

class ApiService {
  static const String _itemsEndpoint = '/items';
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout:
            const Duration(milliseconds: AppConstants.connectTimeout),
        receiveTimeout:
            const Duration(milliseconds: AppConstants.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (obj) => debugPrint(obj.toString()),
      ),
    );
  }

  Future<List<dynamic>> getItems() async {
    try {
      final response = await _dio.get(_itemsEndpoint);
      if (response.data is List) {
        return response.data as List<dynamic>;
      }
      return [];
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> createItem(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(_itemsEndpoint, data: data);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> updateItem(
      String id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put('$_itemsEndpoint/$id', data: data);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> deleteItem(String id) async {
    try {
      await _dio.delete('$_itemsEndpoint/$id');
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
