
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sizer/sizer.dart';

import '../../Constans/Style.dart';
import '../../Localization/Translations.dart';


class QrScannerView extends StatelessWidget {

  final MobileScannerController controller;
  final void Function(BarcodeCapture) onDetect;
  final String? scannedResult;
  final VoidCallback onRestart;

  const QrScannerView({
    Key? key,
    required this.controller,
    required this.onDetect,
    this.scannedResult,
    required this.onRestart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [

        MobileScanner(
          controller: controller,
          onDetect: onDetect,
        ),

        Positioned(
          top: 3.h,
          left: 0,
          right: 0,
          child: GestureDetector(
          onTap: onRestart,
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 6.w,
                vertical: 1.2.h,
              ),
              decoration: BoxDecoration(
                color: Style.MainColor.withOpacity(0.85),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.qr_code_scanner,
                    color: Colors.white,
                    size: 2.5.h,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    Translations.of(context)!.scanQr,
                    style: Style.Header7,
                  ),
                ],
              ),
            ),
          )),
        ),



      ],
    );

  }

}
