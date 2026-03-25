
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sizer/sizer.dart';
import 'package:store_redirect/store_redirect.dart';
import '../Constans/Style.dart';
import '../Localization/Translations.dart';
import '../Routes/route_constants.dart';

AlertView(BuildContext context, String image,  String Title, String Description, {int id=0})async {
  await Alert(

      context: context,
      title: Title,
      desc: Description,
      image: Image.asset("lib/assets/"+image+".png", width: 70.0.w, height: 10.0.h,),
      buttons: [
        DialogButton(
          child: Text(
            Translations.of(context)!.Ok,
            style: Style.BlackText12Bold,
          ),
          onPressed: () {
            if(id==0) {
              Navigator.pop(context);
            }
            else {
              try {
                StoreRedirect.redirect(androidAppId: "com.raitotec.gas_services_new_demo",
                    iOSAppId: "585027354");
              }
              catch (e) {
                print(e);
              }
            }

          },
          color: Colors.black12,
          // padding:  EdgeInsets.fromLTRB(30.0.w,0, 30.0.w, 0),
          height: 5.0.h,
          // width: 70.0.w,
        ),
      ],
      style: AlertStyle(overlayColor:  Colors.black54, titleStyle: Style.GreyText12, descStyle: Style.GreyText12,
      )
  ).show();
}

AlertView2(BuildContext context)async {
  await Alert(
      context: context,
      title: Translations.of(context)!.Please,
      desc: Translations.of(context)!.Login_btn,
      image: Image.asset("lib/assets/warning.png", width: 70.0.w, height: 10.0.h,),
      buttons: [
        DialogButton(
          child: Text(
            Translations.of(context)!.Ok,
            style: Style.BlackText12Bold,
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, startRoute);
          },
          color: Colors.black12,
          // padding:  EdgeInsets.fromLTRB(30.0.w,0, 30.0.w, 0),
          height: 5.0.h,
          // width: 70.0.w,
        ),
        DialogButton(
          child: Text(
            Translations.of(context)!.cancel,
            style: Style.BlackText12Bold,
          ),
          onPressed: () {
            try {
              Navigator.pushNamedAndRemoveUntil(context, homeRoute,(Route<dynamic> r)=>false);
            }
            catch(e)
            {
           }

          },
          color: Colors.black12,
          // padding:  EdgeInsets.fromLTRB(30.0.w,0, 30.0.w, 0),
          height: 5.0.h,
          // width: 70.0.w,
        ),
      ],
      style: AlertStyle(overlayColor:  Colors.black54, titleStyle: Style.GreyText12, descStyle: Style.GreyText12,
        isCloseButton: false
      )
  ).show();
}
