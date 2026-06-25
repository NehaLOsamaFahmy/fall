import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Api/LoginApi.dart';
import '../Routes/route_constants.dart';
import '../Shared_Data/DelegateData.dart';



class LoginViewModel extends ChangeNotifier {

  bool _loading = false;
  bool get loading => _loading;

  Future<void> deleteAccount(BuildContext context) async {
    try {
      _loading = true;
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
    _loading= false;
    notifyListeners();
  }
}
