//PayPageRoute
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:babco/Models/RequestsModel.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:sizer/sizer.dart';

import '../Api/RequestsApi.dart';
import '../Constans/Style.dart';
import '../Localization/Translations.dart';
import '../Models/PaymentModel.dart';
import '../Models/ServicesModel.dart';
import '../Routes/route_constants.dart';
import '../Shared_Data/DelegateData.dart';
import '../Shared_Data/ServicesData.dart';
import '../Shared_View/AlertView.dart';
import '../Shared_View/AppBarView.dart';
import '../Shared_View/DrawerView.dart';

class RequestsPage extends StatefulWidget {
  RequestsPage({ Key? key}) : super(key: key);
  @override
  _RequestsPageState createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {

  bool _isLoading = false;

  TextEditingController nameController = TextEditingController();
  List<RequestsModel> RequestsList=<RequestsModel>[];

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      GetData(context);
    });
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    //GetData(context);
  }
  void GetData(BuildContext context)async
  {
    if (DelegateData.delegateData != null &&
        DelegateData.delegateData!.id! > 0) {
      showLoading();
      var data = await GetRequests(context);
      if (data != null) {
        setState(() {
          RequestsList = data;
        });
      }
      hideLoading();
    }
    else {
      await AlertView2(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithBack(context, Translations.of(context)!.Requests),
        drawer: DrawerList(context),
        body: SafeArea(child: LoadingOverlay(
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
    if(RequestsList != null && RequestsList.length>0) {
      return ListView.builder(
          itemCount: RequestsList.length,
          itemBuilder: (context, index) {
            return ListData(RequestsList[index], index);
          });
    } else {
      return Center(child: Text(Translations.of(context)!.NoData,
        style: Style.MainText14Bold.copyWith(color:Style.MainTextColor),));
    }
  }

  ListData(RequestsModel data, int i) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.0.h, horizontal: 2.0.w),
      decoration: Style.BoxDecorationBoxShadowGreyColor,
      child:
      IntrinsicHeight(child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child:
          Container(child: Image(image: AssetImage('lib/assets/i12.png'),
            width: 15.0.w,
            height: 10.0.h,),
            padding: EdgeInsets.fromLTRB(1.0.w, 1.0.h, 1.0.w, 0),

          )),
          SizedBox(width: 2.0.w,),
          VerticalDivider(
            color: Style.LightGreyColor, thickness: 2, width: 0,),

          Expanded(child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                    padding: EdgeInsets.fromLTRB(3.0.w, 1.0.h, 3.0.w, 1.0.h),
                    child: Row(
                      children: [
                        Expanded(child: RichText(text: TextSpan(
                            text: Translations.of(context)!.order_number + " ",
                            style: Style.SecondryText10.copyWith(
                                color: Style.MainColor),
                            children: [
                              TextSpan(text: data.id.toString(),
                                style: Style.SecondryText10.copyWith(
                                    color:Style.MainTextColor),)
                            ]))),
                        Expanded(child: Text(data.date!,
                          style: Style.SecondryText10.copyWith(
                              color: Style.MainColor),)),
                        Expanded(child: RichText(text: TextSpan(
                            text: Translations.of(context)!.status + " ",
                            style: Style.SecondryText10.copyWith(
                                color: Style.MainColor),
                            children: [
                              TextSpan(text: data.status.toString(),
                                style: Style.SecondryText10.copyWith(
                                    color:Style.MainTextColor),)
                            ]))),
                      ],
                    )),
                Divider(
                  color: Style.LightGreyColor, thickness: 2, height: 0,),
                Padding(
                    padding: EdgeInsets.fromLTRB(3.0.w, 1.0.h, 3.0.w, 0.0.h),
                    child: Row(
                      children: [
                        Expanded(child: RichText(text: TextSpan(
                            text: Translations.of(context)!.Total + "  ",
                            style: Style.MainText10,
                            children: [
                              TextSpan(text: data.totalCost,
                                style: Style.MainText14Bold,),
                              TextSpan(
                                text: "  " + Translations.of(context)!.SAR,
                                style: Style.MainText10,)
                            ]),),flex: 2,),
                        Expanded(child: InkWell(
                          onTap: () => { Navigator.pushNamed(context, RequestsDetailsRoute,arguments:data ) },
                          child: Container(
                            padding: EdgeInsets.fromLTRB(
                                0.0.w, 0.5.h, 0.0.w, 0.5.h),
                            //  margin: EdgeInsets.fromLTRB(0, 4.0.h, 0, 0),
                            decoration: Style.ButtonSecondryDecoration,

                            child: Text(
                              Translations.of(context)!.order_details,
                              style: Style.MainText10,
                              textAlign: TextAlign.center,

                            ),


                          ),
                        ),)


                      ],
                    )

                )
              ]),)
        ],),),
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