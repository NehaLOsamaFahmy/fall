import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:babco/Shared_View/AnimatedButton.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:sizer/sizer.dart';
import '../Api/DataApi.dart';
import '../Api/PinApi.dart';
import '../Api/stations_servicesApi.dart';
import '../Constans/Style.dart';
import '../Localization/Translations.dart';
import '../Models/LineChartModel.dart';
import '../Models/PinDataModel.dart';
import '../Models/RegionModel.dart';
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
  CitiesModel SelectCityData= new CitiesModel(id:-1,nameAr:  "",nameEn: "");
  List<CitiesModel> Citydata=<CitiesModel>[];
  RegionModel SelectCountryData= new RegionModel(id:-1,nameAr:  "",nameEn: "",cities: []);
  List<RegionModel> CountryData=<RegionModel>[];
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
    var d = await GetRegion(context);
    setState(()  {

      if(d != null && d.length>0)
      {
        CountryData=d;
      }
      else
      {
        CountryData= <RegionModel>[];
      }
      Citydata = <CitiesModel>[];
      SelectCountryData = RegionModel( id:-1,
          nameAr: " اختر منطقه ",
          nameEn: "choose region"  ,cities: []);
      SelectCityData = CitiesModel(id:-1,
        nameAr: " اختر مدينه ",
        nameEn: "choose city"  ,);
    });
  }
  Future<void>  LocationFun(double mapLatitude, double mapLongitude,String title) async {
    try {
      if (mapLongitude != null && mapLatitude != null) {
        await MapsLauncher.launchCoordinates(mapLatitude, mapLongitude,title);
      }
      else {
        AlertView(context, "error",  Translations.of(context)!.ErrorTitle,
            Translations.of(context)!.ErrorDes);
      }
    } catch (e) {
      print(e);
    }
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
              icon: await _getAssetIcon(context, "gas_station_pin"),
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
        obj = Allobj!.where((element) =>
        element.region_id == country_id ).toList();
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
                icon: await _getAssetIcon(context, "gas_station_pin"),
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
        obj = Allobj!.where((element) =>
        element.region_id == country_id &&
            element.cityId == city_id).toList();
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
                icon: await _getAssetIcon(context, "gas_station_pin"),
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

  void _onMarkerTapped(MarkerId markerId, PinDataModel pin) async {
    try {
      /// لو ضغط على نفس الـ Marker مرة تانية
      if (selectedMarker == int.parse(markerId.value)) {
        await _getAssetIcon(context, "gas_station_pin").then((icon) {
          _setMarkerIcon(markerId, icon);
        });

        setState(() {
          selectedMarker = -1;
          selectedPin = PinDataModel(
            -1,
            "name",
            "address",
            "phone",
            "2",
            0,
            0,
            [
              "https://images.adsttc.com/media/images/5da3/9ead/3312/fd25/b100/00de/large_jpg/stringio.jpg?1571004070"
            ],
            "mail",
          );
        });

        return;
      }

      /// رجع الـ Marker القديم للونه الأصفر
      if (selectedMarker != -1) {
        MarkerId previousMarkerId = MarkerId(selectedMarker.toString());

        if (markers.containsKey(previousMarkerId)) {
          await _getAssetIcon(context, "gas_station_pin").then((icon) {
            _setMarkerIcon(previousMarkerId, icon);
          });
        }
      }

      /// لون الـ Marker الجديد أزرق
      await _getAssetIcon(context, "gas_station_selected").then((icon) {
        _setMarkerIcon(markerId, icon);
      });

      setState(() {
        selectedMarker = int.parse(markerId.value);
        selectedPin = pin;
      });
    } catch (e) {
      debugPrint(e.toString());
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

  Future<BitmapDescriptor> _getAssetIcon(
      BuildContext context,
      String assetName,
      ) async {
    final ByteData data =
    await DefaultAssetBundle.of(context).load('lib/assets/$assetName.png');

    final Codec codec = await instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: 200,   // جربي 60 أو 70 أو 80
      targetHeight: 200,
    );

    final FrameInfo fi = await codec.getNextFrame();

    final ByteData? bytes =
    await fi.image.toByteData(format: ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithlanguage(
            context, Translations.of(context)!.Station_locations),
        drawer: DrawerList(context),
        body: SafeArea(child: LoadingOverlay(
            isLoading: _isLoading,
            opacity: 0.2,
            color: Style.MainColor,
            progressIndicator: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Style.MainColor),),
            child: Stack(
              children: [

                /// الخريطة تملأ الشاشة
                Positioned.fill(
                  child: GoogleMap(
                    onMapCreated: (controller) {
                      mapController = controller;
                    },
                    initialCameraPosition: const CameraPosition(
                      target: center,
                      zoom: 6,
                    ),
                    markers: Set<Marker>.of(markers.values),
                  ),
                ),

                /// Dropdown فوق الخريطة
                Positioned(
                  top: MediaQuery
                      .of(context)
                      .padding
                      .top + 10,
                  left: 10,
                  right: 10,
                  child: Container(
                    decoration: Style.BoxDecorationBoxShadowGreyColor,
                    padding: EdgeInsets.symmetric(
                      vertical: 2.h,
                      horizontal: 2.w,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 1.5.w),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<RegionModel>(
                                isExpanded: true,
                                value: SelectCountryData.id == -1
                                    ? null
                                    : SelectCountryData,
                                hint: Center(
                                  child: Text(
                                    Translations.of(context)!.choose_Country,
                                    style: Style.MainText12,
                                  ),
                                ),
                                items: CountryData.map((item) {
                                  return DropdownMenuItem<RegionModel>(
                                    value: item,
                                    child: Text(
                                      LanguageData.languageData == "ar"
                                          ? item.nameAr!
                                          : item.nameEn!,
                                      style: Style.MainText14,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    SelectCountryData = value!;
                                    Citydata = value.cities ?? [];

                                    SelectCityData = CitiesModel(
                                      id: -1,
                                      nameAr: "اختر مدينة",
                                      nameEn: "Select City",
                                    );
                                  });

                                  GetData(
                                    SelectCountryData.id.toString(),
                                    SelectCityData.id.toString(),
                                  );
                                },
                                buttonStyleData: ButtonStyleData(
                                  height: 45,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: Style
                                      .BoxDecorationBoxShadowGreyColor,
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  maxHeight: 250,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                iconStyleData: IconStyleData(
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Style.SecondryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 1.5.w),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<CitiesModel>(
                                isExpanded: true,
                                value: SelectCityData.id == -1
                                    ? null
                                    : SelectCityData,
                                hint: Center(
                                  child: Text(
                                    Translations.of(context)!.choose_City,
                                    style: Style.MainText12,
                                  ),
                                ),
                                items: Citydata.map((item) {
                                  return DropdownMenuItem<CitiesModel>(
                                    value: item,
                                    child: Text(
                                      LanguageData.languageData == "ar"
                                          ? item.nameAr!
                                          : item.nameEn!,
                                      style: Style.MainText14,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    SelectCityData = value!;
                                  });

                                  GetData(
                                    SelectCountryData.id.toString(),
                                    SelectCityData.id.toString(),
                                  );
                                },
                                buttonStyleData: ButtonStyleData(
                                  height: 45,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: Style
                                      .BoxDecorationBoxShadowGreyColor,
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  maxHeight: 250,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                iconStyleData: IconStyleData(
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Style.SecondryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (SelectCountryData.id != -1 ||
                            SelectCityData.id != -1)
                          IconButton(
                            icon: Icon(
                              Icons.delete_forever_sharp,
                              color: Colors.red,
                              size: 2.5.h,
                            ),
                            onPressed: () {
                              // الكود الحالي
                            },
                          ),
                      ],
                    ),
                  ),
                ),

                /// Card بتاعة الـ Marker
                if(selectedPin != null && selectedPin.id != -1)
                  Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Stack(
                            children: [
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
                                          color: Style.LightGreyColor
                                              .withOpacity(0.3),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: Offset(7, 7))
                                    ]
                                ),
                                margin: EdgeInsets.fromLTRB(
                                    8.0.w, 0, 8.0.w, 10.0.h),
                                padding: EdgeInsets.fromLTRB(
                                    5.0.w, 2.0.h, 5.0.w, 2.0.h),
                                child: Row(
                                  children: [

                                    Expanded(
                                      flex: 2,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, serviceRoute,
                                              arguments: selectedPin.id
                                                  .toString());
                                        },
                                        child: Column(
                                          children: [
                                            IntrinsicHeight(child: Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .start,
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Icon(
                                                  Icons.location_on,
                                                  color: Style.MainColor,
                                                  size: 3.0.h,),
                                                VerticalDivider(
                                                  width: 5.0.w,
                                                  color: Style
                                                      .LightGreyColor,
                                                  thickness: 2,),
                                                Expanded(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .start,
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .start,
                                                      children: [

                                                        Text(selectedPin.name! +
                                                            " - " +
                                                            selectedPin
                                                                .address!,
                                                          style: TextStyle(
                                                              color: Style
                                                                  .GreyColor,
                                                              fontSize: 16.0
                                                                  .sp),),
                                                        SizedBox(height: 1.5.h,)
                                                      ],
                                                    ))
                                              ],
                                            )),
                                            IntrinsicHeight(child: Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .start,
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Icon(
                                                  Icons.phone_android,
                                                  color: Style.SecondryColor,
                                                  size: 3.0.h,),
                                                VerticalDivider(
                                                  width: 5.0.w,
                                                  color: Style
                                                      .LightGreyColor,
                                                  thickness: 2,),
                                                Expanded(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .start,
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Text(selectedPin.phone!,
                                                          style: TextStyle(
                                                              color: Style
                                                                  .GreyColor,
                                                              fontSize: 16.0
                                                                  .sp),),
                                                        SizedBox(height: 1.5.h,)
                                                      ],
                                                    ))
                                              ],
                                            )),
                                            IntrinsicHeight(child: Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .start,
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Icon(
                                                  Icons.email_outlined,
                                                  color: Style.SecondryColor,
                                                  size: 3.0.h,),
                                                VerticalDivider(
                                                  width: 5.0.w,
                                                  color: Style
                                                      .LightGreyColor,
                                                  thickness: 2,),
                                                Expanded(
                                                    child:
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .start,
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Text(selectedPin.mail!,
                                                          style: TextStyle(
                                                              color: Style
                                                                  .GreyColor,
                                                              fontSize: 16.0.sp),),
                                                        SizedBox(height: 1.0.h,)
                                                      ],
                                                    )
                                                )
                                              ],
                                            )),
                                            IntrinsicHeight(child: Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .start,
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Icon(
                                                  Icons.star_rate,
                                                  color: Style.MainColor,
                                                  size: 3.0.h,),
                                                VerticalDivider(
                                                  width: 5.0.w,
                                                  color: Style
                                                      .LightGreyColor,
                                                  thickness: 2,),
                                                Expanded(
                                                    child: RatingBar.builder(
                                                      ignoreGestures: true,
                                                      initialRating: double
                                                          .parse(
                                                          selectedPin.rate!),
                                                      minRating: 0,
                                                      direction: Axis
                                                          .horizontal,
                                                      allowHalfRating: false,
                                                      itemCount: 5,
                                                      itemPadding: EdgeInsets
                                                          .fromLTRB(
                                                          0.5.w, 0.5.h, 0.5.w,
                                                          0),
                                                      itemBuilder: (context,
                                                          _) =>
                                                          Icon(
                                                            Icons.star,
                                                            color: Style
                                                                .SecondryColor,
                                                          ),
                                                      itemSize: 2.5.h,
                                                      onRatingUpdate: (rating) {
                                                        print(rating);
                                                      },
                                                    ))
                                              ],
                                            )),
                                            InkWell(
                                              child: AnimatedButton(
                                                  text: Translations.of(
                                                      context)!
                                                      .Station_location,
                                                  onTapped: () =>
                                                      LocationFun(
                                                          selectedPin.lat,
                                                          selectedPin.lng,
                                                          selectedPin.name ??
                                                              "")),
                                            )
                                          ],
                                        ),),),
                                    SizedBox(width: 2.0.w,),
                                    if(selectedPin.images != null &&
                                        selectedPin.images!.length > 0)
                                      Expanded(child: Image.network(
                                          selectedPin.images[0])),
                                    if(selectedPin.images == null ||
                                        selectedPin.images!.length == 0)
                                      Expanded(child: Image(image: AssetImage(
                                          'lib/assets/logo.png'),),)
                                  ],
                                ),
                              ),
                              Positioned(
                                  top: 10,
                                  left: 40,
                                  child: CircleAvatar(
                                      radius: 16,
                                      backgroundColor: Colors.white,
                                      child: IconButton(
                                          padding: EdgeInsets.zero,
                                          iconSize: 3.0.h,
                                          icon: const Icon(
                                              Icons.highlight_remove, color: Colors.red),
                                          onPressed: () async {
                                            if (selectedMarker != -1) {
                                              final markerId = MarkerId(
                                                  selectedMarker.toString());

                                              final icon =
                                              await _getAssetIcon(
                                                  context, "gas_station_pin");

                                              _setMarkerIcon(markerId, icon);
                                            }
                                            setState(() {
                                              selectedMarker = -1;
                                              selectedPin = PinDataModel(
                                                -1,
                                                "name",
                                                "address",
                                                "phone",
                                                "2",
                                                0,
                                                0,
                                                [],
                                                "mail",
                                              );
                                            });
                                          })))
                            ])
                      ]),
              ],
            ))));
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