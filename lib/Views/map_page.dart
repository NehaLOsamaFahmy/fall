import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:babco/Api/DataApi.dart';
import 'package:babco/Shared_Data/CompanyData.dart';
import 'package:babco/Shared_Data/ServicesData.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:map_launcher/map_launcher.dart' as map_launcher;
import 'package:sizer/sizer.dart';

import '../Api/Login/LoginApi.dart';
import '../Api/PinApi.dart';
import '../Api/stations_servicesApi.dart';
import '../Constans/Style.dart';
import '../Localization/Translations.dart';
import '../Models/PinDataModel.dart';
import '../Routes/route_constants.dart';
import '../Shared_Data/LocationData.dart';
import '../Shared_View/AlertView.dart';
import '../Shared_View/AppBarView.dart';
import '../Shared_View/DrawerView.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool _isLoading = true;
  LatLng center =  LatLng(24.729093504522194, 46.70469951629638);
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  int selectedMarker=-1;
  List<PinDataModel>? obj = <PinDataModel>[];
  PinDataModel selectedPin= new PinDataModel(-1, "name", "address", "phone", "2", 0, 0, ["https://images.adsttc.com/media/images/5da3/9ead/3312/fd25/b100/00de/large_jpg/stringio.jpg?1571004070",
  ],"mail");
  GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();
    GetData();
  }
  Future<void> GetData() async {
    showLoading();
    try
    {

      obj = await Allstations(context);
      if (obj != null && obj!.length > 0) {
        for (var pin in obj!) {
          Marker marker = Marker(
              markerId: MarkerId(pin.id.toString()),
              position: LatLng(
                  pin.lat,
                  pin.lng
              ),
              onTap: () => _onMarkerTapped(MarkerId(pin.id.toString()), pin),
              icon: await getMarkerIcon("lib/assets/pin_y.png", 60),
              infoWindow: InfoWindow(title: pin.name)
          );

          setState(() {
            markers[MarkerId(pin.id.toString())] = marker;
          });
        }
        setState(() {
          LatLng newlatlang = LatLng(obj![0].lat, obj![0].lng);
          mapController?.animateCamera(
              CameraUpdate.newCameraPosition(
                  CameraPosition(target: newlatlang, zoom: 6)
                //17 is new zoom level
              )
          );
        });
      }
      else {
        await AlertView(
            context, "error", Translations.of(context)!.ErrorTitle,
            Translations.of(context)!.NoData);
      }
    }catch(e)
    {

    }

    hideLoading();
  }


  Future<BitmapDescriptor> getMarkerIcon(String path, int width) async {
    final ByteData data = await rootBundle.load(path);
    final codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width, // 👈 هنا بتتحكمي في الحجم
    );
    final frame = await codec.getNextFrame();
    final byteData = await frame.image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onMarkerTapped(MarkerId markerId,PinDataModel pin) {
    try {
      final Marker? tappedMarker = markers[markerId];
      if (tappedMarker != null) {
        setState(() {
          final MarkerId? previousMarkerId = MarkerId("$selectedMarker");
          if (previousMarkerId != null &&
              markers.containsKey(previousMarkerId)) {
            final Marker? resetOld = markers[previousMarkerId];
            markers[previousMarkerId] = resetOld!;
            getMarkerIcon("lib/assets/pin_y.png", 60).then(
                  (BitmapDescriptor icon) {
                _setMarkerIcon(previousMarkerId, icon);
              },
            );

          }
          selectedMarker = int.parse(markerId.value);
          selectedPin = pin;
          final Marker newMarker = tappedMarker;
          markers[markerId] = newMarker;
          getMarkerIcon("lib/assets/pin_b.png", 90).then(
                (BitmapDescriptor icon) {
              _setMarkerIcon(markerId, icon);
            },
          );
          //markerPosition = null;
        });
      }
    }
    catch(e)
    {
      print("-------------------------------- "+e.toString());
    }
  }

  void _setMarkerIcon(MarkerId markerId, BitmapDescriptor assetIcon) {
    final Marker marker = markers[markerId]!;
    setState(() {
      markers[markerId] = marker.copyWith(
        iconParam: assetIcon,
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBarWithlanguage(
            context, Translations.of(context)!.Home_page),
        drawer: DrawerList(context),
        body:SafeArea(child: LoadingOverlay(
            isLoading: _isLoading,
            opacity: 0.2,
            color: Style.MainColor,
            progressIndicator: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Style.MainColor),),
            child: Stack(children: <Widget>[
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

                        )),


                ],
              ),
              if(selectedPin != null && selectedPin.id != -1)
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
                      child: Row(
                        children: [

                          Expanded(
                            flex: 2,
                            child: InkWell(
                              onTap: (){
                                Navigator.pushNamed(context, serviceRoute,arguments: selectedPin.id.toString());
                              },
                              child: Column(
                              children: [
                                IntrinsicHeight(child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.location_on, color: Style.MainColor,
                                      size: 3.0.h,),
                                    VerticalDivider(width: 5.0.w, color: Style
                                        .LightGreyColor, thickness: 2,),
                                    Expanded(
                                      child:Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                          Text(selectedPin.name! + " - " +
                                              selectedPin.address! ,
                                            style: TextStyle(color: Style.GreyColor, fontSize: 16.0.sp),),
                                          SizedBox(height: 1.5.h,)
                                        ],
                                      ))
                                  ],
                                )),
                                IntrinsicHeight(child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.phone_android,
                                      color: Style.SecondryColor,
                                      size: 3.0.h,),
                                    VerticalDivider(width: 5.0.w, color: Style
                                        .LightGreyColor, thickness: 2,),
                                    Expanded(
                                      child:Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(selectedPin.phone! ,
                                            style: TextStyle(color: Style.GreyColor, fontSize: 16.0.sp),),
                                          SizedBox(height: 1.5.h,)
                                        ],
                                      ) )
                                  ],
                                )),
                                IntrinsicHeight(child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.email_outlined,
                                      color: Style.SecondryColor,
                                      size: 3.0.h,),
                                    VerticalDivider(width: 5.0.w, color: Style
                                        .LightGreyColor, thickness: 2,),
                                    Expanded(
                                      child:
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(selectedPin.mail!,
                                                style: TextStyle(color: Style.GreyColor, fontSize: 16.0.sp),),
                                              SizedBox(height: 1.0.h,)
                                            ],
                                          )
                                   )
                                  ],
                                )),
                                IntrinsicHeight(child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.star_rate, color: Style.MainColor,
                                      size: 3.0.h,),
                                    VerticalDivider(width: 5.0.w, color: Style
                                        .LightGreyColor, thickness: 2,),
                                    Expanded(
                                        child: RatingBar.builder(
                                          ignoreGestures: true,
                                          initialRating: double.parse(
                                              selectedPin.rate!),
                                          minRating: 0,
                                          direction: Axis.horizontal,
                                          allowHalfRating: false,
                                          itemCount: 5,
                                          itemPadding: EdgeInsets.fromLTRB(0.5.w, 0.5.h, 0.5.w, 0),
                                          itemBuilder: (context, _) =>
                                           Icon(
                                            Icons.star,
                                            color: Style.SecondryColor,
                                          ),
                                          itemSize: 2.5.h,
                                          onRatingUpdate: (rating) {
                                            print(rating);
                                          },
                                        ))
                                  ],
                                )),
                              ],
                            ),),),
                          SizedBox(width: 2.0.w,),

                          Expanded(child:Container(child: Column(
                            children: [
                              if(selectedPin.images != null && selectedPin.images!.length>0)
                              Image.network(selectedPin.images[0], height: 10.0.h,width: 55.0.w,),
                              if(selectedPin.images == null || selectedPin.images!.length ==0)
                               Image(image: AssetImage('lib/assets/logo.png'),height: 10.0.h,width: 55.0.w, ),
                              SizedBox(height: 1.0.h,),
                             Location_Button(),
                            ],
                          )))

                        ],
                      ),
                    )
                  ]),

            ]))));
  }

  Location_Button() {
    return  InkWell(child: Container(
      padding: EdgeInsets.fromLTRB(3.0.w, 0.5.h, 3.0.w, 0.5.h),
     // margin: EdgeInsets.fromLTRB(0, 4.0.h, 0, 0),
      decoration: Style.ButtonDecoration,
        child: Text(Translations.of(context)!.Station_location,style: TextStyle(color: Style.WhiteColor, fontSize: 16.0.sp),),
      ),
        onTap: () async {
      showLoading();
          try {
        //     await getLocationData(context);
         //    print(LocationData.currentLocation!.latitude);
          //   print(LocationData.currentLocation!.longitude);
           //  if(LocationData.currentLocation != null && LocationData.currentLocation!.latitude>0 && LocationData.currentLocation!.longitude>0) {
               await map_launcher.MapLauncher.showMarker(
                  mapType: map_launcher.MapType.google,
                  coords: map_launcher.Coords(selectedPin.lat, selectedPin.lng),
                  title: Translations.of(context)!.Station_location,
                  description: "",
                );

            // }
            // else
              // {
                // AlertView(context,"error",Translations.of(context)!.ErrorTitle,Translations.of(context)!.errorLocation);
              // }
             hideLoading();
          } catch (e) {
            print(e);
            AlertView(context,"error",Translations.of(context)!.ErrorTitle,Translations.of(context)!.errorLocation+"/"+e.toString());
            hideLoading();
          }
        },
      );
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