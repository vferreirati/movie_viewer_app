import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'src/common/constants.dart';
import 'src/tmdb_app.dart';

void main() {
  final client = Dio(
    BaseOptions(
      baseUrl: Constants.baseUrl,
      queryParameters: {
        'api_key': Constants.apiKey,
        'language': 'en-US',
      },
    ),
  );

  if (kDebugMode) {
    client.interceptors.add(
      AwesomeDioInterceptor(
        logRequestHeaders: false,
        logResponseHeaders: false,
      ),
    );
  }

  runApp(
    TMDBApp(
      client: client,
    ),
  );
}
