
import 'package:flutter/material.dart';
import 'package:babco/Api/BalancePointApi.dart';
import 'package:babco/Localization/Translations.dart';
import 'package:babco/Shared_View/AnimatedButton.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sizer/sizer.dart';

import '../Api/DataApi.dart';
import '../Constans/Style.dart';
import '../Routes/route_constants.dart';
import '../Shared_Data/BalancePointData.dart';
import '../Shared_Data/DelegateData.dart';
import '../Shared_Data/formatDateTime.dart';
import '../Shared_View/AlertView.dart';
import '../Shared_View/AppBarView.dart';
import '../Shared_View/DrawerView.dart';

class LoyaltySystemPage extends StatefulWidget {

  LoyaltySystemPage({Key? key}) : super(key: key);

  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<LoyaltySystemPage> {

  bool _isLoading = false;
  String data="";
  bool login =false;

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
        appBar: AppBarWithBack(
            context, Translations.of(context)!.Loyalty_System),
        drawer: DrawerList(context),
        body: SafeArea(child: LoadingOverlay(
            child: Container(
                height: double.infinity,
                width: double.infinity,
                child: new GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  child: FormUI(context),
                )),

            isLoading: _isLoading,
            opacity: 0.3,
            color: Style.WhiteColor,
            progressIndicator: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Style.MainColor),))
    ));
  }

  Widget FormUI(BuildContext context) {
    if(login)
    {
      return Container();
    }
    else {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 2.0.h,),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0.h,horizontal: 4.0.w),
                    decoration: Style.BoxDecorationRadius,
                    child: Row(
                    children: [
                      Expanded(child: Column(
                        children: [
                          SizedBox(height: 2.0.h,),
                          Text(Translations.of(context)!.Loyalty_System,style: Style.MainText14Bold,),

                          SizedBox(height: 1.0.h,),
                          Text(BalancePointData.Point + " "+ Translations.of(context)!.Point,style: Style.MainText14,),
                          SizedBox(height: 2.0.h,),
                          AnimatedButton(text: Translations.of(context)!.replacement_point, onTapped: StartFun)
                        ],
                      )),

                       Expanded(child: Image(image: AssetImage("lib/assets/Point.png"),fit: BoxFit.contain,height: 15.0.h,),
                    //   )
                  )
                    ],
                  ),),
              ],
            )

      );
    }
  }

  Future<void> GetData()
  async {

    showLoading();

    if (DelegateData.delegateData != null &&
        DelegateData.delegateData!.id! > 0) {
      showLoading();
      hideLoading();
    }
    else {
      setState(() {
        login=true;
      });
      await AlertView2(context);
    }
    hideLoading();
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



  Future<void> StartFun()async {
      showLoading();
      var x= await ConvertPointsFun(context);
      hideLoading();
      if(x==true)
      {
        Navigator.pushNamedAndRemoveUntil(context, homeRoute,(Route<dynamic> r)=>false);
      }

  }
}