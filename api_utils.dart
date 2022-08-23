import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiUtils {
  static ApiUtilsModel getMessageAndMultiDataFromResponse(Response response) {
    final successMessage = response.data['message'];
    List<Map<String, dynamic>> formattedData = response.data['data'] != null ? response.data['data'].cast<Map<String, dynamic>>() : {};
    return ApiUtilsModel(
      message: successMessage,
      data: formattedData,
    );
  }

  static ApiUtilsModel getMessageAndSingleDataFromResponse(Response response) {
    final successMessage = response.data['message'];
    Map<String, dynamic> formattedData = response.data['data'] != null ? Map<String, dynamic>.from(response.data['data']) : {};
    return ApiUtilsModel(
      message: successMessage,
      data: [formattedData],
    );
  }

  static ApiUtilsModel getMessageTokensAndSingleDataFromResponse(Response response) {
    final successMessage = response.data['message'];
    final responseHeader = response.headers['authorization'];
    //final refreshToken = response.data['refreshToken'];
    Map<String, dynamic> formattedData = response.data['data'] != null ? Map<String, dynamic>.from(response.data['data']) : {};
    return ApiUtilsModel(
      message: successMessage,
      accessToken: responseHeader[0].split('Bearer ')[1],
      //refreshToken: refreshToken,
      data: [formattedData],
    );
  }

  static ApiUtilsModel getMultiDataFromStreamResponse(String streamResponse) {
    final parsed = json.decode(streamResponse);
    List<Map<String, dynamic>> formattedData = parsed != null ? parsed.cast<Map<String, dynamic>>() : {};
    return ApiUtilsModel(
      message: '',
      data: formattedData,
    );
  }

  static handleHttpException(Response response) {
    throw response.data['message'];
  }
}

class ApiUtilsModel {
  String message;
  List<Map<String, dynamic>> data;
  String refreshToken;
  String accessToken;

  ApiUtilsModel({@required this.message, @required this.data, this.accessToken, this.refreshToken});
}
