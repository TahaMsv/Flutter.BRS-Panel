import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:network_manager/network_manager.dart';
import 'package:dio/dio.dart' as dio;
import '../abstracts/exception_abs.dart';
import '../abstracts/network_manager_abs.dart';
import '../abstracts/request_abs.dart';
import '../abstracts/response_abs.dart';
import '../constants/apis.dart';

class NetworkManager implements NetworkManagerInterface {
  NetworkManager();

  @override
  Future<Response> post(Request request, {String? api}) async {
    NetworkRequest networkRequest = NetworkRequest(api: api ?? Apis.baseUrl, data: request.toJson());
    // debugPrint("request: ${jsonEncode(request.toJson())}");
    // print("networkRequest: ${networkRequest.data}");
    // print("api: ${api}");
    // debugPrint(networkRequest.options.baseUrl);
    NetworkResponse networkResponse = await networkRequest.post();
    print("responseBody: ${jsonEncode(networkResponse.responseBody)}");
    // print("responseStatus: ${networkResponse.responseStatus}");
    if (networkResponse.responseStatus) {
      try {
        // Response res = Response.fromJson(networkResponse.responseBody);
        Response res = await compute(Response.fromJson, networkResponse.responseBody);
        return res;
      } catch (e, trace) {
        throw ParseException(message: e.toString(), trace: trace);
      }
    } else {
      print(networkResponse.responseDetails);
      throw ServerException(
        code: networkResponse.responseCode,
        message: networkResponse.extractedMessage!,
        trace: StackTrace.fromString("NetworkManager.post"),
      );
    }
  }

  @override
  Future<Response> get(String url) async {
    dio.Dio d = dio.Dio(dio.BaseOptions(
        responseType: dio.ResponseType.bytes,
        followRedirects: false,
        validateStatus: (status) {
          return (status ?? 0) < 500;
        }));
    var response = await d.get(url);

    // NetworkRequest networkRequest = NetworkRequest(api: url, data: '');
    // NetworkResponse networkResponse = await networkRequest.get();
    Response res = Response(
      status: (response.statusCode == 200) ? 1 : -1,
      message: response.statusMessage ?? 'Unknown Error',
      body: response.data,
    );
    return res;
  }

  Future<dio.Response> dioPost({required String api, Map<String, dynamic> request = const {}, Map<String, dynamic> header = const {}}) async {
    try {
      dio.Dio dd = dio.Dio(dio.BaseOptions(headers: header));
      var formData = dio.FormData.fromMap(request);
      final result = await dd.post(api, data: formData);
      return result;
    } catch (e, trace) {
      throw ServerException(code: -1, message: "Request Failed", trace: trace);
    }
  }

  dio.MultipartFile getImageFileFromString(Uint8List value, {required String fileName}) {
    dio.MultipartFile file = dio.MultipartFile.fromBytes(value, filename: fileName);
    return file;
  }

  String get currentBaseUrl => NetworkRequest(api: "").options.baseUrl;
}
