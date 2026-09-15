import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../utils/logger.dart';

/// Development-safe HTTP telemetry logger stripping PII and credentials.
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      final Map<String, dynamic> sanitizedHeaders = Map<String, dynamic>.from(options.headers);
      if (sanitizedHeaders.containsKey('Authorization')) {
        sanitizedHeaders['Authorization'] = 'Bearer [REDACTED]';
      }

      final dynamic sanitizedData = _sanitizePayload(options.data);

      Logger.debug(
        '--> ${options.method.toUpperCase()} ${options.uri}\n'
        'Headers: $sanitizedHeaders\n'
        'Body: ${_formatJson(sanitizedData)}',
        tag: 'HTTP',
      );
    }
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      Logger.debug(
        '<-- ${response.statusCode} ${response.requestOptions.method.toUpperCase()} ${response.requestOptions.uri}\n'
        'Body: ${_formatJson(_sanitizePayload(response.data))}',
        tag: 'HTTP',
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      Logger.error(
        '<-- HTTP ERROR [${err.response?.statusCode ?? 'N/A'}] ${err.requestOptions.method.toUpperCase()} ${err.requestOptions.uri}\n'
        'Message: ${err.message}\n'
        'Response: ${_formatJson(err.response?.data)}',
        tag: 'HTTP',
      );
    }
    handler.next(err);
  }

  // ---------------------------------------------------------------------------
  // PII & Credential Sanitization
  // ---------------------------------------------------------------------------

  static dynamic _sanitizePayload(dynamic data) {
    if (data is Map<String, dynamic>) {
      final Map<String, dynamic> copy = Map<String, dynamic>.from(data);
      const List<String> sensitiveKeys = <String>[
        'password',
        'otp',
        'token',
        'jwt',
        'aadhaarNumber',
        'panNumber',
        'documentBase64',
        'cvv',
        'cardNumber',
      ];

      for (final String key in sensitiveKeys) {
        if (copy.containsKey(key)) {
          copy[key] = '[REDACTED]';
        }
      }
      return copy;
    }
    return data;
  }

  static String _formatJson(dynamic data) {
    if (data == null) return 'null';
    try {
      if (data is Map || data is List) {
        return const JsonEncoder.withIndent('  ').convert(data);
      }
      return data.toString();
    } catch (_) {
      return data.toString();
    }
  }
}
