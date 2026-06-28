
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:babco/Models/DataModel.dart';
import 'package:babco/Shared_View/DrawerView.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:sizer/sizer.dart';

import '../Api/DataApi.dart';
import '../Api/Login/LoginApi.dart';
import '../Constans/Style.dart';
import '../Localization/Translations.dart';
import '../Routes/route_constants.dart';
import '../Shared_Data/CompanyData.dart';
import '../Shared_Data/DelegateData.dart';
import '../Shared_View/AlertView.dart';
import '../Shared_View/AnimatedButton.dart';
import '../Shared_View/AppBarView.dart';


class Connect_usPage extends StatefulWidget {
  Connect_usPage({Key? key}) : super(key: key);

  @override
  _Connect_usPageState createState() => _Connect_usPageState();
}

class _Connect_usPageState extends State<Connect_usPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController name1Controller = TextEditingController();
  TextEditingController commentController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController name2Controller = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool _isLoading = false;
  DataModel SelectData= new DataModel(-1, "name","","","");
  List<DataModel> data=<DataModel>[];

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
        appBar: AppBarWithBack(context, Translations.of(context)!.Connect_us),
        drawer: DrawerList(context),
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
          SizedBox(height: 4.0.h,),
      /*
      Container(
        decoration: Style.BoxDecorationBoxShadowGreyColor,
        padding: EdgeInsets.symmetric(
            vertical: 0.5.h, horizontal: 2.0.w),
         margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0.w),
        child:   PopupMenuButton(
            child:
            Container(margin: EdgeInsets.symmetric(
                  vertical: 0.0.h, horizontal: 0.0.w),child:
            Row(
              children: [
                Expanded(child:Center(child:  Text(SelectData.name!, style: Style.MainText12,))),
                Icon(Icons.arrow_drop_down,
                    color: Style.SecondryColor,
                    size: 2.5.h),
              ],
            ),
            ),

            itemBuilder: (context) {
              return data.map((DataModel choice) {
                return PopupMenuItem(
                    value: choice,
                    child: Row(
                      children: [
                        Padding(padding: EdgeInsets.symmetric(
                            vertical: 0.0.h,
                            horizontal: 1.0.w),),
                        Expanded(
                          child: Text(choice.name.toString(),
                            style: Style.MainText14,),),
                      ],)
                );
              }).toList();
            },
            onSelected: (DataModel value) {
              setState(() {
                SelectData = value;
              });
            },
          )),
        */  Container(
            margin: EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 3.0.h),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                /*  Row(
                    children: [
                      Expanded(child: Theme(
                        data: Theme.of(context).copyWith(primaryColor: Style
                            .SecondryColor),
                        child: TextFormField(
                            controller: name1Controller,
                            cursorColor: Style.SecondryColor,
                            style: TextStyle(
                                fontSize: 16.0.sp, color: Style.MainTextColor),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return Translations.of(context)!
                                    .First_name_Validation;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.person, size:3.0.h,),
                                hintText: Translations.of(context)!.First_name,
                                // labelStyle: TextStyle(fontSize: 16.0.sp, color: Style.GreyColor),
                                //  labelText: Translations.of(context)!.Code,
                                hintStyle: TextStyle(fontSize: 16.0.sp,
                                  color: Style.GreyColor,),
                                errorStyle: TextStyle(fontSize: 16.0.sp,
                                    color:Style.MainTextColor)
                            ),
                            keyboardType: TextInputType.name,
                            onEditingComplete: () {
                              FocusScope.of(context).unfocus();
                            }
                        ),),),
                      SizedBox(width: 5.0.w,),
                      Expanded(child: Theme(
                        data: Theme.of(context).copyWith(primaryColor: Style
                            .SecondryColor),
                        child: TextFormField(
                            controller: name2Controller,
                            cursorColor: Style.SecondryColor,
                            style: TextStyle(
                                fontSize: 16.0.sp, color: Style.MainTextColor),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return Translations.of(context)!
                                    .Last_name_Validation;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.person, size: 3.0.h,),
                                hintText: Translations.of(context)!.Last_name,
                                // labelStyle: TextStyle(fontSize: 16.0.sp, color: Style.GreyColor),
                                //  labelText: Translations.of(context)!.Code,
                                hintStyle: TextStyle(fontSize: 16.0.sp,
                                  color: Style.GreyColor,),
                                errorStyle: TextStyle(fontSize: 16.0.sp,
                                    color:Style.MainTextColor)
                            ),
                            keyboardType: TextInputType.name,
                            onEditingComplete: () {
                              FocusScope.of(context).unfocus();
                            }
                        ),),)
                    ],
                  ),
                  SizedBox(height: 1.0.h,),
                  Theme(
                    data: Theme.of(context).copyWith(
                        primaryColor: Style.SecondryColor),
                    child: TextFormField(
                        controller: mobileController,
                        cursorColor: Style.SecondryColor,
                        style: TextStyle(
                            fontSize: 16.0.sp, color: Style.MainTextColor),
                        validator: (value) {
                          if (value!.isEmpty|| value.length < 9) {
                            return Translations.of(context)!
                                .Phone_number_Validation;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.phone_android, size: 3.0.h,),
                            hintText: Translations.of(context)!.Phone_number,
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
                  SizedBox(height: 1.0.h,),
                  Theme(
                    data: Theme.of(context).copyWith(
                        primaryColor: Style.SecondryColor),
                    child: TextFormField(
                        controller: emailController,
                        cursorColor: Style.SecondryColor,
                        style: TextStyle(
                            fontSize: 16.0.sp, color: Style.MainTextColor),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return Translations.of(context)!.Email_Validation;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.email_outlined, size: 3.0.h,),
                            hintText: Translations.of(context)!.Email,
                            // labelStyle: TextStyle(fontSize: 16.0.sp, color: Style.GreyColor),
                            //  labelText: Translations.of(context)!.Code,
                            hintStyle: TextStyle(fontSize: 16.0.sp,
                              color: Style.GreyColor,),
                            errorStyle: TextStyle(fontSize: 16.0.sp,
                                color:Style.MainTextColor)
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onEditingComplete: () {
                          FocusScope.of(context).unfocus();
                        }
                    ),),
                  *///SizedBox(height: 4.0.h,),
                  Container(
                      decoration: Style.BoxDecorationBoxShadowGreyColor,
                      padding: EdgeInsets.symmetric(
                          vertical: 0.5.h, horizontal: 2.0.w),
                     // margin: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 5.0.w),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                            primaryColor: Style.SecondryColor),
                        child: TextFormField(
                            maxLines: 6,
                             controller: commentController,
                            cursorColor: Style.SecondryColor,
                            style: TextStyle(
                                fontSize: 16.0.sp, color: Style.MainTextColor),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: Translations.of(context)!.comment,
                                // labelStyle: TextStyle(fontSize: 16.0.sp, color: Style.GreyColor),
                                //  labelText: Translations.of(context)!.Code,
                                hintStyle: TextStyle(fontSize: 16.0.sp,
                                  color: Style.GreyColor,),
                                errorStyle: TextStyle(fontSize: 16.0.sp,
                                    color:Style.MainTextColor)
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return Translations.of(context)!.comment_Validation;
                              }
                              return null;
                            },
                            keyboardType: TextInputType.text,
                            onEditingComplete: () {
                              FocusScope.of(context).unfocus();
                            }
                        ),)),

                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 14.0.w, vertical: 10.0.h),
                      child:
                      AnimatedButton(text:Translations.of(context)!.send,onTapped: startFun,))

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

  Future<void> GetData()
  async {
  /*  showLoading();
    setState(() {
      data=<DataModel>[
         DataModel(0, Translations.of(context)!.inquiry ,"","",""),
         DataModel(1, Translations.of(context)!.complaint,"" ,"",""),
         DataModel(2, Translations.of(context)!.suggestion,"" ,"",""),
      ];
      SelectData=data[0];
    });
    hideLoading();*/
 /*   showLoading();

    if (DelegateData.delegateData != null &&
        DelegateData.delegateData!.id! > 0) {
      hideLoading();
    }
    else {

      await AlertView2(context);
    }
    hideLoading();*/
  }

  Future<void> startFun() async {
    if (_formKey.currentState!.validate()) {
      showLoading();
      var res = await Contact_us(context, mobileController.text,
          name1Controller.text+name2Controller.text, commentController.text,emailController.text,SelectData.id.toString());
      hideLoading();
      if (res == true) {
        Navigator.pushNamed(context, homeRoute);
      }
      hideLoading();
    }
  }
}
