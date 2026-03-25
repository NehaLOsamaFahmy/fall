//PayPageRoute
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:babco/Api/PaymentApi.dart';
import 'package:babco/Models/DelegateDataModel.dart';
import 'package:babco/Models/OrderModel.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:sizer/sizer.dart';

import '../Api/SetvicesApi.dart';
import '../Constans/Style.dart';
import '../Localization/Translations.dart';
import '../Models/PaymentModel.dart';
import '../Models/ServicesModel.dart';
import '../Routes/route_constants.dart';
import '../Shared_Data/DelegateData.dart';
import '../Shared_Data/ServicesData.dart';
import '../Shared_Data/formatDateTime.dart';
import '../Shared_View/AlertView.dart';
import '../Shared_View/AppBarView.dart';
import '../Shared_View/DrawerView.dart';

class PayPage extends StatefulWidget {
  final  List<ServicesModel> obj;
  PayPage({required this.obj, Key? key}) : super(key: key);
  @override
  _PayPageState createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {

  bool _isLoading = false;
  double Total=0;
  List<PaymentModel> PaymentList=<PaymentModel>[];
   String PaymentId="";
   String ServiceType="";
   TextEditingController addressController= new TextEditingController();

  @override
  void didChangeDependencies() {
    GetTotal(context);
    super.didChangeDependencies();
  }

/*
  @override
  void initState() {

    GetTotal(context);
    super.initState();
  }
*/


  void GetTotal(BuildContext context)
  {
    if(Total>0) {
    }
    else {
      setState(() {
        Total = 0;
      });
      for (var i in widget.obj) {
        setState(() {
          var x = i.details.where((element) => element.selected == true)
              .toList();
          if (x != null && x.length > 0) {
            Total = Total +
                x.map((expense) => expense.get_total()!)
                    .fold(0, (prev, amount) => prev + amount);
          }
        });
      }
    }
    print("-----");
    print(Total);
    print("-----");
    if(PaymentList != null && PaymentList.length>0) {
    }
    else
      {
        setState(() {
          PaymentList = GetPayment(context);
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithBack(context, Translations.of(context)!.Pay),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        SizedBox(height: 1.0.h,),
        Center(child: Image(image: AssetImage('lib/assets/i9.png'),
          width: 60.0.w,
          height: 15.0.h,)),

/*
        Container(

          margin: EdgeInsets.symmetric(vertical: 0.0.h, horizontal: 5.0.w),
          child: Text(
            Translations.of(context)!.serviceType, style: Style.MainText14,),),
        Container(
          decoration: Style.BoxDecorationBoxShadowGreyColor,
          margin: EdgeInsets.symmetric(vertical: 0.0.h, horizontal: 5.0.w),
          padding: EdgeInsets.symmetric(vertical: 0.0.h, horizontal: 2.0.w),
          child: IntrinsicHeight(child: Row(
            children: [
              Expanded(child:
              InkWell(
                onTap: () {
                  setState(() {
                    ServiceType = "1";
                  });
                },
                child:
                Container(
                  margin: EdgeInsets.symmetric(
                      vertical: 0.5.h, horizontal: 0.0.w),
                  color: ServiceType == "1" ? Style.SecondryColor : Colors
                      .transparent,
                  child: Center(child: Text(Translations.of(context)!
                      .serviceType1, style: Style.MainText14Bold,)),
                ),)),
              SizedBox(height: 7.0.h, width: 3.0.w,),
              VerticalDivider(
                color: Style.LightGreyColor, thickness: 2, width: 0,),
              SizedBox(height: 7.0.h, width: 3.0.w,),
              Expanded(child:
              InkWell(
                  onTap: () {
                    setState(() {
                      ServiceType = "0";
                    });
                  },
                  child:
                  Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 0.5.h, horizontal: 0.0.w),
                      color: ServiceType == "0" ? Style.SecondryColor : Colors
                          .transparent,
                      child: Center(child: Text(Translations.of(context)!
                          .serviceType2, style: Style.MainText14Bold))))),
            ],)
          ),),*/
        SizedBox(height: 2.0.h,),
        Container(
            decoration: Style.BoxDecorationBoxShadowGreyColor,
            margin: EdgeInsets.symmetric(vertical: 2.0.h, horizontal: 15.0.w),
            padding: EdgeInsets.symmetric(vertical: 0.0.h, horizontal: 5.0.w),
            child: IntrinsicHeight(child: Row(
              children: [
                Expanded(child: Center(child: Text(
                  Translations.of(context)!.Total,
                  style: TextStyle(
                      color: Style.MainTextColor, fontSize: 16.0.sp, fontWeight: FontWeight.bold),))),
                VerticalDivider(
                  color: Style.LightGreyColor, thickness: 2, width: 0,),
                SizedBox(height: 7.0.h, width: 5.0.w,),
                Expanded(child: Center(child: RichText(text: TextSpan(
                    text: Total.toString(),
                    style: TextStyle(
                        color: Style.MainTextColor, fontSize: 16.0.sp, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(text: "  " + Translations.of(context)!.SAR,
                        style: TextStyle(
                            color: Style.MainTextColor, fontSize: 16.0.sp, ),)
                    ])),)),
              ],
            ),)
        ),
        if(widget.obj[0].type == "0")
          Container(
            decoration: Style.BoxDecorationBoxShadowGreyColor,
            padding: EdgeInsets.symmetric(
                vertical: 0.5.h, horizontal: 2.0.w),
            margin: EdgeInsets.symmetric(
                vertical: 2.0.h, horizontal: 5.0.w),
            child: Row(
              children: [
                Expanded(child: Theme(
                  data: Theme.of(context).copyWith(
                      primaryColor: Style.SecondryColor),
                  child: TextFormField(
                      controller: addressController,
                      cursorColor: Style.SecondryColor,
                      style: TextStyle(
                          fontSize: 16.0.sp, color: Style.MainTextColor),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                          prefixIcon: Icon(Icons.home_outlined, size: Style.SizeIcon,
                            color: Style.SecondryColor,),
                          hintText: Translations.of(context)!.address,
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
              ]),),
        Expanded(child: payment(),)
        //Code_resend


      ],
    );
  }

  payment()
  {
     if(PaymentList != null && PaymentList.length>0) {
    return ListView.builder(
        itemCount: PaymentList.length,
        itemBuilder: (context, index) {
          return DataTile(PaymentList[index], index);
        });
     }
    else
    {
      return SizedBox(height: 0,width: 0,);
    }
  }
  DataTile(PaymentModel data, int i) {
    return Column(
      children: [
        Container(
            decoration: Style.BoxDecorationBoxShadowGreyColor,
            margin: EdgeInsets.symmetric(vertical: 1.0.h, horizontal: 5.0.w),
            padding: EdgeInsets.symmetric(vertical: 0.0.h, horizontal: 2.0.w),
            child: IntrinsicHeight(child: Row(
              children: [
                InkWell(
                  onTap: () async {
                    setState(() {

                      if(PaymentList[i].id.toString()=="2") {
                        PaymentList.forEach((element) => element.selected = false);
                        PaymentList[i].selected = true;
                        PaymentId = PaymentList[i].id.toString();
                      }
                    });
                  },
                  child:
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 0.0.h, horizontal: 2.0.w),
                    child: Icon(

                      data.selected! ? Icons.check_circle_rounded : Icons.circle,
                      size: 5.0.h, color: Style.MainColor2,),

                  ),),
                Expanded(child: Text(
                  data.name!,
                  style: TextStyle(
                      color: Style.MainTextColor, fontSize: 16.0.sp, fontWeight: FontWeight.bold),)),
                SizedBox(height: 7.0.h, width: 5.0.w,),
                if(data.icon1 != null)
                  Image(image: AssetImage('lib/assets/' + data.icon1! + '.png'),
                    width: 15.0.w,
                    height: 5.0.h,),
                if(data.icon2 != null)
                  Image(image: AssetImage('lib/assets/' + data.icon2! + '.png'),
                    width: 15.0.w,
                    height: 5.0.h,),
              ],
            ),)
        ),

        if(PaymentList.length - 1 == i)
          InkWell(
              child: Container(
                padding: EdgeInsets.fromLTRB(10.0.w, 0.5.h, 10.0.w, 0.5.h),
                margin: EdgeInsets.fromLTRB(0, 4.0.h, 0, 0),
                decoration: Style.ButtonDecoration,
                child: Text(
                  Translations.of(context)!.Pay,
                  style: TextStyle(color: Colors.white,
                      fontSize: 15.0.sp),

                  textAlign: TextAlign.center,

                ),

              ),
              onTap: () async {
               // if (PaymentId != null && PaymentId.isNotEmpty) {
                 // if (ServiceType != null && ServiceType.isNotEmpty) {
                    SaveOrder();
                 /* }
                  else {
                    await AlertView(
                        context, "error", Translations.of(context)!.Please,
                        Translations.of(context)!.serviceType_Validation);
                  }
                }
                else {
                  await AlertView(
                      context, "error", Translations.of(context)!.Please,
                      Translations.of(context)!.Pay_Validation);
                }*/
              }
          ),
      ],
    );
  }

  Future<void> SaveOrder()
  async {

    showLoading();
    try {
      OrderModel order = new OrderModel();
      setState(() {
        order.status = "underexecute";
        order.customerId = DelegateData.delegateData!.id.toString();
        order.totalCost = Total.toString();
        order.date = getFormatDate(DateTime.now());
        order.inStation = widget.obj[0].type;
        List<DetailsOrderModel> detailsOrder = <DetailsOrderModel>[
        ];
        for (var x in widget.obj) {
          for (var y in x.details.where((element) =>
          element.selected == true).toList()) {
            if (y.selected == true) {
              DetailsOrderModel d = new DetailsOrderModel();
              d.cost = y.price.toString();
              d.productId = y.id.toString();
              d.quantity = y.quantity.toString();
              detailsOrder.add(d);
            }
          }
        }
        order.details = detailsOrder;
        order.address= addressController.text;
        print("order.toJson()");
        print(order.toJson());
      });
      var datar = await AddOrder(context, order);
      if (datar != null && datar.length>0 ) {
        Navigator.pushNamed(context, RatePageRoute,arguments: datar);
      }
    }
    catch(e)
    {
      await AlertView(
          context, "error", Translations.of(context)!.ErrorTitle,
          "Exception : ${e.toString()}");
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