
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:sizer/sizer.dart';

import '../Api/CustomersClaimApi.dart';
import '../Api/SetvicesApi.dart';
import '../Constans/Style.dart';
import '../Localization/Translations.dart';
import '../Models/PaymentModel.dart';
import '../Models/ServicesModel.dart';
import '../Routes/route_constants.dart';
import '../Shared_Data/ServicesData.dart';
import '../Shared_View/AppBarView.dart';
import '../Shared_View/DrawerView.dart';

class ClientServicePage extends StatefulWidget {
  ClientServicePage({ Key? key}) : super(key: key);
  @override
  _ClientServicePageState createState() => _ClientServicePageState();
}

class _ClientServicePageState extends State<ClientServicePage> {
  bool _isLoading = false;
  List<ServicesModel> data = <ServicesModel>[];
  List<ServicesModel> FilterDataList = <ServicesModel>[];
  TextEditingController searchText = new TextEditingController();

  @override
  void initState() {
    super.initState();
    GetData(context);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBarWithBack(context, Translations.of(context)!.serviceType2),
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
                  child: FormUI(),
                )))));
  }

  FormUI() {
    if (data != null && data.length > 0) {
      return Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 5.0.h),
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  mainAxisExtent: 20.0.h,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10.0.w,
                  mainAxisSpacing: 4.0.h),
              itemCount: data.length,
              itemBuilder: (BuildContext ctx, index) {
                return InkWell(
                    onTap: () {
                      setState(() {
                        data.forEach((element) => element.selected = false);
                        data[index].selected = true;
                        data.forEach((element) => element.type = "0");

                        ServicesData.serviceData = data;

                      });
                      Navigator.pushNamed(context, serviceDetailsRoute, arguments: data);
                    },
                    child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Style.WhiteColor,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(15.0),
                              topRight: const Radius.circular(15.0),
                              bottomRight: const Radius.circular(15.0),
                              bottomLeft: const Radius.circular(15.0),
                            ),
                            border: data[index].selected! ? Border.all(
                                color: Style.MainColor) : Border.all(
                                color: Style.LightGreyColor),
                            boxShadow: [BoxShadow(
                                color: Style.LightGreyColor.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(7, 7))
                            ]
                        ),
                        child: Column(children: [
                          Text(data[index].name!, style: Style.MainText14Bold,),
                          Expanded(child: Image.network(data[index].icon!),)
                          /* Expanded(
                            child: Image(image: AssetImage('lib/assets/' +
                                data[index].icon! + '.png'),
                              width: 25.0.w,
                              height: 10.0.h,),)*/
                        ],)
                    ));
              }));
    } else {
      return Center(child: Text(Translations.of(context)!.NoData,
        style: Style.MainText14Bold.copyWith(color:Style.MainTextColor),));
    }
  }

  Future<void> GetData(BuildContext context) async {
    showLoading();
    var Services = await GetAllServices(context,"");
    if (Services != null) {
      setState(() {
        data = Services!;
        ServicesData.serviceData = data;
      });
    }
    hideLoading();
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