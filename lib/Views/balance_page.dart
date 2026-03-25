
import 'package:flutter/material.dart';
import 'package:babco/Localization/Translations.dart';
import 'package:babco/Routes/route_constants.dart';
import 'package:babco/Shared_Data/BalancePointData.dart';
import 'package:babco/Shared_Data/LanguageData.dart';
import 'package:babco/Views/home_page.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sizer/sizer.dart';

import '../Api/BalancePointApi.dart';
import '../Api/DataApi.dart';
import '../Constans/Style.dart';
import '../Shared_Data/DelegateData.dart';
import '../Shared_Data/formatDateTime.dart';
import '../Shared_View/AlertView.dart';
import '../Shared_View/AnimatedButton.dart';
import '../Shared_View/AppBarView.dart';
import '../Shared_View/DrawerView.dart';
import '../Shared_View/border_text_field.dart';

class BalancePage extends StatefulWidget {

  BalancePage({Key? key}) : super(key: key);

  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<BalancePage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool login =false;
  TextEditingController notes= new TextEditingController();
  TextEditingController amount= new TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      GetData();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithBack(
            context, Translations.of(context)!.Recharge_wallet),
        drawer: DrawerList(context),
        body:SafeArea(child: LoadingOverlay(
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
           Stack(
             children: [


               Row(children: [
                 Expanded(child:
                 Container(
                   margin: EdgeInsets.symmetric(vertical: 8.0.h,horizontal: 4.0.w),
                   decoration: Style.BoxDecorationRadius,
                   height: 20.0.h,child: Row(
children: [
  Expanded(child: Column(
    children: [
      SizedBox(height: 2.0.h,),
      Text(Translations.of(context)!.Wallet_balance,style: Style.MainText14Bold,),

      SizedBox(height: 1.0.h,),
      Text(BalancePointData.Balance,style: Style.MainText14,),

      AnimatedButton(text: Translations.of(context)!.Connect_us, onTapped: StartFun),

    ],
  )),
  Expanded(child: Container())
],
                 ),),)
               ],),
               Row(children: [
                 Expanded(child: Container()),
                 Expanded(child:
                 // Container(  margin: EdgeInsets.symmetric(vertical: 2.0.h,horizontal: 4.0.w), height: 30.0,child:
                 Image(image: AssetImage("lib/assets/balance.png"),fit: BoxFit.cover,height: 35.0.h,),
                   //   )
                 )
               ],),
             ],
           )


          ],
        ),
      );
    }
  }


  Future<bool?> addNotes() async {
    return await Alert(
        context: context,
        padding: EdgeInsets.all(0),
        style: AlertStyle(isButtonVisible: false,
            isCloseButton: true,
            buttonAreaPadding: EdgeInsets.all(0)),
        // title: "",
        content: SingleChildScrollView(child:   Form(
    key: _formKey,
    child:Column(
          children: <Widget>[
            Container(margin: EdgeInsets.symmetric(vertical: 0.0.h,horizontal: 0.0.w),
                child:
                BorderTextField(
                  onChanged: (String value) async {},
                  lang: LanguageData.languageData,
                  controller: amount,
                  label: Translations.of(context)!.amount,
                  hint: Translations.of(context)!.enter_amount,
                  keyboardType: TextInputType.number,
                  validator: (value){
                    if (value == null || value.isEmpty) {
                      return Translations.of(context)!.enter_amount;
                    }
                    var res = double.tryParse(value);
                    if (res == null) {
                      return Translations.of(context)!.enter_amount_valid;
                    }

                    if (res <= 0) {
                      return Translations.of(context)!.enter_amount_valid;
                    }
                    return null;
                  },
                )),
            Container(margin: EdgeInsets.symmetric(vertical: 0.5.h,horizontal: 0.0.w),
                child:
                BorderTextField(
                  onChanged: (String value) async {},
                  lang: LanguageData.languageData,
                  controller: notes,
                  label: Translations.of(context)!.des,
                  hint: Translations.of(context)!.enter_des,
                  validator: (value){
                    if (value == null || value.isEmpty) {
                      return Translations.of(context)!.enter_des;
                    }

                    return null;
                  },
                )),
            SizedBox(height: 4.0.h,),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 14.0.w),
                child:
                AnimatedButton(text:Translations.of(context)!.send,onTapped: sendFun,)),

            SizedBox(height: 2.0.h,),
          ],
        ),))).show();
  }


  Future<void> GetData()
  async {

    showLoading();

    if (DelegateData.delegateData != null &&
        DelegateData.delegateData!.id! > 0) {
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
    await addNotes();
  }

  Future<void> sendFun()async {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context);
      showLoading();
     var x= await WalletRequestFun(context,notes.text,amount.text);
     hideLoading();
     if(x==true)
       {
         Navigator.pushNamedAndRemoveUntil(context, homeRoute,(Route<dynamic> r)=>false);
       }
    }
  }
}