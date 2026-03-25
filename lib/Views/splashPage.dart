
import 'package:flutter/material.dart';
import 'package:babco/Routes/route_constants.dart';
import 'package:sizer/sizer.dart';

import '../Api/DataApi.dart';
import '../Api/LoginApi.dart';
import '../Shared_Data/CompanyData.dart';
import '../Shared_Data/DelegateData.dart';
import '../Shared_Data/ServicesData.dart';


class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    GetData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: FormUI(context),
        ));
  }

  Widget FormUI(BuildContext context)  {
    return Container(child:  FittedBox(
      child: Image.asset("lib/assets/logo.png",repeat: ImageRepeat.noRepeat,gaplessPlayback: false,),
      fit: BoxFit.contain,
    ),margin: EdgeInsets.symmetric(horizontal: 5.0.w),);
  }


  Future<void> GetData() async {
    //5500
    try {
     // if(CompanyData.companyData != null && CompanyData.companyData!.petrolstation_base_url !=null)
      await StartToLogin(context, "61");
      var xx = await getCompanyData();
      setState(() {
        CompanyData.companyData = xx;
      });
      var x = await getDelegateData();
      setState(() {
        DelegateData.delegateData = x;
      });
      try
      {
        var x= await GetServices(context);
        setState(() {
          NewServicesData.serviceData=x;
        });

      }
      catch(e)
      {

      }
      //4300
        Future.delayed(const Duration(milliseconds: 1), () {
       Navigator.pushNamedAndRemoveUntil(context, homeRoute,(Route<dynamic> r)=>false);
      });
    }
    catch(e)
    {
      print("Exception"+"GetDataSplash");
    }
  }

}