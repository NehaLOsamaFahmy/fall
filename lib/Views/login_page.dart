
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:babco/Shared_Data/DelegateData.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:sizer/sizer.dart';

import '../Api/LoginApi.dart';
import '../Constans/Style.dart';
import '../Localization/Translations.dart';
import '../Routes/route_constants.dart';
import '../Shared_Data/CompanyData.dart';
import '../Shared_View/AlertView.dart';
import '../Shared_View/AppBarView.dart';


class LoginPage extends StatefulWidget {
  final String mobile;
  LoginPage({required this.mobile,Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      GetData();
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      //resizeToAvoidBottomInset: false,
        appBar: AppBarWithBackOnly(context, ""),
        body:SafeArea(child: LoadingOverlay(
            isLoading: _isLoading,
            opacity: 0.2,
            color: Style.MainColor,
            progressIndicator: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Style.MainColor),),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              child: FormUI(),
            ))
    ));
  }

  Widget FormUI() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 10.0.h,),
          Image(image: AssetImage('lib/assets/logo.png'),
            width: 60.0.w,
            height: 20.0.h,),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15.0.w, vertical: 5.0.h),
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[

                 Theme(
                    data: Theme.of(context).copyWith(primaryColor: Style.SecondryColor),
                    child: TextFormField(
                        controller: nameController,
                        cursorColor: Style.SecondryColor,
                        style: TextStyle(fontSize: 16.0.sp, color: Style.MainTextColor),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: Translations.of(context)!.Code_Validation,
                           // labelStyle: TextStyle(fontSize: 16.0.sp, color: Style.GreyColor),
                          //  labelText: Translations.of(context)!.Code,
                            hintStyle: TextStyle(fontSize: 16.0.sp,
                              color: Style.GreyColor,),
                            errorStyle: TextStyle(fontSize: 16.0.sp,
                                color:Style.MainTextColor)
                        ),
                        keyboardType: TextInputType.number,
                        onEditingComplete: () {
                          FocusScope.of(context).unfocus();
                        }
                    ),),
                Divider(color: Style.MainColor,),


              ],
            ),
          ),
          // Login Button
          InkWell(
            child: Container(
            padding: EdgeInsets.fromLTRB(10.0.w, 0.5.h, 10.0.w, 0.5.h),
            margin: EdgeInsets.fromLTRB(0, 4.0.h, 0, 0),
            decoration: Style.ButtonDecoration,
            child:  Text(
                  Translations.of(context)!.login,
                  style: TextStyle(color: Colors.white,
                      fontSize: 17.0.sp),

                  textAlign: TextAlign.center,

                ),

            ),
              onTap: () async {
                if (nameController.text!=null && nameController.text.length>0) {
                  showLoading();
                  var res = await Verifycode(context, widget.mobile,nameController.text);
                  hideLoading();
                  if (res != null) {
                    Navigator.pushNamed(context, homeRoute);
                  }
                }
                else
                {
                  await AlertView(
                      context, "error",
                      Translations.of(context)!.Please,
                      Translations.of(context)!.Code_Validation);
                }
              }
          ),
          //Code_resend
      InkWell(
        child:  Container(
            padding: EdgeInsets.fromLTRB(10.0.w, 0.5.h, 10.0.w, 0.5.h),
            margin: EdgeInsets.fromLTRB(0, 4.0.h, 0, 0),
          //  decoration: Style.ButtonDecoration,
            child: Text(
                  Translations.of(context)!.Code_resend,
                  style: Style.Secondry16Bold,

                  textAlign: TextAlign.center,

                ),),
                onTap: () async {
                  showLoading();
                  var res = await Login(
                      context, widget.mobile);
                  hideLoading();
                  if (res != null) {
                    await AlertView(
                        context, "success", Translations.of(context)!.Ok,Translations.of(context)!.success_msg);
                  }

                }

            ),
        ],
      ),
    );
  }

  void showLoading() {
    setState(() {
      _isLoading=true;
    });
  }

  void hideLoading() {
    setState(() {
      _isLoading=false;
    });
  }

  void GetData() {
    setState(() {
      DelegateData.delegateData =null;
    });
  }

}
