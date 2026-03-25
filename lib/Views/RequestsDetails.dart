

import 'package:flutter/material.dart';
import 'package:babco/Models/RequestsModel.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sizer/sizer.dart';

import '../Constans/Style.dart';
import '../Localization/Translations.dart';
import '../Shared_View/AppBarView.dart';
import '../Shared_View/DrawerView.dart';

class RequestsDetailsPage extends StatefulWidget {
  final RequestsModel obj;
  RequestsDetailsPage({required this.obj, Key? key}) : super(key: key);
  @override
  _RequestsDetailsPageState createState() => _RequestsDetailsPageState();
}

class _RequestsDetailsPageState extends State<RequestsDetailsPage> {

  bool _isLoading = false;
  double Total = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBarWithBack(
            context, Translations.of(context)!.order_details),
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
    return  Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 2.0.h,),
            Center(child:  QrImageView(
              data: widget.obj.url!,
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
            Container(
              margin: EdgeInsets.symmetric(vertical: 3.0.h, horizontal: 2.0.w),
              decoration: Style.BoxDecorationBoxShadowGreyColor,
              child:
              IntrinsicHeight(child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child:
                  Container(child: Image(image: AssetImage(
                      'lib/assets/i12.png'),
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
                            padding: EdgeInsets.fromLTRB(
                                3.0.w, 1.0.h, 3.0.w, 1.0.h),
                            child: Row(
                              children: [
                                Expanded(child: Text(
                                    Translations.of(context)!.quantity,
                                    style: Style.SecondryText12.copyWith(
                                        color: Style.MainColor3)),),
                                Expanded(child: Text(
                                    Translations.of(context)!.ServiceKind,
                                    style: Style.SecondryText12.copyWith(
                                        color: Style.MainColor3)), flex: 2),
                                Expanded(child: Text(
                                  " "+Translations.of(context)!.ServicePrice,
                                  style: Style.SecondryText12.copyWith(
                                      color:Style.MainTextColor),),flex: 2),
                              ],
                            )),
                        Divider(
                          color: Style.LightGreyColor,
                          thickness: 2,
                          height: 0,),
                         ListData(),
                        Divider(
                          color: Style.LightGreyColor,
                          thickness: 2,
                          height: 0,),
                        Padding(
                            padding: EdgeInsets.fromLTRB(
                                3.0.w, 1.0.h, 3.0.w, 0.0.h),
                            child: Row(
                              children: [
                                Expanded(child: RichText(text: TextSpan(
                                    text: Translations.of(context)!
                                        .order_number + " ",
                                    style: Style.SecondryText10.copyWith(
                                        color: Style.MainColor),
                                    children: [
                                      TextSpan(text: widget.obj.id.toString(),
                                        style: Style.SecondryText10.copyWith(
                                            color:Style.MainTextColor),)
                                    ]))),
                                Expanded(child: Text(widget.obj.date!,
                                  style: Style.SecondryText10.copyWith(
                                      color: Style.MainColor),)),
                                Expanded(child: RichText(text: TextSpan(
                                    text: Translations.of(context)!.status +
                                        " ",
                                    style: Style.SecondryText10.copyWith(
                                        color: Style.MainColor),
                                    children: [
                                      TextSpan(
                                        text: widget.obj.status.toString(),
                                        style: Style.SecondryText10.copyWith(
                                            color:Style.MainTextColor),)
                                    ]))),
                              ],
                            )),
                      ]),)
                ],),),
            )
          ]
      );
  }


  ListData() {
    return Column(
        children: [
          for(var data in widget.obj.details!)
            DataTile(data),
          Padding(
              padding: EdgeInsets.fromLTRB(
                  3.0.w, 1.0.h, 3.0.w, 1.0.h),
              child: Row(
                children: [
                  Expanded(child: Text(""), flex: 2),
                  Expanded(child: Container(

                      color:Style.MainTextColor,
                      child: RichText(text: TextSpan(
                      text:" "+ widget.obj.totalCost!,
                      style: Style.MainText14Bold.copyWith(color: Colors.white),
                      children: [
                        TextSpan(
                          text: "  " + Translations.of(context)!.SAR,
                          style: Style.MainText10.copyWith(color: Colors.white),)
                      ]),)),)
                ],
              ))
        ]);
  }
DataTile(RequestsDetails data)
{
  return   Padding(
      padding: EdgeInsets.fromLTRB(
          3.0.w, 1.0.h, 3.0.w, 1.0.h),
      child: Row(
        children: [
          Expanded(child: Text(  data.quantity.toString(),
      style: Style.SecondryText12.copyWith(
          color: Style.MainColor3)), ),
          Expanded(child: Text(
               data.productName!,
              style: Style.SecondryText12.copyWith(
                  color: Style.MainColor3)), flex: 2),
          Expanded(flex: 2,child: RichText(text: TextSpan(
              text:" "+ data.cost!,
              style: Style.MainText14Bold,
              children: [
                TextSpan(
                  text: "  " + Translations.of(context)!.SAR,
                  style: Style.MainText10,)
              ]),)),
        ],
      ));
}


  void showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  void hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }
}


