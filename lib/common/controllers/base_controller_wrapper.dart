import 'package:get/get_state_manager/src/simple/get_controllers.dart';

abstract  class BaseController extends GetxController {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setLoading(bool value) {
    if (value == true) {
      _errorMessage = null;
    }
    _isLoading = value;

    update();
  }

  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  void setErrorMessage(String? value, {bool notify = false}) {
    _errorMessage = value;
    update();
  }

  void resetState() {
    _isLoading = false;
    _errorMessage = null;
    update();
  }
}
