
import 'package:flutter/material.dart';
import 'package:babco/Localization/Translations.dart';
import 'package:babco/Shared_Data/DelegateData.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sizer/sizer.dart';

import '../Api/LoginApi.dart';
import '../Constans/Style.dart';
import '../Routes/route_constants.dart';
import '../Shared_Data/formatDateTime.dart';
import '../Shared_View/AlertView.dart';
import '../Shared_View/AnimatedButton.dart';
import '../Shared_View/AppBarView.dart';
import '../Shared_View/DrawerView.dart';
import '../Shared_View/GlobalTextField.dart';

class PersonInformationPage extends StatefulWidget {

  PersonInformationPage({Key? key}) : super(key: key);

  @override
  _PersonInformationPageState createState() => _PersonInformationPageState();
}

class _PersonInformationPageState extends State<PersonInformationPage> {

  bool _isLoading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      GetData();
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithBack(
            context, Translations.of(context)!.Info),
        drawer: DrawerList(context),
        body:SafeArea(child: LoadingOverlay(
            child: Container(
                height: double.infinity,
                width: double.infinity,
                child: new GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  child: FormUI(context),
                )),

            isLoading: _isLoading,
            opacity: 0.3,
            color: Style.WhiteColor,
            progressIndicator: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Style.MainColor),))
    ));
  }

  Widget FormUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 3.0.h,),
          Image(image: AssetImage('lib/assets/logo.png'), width: 60.0.w, height: 17.0.h,),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 5.0.h),
            child:Form(
              key: _formKey,
              child:   Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  GlobalTextField(controller: nameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return Translations.of(context)!.username_Validation;
                        }
                        return null;
                      },
                      keyboardType: TextInputType.name, label: '',
                    hint: Translations.of(context)!.username,
                    onChanged: (String ) {  },
                    icon: Icons.person,
                      ),
                  SizedBox(height: 1.0.h,),
                  GlobalTextField(controller: mobileController,
                    validator: (value){
                      if (value!.isEmpty ||  value.length <9) {
                        return Translations.of(context)!.Phone_number_Validation;
                      }
                      return null;
                    },
                    keyboardType: TextInputType.phone, label: '',
                    hint: Translations.of(context)!.phone_number_ex,
                    onChanged: (String ) {  },
                    icon: Icons.phone_android,
                  ),
                  SizedBox(height: 1.0.h,),
                  GlobalTextField(controller: emailController,
                    validator: (value){
                      if (value!.isEmpty) {
                        return Translations.of(context)!.Email_Validation;
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress, label: '',
                    hint: Translations.of(context)!.Email,
                    onChanged: (String ) {  },
                    icon: Icons.email_outlined,
                  ),
                  SizedBox(height: 5.0.h,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 14.0.w),
                child:
                        AnimatedButton(text:Translations.of(context)!.edit_data,onTapped: startFun,))



                ],
              ),
            ),
          ),


        ],
      ),
    );
  }

  Future<void> GetData()
  async {

    if(DelegateData.delegateData!= null && DelegateData.delegateData!.id!>0) {
      showLoading();
      setState(() {
        nameController.text = DelegateData.delegateData!.name!;
        mobileController.text = DelegateData.delegateData!.mobile!;
        emailController.text = DelegateData.delegateData!.email!;
      });
      hideLoading();
    }
    else
    {
      await AlertView2(context);
    }

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




  Future<void> startFun()async {
    if( nameController.text == DelegateData.delegateData!.name!&&
    mobileController.text == DelegateData.delegateData!.mobile!&&
    emailController.text == DelegateData.delegateData!.email!)
      {
        await AlertView(
            context, "error", Translations.of(context)!.Please,Translations.of(context)!.new_noData);
      }
    else {
      if (_formKey.currentState!.validate()) {
        showLoading();
        var res = await EditCustomer(
            context, mobileController.text, nameController.text,
            emailController.text);
        hideLoading();
        if (res != null) {
          setState(() {
            DelegateData.delegateData = res;
          });
          Navigator.pushNamed(context, homeRoute);
        }
        hideLoading();
      }
    }
  }
}