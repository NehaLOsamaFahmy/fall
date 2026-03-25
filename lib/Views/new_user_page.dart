
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:sizer/sizer.dart';

import '../Api/LoginApi.dart';
import '../Constans/Style.dart';
import '../Localization/Translations.dart';
import '../Routes/route_constants.dart';
import '../Shared_Data/CompanyData.dart';
import '../Shared_View/AlertView.dart';
import '../Shared_View/AppBarView.dart';


class NewUserPage extends StatefulWidget {
  NewUserPage({Key? key}) : super(key: key);

  @override
  _NewUserPageState createState() => _NewUserPageState();
}

class _NewUserPageState extends State<NewUserPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController name1Controller = TextEditingController();
  TextEditingController name2Controller = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      //resizeToAvoidBottomInset: false,
        appBar: AppBarWithBackOnly(context, ""),
        body: SafeArea(child:LoadingOverlay(
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
          SizedBox(height: 4.0.h,),
          Image(image: AssetImage('lib/assets/logo.png'), width: 60.0.w, height: 12.0.h,),
          Text(Translations.of(context)!.New_user,style: Style.Secondry16Bold,),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 5.0.h),
            child:Form(
              key: _formKey,
              child:   Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                  Expanded(child: Row(children: [
                    SizedBox(width: 3.0.w,),
                    Icon( Icons.person,size: 3.0.h,color: Style.SecondryColor,),
                    SizedBox(width: 3.0.w,),
                    Expanded(child:
                    Theme(
                      data: Theme.of(context).copyWith(primaryColor: Style.SecondryColor),
                      child: TextFormField(
                          controller: name1Controller,
                          cursorColor: Style.SecondryColor,
                          style: TextStyle(fontSize: 16.0.sp, color: Style.MainTextColor),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return Translations.of(context)!.First_name_Validation;
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                           //   prefixIcon:Icon( Icons.person,size: 3.0.h,color: Style.SecondryColor,),
                              hintText: Translations.of(context)!.First_name,
                              // labelStyle: TextStyle(fontSize: 16.0.sp, color: Style.GreyColor),
                              //  labelText: Translations.of(context)!.Code,
                              hintStyle: TextStyle(fontSize: 16.0.sp,
                                color: Style.GreyColor,),
                              errorStyle: TextStyle(fontSize: 11.0.sp,
                                  color:Style.MainTextColor)
                          ),
                          keyboardType: TextInputType.name,
                          onEditingComplete: () {
                            FocusScope.of(context).unfocus();
                          }
                      ),)
                    ),
                  ],),),

                   Expanded(child: Row(children: [
                     SizedBox(width: 3.0.w,),
                     Icon( Icons.person,size: 3.0.h,color: Style.SecondryColor,),
                     SizedBox(width: 3.0.w,),
                     Expanded(child:
                     Theme(
                       data: Theme.of(context).copyWith(primaryColor: Style.SecondryColor),
                       child: TextFormField(
                           controller: name2Controller,
                           cursorColor: Style.SecondryColor,
                           style: TextStyle(fontSize: 16.0.sp, color: Style.MainTextColor),
                           validator: (value) {
                             if (value!.isEmpty) {
                               return Translations.of(context)!.Last_name_Validation;
                             }
                             return null;
                           },
                           decoration: InputDecoration(
                            //   prefixIcon:Icon( Icons.person,size: 3.0.h,color: Style.SecondryColor),
                               hintText: Translations.of(context)!.Last_name,
                               // labelStyle: TextStyle(fontSize: 16.0.sp, color: Style.GreyColor),
                               //  labelText: Translations.of(context)!.Code,
                               hintStyle: TextStyle(fontSize: 16.0.sp,
                                 color: Style.GreyColor,),
                               errorStyle: TextStyle(fontSize: 11.0.sp,
                                   color:Style.MainTextColor)
                           ),
                           keyboardType: TextInputType.name,
                           onEditingComplete: () {
                             FocusScope.of(context).unfocus();
                           }
                       ),),
                     ),
                   ],),),
                  ],
                ),
                SizedBox(height: 1.0.h,),

                Row(children: [
                  SizedBox(width: 3.0.w,),
                  Icon( Icons.phone_android,size: 3.0.h,color: Style.SecondryColor),
                  SizedBox(width: 3.0.w,),
                  Text("+966", style: TextStyle(
                      fontSize: 16.0.sp, color: Style.GreyColor),),
                  SizedBox(width: 1.0.w,),
                  Expanded(child:
                Theme(
                    data: Theme.of(context).copyWith(primaryColor: Style.SecondryColor),
                    child: TextFormField(
                        controller: mobileController,
                        cursorColor: Style.SecondryColor,
                        style: TextStyle(fontSize: 16.0.sp, color: Style.MainTextColor),
                        validator: (value) {
                          if (value!.isEmpty ||  value.length <9) {
                            return Translations.of(context)!.Phone_number_Validation;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          //prefixIcon:Icon( Icons.phone_android,size: 3.0.h,color: Style.SecondryColor),
                            hintText: Translations.of(context)!.Phone_number + " "+Translations.of(context)!.phone_number_ex,
                           // labelStyle: TextStyle(fontSize: 16.0.sp, color: Style.GreyColor),
                          //  labelText: Translations.of(context)!.Code,
                            hintStyle: TextStyle(fontSize: 16.0.sp,
                              color: Style.GreyColor,),
                            errorStyle: TextStyle(fontSize: 11.0.sp,
                                color:Style.MainTextColor)
                        ),
                        keyboardType: TextInputType.number,
                        onEditingComplete: () {
                          FocusScope.of(context).unfocus();
                        }
                    ),)),
                ],),
                SizedBox(height: 1.0.h,),
                Row(children: [
                  SizedBox(width: 3.0.w,),
                  Icon(Icons.email_outlined,size: 3.0.h,color: Style.SecondryColor),
                  SizedBox(width: 3.0.w,),

                  Expanded(child:
                  Theme(
                    data: Theme.of(context).copyWith(primaryColor: Style.SecondryColor),
                    child: TextFormField(
                        controller: emailController,
                        cursorColor: Style.SecondryColor,
                        style: TextStyle(fontSize: 16.0.sp, color: Style.MainTextColor),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return Translations.of(context)!.Email_Validation;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                         //   prefixIcon: Icon(Icons.email_outlined,size: 3.0.h,color: Style.SecondryColor),
                            hintText: Translations.of(context)!.Email,
                            // labelStyle: TextStyle(fontSize: 16.0.sp, color: Style.GreyColor),
                            //  labelText: Translations.of(context)!.Code,
                            hintStyle: TextStyle(fontSize: 16.0.sp,
                              color: Style.GreyColor,),
                            errorStyle: TextStyle(fontSize: 11.0.sp,
                                color:Style.MainTextColor)
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onEditingComplete: () {
                          FocusScope.of(context).unfocus();
                        }
                    ),),
                  ),
                ],),

                // Login Button
                InkWell(
                  child: Container(
                  padding: EdgeInsets.fromLTRB(10.0.w, 0.5.h, 10.0.w, 0.5.h),
                  margin: EdgeInsets.fromLTRB(0, 10.0.h, 0, 0),
                  decoration: Style.ButtonDecoration,
                  child:  Text(
                        Translations.of(context)!.login,
                        style: TextStyle(color: Colors.white,
                            fontSize: 17.0.sp),

                        textAlign: TextAlign.center,

                      ),

                  ),
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        showLoading();
                        var res = await Registration(context, mobileController.text,name1Controller.text,name2Controller.text,emailController.text);
                        hideLoading();
                        if (res ==true) {
                          Navigator.pushNamed(context, startRoute);
                        }
                        hideLoading();
                      }
                    }
                ),

              ],
            ),
            ),
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

}
