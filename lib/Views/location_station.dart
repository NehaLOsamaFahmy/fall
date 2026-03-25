import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:sizer/sizer.dart';

import '../Api/DataApi.dart';
import '../Api/PinApi.dart';
import '../Api/stations_servicesApi.dart';
import '../Constans/Style.dart';
import '../Localization/Translations.dart';
import '../Models/LineChartModel.dart';
import '../Models/PinDataModel.dart';
import '../Routes/route_constants.dart';
import '../Shared_Data/LanguageData.dart';
import '../Shared_View/AlertView.dart';
import '../Shared_View/AppBarView.dart';
import '../Shared_View/DrawerView.dart';

class MapLocationStationScreen extends StatefulWidget {
  const MapLocationStationScreen({super.key});

  @override
  State<MapLocationStationScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapLocationStationScreen> {
  bool _isLoading = true;
  static const LatLng center =  LatLng(24.729093504522194, 46.70469951629638);
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  int selectedMarker=-1;
  List<PinDataModel>? Allobj = <PinDataModel>[];
  List<PinDataModel>? obj = <PinDataModel>[];
  PinDataModel selectedPin= new PinDataModel(-1, "name", "address", "phone", "2", 0, 0, ["https://images.adsttc.com/media/images/5da3/9ead/3312/fd25/b100/00de/large_jpg/stringio.jpg?1571004070",
  ],"mail");
  CityModel SelectCityData= new CityModel(-1, "","");
  List<CityModel> Citydata=<CityModel>[];
  CityModel SelectCountryData= new CityModel(-1, "","");
  List<CityModel> CountryData=<CityModel>[];
  GoogleMapController? mapController;



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    DataFun();
  }
  @override
  void initState() {
    super.initState();
    GetData("-1","-1");
  }

  void DataFun()async {
    var d = await GetCity(context);
    setState(()  {

      if(d != null && d.length>0)
        {
          CountryData=d;
        }
      else
        {
          CountryData= <CityModel>[];
        }
      Citydata = <CityModel>[];
      SelectCountryData = CityModel(-1, Translations.of(context)!.choose_Country,Translations.of(context)!.choose_Country);
      SelectCityData = CityModel(-1, Translations.of(context)!.choose_City,Translations.of(context)!.choose_City);
    });
  }
  Future<void> GetData(String country_id,String city_id) async {
  print(country_id);
  print(city_id);
    showLoading();
    setState(() {
       markers = <MarkerId, Marker>{};
       selectedMarker=-1;
       selectedPin= new PinDataModel(-1, "name", "address", "phone", "2", 0, 0, ["https://images.adsttc.com/media/images/5da3/9ead/3312/fd25/b100/00de/large_jpg/stringio.jpg?1571004070",
      ],"mail");
    });
    if(country_id=="-1"&&city_id=="-1") {
      obj = await Allstations(context);
      setState(() {
        Allobj = obj;
      });
      if (obj != null && obj!.length > 0) {
        for (var pin in obj!) {
          Marker marker = Marker(
              markerId: MarkerId(pin.id.toString()),
              position: LatLng(
                  pin.lat,
                  pin.lng
              ),
              onTap: () => _onMarkerTapped(MarkerId(pin.id.toString()), pin),
              icon: await BitmapDescriptor.fromAssetImage(
                  ImageConfiguration(), "lib/assets/pin_y.png"),
              infoWindow: InfoWindow(title: pin.name)
          );

          setState(() {
            markers[MarkerId(pin.id.toString())] = marker;
          });
          setState(() {
            LatLng newlatlang = LatLng(obj![0].lat,obj![0].lng);
            mapController?.animateCamera(
                CameraUpdate.newCameraPosition(
                    CameraPosition(target: newlatlang, zoom: 6)
                  //17 is new zoom level
                )
            );
          });
        }
      }
      else {
        await AlertView(
            context, "error", Translations.of(context)!.ErrorTitle,
            Translations.of(context)!.NoData);
      }
    }
    else if(country_id !="-1"&&city_id=="-1"){
      if (Allobj != null && Allobj!.length > 0) {
        obj = Allobj!.where((element) => element.cityId == country_id ).toList();
        if (obj != null && obj!.length > 0) {
          for (var pin in obj!) {
            Marker marker = Marker(
                markerId: MarkerId(pin.id.toString()),
                position: LatLng(
                    pin.lat,
                    pin.lng
                ),
                onTap: () =>
                    _onMarkerTapped(MarkerId(pin.id.toString()), pin),
                icon: await BitmapDescriptor.fromAssetImage(
                    ImageConfiguration(), "lib/assets/pin_y.png"),
                infoWindow: InfoWindow(title: pin.name)
            );

            setState(() {
              markers[MarkerId(pin.id.toString())] = marker;
            });
            setState(() {
              LatLng newlatlang = LatLng(obj![0].lat,obj![0].lng);
              mapController?.animateCamera(
                  CameraUpdate.newCameraPosition(
                      CameraPosition(target: newlatlang, zoom: 10)
                    //17 is new zoom level
                  )
              );
            });
          }
        }
        else {
          await AlertView(
              context, "error", Translations.of(context)!.ErrorTitle,
              Translations.of(context)!.NoData);
        }
      }
      else {
        await AlertView(
            context, "error", Translations.of(context)!.ErrorTitle,
            Translations.of(context)!.NoData);
      }

    }
    else
      {
        if (Allobj != null && Allobj!.length > 0) {
          obj = Allobj!.where((element) => element.cityId == country_id &&
              element.neighborhoodId == city_id).toList();
          if (obj != null && obj!.length > 0) {
            for (var pin in obj!) {
              Marker marker = Marker(
                  markerId: MarkerId(pin.id.toString()),
                  position: LatLng(
                      pin.lat,
                      pin.lng
                  ),
                  onTap: () =>
                      _onMarkerTapped(MarkerId(pin.id.toString()), pin),
                  icon: await BitmapDescriptor.fromAssetImage(
                      ImageConfiguration(), "lib/assets/pin_y.png"),
                  infoWindow: InfoWindow(title: pin.name)
              );

              setState(() {
                markers[MarkerId(pin.id.toString())] = marker;
              });
              setState(() {
                LatLng newlatlang = LatLng(obj![0].lat,obj![0].lng);
                mapController?.animateCamera(
                    CameraUpdate.newCameraPosition(
                        CameraPosition(target: newlatlang, zoom: 10)
                      //17 is new zoom level
                    )
                );
              });
            }
          }
          else {
            await AlertView(
                context, "error", Translations.of(context)!.ErrorTitle,
                Translations.of(context)!.NoData);
          }
        }
        else {
          await AlertView(
              context, "error", Translations.of(context)!.ErrorTitle,
              Translations.of(context)!.NoData);
        }

      }
    hideLoading();
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
            _getAssetIcon(context, "pin_y").then(
                  (BitmapDescriptor icon) {
                _setMarkerIcon(previousMarkerId, icon);
              },
            );
          }
          selectedMarker = int.parse(markerId.value);
          selectedPin = pin;
          final Marker newMarker = tappedMarker;
          markers[markerId] = newMarker;
          _getAssetIcon(context, "pin_b").then(
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

  Future<BitmapDescriptor> _getAssetIcon(BuildContext context,String _AssetImage) async {
    final Completer<BitmapDescriptor> bitmapIcon =
    Completer<BitmapDescriptor>();
    final ImageConfiguration config = createLocalImageConfiguration(context);

    AssetImage('lib/assets/'+_AssetImage+'.png')
        .resolve(config)
        .addListener(ImageStreamListener((ImageInfo image, bool sync) async {
      final ByteData? bytes =
      await image.image.toByteData(format: ImageByteFormat.png);
      if (bytes == null) {
        bitmapIcon.completeError(Exception('Unable to encode icon'));
        return;
      }
      final BitmapDescriptor bitmap =
      BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
      bitmapIcon.complete(bitmap);
    }));

    return await bitmapIcon.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithlanguage(
            context, Translations.of(context)!.Station_locations),
        drawer: DrawerList(context),
        body: SafeArea(child:LoadingOverlay(
            isLoading: _isLoading,
            opacity: 0.2,
            color: Style.MainColor,
            progressIndicator: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Style.MainColor),),
            child: Stack(children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                      decoration: Style.BoxDecorationBoxShadowGreyColor,
                      padding: EdgeInsets.symmetric(
                          vertical: 2.0.h, horizontal: 2.0.w),
                      //margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0.w),
                      child:  Row(
                    children: [
                   Expanded(child:    Container(
                          decoration: Style.BoxDecorationBoxShadowGreyColor,
                          padding: EdgeInsets.symmetric(
                              vertical: 0.5.h, horizontal: 2.0.w),
                          margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 2.0.w),
                          child:   PopupMenuButton(
                            child:
                            Container(margin: EdgeInsets.symmetric(
                                vertical: 0.0.h, horizontal: 0.0.w),child:
                            Row(
                              children: [
                                Expanded(child:Center(child:  Text(LanguageData.languageData=="ar"?SelectCountryData.nameAr!:SelectCountryData.nameEn!, style: Style.MainText12,))),
                                Icon(Icons.arrow_drop_down,
                                    color: Style.SecondryColor,
                                    size: 2.5.h),
                              ],
                            ),
                            ),

                            itemBuilder: (context) {
                              return CountryData.map((CityModel choice) {
                                return PopupMenuItem(
                                    value: choice,
                                    child: Row(
                                      children: [
                                        Padding(padding: EdgeInsets.symmetric(
                                            vertical: 0.0.h,
                                            horizontal: 1.0.w),),
                                        Expanded(
                                          child: Text(LanguageData.languageData=="ar"?choice.nameAr!:choice.nameEn!,
                                            style: Style.MainText14,),),
                                      ],)
                                );
                              }).toList();
                            },
                            onSelected: (CityModel value) async {
                              setState(()  {
                                SelectCountryData = value;
                                SelectCityData=CityModel(-1,Translations.of(context)!.choose_City,
                                    Translations.of(context)!.choose_City);
                              });
                              GetData(SelectCountryData.id.toString(), SelectCityData.id.toString());
                              showLoading();
                              var d = await GetNeighborhoods(context, value.id.toString());
                              hideLoading();
                              setState(()  {
                                if(d != null && d.length>0)
                                {
                                  Citydata=d;
                                }
                                else
                                {
                                  Citydata= <CityModel>[];
                                }

                              });

                            },
                          ))),
                      Expanded(child:     Container(
                          decoration: Style.BoxDecorationBoxShadowGreyColor,
                          padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 2.0.w),
                          margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 2.0.w),
                          child:   PopupMenuButton(
                            child:
                            Container(margin: EdgeInsets.symmetric(
                                vertical: 0.0.h, horizontal: 0.0.w),child:
                            Row(
                              children: [
                                Expanded(child:Center(child:  Text(LanguageData.languageData=="ar"?SelectCityData.nameAr!:SelectCityData.nameEn!, style: Style.MainText12,))),
                                Icon(Icons.arrow_drop_down,
                                    color: Style.SecondryColor,
                                    size: 2.5.h),
                              ],
                            ),
                            ),

                            itemBuilder: (context) {
                              return Citydata.map((CityModel choice) {
                                return PopupMenuItem(
                                    value: choice,
                                    child: Row(
                                      children: [
                                        Padding(padding: EdgeInsets.symmetric(
                                            vertical: 0.0.h,
                                            horizontal: 1.0.w),),
                                        Expanded(
                                          child: Text(LanguageData.languageData=="ar"?choice.nameAr!:choice.nameEn!,
                                            style: Style.MainText14,),),
                                      ],)
                                );
                              }).toList();
                            },
                            onSelected: (CityModel value) {
                              setState(() {
                                SelectCityData = value;
                                GetData(SelectCountryData.id.toString(),SelectCityData.id.toString());
                              });
                            },
                          )))
                    ],
                  ),),
               //   if(markers != null && markers.length > 0)
                    Expanded(
                        child: GoogleMap(
                          onMapCreated: (controller) { //method called when map is created
                            setState(() {
                              mapController = controller;
                            });
                          },
                          initialCameraPosition: const CameraPosition(
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
                            if(selectedPin.images != null && selectedPin.images!.length>0)
                              Expanded(child: Image.network(selectedPin.images[0])),
                            if(selectedPin.images == null || selectedPin.images!.length ==0)
                              Expanded(child: Image(image: AssetImage('lib/assets/logo.png'), ),)
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