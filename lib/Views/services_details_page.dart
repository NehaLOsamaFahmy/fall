import 'package:flutter/material.dart';
import 'package:babco/Shared_Data/DelegateData.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:sizer/sizer.dart';

import '../Api/SetvicesApi.dart';
import '../Constans/Style.dart';
import '../Localization/Translations.dart';
import '../Models/ServicesModel.dart';
import '../Routes/route_constants.dart';
import '../Shared_Data/ServicesData.dart';
import '../Shared_View/AlertView.dart';
import '../Shared_View/AppBarView.dart';
import '../Shared_View/DrawerView.dart';

class ServicesDetailsPage extends StatefulWidget {
  List<ServicesModel> obj;
  ServicesDetailsPage({required this.obj, Key? key}) : super(key: key);

  @override
  _ServicesDetailsPageState createState() => _ServicesDetailsPageState();
}

class _ServicesDetailsPageState extends State<ServicesDetailsPage> {
  bool _isLoading = false;
  List<TextEditingController> _controllers = <TextEditingController>[];


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBarWithBack(context, widget.obj.where((element) => element.selected==true).first.name!),
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
                  child: FormUI(),
                )))));
  }
  FormUI() {
  return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(child: Text(widget.obj.where((element) => element.selected==true).first.name!, style: TextStyle(
              color: Style.MainTextColor, fontSize: 16.0.sp, fontWeight: FontWeight.bold),),
            decoration: Style.SecondryColorDecoration,
            margin: EdgeInsets.fromLTRB(3.0.w, 3.0.h, 3.0.w, 0.0.h),
            padding: EdgeInsets.fromLTRB(10.0.w, 0.5.h, 10.0.w, 0.5.h),
          ),
          Center(child: Image.network( widget.obj.where((element) => element.selected==true).first.icon! , width: 25.0.w, height: 15.0.h,),),
          SizedBox(height: 2.0.h,),
          NormalList(),
        ],
      );
  }
  NormalList() {
    return Expanded(child:
       productListView(),
    );
  }
  productListView() {
    if( widget.obj.where((element) => element.selected==true).first.details! != null && widget.obj.where((element) => element.selected==true).first.details.length>0) {
        return new ListView.builder(
            itemCount: widget.obj.where((element) => element.selected==true).first.details.length,
            itemBuilder: (context, index) {
              _controllers.add(new TextEditingController());
              return _tile(widget.obj.where((element) => element.selected==true).first.details[index], index);
            });
    }
    else
    {
      return  Center(child: Text(Translations.of(context)!.NoData,
        style: TextStyle(
            color:Style.MainTextColor, fontSize: 16.0.sp, fontWeight: FontWeight.bold),));
    }
  }
  _tile( ServicesDetailsModel data, int index ) {
    return Container(
        decoration: Style.BoxDecorationBoxShadowGreyColor,
        margin: EdgeInsets.fromLTRB(2.0.w, 0.0.h, 2.0.w, 2.0.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            Expanded(flex: 2,child: Container(
                decoration: Style.SecondryColorDecorationNoBoxShadow,
                //  margin: EdgeInsets.fromLTRB(0.0.w, 0.0.h, 0.0.w, 0.0.h),
                padding: EdgeInsets.fromLTRB(1.0.w, 0.5.h, 1.0.w, 0.5.h),
                child: Center(
                    child: Text(data.name!, style: Style.MainText12,)))),
            Expanded(flex: 2,
                child: Center(child: Text(
                  data.price.toString()! + " " + Translations.of(context)!.SAR,
                  style: Style.MainText12.copyWith(color:Style.MainTextColor),))),
            Expanded(child: TextField(
                textAlignVertical: TextAlignVertical.top,
                textAlign: TextAlign.center,
                cursorColor: Style.MainColor,
                style: Style.MainText10,
                decoration: InputDecoration(
                  hintStyle: Style.MainText10,
                  hintText: Translations.of(context)!.quantity,
                  alignLabelWithHint:true,

                ),
                keyboardType: TextInputType.number,
                controller: _controllers[index],
                onChanged: (String value) async {
                  var res = double.tryParse(value);
                  if (res != null && res > 0) {
                    if(DelegateData.delegateData!= null && DelegateData.delegateData!.id!>0) {
                      setState(() {
                        widget.obj
                            .where((element) => element.selected == true)
                            .first
                            .details[index].selected = true;
                        widget.obj
                            .where((element) => element.selected == true)
                            .first
                            .details[index].quantity = res;
                        ServicesData.serviceData = widget.obj;
                      });
                    }
                    else
                      {
                        await AlertView2(context);
                      }

                  }
                  else{

                      setState(() {
                        widget.obj.where((element) => element.selected==true).first.details[index].selected =false;
                        widget.obj.where((element) => element.selected==true).first.details[index].quantity = 0;
                        ServicesData.serviceData=widget.obj;
                      });

                  }
                }

            ),),
            if( !data.selected!)
              Expanded(flex: 2,child: InkWell(
                onTap: () async {
                  if(widget.obj.where((element) => element.selected==true).first.details[index].quantity! >0) {
                    setState(() {
                      widget.obj
                          .where((element) => element.selected == true)
                          .first
                          .details[index].selected = !data.selected!;
                      ServicesData.serviceData = widget.obj;
                    });
                  }
                  else
                    {
                      if(DelegateData.delegateData!= null && DelegateData.delegateData!.id!>0) {
                        await AlertView(
                            context, "error", Translations.of(context)!.Please,
                            Translations.of(context)!.quantity_Validation);
                      }
                      else
                        {
                          await AlertView2(context);
                        }
                    }

                },
                child:
                Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 0.5.h, horizontal: 0.0.w),
                    margin: EdgeInsets.symmetric(
                        vertical: 0.6.h, horizontal: 3.0.w),
                    decoration: Style.ButtonDecoration,
                    child: Center(
                        child: Text(Translations.of(context)!.AddService,
                          style: Style.Header7,))

                ),)),
            if( data.selected!)
              Expanded(flex: 2,child:
              Row(
                children: [
               Expanded(child:    InkWell(
                    onTap: () async {
                      setState(() {
                        widget.obj.where((element) => element.selected==true).first.details[index].selected = !data.selected!;
                        ServicesData.serviceData=widget.obj;
                      });
                    },
                    child:
                    Container(
                      // padding: EdgeInsets.symmetric(vertical: 1.0.h, horizontal: 2.0.w),
                      child: Icon(

                        data.selected! ? Icons.check_circle_rounded : Icons
                            .circle,
                        size: Style.SizeIconPrint, color: Style.MainColor2,),

                    ),)),
                  InkWell(
                    onTap: () async {
                      if(DelegateData.delegateData!= null && DelegateData.delegateData!.id!>0) {
                        Navigator.pushNamed(context, serviceSelectedPageRoute,
                            arguments: widget.obj).then((onValue) {
                          _refreshData();
                        });
                      }
                      else
                        {
                          await AlertView2(context);
                        }
                    },
                    child:
                    Container(
                      // padding: EdgeInsets.symmetric(vertical: 1.0.h, horizontal: 2.0.w),
                      child: Icon(
                        Icons.arrow_forward,
                        size: Style.SizeIconPrint, color: Style.MainColor2,),

                    ),)
                ],
              )
              ),
          ],
        ));
  }

  void _refreshData()
  {
    print("_refresh------------");
    setState(() {
      widget.obj=ServicesData.serviceData!;
    });
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
