
import 'package:flutter/material.dart';
import 'package:babco/Constans/Base_Url.dart';
import 'package:babco/Localization/Translations.dart';
import 'package:babco/Models/AboutModel.dart';
import 'package:babco/Models/DataModel.dart';
import 'package:babco/Shared_Data/LanguageData.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sizer/sizer.dart';

import '../Api/DataApi.dart';
import '../Constans/Style.dart';
import '../Shared_Data/formatDateTime.dart';
import '../Shared_View/AlertView.dart';
import '../Shared_View/AppBarView.dart';
import '../Shared_View/DrawerView.dart';

class AboutUsPage extends StatefulWidget {

  AboutUsPage({Key? key}) : super(key: key);

  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {

  bool _isLoading = false;
  List<AboutModel>? data;
  List<DataModel> branches=<DataModel>[];

  @override
  void initState() {
    super.initState();
    GetData();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBarWithBack(context, Translations.of(context)!.About_us),
        drawer: DrawerList(context),
        body:SafeArea(child: LoadingOverlay(
            child: Container(
                height: double.infinity,
                width: double.infinity,
                child:FormUI(context),
                ),

            isLoading: _isLoading,
            opacity: 0.3,
            color: Style.WhiteColor,
            progressIndicator: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Style.MainColor),))
    ));
  }

  Widget FormUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 3.0.h,),
          Image(image: AssetImage('lib/assets/logo.png'), width: 60.0.w, height: 17.0.h,),
         // Text(Translations.of(context)!.New_user,style: Style.Secondry16Bold,),
          if(data != null &&data!.length>0)
         Container(
            margin: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 3.0.h),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                   ListView.builder(
                    shrinkWrap:true,// -> Add this here
                    physics:NeverScrollableScrollPhysics(),// -> And this one
                     itemCount:data!.length,
                     itemBuilder: (context, index) =>
                        Container(
                        margin: EdgeInsets.symmetric(vertical: 0.5.h,horizontal: 4.0.w),
                        child:  Column(
                          children: [
                            SizedBox(height: 1.0.h,),
                            title(data![index].name!),
                            des(data![index].description!),
                          ],
                        )),
                 ),


          ]))


      ])
    );
  }

  title(String t) {
    return Row(
      children: [
        Container(decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Style.SecondryColor
        ),
          height: 3.0.h,
          width: 2.8.w,
        ),
        SizedBox(width: 2.0.w,),
        Expanded(child: Text(t, style: Style.MainText16Bold,))
      ],
    );
  }

  des(String d)
  {
    return  Container(
        margin: EdgeInsets.symmetric(vertical: 0.5.h,horizontal: 1.0.w),
        child:  Row(children: [
          Expanded(child: Text(d, style: Style.MainText14,
          )),
        ],));
  }
  Future<void> GetData()
  async {
    showLoading();
    var x= await About_us(context);
    if(x != null) {
      setState(() {
        data = x!;
      });
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


}