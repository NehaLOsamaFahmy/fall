
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

class StationMaintenancePage extends StatefulWidget {
  StationMaintenancePage({ Key? key}) : super(key: key);
  @override
  _StationMaintenancePageState createState() => _StationMaintenancePageState();
}

class _StationMaintenancePageState extends State<StationMaintenancePage> {

  bool _isLoading = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  String SelectServices="";
  TextEditingController SelectStation = TextEditingController();
  String SelectServicesId="";
  TextEditingController address = TextEditingController();
  String lat="";
  String lng="";
  List<MaintenanceModel> ServicesList=<MaintenanceModel>[];
 // List<PinDataModel> StationList=<PinDataModel>[];
  List<File> images = <File>[];
  List <String> images_path=<String>[];

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBarWithBack(context, Translations.of(context)!.Station_maintenance),
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
          vertical: 1.0.h, horizontal: 5.0.w),
    child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 2.0.h,),
              Container(margin: EdgeInsets.symmetric(
                  vertical: 1.0.h, horizontal: 5.0.w),
                child: Text(
                  Translations.of(context)!.SelectServices,
                  style: TextStyle(
                      color: Style.MainTextColor, fontSize: 16.0.sp, fontWeight: FontWeight.bold),),),
              Container(margin: EdgeInsets.symmetric(
                  vertical: 0.0.h, horizontal: 5.0.w), child:
              PopupMenuButton(
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
                  decoration: Style.BoxDecorationBoxShadowGreyColor,
                  padding: EdgeInsets.symmetric(
                      vertical: 1.0.h, horizontal: 2.0.w),
                  // margin: EdgeInsets.symmetric(vertical: 0.0.h, horizontal: 1.0.w),
                ),

                itemBuilder: (context) {
                  return ServicesList.map((MaintenanceModel choice) {
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
                onSelected: (MaintenanceModel value) {
                  setState(() {
                    SelectServices = value.name.toString();
                    SelectServicesId = value.id.toString();
                  });
                },
              ),),

              SizedBox(height: 2.0.h,),
              Container(margin: EdgeInsets.symmetric(
                  vertical: 0.0.h, horizontal: 5.0.w), child:
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
              Container(margin: EdgeInsets.symmetric(
                  vertical: 0.0.h, horizontal: 5.0.w), child:
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
                  margin: EdgeInsets.symmetric(
                  vertical: 0.0.h, horizontal: 5.0.w),
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
              Container(margin: EdgeInsets.symmetric(
                  vertical: 0.0.h, horizontal: 5.0.w), child:
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
                ),)),
              SizedBox(height: 2.0.h,),
              Container(
                  decoration: Style.BoxDecorationBoxShadowGreyColor,
                  padding: EdgeInsets.symmetric(
                      vertical: 0.5.h, horizontal: 2.0.w),
                  margin: EdgeInsets.symmetric(
                      vertical: 0.5.h, horizontal: 5.0.w),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                        primaryColor: Style.SecondryColor),
                    child: TextFormField(
                        maxLines: 5,
                        controller: commentController,
                        cursorColor: Style.SecondryColor,
                        style: TextStyle(
                            fontSize: 16.0.sp, color: Style.MainTextColor),
                        decoration: InputDecoration(
                            border: InputBorder.none,
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
              Add_photos(),
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


  @override
  void initState() {
    super.initState();
    GetData();
  }
  Future<void> GetData() async {
    showLoading();

   /* var obj = await Allstations(context);
    if(obj != null) {
      setState(() {
        StationList = obj!;
      });
    }*/
    var obj2 = await GetMaintenanceServices(context);
    if(obj2 != null) {
      setState(() {
        ServicesList = obj2!;
      });
    }
    hideLoading();
  }

  Future<void> SaveData()
  async {
    if(SelectServicesId == null ||SelectServicesId.isEmpty )
      {
        await AlertView(
            context, "error", Translations.of(context)!.Please,Translations.of(context)!.SelectServices);
      }
    else if(SelectStation.text == null ||SelectStation.text.isEmpty ||address.text==null||address.text.isEmpty )
    {
      await AlertView(
          context, "error", Translations.of(context)!.Please,Translations.of(context)!.SelectStation);
    }
    else if(nameController.text== null|| nameController.text.isEmpty )
    {
      await AlertView(
          context, "error", Translations.of(context)!.Please,Translations.of(context)!.not_valid_username);
    }
    else if(phoneController.text== null|| phoneController.text.isEmpty )
    {
      await AlertView(
          context, "error", Translations.of(context)!.Please,Translations.of(context)!.Phone_number_Validation);
    }
    else
    {
      showLoading();
      var res=await SaveMaintenanceServices(context,phoneController.text,SelectStation.text,SelectServicesId,address.text,lat,lng,commentController.text,images_path);
      if(res== true)
        {
          Navigator.pushNamed(context, homeRoute);
        }
      hideLoading();
    }
  }
  Add_photos() {
    return InkWell(
        onTap: () {
          pickImages();
        },
        child: Container(
            decoration: Style.BoxDecorationBoxShadowGreyColor,
            padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 2.0.w),
            margin: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 5.0.w),
            child: Row(
              children: [

                // SizedBox(width: SizeConfig.screenWidth * s10,),
                Expanded(
                    child: Container(
                        height:  7.0.h,
                        width: 50.0.w,
                        child: Column(
                          //crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [

                              if(images != null && images.length > 0)
                                Expanded(child: MainCategoryShape(images[images.length - 1])

                                ),
                              if(images == null || images.length == 0 )
                                Expanded(child: Center(child:  Text(Translations.of(context)!.add_photo,style: Style.GreyText12,),))
                            ]))),

                Image.asset("lib/assets/add.png", width: 10.0.w,
                  height: 5.0.h,)

              ],

            )));
  }

  MainCategoryShape(_imageFileList)
  {
    return Container(
        margin: const EdgeInsets.fromLTRB(10,0,10,0),
        child: Stack(
          children: [
            /*  AssetThumb(
              width: (10.0.w).toInt(),
              height: (10.0.h).toInt(),
              asset: asset,
            ),*/
            Image.file(File(_imageFileList.path),),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                child: Icon(Icons.close,color:Style.MainTextColor,),
                onTap: (){
                  setState(() {
                    images.remove(_imageFileList);
                  });

                },
              ),
            ),
          ],
        )
    );

  }

  Future<void> pickImages() async {
    try {
      showLoading();
      ImagePicker _picker = ImagePicker();
      images_path = <String>[];
      images= <File>[];
      // Pick multiple images
      XFile? resultList = await _picker.pickImage(source: ImageSource.gallery);
      print(resultList!.path);
    //  for (var item in resultList) {
        var compress_File = await compressFile(File(resultList!.path));
        setState(() {
          print("&&&&");
          print(compress_File!.path);
          images.add(File(compress_File!.path));
          images_path.add(compress_File.path);
        });
    //  }
      hideLoading();
    }
    catch (e) {
      hideLoading();
      print("************* "+e.toString());
    }
  }
  Future<XFile?> compressFile(File file) async {
    final filePath = file.absolute.path;
    final lastIndex = filePath.lastIndexOf('.');
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out_${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}${filePath.substring(lastIndex)}";
    print("6666666 "+outPath);
    print(filePath.substring(lastIndex).toString());
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path, outPath,
      quality: 25,
      format: filePath.substring(lastIndex).toString().contains("png")?CompressFormat.png:CompressFormat.jpeg
    );
    print('before');
    print(file.lengthSync());
    print(file.path);
    print(file.absolute.path);
    print('after');
    // print(result.lengthSync());
    //print(result.absolute.path);
    return result;
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