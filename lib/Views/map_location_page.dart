import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:map_launcher/map_launcher.dart' as map_launcher;
//import 'package:map_location_picker/google_map_location_picker.dart';
import 'package:sizer/sizer.dart';

import '../Api/PinApi.dart';
import '../Api/stations_servicesApi.dart';
import '../Constans/Style.dart';
import '../Localization/Translations.dart';
import '../Models/PinDataModel.dart';
import '../Routes/route_constants.dart';
import '../Shared_Data/LocationData.dart';
import '../Shared_Data/ServicesData.dart';
import '../Shared_View/AlertView.dart';
import '../Shared_View/AppBarView.dart';
import '../Shared_View/DrawerView.dart';

class MapLocationScreen extends StatefulWidget {
  const MapLocationScreen({super.key});

  @override
  State<MapLocationScreen> createState() => _MapLocationScreenState();
}

class _MapLocationScreenState extends State<MapLocationScreen> {
  bool _isLoading = false;
  LatLng center =  LatLng(24.729093504522194, 46.70469951629638);
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  GoogleMapController? mapController;
  int count =0;

  @override
  void initState() {
    super.initState();
    GetData();
  }
  void GetData()
  {
    showLoading();
    setState(() {
      AddressData.addressData = "";
      AddressData.lng = 0;
      AddressData.lat = 0;
    });
    hideLoading();
  }

  Future<void> AddData(double lat,double lng) async {
    showLoading();
    setState(() {
      AddressData.addressData = "";
      AddressData.lng = 0;
      AddressData.lat = 0;
    });
    count++;
  //  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
        Marker marker = Marker(
            markerId: MarkerId(count.toString()),
            position: LatLng(
                lat,
                lng
            ),
          icon: await BitmapDescriptor.fromAssetImage(
              ImageConfiguration(), "lib/assets/pin_y.png"),
        );

        setState(() {
          MarkerId id= MarkerId((count-1).toString());
          markers.removeWhere((key, value) => key==id);
          markers[MarkerId(count.toString())] = marker;
          
        });

   // var xx=await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await placemarkFromCoordinates(lat,lng);

    var first = placemarks.first;
    var address=first.street!+","+first.locality!+","+first.subAdministrativeArea!+","+first.administrativeArea!+","+first.country!;
    print(' *******${address}');

    setState(() {
      AddressData.addressData =address;
      AddressData.lng = lng;
      AddressData.lat = lat;
    });
    

    hideLoading();
  }


  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBarWithBack(context, Translations.of(context)!.Transportation),
        drawer: DrawerList(context),
        body: SafeArea(child:LoadingOverlay(
            isLoading: _isLoading,
            opacity: 0.2,
            color: Style.MainColor,
            progressIndicator: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Style.MainColor),),
            child:  Stack(children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  //  if(markers != null && markers.length > 0)
                  Expanded(
                      child: GoogleMap(
                        onMapCreated: (controller) { //method called when map is created
                          setState(() {
                            mapController = controller;
                          });
                        },
                        initialCameraPosition:  CameraPosition(
                          target: center,
                          zoom: 6.0,

                        ),
                        markers: Set<Marker>.of(markers.values),
                        onTap: (v)
                        async {
                          print("*******"+v.longitude.toString());
                          await AddData(v.latitude,v.longitude);
                        },

                      )),
                ],
              ),

                  if(AddressData.addressData != null && AddressData.addressData.length >0)
                    Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                color: Style.WhiteColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(15.0),
                                  topRight: const Radius.circular(15.0),
                                  bottomRight: const Radius.circular(15.0),
                                  bottomLeft: const Radius.circular(15.0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                      color: Style.LightGreyColor.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(7, 7))
                                ]
                            ),
                            margin: EdgeInsets.fromLTRB(8.0.w, 0, 8.0.w, 10.0.h),
                            padding: EdgeInsets.fromLTRB(
                                5.0.w, 2.0.h, 5.0.w, 2.0.h),
                            child: Column(
                              children: [
                                
                                Text(Translations.of(context)!.location_added,style: Style.MainText14,),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                 Expanded(child:  InkWell(child: Container(
                                    padding: EdgeInsets.fromLTRB(3.0.w, 0.5.h, 3.0.w, 0.5.h),
                                     margin: EdgeInsets.fromLTRB(15.0.w, 1.0.h, 15.0.w, 0.0.h),
                                    decoration: Style.ButtonDecoration,
                                    child: Center(child:  Text(Translations.of(context)!.accept,style: TextStyle(color: Style.WhiteColor, fontSize: 16.0.sp),)),
                                  ),
                                      onTap: () async {
                                       Navigator.pop(context);

                                      })),
                                 /* SizedBox(width: 3.0.w,),
                                 Expanded(child:  InkWell(child: Container(
                                    padding: EdgeInsets.fromLTRB(3.0.w, 0.5.h, 3.0.w, 0.5.h),
                                   margin: EdgeInsets.fromLTRB(3.0.w, 1.0.h, 3.0.w, 0.0.h),
                                    decoration: Style.ButtonDecoration.copyWith(gradient: LinearGradient(
                                        begin: Alignment.topRight,
                                        end: Alignment.bottomLeft,
                                        colors: [Colors.red, Colors.deepOrange]),),
                                    child:Center(child:  Text(Translations.of(context)!.cancel,style: TextStyle(color: Style.WhiteColor, fontSize: 16.0.sp),)),
                                  ),
                                      onTap: () async {})),*/
                                ],
                                )

                              ],
                            ),
                          )
                        ]),


            ]))));
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