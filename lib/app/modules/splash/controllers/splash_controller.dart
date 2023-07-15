import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  RxBool permissionStatus = false.obs;
  Location location = Location();

  @override
  void onInit() {
    super.onInit();
    _getLocationPermission();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  _getLocationPermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      permissionStatus.value = false;
      _permissionGranted = await location.requestPermission();
    } else
      permissionStatus.value = true;
  }
}
