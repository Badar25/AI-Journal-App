import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AppSnackbars {
  static void showErrorSnack(String error) {
    Get.snackbar(
      'Error', // Title of the snackbar
      error,   // Message content of the snackbar
      backgroundColor: Colors.red, // Background color for error
      colorText: Colors.white, // Text color
      snackPosition: SnackPosition.BOTTOM, // Snackbar position
      duration: const Duration(seconds: 3), // Duration for snackbar visibility
      margin: const EdgeInsets.all(10), // Margin around snackbar
      borderRadius: 10, // Rounded corners
    );
  }
}