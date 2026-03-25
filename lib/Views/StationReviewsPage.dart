//////////////////////////////////


import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:loading_overlay/loading_overlay.dart';
//import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../Api/DataApi.dart';
import '../Api/SetvicesApi.dart';
import '../Constans/Style.dart';
import '../Localization/Translations.dart';
import '../Models/PaymentModel.dart';
import '../Models/ServicesModel.dart';
import '../Routes/route_constants.dart';
import '../Shared_Data/ServicesData.dart';
import '../Shared_View/AppBarView.dart';
import '../Shared_View/DrawerView.dart';

class StationReviewsPage extends StatefulWidget {
  StationReviewsPage({ Key? key}) : super(key: key);
  @override
  _StationReviewsPageState createState() => _StationReviewsPageState();
}

class _StationReviewsPageState extends State<StationReviewsPage> {

  bool _isLoading = false;
 String data="";

  @override
  void initState() {
    super.initState();
  //  GetData(context);
  }

  Future<void> GetData(BuildContext context)
  async {
    showLoading();
    var Services = await StationReviews(context);
    if (Services != null) {
      setState(() {
        data = Services!;
      });
    }
    hideLoading();
  }
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  //Barcode? result;
 // QRViewController? controller;
  late final WebViewController _controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    //if (Platform.isAndroid) {
      //controller!.pauseCamera();
    //} else if (Platform.isIOS) {
     // controller!.resumeCamera();
    //}
  }
/*
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        if (result != null) {
          _controller = WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setBackgroundColor(const Color(0x00000000))
            ..setNavigationDelegate(
              NavigationDelegate(
                onProgress: (int progress) {
                  debugPrint('WebView is loading (progress : $progress%)');
                  showLoading();
                },
                onPageStarted: (String url) {
                  debugPrint('Page started loading: $url');
                },
                onPageFinished: (String url) {
                  debugPrint('Page finished loading: $url');
                  hideLoading();
                },
                onWebResourceError: (WebResourceError error) {
                  debugPrint('''Page resource error: code: ${error.errorCode} description: ${error.description} errorType: ${error.errorType} isForMainFrame: ${error.isForMainFrame}
          ''');
                },
                onNavigationRequest: (NavigationRequest request) {
                  if (request.url.startsWith('https://www.youtube.com/')) {
                    debugPrint('blocking navigation to ${request.url}');
                    return NavigationDecision.prevent;
                  }
                  debugPrint('allowing navigation to ${request.url}');
                  return NavigationDecision.navigate;
                },
                onUrlChange: (UrlChange change) {
                  debugPrint('url change to ${change.url}');
                },
              ),
            )
            ..loadRequest(Uri.parse(result!.code!));
        }
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
*/

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBarWithBack(context, Translations.of(context)!.Station_services),
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
    /*
    return (result != null)?Column(
          children: [
           Expanded(child:  WebViewWidget(controller: _controller),)
          ],
        ): Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.0.h,),
            Center(
              child:  Text('Scan a QR Code',style: Style.MainText14Bold,),
            ),
            SizedBox(height:5.0.h,),
            /*
            (data != null && data.length>0)?
            Center(child:  QrImageView(
              data: data,
              version: QrVersions.auto,
              size: 25.0.h,
              gapless: false,
              errorStateBuilder: (cxt, err) {
                return Container(
                  child: Center(
                    child: Text(
                      'Something went wrong...',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            )):
            Center(child: Text(Translations.of(context)!.NoData,
              style: Style.MainText14Bold.copyWith(color:Style.MainTextColor),))
*/
          Expanded(child:  Container(
            padding: EdgeInsets.fromLTRB(1.0.w, 0.5.h, 1.0.w, 0.5.h),
            margin: EdgeInsets.fromLTRB(1.0.w, 0.5.h, 1.0.w, 5.0.h),
            decoration: Style.BoxDecorationBoxShadowGreyColor,
             child:   QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),),),


          ],
        );*/
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