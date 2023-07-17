import 'dart:developer';

import 'package:alcohol_inventory/models/upc_response_model.dart';
import 'package:alcohol_inventory/services/snackbar_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../utils/api.dart';

enum ApiStatus { ideal, loading, success, failed }

class ApiProvider extends ChangeNotifier {
  ApiStatus? status = ApiStatus.ideal;
  late Dio _dio;
  static ApiProvider instance = ApiProvider();

  ApiProvider() {
    _dio = Dio();
  }

  Future<UpcResponseModel?> getItemByUpc(String upc) async {
    status = ApiStatus.loading;
    notifyListeners();
    UpcResponseModel? productDetail;
    try {
      Response response = await _dio.get(
        '${Api.upcItemApi}$upc',
      );

      if (response.statusCode == 200 && response.data['code'] == Api.ok) {
        status = ApiStatus.success;
        notifyListeners();
        productDetail = UpcResponseModel.fromMap(response.data);
      } else {
        status = ApiStatus.failed;
        notifyListeners();
        SnackBarService.instance.showSnackBarError('Could not parse data');
      }
    } on DioException catch (e) {
      log(e.response?.data.toString() ?? e.response.toString());
      status = ApiStatus.failed;
      // var resBody = e.response?.data ?? {};
      notifyListeners();

      // SnackBarService.instance
      //     .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());

      log(e.toString());
    }

    return productDetail;
  }
}
