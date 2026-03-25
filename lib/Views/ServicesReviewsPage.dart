


import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
//import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../Api/DataApi.dart';
import '../Api/SetvicesApi.dart';
import '../Constans/Style.dart';
import '../Localization/Translations.dart';
import '../Models/PaymentModel.dart';
import '../Models/ServicesModel.dart';
import '../Routes/route_constants.dart';
import '../Shared_Data/ServicesData.dart';
import '../Shared_View/AnimatedButton.dart';
import '../Shared_View/AppBarView.dart';
import '../Shared_View/DrawerView.dart';

class ServicesReviewsPage extends StatefulWidget {
  ServicesReviewsPage({ Key? key}) : super(key: key);
  @override
  _StationReviewsPageState createState() => _StationReviewsPageState();
}

class _StationReviewsPageState extends State<ServicesReviewsPage> {

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  final MobileScannerController controller = MobileScannerController();
  String? result;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithBack(context, Translations.of(context)!.Service_Evaluation),
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
       return Column(children: [Expanded(child:
    result == null?
    MobileScanner(
      controller: controller,
      onDetect: (BarcodeCapture capture) async {
        final List<Barcode> barcodes = capture.barcodes;
        showLoading();
        for (final barcode in barcodes) {
          print("*******"+barcode.rawValue!);
          setState(() {
            result=barcode.rawValue;
          });
        }
        await controller.stop();
        showLoading();
        try {
          if (!await launchUrl(
            Uri.parse(result!), mode: LaunchMode.inAppBrowserView,
            browserConfiguration: const BrowserConfiguration(
                showTitle: true),)) {
            throw Exception('Could not launch $result');
          }
        }
        catch(e)
        {

        }
        hideLoading();
      },
    ):Column(children: [
         SizedBox(height: 40.0),
    Container(
    margin: EdgeInsets.symmetric(horizontal: 14.0.w),
    child:AnimatedButton(text:Translations.of(context)!.try_again,onTapped: startFun,))
      ]))]);
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



  Future<void> startFun() async {

    setState(() {
      result= null;
    });
  }
}