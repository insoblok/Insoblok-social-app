import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';

import 'package:insoblok/locator.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class APIMETHOD {
  static String get = 'GET';
  static String post = 'POST';
  static String put = 'PUT';
  static String delete = 'DELETE';
}

class NetworkService with ListenableServiceMixin {
  final RxValue<Dio?> _vtoApiRx = RxValue<Dio?>(null);
  Dio? get vtoApiDio => _vtoApiRx.value;

  final RxValue<Dio?> _newsApiRx = RxValue<Dio?>(null);
  Dio? get newsApiDio => _newsApiRx.value;

  InterceptorsWrapper get apiInterceptor => InterceptorsWrapper(
    onRequest: (RequestOptions options, handler) {
      return handler.next(options);
    },
    onError: (DioException e, handler) {
      return handler.next(e);
    },
    onResponse: (Response response, handler) {
      return handler.next(response);
    },
  );

  NetworkService() {
    listenToReactiveValues([_vtoApiRx, _newsApiRx]);
  }

  Map<String, dynamic> _nonNullJson(Map<String, dynamic>? json) {
    if (json == null) return {};
    Map<String, dynamic> result = {};
    for (var key in json.keys) {
      var value = json[key];
      if (value == null) continue;
      if (value is String || value is int || value is MultipartFile) {
        result[key] = value;
      } else {
        result[key] = jsonEncode(value);
      }
    }
    return result;
  }

  Future<void> init() async {
    try {
      var vtoApi =
          Dio()
            ..options.baseUrl = 'https://thenewblack.ai/api/1.1/wf/'
            ..options.validateStatus = ((status) => (status ?? 1) > 0)
            ..interceptors.add(LogInterceptor());
      _vtoApiRx.value = vtoApi;

      var newsApi =
          Dio()
            ..options.baseUrl = 'https://newsdata.io/api/1/'
            ..options.validateStatus = ((status) => (status ?? 1) > 0)
            ..interceptors.add(LogInterceptor());
      _newsApiRx.value = newsApi;

      notifyListeners();
    } catch (e) {
      logger.e(e);
    }
  }

  Future<Response> vtoApiRequest(
    String path, {
    String method = 'GET',
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? postParams,
    Function(int, int)? onSendProgress,
    Function(int, int)? onReceiveProgress,
  }) async {
    var startTime = DateTime.now();

    queryParams ??= <String, String>{};

    var pParm = {
      ...(postParams ?? {}),
      'email': kDefaultVTOEmail,
      'password': kDefaultVTOPassword,
    };

    logger.d(pParm);

    var reqData = FormData.fromMap(pParm);

    var dio =
        vtoApiDio!
          ..options.queryParameters = _nonNullJson(queryParams)
          ..options.method = method
          ..interceptors.add(apiInterceptor);
    final response = await dio.request(
      path,
      data: reqData,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    var endTime = DateTime.now();
    logger.i(endTime.difference(startTime).inMilliseconds);
    return response;
  }

  Future<Response> newsApiRequest(
    String path, {
    String method = 'GET',
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? postParams,
    Function(int, int)? onSendProgress,
    Function(int, int)? onReceiveProgress,
  }) async {
    var startTime = DateTime.now();

    var qParm = {
      ...(queryParams ?? {}),
      'apikey': kNewsDataCryptoApiKey,
      'q': 'crypto',
    };

    var pParm = postParams ?? {};

    logger.d(pParm);

    var reqData = FormData.fromMap(pParm);

    var dio =
        newsApiDio!
          ..options.queryParameters = _nonNullJson(qParm)
          ..options.method = method
          ..interceptors.add(apiInterceptor);
    final response = await dio.request(
      path,
      data: reqData,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    var endTime = DateTime.now();
    logger.i(endTime.difference(startTime).inMilliseconds);
    return response;
  }

  Future<File?> downloadFile(
    String link,
    String type,
    String ext, {
    Function(int, int)? onReceiveProgress,
  }) async {
    try {
      Dio dio = Dio();

      final dir = await getApplicationDocumentsDirectory();
      final savePath =
          '${dir.path}/${type}_${DateTime.now().toIso8601String()}.$ext';

      // Download the file
      await dio.download(
        link,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            logger.i('${(received / total * 100).toStringAsFixed(0)}%');
          }
        },
      );

      logger.i('File downloaded to: $savePath');

      File file = File(savePath);
      if (!file.existsSync()) {
        await file.create();
      } else {
        if (file.lengthSync() > 0) {
          return file;
        }
      }

      return file;
    } catch (e) {
      logger.i('Error downloading file: $e');
    }

    return null;
  }
}

class NetworkHelper {
  static NetworkService get service => locator<NetworkService>();

  static Future<Response> vtoApiRequest(
    String path, {
    String method = 'GET',
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? postParams,
    Function(int, int)? onSendProgress,
    Function(int, int)? onReceiveProgress,
  }) => service.vtoApiRequest(
    path,
    method: method,
    queryParams: queryParams,
    postParams: postParams,
    onSendProgress: onSendProgress,
    onReceiveProgress: onReceiveProgress,
  );

  static Future<Response> newsApiRequest(
    String path, {
    String method = 'GET',
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? postParams,
    Function(int, int)? onSendProgress,
    Function(int, int)? onReceiveProgress,
  }) => service.newsApiRequest(
    path,
    method: method,
    queryParams: queryParams,
    postParams: postParams,
    onSendProgress: onSendProgress,
    onReceiveProgress: onReceiveProgress,
  );

  static Future<File?> downloadFile(
    String link, {
    required String type,
    required String ext,
    Function(int, int)? onReceiveProgress,
  }) => service.downloadFile(
    link,
    type,
    ext,
    onReceiveProgress: onReceiveProgress,
  );
}
