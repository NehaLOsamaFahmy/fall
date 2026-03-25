
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:babco/Models/MaintenanceModel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:sizer/sizer.dart';

import '../Api/MaintenanceApi.dart';
import '../Api/PinApi.dart';
import '../Api/SetvicesApi.dart';
import '../Api/stations_servicesApi.dart';
import '../Constans/Style.dart';
import '../Localization/Translations.dart';
import '../Models/PaymentModel.dart';
import '../Models/PinDataModel.dart';
import '../Models/ServicesModel.dart';
import '../Routes/route_constants.dart';
import '../Shared_Data/ServicesData.dart';
import '../Shared_View/AlertView.dart';
import '../Shared_View/AppBarView.dart';
import '../Shared_View/DrawerView.dart';

class StationTransportationPage extends StatefulWidget {
  StationTransportationPage({ Key? key}) : super(key: key);
  @override
  _StationTransportationPageState createState() => _StationTransportationPageState();
}

class _StationTransportationPageState extends State<StationTransportationPage> {

  bool _isLoading = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  String SelectServices="";
  TextEditingController SelectStation = TextEditingController();
  int SelectServicesId=-1;
  TextEditingController address = TextEditingController();
  String lat="";
  String lng="";
  List<TransportationModel> ServicesList=<TransportationModel>[];
  List<TransportationModel> quantityList=<TransportationModel>[];
  List<TransportationModel> SelectServicesList=<TransportationModel>[];
  String SelectQuantity="";
  int SelectQuantityId=-1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithBack(context, Translations.of(context)!.Transportation),
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
    if (ServicesList != null && ServicesList.length > 0 ) {
      return SingleChildScrollView(
          child:Container(margin: EdgeInsets.symmetric(
          vertical: 1.0.h, horizontal: 3.0.w),
    child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 2.0.h,),

              Container(//margin: EdgeInsets.symmetric(vertical: 0.0.h, horizontal: 5.0.w),
                  child:
              Theme(
                data: Theme.of(context).copyWith(
                    primaryColor: Style.SecondryColor),
                child: TextFormField(
                    controller: nameController,
                    cursorColor: Style.SecondryColor,
                    style: TextStyle(
                        fontSize: 16.0.sp, color: Style.MainTextColor),
                    validator: (value) {},
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person, size: 3.0.h, color: Style.SecondryColor,),
                        hintText: Translations.of(context)!.username,
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
              Container(//margin: EdgeInsets.symmetric(vertical: 0.0.h, horizontal: 5.0.w),
                  child:
              Theme(
                data: Theme.of(context).copyWith(
                    primaryColor: Style.SecondryColor),
                child: TextFormField(
                    controller: phoneController,
                    cursorColor: Style.SecondryColor,
                    style: TextStyle(
                        fontSize: 16.0.sp, color: Style.MainTextColor),
                    validator: (value) {},
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.phone_android, size: 3.0.h,color: Style.SecondryColor,),
                        hintText: Translations.of(context)!.Phone_number,
                        // labelStyle: TextStyle(fontSize: 16.0.sp, color: Style.GreyColor),
                        //  labelText: Translations.of(context)!.Code,
                        hintStyle: TextStyle(fontSize: 16.0.sp,
                          color: Style.GreyColor,),
                        errorStyle: TextStyle(fontSize: 16.0.sp,
                            color:Style.MainTextColor)
                    ),
                    keyboardType: TextInputType.number,
                    onEditingComplete: () {
                      FocusScope.of(context).unfocus();
                    }
                ),)),
              Container(
               //   margin: EdgeInsets.symmetric(vertical: 0.0.h, horizontal: 5.0.w),
                  child:
              Theme(
                data: Theme.of(context).copyWith(
                    primaryColor: Style.SecondryColor),
                child: TextFormField(
                    controller: SelectStation,
                    cursorColor: Style.SecondryColor,
                    style: TextStyle(
                        fontSize: 16.0.sp, color: Style.MainTextColor),
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.local_gas_station, size: 3.0.h,color: Style.SecondryColor,),
                        hintText: Translations.of(context)!.Station_name,
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
              Row(

                children: [

                Expanded(child: Container(//margin: EdgeInsets.symmetric(vertical: 0.0.h, horizontal: 5.0.w),
                  child:
              Theme(
                data: Theme.of(context).copyWith(
                    primaryColor: Style.SecondryColor),
                child: TextFormField(
                    controller: address,
                    cursorColor: Style.SecondryColor,
                    style: TextStyle(
                        fontSize: 16.0.sp, color: Style.MainTextColor),
                    validator: (value) {},
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.location_on, size:3.0.h,color: Style.SecondryColor,),
                        hintText: Translations.of(context)!.Station_address,
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
                ),))),
                  SizedBox(width: 2.0.w,),
                  InkWell(child: Container(
                    padding: EdgeInsets.fromLTRB(3.0.w, 0.5.h, 3.0.w, 0.5.h),
                    margin: EdgeInsets.fromLTRB(0, 2.0.h, 0, 0),
                    decoration: Style.ButtonDecoration,
                    child: Text(Translations.of(context)!.Station_location,style: TextStyle(color: Style.WhiteColor, fontSize: 16.0.sp),),
                  ), onTap: () async {
                    Navigator.pushNamed(context, "MapLocationRoute").then((onValue) {
                      _refreshData();
                    });

                  })
                ]),

              Container(
                 // margin: EdgeInsets.symmetric(vertical: 0.0.h, horizontal: 5.0.w),
                  child:
              Theme(
                data: Theme.of(context).copyWith(
                    primaryColor: Style.SecondryColor),
                child: TextFormField(
                    controller: commentController,
                    cursorColor: Style.SecondryColor,
                    style: TextStyle(
                        fontSize: 16.0.sp, color: Style.MainTextColor),
                    validator: (value) {},
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.sticky_note_2, size:3.0.h,color: Style.SecondryColor,),
                        hintText: Translations.of(context)!.comment,
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
              SizedBox(height: 2.0.h,),
              ChooseGas(),
              SizedBox(height: 2.0.h,),
              SelectedGas(),
              Center(child:InkWell(
                child: Container(
                padding: EdgeInsets.fromLTRB(10.0.w, 0.5.h, 10.0.w, 0.5.h),
                margin: EdgeInsets.fromLTRB(0, 2.0.h, 0, 4.0.h),
                decoration: Style.ButtonDecoration,
                child:  Text(
                      Translations.of(context)!.send,
                      style: TextStyle(color: Colors.white,
                          fontSize: 15.0.sp),
                      textAlign: TextAlign.center,

                    ),),
                    onTap: () async {
                      SaveData();
                    }

              )),


            ],
          )));
    } else {
      return Center(child: Text(Translations.of(context)!.NoData,
        style: Style.MainText14Bold.copyWith(color:Style.MainTextColor),));
    }
  }
  ChooseGas() {
    return  Column(

          children: [
            Container(
                decoration: Style.BoxDecorationBoxShadowGreyColor,
                margin: EdgeInsets.fromLTRB(2.0.w, 0.0.h, 2.0.w, 2.0.h),
                child: IntrinsicHeight(
                    child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Expanded(flex: 3, child:  PopupMenuButton(
                      child:
                      Container(child:
                      Row(
                        children: [
                          Expanded(child: Text(
                            SelectServices, style: Style.MainText14,)),
                          Icon(Icons.arrow_drop_down, color: Style.SecondryColor,
                              size: Style.SizeIcon),
                        ],
                      ),
                        decoration: Style.SecondryColorDecorationNoBoxShadow.copyWith(color: Colors.white),
                        padding: EdgeInsets.symmetric(
                            vertical: 1.0.h, horizontal: 2.0.w),
                        // margin: EdgeInsets.symmetric(vertical: 0.0.h, horizontal: 1.0.w),
                      ),

                      itemBuilder: (context) {
                        return ServicesList.map((TransportationModel choice) {
                          return PopupMenuItem(
                              value: choice,
                              child: Row(
                                children: [
                                  Padding(padding: EdgeInsets.symmetric(
                                      vertical: 0.0.h, horizontal: 1.0.w),),
                                  Expanded(
                                    child: Text(choice.name.toString(),
                                      style: Style.MainText14,),),
                                ],)
                          );
                        }).toList();
                      },
                      onSelected: (TransportationModel value) {
                        setState(() {
                          SelectServices = value.name.toString();
                          SelectServicesId = value.id!;
                        });
                      },
                    ),),

                    SizedBox(width: 2.0.w,),
                    Expanded(flex: 2, child:  PopupMenuButton(
                      child:
                      Container(child:
                      Row(
                        children: [
                          Expanded(child: Text(
                            SelectQuantity, style: Style.MainText14,)),
                          Icon(Icons.arrow_drop_down, color: Style.SecondryColor,
                              size: Style.SizeIcon),
                        ],
                      ),
                        decoration: Style.SecondryColorDecorationNoBoxShadow.copyWith(color: Colors.white),
                        padding: EdgeInsets.symmetric(
                            vertical: 1.0.h, horizontal: 2.0.w),
                        // margin: EdgeInsets.symmetric(vertical: 0.0.h, horizontal: 1.0.w),
                      ),

                      itemBuilder: (context) {
                        return quantityList.map((TransportationModel choice) {
                          return PopupMenuItem(
                              value: choice,
                              child: Row(
                                children: [
                                  Padding(padding: EdgeInsets.symmetric(
                                      vertical: 0.0.h, horizontal: 1.0.w),),
                                  Expanded(
                                    child: Text(choice.name.toString(),
                                      style: Style.MainText14,),),
                                ],)
                          );
                        }).toList();
                      },
                      onSelected: (TransportationModel value) {
                        setState(() {
                          SelectQuantity = value.name.toString();
                          SelectQuantityId = value.id!;
                        });
                      },
                    ),),
                    SizedBox(width: 2.0.w,),
                      Expanded(flex: 2,child: InkWell(
                        onTap: () async {
                          AddData();
                       },
                        child:
                        Container(
                          padding: EdgeInsets.fromLTRB(3.0.w, 0.5.h, 3.0.w, 0.5.h),
                          margin: EdgeInsets.fromLTRB(1.0.w, 0.0.h, 1.0.w, 0),
                          decoration: Style.ButtonDecoration,
                          child: Text(Translations.of(context)!.AddService,style: TextStyle(color: Style.WhiteColor, fontSize: 16.0.sp),),
                        ))),

                  ],
                )))
          ],
        );
  }
  SelectedGas()
  {
    if (SelectServicesList != null && SelectServicesList.length > 0)
      return  Container(
          margin: EdgeInsets.symmetric(vertical: 2.0.h, horizontal: 1.0.w),
          // padding: EdgeInsets.symmetric(vertical: 1.0.h, horizontal: 3.0.w),
          //  decoration: Style.BoxDecorationBoxShadowGreyColor,
          child: ListView.builder(
              itemCount: SelectServicesList.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return _tile(context,SelectServicesList[index], index);
              }));
    else
    return Container();
  }
  _tile(BuildContext context, TransportationModel selectServicesList, int index) {
    return InkWell(
        onTap: () {

        },
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if(index == 0)
                Container(
                  decoration: BoxDecoration(
                    color: Style.BlueColor,
                    border: Border.all(
                        color: Style.LightGreyColor, width: 1),
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(8.0),
                      topRight: const Radius.circular(8.0),
                      //bottomRight: const Radius.circular(8.0),
                      // bottomLeft: const Radius.circular(8.0),
                    ),
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                      Expanded(flex: 1, child:Container()),
                        VerticalDivider(
                          color: Colors.black26,
                        ),
                    SizedBox(height: 3.5.h,),
                        Expanded(flex: 3,
                            child: Center(child: Text(
                              Translations.of(context)!.gasType,
                              style: Style.Secondry12Bold,),)),
                        VerticalDivider(
                          color: Colors.black26,
                        ),
                        Expanded(flex: 3,
                            child: Center(child: Text(
                              Translations.of(context)!.quantity,
                              style: Style.Secondry12Bold,),)),



                      ],
                    ),
                  ),
                ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: Style.LightGreyColor, width: 1),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      SizedBox(height: 3.5.h,),
                  Expanded(flex: 1, child: InkWell(child: Padding(child:  Icon(Icons.highlight_remove,color:Style.MainTextColor,),
                        padding: EdgeInsets.symmetric(vertical: 1.0.h,horizontal: 3.0.w),),
                          onTap: (){
                            setState(() {
                              SelectServicesList.removeWhere((element) =>
                              element.id == selectServicesList.id);
                            });
                          })),
                      VerticalDivider(
                        color: Colors.black26,
                      ),
                      Expanded(flex: 3, child:  Center(child: Text(
                        selectServicesList.name!, style: Style.MainText10,),)),
                      VerticalDivider(
                        color: Colors.black26,
                      ),
                      Expanded(flex: 3, child: Center(child: Text(selectServicesList.quantity!, style: Style.MainText10,),)),


                    ],
                  ),
                ),
              ),


            ]
        ));
  }

  @override
  void initState() {
    super.initState();
    GetData();
  }
  Future<void> GetData() async {
    showLoading();


  //  var obj2 = await GetMaintenanceServices(context);
    List<TransportationModel> obj2= <TransportationModel>[TransportationModel(1, "وقود 90","0"),TransportationModel(2, "وقود 92","0"),TransportationModel(3, "وقود 95","0")];
    if(obj2 != null) {
      setState(() {
        ServicesList = obj2!;
        SelectServices=obj2![0].name!;
        SelectServicesId=obj2![0].id!;
      });
    }

    List<TransportationModel> obj3= <TransportationModel>[TransportationModel(1, "10","0"),TransportationModel(2, "20","0"),TransportationModel(3, "30","0")];
    if(obj3 != null) {
      setState(() {
        quantityList = obj3!;
         SelectQuantity=obj3![0].name!;
         SelectQuantityId=obj3![0].id!;
      });
    }
    hideLoading();
  }

  Future<void> SaveData()
  async {
    TransportationSaveModel transportationSaveModel= TransportationSaveModel(nameController.text, phoneController.text,
        SelectStation.text , address.text, commentController.text,AddressData.lat.toString(),AddressData.lng.toString(), SelectServicesList);
    print(transportationSaveModel.toJson());
    if(SelectServicesList == null ||SelectServicesList.length ==0 ||
        SelectStation.text == null ||SelectStation.text.isEmpty ||address.text==null||address.text.isEmpty||
        nameController.text== null|| nameController.text.isEmpty ||phoneController.text== null|| phoneController.text.isEmpty )
    {
      await AlertView(
          context, "error", Translations.of(context)!.Please,Translations.of(context)!.data_Validation);
    }
    else
    {
      showLoading();
    /*  var res=await SaveMaintenanceServices(context,phoneController.text,SelectStation.text,SelectServicesId,address.text,lat,lng,commentController.text,images_path);
      if(res== true)
        {
          Navigator.pushNamed(context, homeRoute);
        }*/
      hideLoading();
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

  Future<void> AddData() async {
    if(SelectServicesList != null && SelectServicesList.length>0) {

      var x= SelectServicesList.where((element) => element.id==SelectServicesId ).toList();
      print(x.length);
      if(x!= null&&x.length>0) {
        var xx= SelectServicesList.where((element) => element.id==SelectServicesId &&element.quantity==SelectQuantity).toList();
        if(xx!= null&&xx.length>0) {
          await AlertView(
              context, "error", Translations.of(context)!.ErrorTitle,Translations.of(context)!.not_accept);
        }
        else {
          setState(() {
            SelectServicesList.removeWhere((element) =>
            element.id == SelectServicesId);
            SelectServicesList.add(TransportationModel(
                SelectServicesId, SelectServices, SelectQuantity));
          });
        }


      }
      else {
        setState(() {
          SelectServicesList.add(TransportationModel(
              SelectServicesId, SelectServices, SelectQuantity));
        });
      }

    }
    else
      {
        setState(() {
          SelectServicesList.add(TransportationModel(
              SelectServicesId, SelectServices, SelectQuantity));
        });
      }
  }

  void _refreshData() {
    if(AddressData.addressData!= null && AddressData.addressData.length>0)
    {
      setState(() {
        address.text=AddressData.addressData;
        lat=AddressData.lat.toString();
        lng=AddressData.lng.toString();
      });}
  }




}