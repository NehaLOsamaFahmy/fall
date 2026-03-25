//PayPageRoute
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sizer/sizer.dart';

import '../Api/SetvicesApi.dart';
import '../Constans/Style.dart';
import '../Localization/Translations.dart';
import '../Models/PaymentModel.dart';
import '../Models/ServicesModel.dart';
import '../Routes/route_constants.dart';
import '../Shared_Data/ServicesData.dart';
import '../Shared_View/AppBarView.dart';
import '../Shared_View/DrawerView.dart';

class RatePage extends StatefulWidget {
  String obj;
  RatePage({required this.obj, Key? key}) : super(key: key);
  @override
  _RatePageState createState() => _RatePageState();
}

class _RatePageState extends State<RatePage> {

  bool _isLoading = false;

  TextEditingController nameController = TextEditingController();
  String rate="0";

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBarWithBack(context, Translations.of(context)!.serviceRate),
        drawer: DrawerList(context),
        body:SafeArea(child: LoadingOverlay(
            isLoading: _isLoading,
            opacity: 0.2,
            color: Style.MainColor,
            progressIndicator: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Style.MainColor),),
            child: Container(
                height: double.infinity,
                width: double.infinity,
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  child: FormUI(context),
                )))));
  }
  FormUI(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.0.h,),
           Center(child:  QrImageView(
              data: widget.obj,
              version: QrVersions.auto,
              size: 25.0.h,
              gapless: false,
              errorStateBuilder: (cxt, err) {
                return Container(
                  child: Center(
                    child: Text(
                      'Uh oh! Something went wrong...',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            )),
            Container(child: Text(
              Translations.of(context)!.pleaseRate,
              style: TextStyle(color: Style.MainTextColor, fontSize: 16.0.sp, fontWeight: FontWeight.bold)),
              margin: EdgeInsets.symmetric(
                  vertical: 1.0.h, horizontal: 5.0.w),),
            Center(child: RatingBar.builder(
              initialRating: 5,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(
                  horizontal: 1.0.w, vertical: 2.0.h),
              itemBuilder: (context, _) =>
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
              onRatingUpdate: (rating) {
                print(rating);
                setState(() {
                  rate=rating.toString();
                });
              },
            )),
            Container(child: Text(
              Translations.of(context)!.rateQ, style: TextStyle(
                color: Style.MainTextColor, fontSize: 16.0.sp, fontWeight: FontWeight.bold)),
              margin: EdgeInsets.symmetric(
                  vertical: 1.0.h, horizontal: 5.0.w),),
            Container(
                decoration: Style.BoxDecorationBoxShadowGreyColor,
                padding: EdgeInsets.symmetric(
                    vertical: 0.5.h, horizontal: 2.0.w),
                margin: EdgeInsets.symmetric(
                    vertical: 0.5.h, horizontal: 5.0.w),
                child: Theme(
                  data: Theme.of(context).copyWith(
                      primaryColor: Style.SecondryColor),
                  child: TextFormField(
                      maxLines: 5,
                      controller: nameController,
                      cursorColor: Style.SecondryColor,
                      style: TextStyle(
                          fontSize: 16.0.sp, color: Style.MainTextColor),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: Translations.of(context)!.rateQ,
                          // labelStyle: TextStyle(fontSize: 16.0.sp, color: Style.GreyColor),
                          //  labelText: Translations.of(context)!.Code,
                          hintStyle: TextStyle(fontSize: 16.0.sp,
                            color: Style.GreyColor,),
                          errorStyle: TextStyle(fontSize: 16.0.sp,
                              color:Style.MainTextColor)
                      ),
                      keyboardType: TextInputType.text,
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                      }
                  ),)),
            Center(child:InkWell(
                child: Container(
              padding: EdgeInsets.fromLTRB(10.0.w, 0.5.h, 10.0.w, 0.5.h),
              margin: EdgeInsets.fromLTRB(0, 4.0.h, 0, 4.0.h),
              decoration: Style.ButtonDecoration,
              child:  Text(
                    Translations.of(context)!.send,
                    style: TextStyle(color: Colors.white,
                        fontSize: 15.0.sp),
                    textAlign: TextAlign.center,

                  ),),
                  onTap: () async {
                  showLoading();
                    var x= await SaveRate(context,rate,nameController.text);
                    if(x=true) {
                      Navigator.pushNamed(context, homeRoute);
                    }
                    hideLoading();
                  }
            )),


          ],
        ));
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