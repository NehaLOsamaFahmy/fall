
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:babco/Models/DataModel.dart';
import 'package:babco/Shared_View/DrawerView.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Api/Contact_us/GetContactsDataApi.dart';
import '../Api/Contact_us/SendCommentApi.dart';
import '../Api/DataApi.dart';
import '../Api/Login/LoginApi.dart';
import '../Constans/Style.dart';
import '../Localization/Translations.dart';
import '../Routes/route_constants.dart';
import '../Shared_Data/CompanyData.dart';
import '../Shared_Data/DelegateData.dart';
import '../Shared_View/AlertView.dart';
import '../Shared_View/AnimatedButton.dart';
import '../Shared_View/AppBarView.dart';
import '../Shared_View/GlobalTextField.dart';


class Connect_usPage extends StatefulWidget {
  Connect_usPage({Key? key}) : super(key: key);

  @override
  _Connect_usPageState createState() => _Connect_usPageState();
}

class _Connect_usPageState extends State<Connect_usPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController name1Controller = TextEditingController();
  TextEditingController commentController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController name2Controller = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool _isLoading = false;
  DataModel SelectData= new DataModel(-1, "name","","","");
  List<DataModel> data=<DataModel>[];
  String whatsappNumber = "";
  String websiteUrl = "";

  Future<void> openWhatsApp() async {
    final url = "https://wa.me/$whatsappNumber";
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  Future<void> openWebsite() async {
    if (!websiteUrl.startsWith('http')) {
      websiteUrl = "https://$websiteUrl";
    }
    final uri = Uri.parse(websiteUrl);

    if (!await canLaunchUrl(uri)) {
      print("Invalid URL: $websiteUrl");
      return;
    }

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBarWithBack(context, Translations.of(context)!.Connect_us),
        drawer: DrawerList(context),
        backgroundColor: Colors.white,
        body:SafeArea(child: LoadingOverlay(
            isLoading: _isLoading,
            opacity: 0.2,
            color: Style.MainColor,
            progressIndicator: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Style.MainColor),),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              child: FormUI(),
            ))
    ));
  }

  Widget FormUI() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 0.0.h),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[

                  Image(image: AssetImage('lib/assets/logo.png'),
                    width: 60.0.w,
                    height: 15.0.h,),
                  SizedBox(height: 2.0.h),
                  Text(
                    Translations.of(context)!.help,
                    style: Style.BlackText18Bold,
                  ),

                  SizedBox(height: 3.0.h),

                  // WhatsApp
                  Card(
                    color: const Color(0xFFE8F5E9), // أخضر فاتح مريح
                    elevation: 6, // قوة الشادو
                    shadowColor: Colors.black.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 2.0.w, vertical: .5.h),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.10),
                          shape: BoxShape.circle,
                        ),
                        child: FaIcon(
                          FontAwesomeIcons.whatsapp,
                          color: Colors.green,
                          size: 4.0.h,
                        ),
                      ),
                      title:  Text(
                        Translations.of(context)!.whatsApp,
                        style: Style.MainText14Bold,
                      ),
                      subtitle:  Text(Translations.of(context)!.contactWhatsApp,
                        style: Style.MainText14,),
                      trailing:  Icon(Icons.arrow_forward_ios, size: 2.0.h),
                      onTap: openWhatsApp,
                    ),
                  ),
                  SizedBox(height: 2.0.h),
                  // Website
                  Card(
                    color: const Color(0xFFE3F2FD), // أزرق فاتح
                    elevation: 6,
                    shadowColor: Colors.black.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      contentPadding:EdgeInsets.symmetric(horizontal: 2.0.w, vertical: 0.5.h),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child:  Icon(Icons.language, color: Colors.blue, size: 3.5.h,),
                      ),
                      title:  Text(
                        Translations.of(context)!.webSite,
                        style: Style.MainText14Bold,
                      ),
                      subtitle:  Text(Translations.of(context)!.contactWebSite,
                        style: Style.MainText14,),
                      trailing:  Icon(Icons.arrow_forward_ios, size: 2.0.h),
                      onTap: openWebsite,
                    ),
                  ),
                  SizedBox(height: 3.0.h),
                  GlobalTextField(
                    controller: mobileController,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return Translations.of(context)!.Phone_number_Validation;
                      }

                      final phone = value.trim();

                      final saudiNationalRegex = RegExp(r'^05[0-9]{8}$');

                      if (!saudiNationalRegex.hasMatch(phone)) {
                        return Translations.of(context)!.phone_invalid;
                      }

                      return null;
                    },
                    icon: Icons.phone_android,
                    label: Translations.of(context)!.Phone_number,
                    onChanged: (String p1) {  },
                  ),

                  SizedBox(height: 1.0.h),
                  GlobalTextField(
                    controller:commentController ,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return Translations.of(context)!.comment_Validation;
                      }
                      if (value.trim().length < 2) {
                        return Translations.of(context)!.name_Validation;
                      }

                      return null;
                    },
                    icon: Icons.comment,
                    label: Translations.of(context)!.comment,
                    onChanged: (String p1) {  },
                  ),
                  SizedBox(height: 3.0.h),
                      AnimatedButton(text:Translations.of(context)!.sendMsg,onTapped: ()=>startFun(),)

                ],
              ),
            ),
          ),


        ],
      ),
    );
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
    if (_formKey.currentState!.validate()) {
      showLoading();
      var res = await Contact_us(context, mobileController.text,commentController.text);
      hideLoading();
      if (res == true) {
        Navigator.pushNamed(context, homeRoute);
      }
      hideLoading();
    }
  }
  Future<void> getData() async {
    if(DelegateData.delegateData!= null && DelegateData.delegateData!.mobile!=null) {
      setState(() {
      mobileController.text = DelegateData.delegateData!.mobile!;
      });
    }
    showLoading();
    var x=await GetContactUs(context);
    if(x != null) {
      setState(() {
        whatsappNumber= x.whatsappNumber!;
        websiteUrl=  x.siteLink!;
      });
    }
    hideLoading();
  }
}
