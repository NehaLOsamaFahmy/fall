/*
ادخل id الشركه
 */
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../Api/CheckVersionApi.dart';
import '../Api/LoginApi.dart';
import '../Constans/Style.dart';
import '../Localization/Translations.dart';
import '../Routes/route_constants.dart';
import '../Shared_Data/CompanyData.dart';
import '../Shared_Data/DelegateData.dart';
import '../Shared_View/AlertView.dart';
import '../Shared_View/AppBarView.dart';

class startPage extends StatefulWidget {
  startPage({Key? key}) : super(key: key);

  @override
  _startPageState createState() => _startPageState();
}

class _startPageState extends State<startPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController mobileController = TextEditingController();
  bool _isLoading = false;
  bool check_Version= false;

  void initState() {
    super.initState();
   checkVersionFun(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
        appBar: AppBarWithBackOnly(context, ""),
        body: SafeArea(child: LoadingOverlay(
             isLoading: _isLoading,
          opacity: 0.2,
          color: Style.MainColor,
          progressIndicator: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Style.MainColor),),
             child: Container(
          height: double.infinity,
          width: double.infinity,
          //decoration: Style.BoxDecoration1,
          child: FormUI(),
        ))
        ));
  }

  Widget FormUI() {
    return SingleChildScrollView(child: Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 15.0.h,),
            Image(image: AssetImage('lib/assets/logo.png'),
              width: 60.0.w,
              height: 20.0.h,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 5.0.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(children: [
                    Image(image: AssetImage('lib/assets/flag.png'),
                      width: 8.0.w,
                      height: 5.0.h,),
                    SizedBox(width: 3.0.w,),
                    Text("+966", style: TextStyle(
                        fontSize: 16.0.sp, color: Style.GreyColor),),
                    SizedBox(width: 1.0.w,),
                    Expanded(child: Theme(
                      data: Theme.of(context).copyWith(primaryColor: Style
                          .SecondryColor),
                      child: TextFormField(
                          controller: mobileController,
                          cursorColor: Style.SecondryColor,
                          style: TextStyle(
                              fontSize: 16.0.sp, color: Style.MainTextColor),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: Translations.of(context)!.Phone_number + " "+Translations.of(context)!.phone_number_ex,
                              //  labelStyle: TextStyle(fontSize: 16.0.sp, color: Style.GreyColor),
                              hintStyle: TextStyle(fontSize: 16.0.sp,
                                color: Style.GreyColor,),
                              errorStyle: TextStyle(fontSize: 16.0.sp,
                                  color:Style.MainTextColor)
                          ),
                          keyboardType: TextInputType.phone,
                          onEditingComplete: () {
                            FocusScope.of(context).unfocus();
                          }
                      ),),)
                  ],),
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
                  if (mobileController.text != null &&
                      mobileController.text.length > 0) {
                    if(mobileController.text.length != 9)
                      {
                        await AlertView(
                            context, "error",
                            Translations.of(context)!.Please,
                            Translations.of(context)!.Phone_number_Validation);
                      }
                    else {
                      showLoading();
                      var res = await Login(
                          context, mobileController.text);
                      hideLoading();
                      if (res != null) {
                        if (check_Version) {
                          await AlertView(
                              context, "error",
                              Translations.of(context)!.Please,
                              Translations.of(context)!.LastVersion,
                              id: 1);
                        }
                        else {
                          showLoading();
                          var res = await Verifycode(context, mobileController.text,"123456");
                          hideLoading();
                          if (res != null) {
                            Navigator.pushNamed(context, homeRoute);
                          }
                          //Navigator.pushNamed(context, loginRoute,arguments: mobileController.text);
                        }
                      }
                    }
                  }
                  else {
                    await AlertView(
                        context, "error",
                        Translations.of(context)!.Please,
                        Translations.of(context)!.Phone_number_Validation);
                  }
                }
            ),
            //New_user
            Container(
                padding: EdgeInsets.fromLTRB(10.0.w, 0.5.h, 10.0.w, 0.5.h),
                margin: EdgeInsets.fromLTRB(0, 4.0.h, 0, 0),
               // decoration: Style.ButtonDecoration,
                child: InkWell(
                  onTap:()=>  Navigator.pushNamed(context, newUserRoute),
                  child: Text(
                    Translations.of(context)!.New_user,
                    style: Style.Secondry16Bold,
                    textAlign: TextAlign.center,
                  ),
                )
            )
          ]
      ),
    )
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

  Future<void> checkVersionFun(BuildContext context)
  async {
    if (await Permission.locationWhenInUse.serviceStatus.isEnabled) {
      print("*******");
      print("true");
    }
    else
      {
        print("*******");
        print("no true");
      }
    showLoading();

    var x =await checkVersion(context);
    setState(() {
      check_Version = x;
    });
    if (DelegateData.delegateData != null &&
        DelegateData.delegateData!.name != null &&
        CompanyData.companyData != null &&
        CompanyData.companyData!.baseUrl != null) {
      Navigator.pushNamed(context, homeRoute);
    }
    hideLoading();
  }
}

