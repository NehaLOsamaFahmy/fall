import 'dart:async';
import 'package:babco/Models/RegisterResponse.dart';
import 'package:flutter/material.dart';

class OtpViewModel extends ChangeNotifier {
  final RegisterResponse data;

  OtpViewModel({
    required this.data,
  });

  final formKey = GlobalKey<FormState>();
  final otpController = TextEditingController();

  bool isLoading = false;

  static const int otpDuration = 15 * 60; // 15 minutes

  int remainingSeconds = otpDuration;

  Timer? _timer;

  bool get isExpired => remainingSeconds <= 0;

  String get formattedTime {
    final minutes = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingSeconds % 60).toString().padLeft(2, '0');

    return "$minutes:$seconds";
  }

  void startTimer() {
    _timer?.cancel();

    remainingSeconds = otpDuration;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        if (remainingSeconds <= 0) {
          timer.cancel();
        } else {
          remainingSeconds--;
        }

        notifyListeners();
      },
    );
  }

  Future<void> verifyCode(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      /// TODO Verify OTP API

      /*
      await VerifyOtpApi(
        userId: userId,
        code: otpController.text,
      ).call();
      */

      await Future.delayed(const Duration(seconds: 2));

      if (!context.mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        "/home",
            (route) => false,
      );
    } catch (e) {
      debugPrint(e.toString());
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> resendCode() async {
    if (!isExpired) return;

    isLoading = true;
    notifyListeners();

    try {
      /// TODO Resend OTP API

      /*
      await ResendOtpApi(
        userId: userId,
        email: email,
      ).call();
      */

      await Future.delayed(const Duration(seconds: 2));

      startTimer();
    } catch (e) {
      debugPrint(e.toString());
    }

    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }
}