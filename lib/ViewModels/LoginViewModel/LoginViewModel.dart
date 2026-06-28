import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Api/Login/DeleteUserApi.dart';
import '../../Api/Login/LoginApi.dart';
import '../../Routes/route_constants.dart';
import '../../Shared_Data/DelegateData.dart';



import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  final identifierController = TextEditingController(); // email or mobile
  final passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> login(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    isLoading = true;
    notifyListeners();

    try {
      final res = await Login(
        context,
        identifierController.text.trim(),
        passwordController.text.trim(),
      );

      if (res != null) {
        if (res.requiresVerification == true) {
          Navigator.pushNamed(
            context,
            verifyCodeRoute,
            arguments: res,
          );
        } else {
         await saveDelegateData(res);
          DelegateData.delegateData=res;
          notifyListeners();
          Navigator.pushNamedAndRemoveUntil(
            context,
            homeRoute,
                (route) => false,
          );
        }
      }

    } catch (e) {
      debugPrint(e.toString());
    }

    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    identifierController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> deleteAccount(BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();

      var x = await deleteAccountFun(context, DelegateData.delegateData!.mobile.toString());
      if (x == true) {
        try {
          await removeDelgateDate();
        } catch (E) {}
        Navigator.pushNamedAndRemoveUntil(
            context, homeRoute, (Route<dynamic> r) => false);
        return;
      }
    }catch(e){}
    isLoading= false;
    notifyListeners();
  }
}
