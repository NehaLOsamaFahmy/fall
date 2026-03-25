import 'package:flutter/material.dart';
import 'package:babco/Routes/route_constants.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:sizer/sizer.dart';
import '../Constans/Style.dart';
import '../Localization/Translations.dart';
import '../Models/ServicesModel.dart';
import '../Shared_Data/ServicesData.dart';
import '../Shared_View/AppBarView.dart';
import '../Shared_View/DrawerView.dart';

class ServicesSelectedPage extends StatefulWidget {
  final  List<ServicesModel> obj;
  ServicesSelectedPage({required this.obj, Key? key}) : super(key: key);
  @override
  _ServicesSelectedPageState createState() => _ServicesSelectedPageState();
}

class _ServicesSelectedPageState extends State<ServicesSelectedPage> {

  bool _isLoading = false;
  double Total=0;

  @override
  void initState() {
    super.initState();
    GetTotal(context);
  }

  void GetTotal(BuildContext context)
  {
    for(var i in widget.obj )
      {
        setState(() {
          var x= i.details.where((element) => element.selected == true).toList();
          if(x != null && x.length>0) {
            Total = Total +
                x.map((expense) => expense.get_total()!)
                    .fold(0, (prev, amount) => prev + amount);
          }
        });
      }
    print("-----");
    print(Total);
    print("-----");

  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBarWithBack(context, Translations.of(context)!.MyServices),
        drawer: DrawerList(context),
        body:SafeArea(child:  LoadingOverlay(
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
    if (widget.obj != null && widget.obj.length > 0) {
      return Container(
          margin: EdgeInsets.symmetric(vertical: 2.0.h, horizontal: 2.0.w),
          child: Column(children: [
            Expanded(child: ListView.builder(
                itemCount: widget.obj.length,
                itemBuilder: (context, index) {
                  return DataTile(
                      widget.obj[index].details.where((element) => element
                          .selected == true).toList(), widget.obj[index], index);
                }),),

          ],)
      );
    }
    else {
      return Center(child: Text(Translations.of(context)!.NoData,
        style: Style.MainText14Bold.copyWith(color:Style.MainTextColor),));
    }
  }

  DataTile(List<ServicesDetailsModel> ServicesDetails,ServicesModel data, int index) {
    // if(ServicesDetails != null && ServicesDetails.length>0) {
    return Column(
      children: [
        for (int i = 0; i < ServicesDetails.length; i++)
          ListData(ServicesDetails[i], data),
        if(index == widget.obj.length - 1)
          Container(
              decoration: Style.SecondryColorDecoration,
              margin: EdgeInsets.symmetric(vertical: 4.0.h, horizontal: 15.0.w),
              padding: EdgeInsets.symmetric(vertical: 0.0.h, horizontal: 5.0.w),
              child: IntrinsicHeight(child: Row(
                children: [
                  Expanded(child: Center(child: Text(
                    Translations.of(context)!.Total,
                    style: Style.MainText14Bold,))),
                  VerticalDivider(
                    color: Style.LightGreyColor, thickness: 2, width: 0,),
                  SizedBox(height: 7.0.h, width: 5.0.w,),
                  Expanded(child: Center(child: RichText(text: TextSpan(
                      text: Total.toString(),
                      style: Style.MainText16Bold,
                      children: [
                        TextSpan(text: "  " + Translations.of(context)!.SAR,
                          style: Style.MainText14,)
                      ])),)),
                ],
              ),)
          ),
        if(index == widget.obj.length - 1)
          InkWell(
              child: Container(
                padding: EdgeInsets.fromLTRB(10.0.w, 0.5.h, 10.0.w, 0.5.h),
                margin: EdgeInsets.fromLTRB(0, 0.0.h, 0, 7.0.h),
                decoration: Style.ButtonDecoration,

                child: Text(
                  Translations.of(context)!.Pay,
                  style: TextStyle(color: Colors.white,
                      fontSize: 15.0.sp),

                  textAlign: TextAlign.center,

                ),

              ),
              onTap: () async {
                for (var i in widget.obj) {
                  var x = i.details.where((element) => element.selected == true).toList();
                  if (x != null && x.length > 0) {
                    print(x.first.name);
                  }
                }
                setState(() {
                  ServicesData.serviceData=widget.obj;
                });
                Navigator.pushNamed(
                    context, PayPageRoute, arguments: widget.obj);
              }
          )

      ],
    );
    /* }
    else
    {
      return SizedBox(height: 0,width: 0,);
    }*/
  }
  ListData(ServicesDetailsModel ServiceDetail,ServicesModel data) {
    if (ServiceDetail != null && ServiceDetail.selected == true) {
      return Container(
          margin: EdgeInsets.symmetric(vertical: 1.0.h, horizontal: 2.0.w),
          decoration: Style.BoxDecorationBoxShadowGreyColor,
          child: Column(
            children: [
              IntrinsicHeight(child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        Total=0;
                        //Count=0;
                      });
                      for(var i in widget.obj ) {

                        setState(() {
                          try {
                            i.details
                                .where((element) =>
                            element.selected == true &&
                                element.id == ServiceDetail.id)
                                .first
                                .selected = false;
                          }
                          catch (e) {}
                          try {
                            Total = Total +
                                i.details.where((element) => element.selected ==
                                    true).toList().map((expense) =>
                                expense.price!).fold(
                                    0, (prev, amount) => prev + amount);
                        //    Count= Count+i.details.where((element) => element.selected == true).toList().length;
                          }
                          catch (e) {}
                        });
                      }
                      ServicesData.serviceData=widget.obj;


                    },
                    child: Icon(Icons.highlight_remove, color:Style.MainTextColor,
                      size: Style.SizeIcon,),
                  ),
                  SizedBox(width: 2.0.w,),
                  Image.network( data.icon! ,
                    width: 15.0.w,
                    height: 8.0.h,),
                  SizedBox(width: 4.0.w,),
                  VerticalDivider(
                    color: Style.LightGreyColor, thickness: 2, width: 0,),

                  Expanded(child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                          padding: EdgeInsets.fromLTRB(3.0.w, 0.0.h, 3.0.w, 0),
                          child: Row(
                            children: [
                              Expanded(flex: 2,child: RichText(text: TextSpan(
                                  text: Translations.of(context)!.ServiceKind + "/ ",
                                  style: Style.SecondryText10.copyWith(color: Style.MainColor),
                                  children: [
                                    TextSpan(text:data.name.toString(),
                                      style: Style.SecondryText10.copyWith(
                                          color:Style.MainTextColor),)
                                  ]))),
                              Expanded(child: Text(
                                Translations.of(context)!.ServicePrice,
                                style: Style.SecondryText10.copyWith(
                                    color:Style.MainTextColor),)),
                            ],
                          )),
                      Divider(
                        color: Style.LightGreyColor, thickness: 2, height: 0,),
                      Row(
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        //mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(flex: 2, child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                  3.0.w, 1.0.h, 3.0.w, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    ServiceDetail.name.toString(),
                                    style: Style.MainText12.copyWith(fontWeight: FontWeight.bold),),
                                  Text(
                                    Translations.of(context)!.quantity +"  "+ServiceDetail.quantity.toString(),
                                    style: Style.MainText12,),
                                  Text(
                                    Translations.of(context)!.ServicePrice +"  "+ServiceDetail.price.toString()+Translations.of(context)!.SAR ,
                                    style: Style.MainText12,)

                                ],
                              )
                          )),

                          Expanded(child: RichText(text: TextSpan(
                              text: ServiceDetail.get_total().toString(),
                              style: Style.MainText16Bold,
                              children: [
                                TextSpan(text: "  "+Translations.of(context)!.SAR,
                                  style: Style.MainText10,)
                              ]))),


                        ],
                      )
                    ],
                  ),)
                ],),),
            ],
          )
      );
    }
    else {
      return SizedBox(height: 0, width: 0,);
    }
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