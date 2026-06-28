import 'package:babco/Shared_View/GlobalTextField.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Constans/Style.dart';
import '../../Localization/Translations.dart';
import '../../Shared_View/AnimatedButton.dart';
import '../../Shared_View/AppBarView.dart';
import '../../ViewModels/LoginViewModel/RegisterViewModel.dart';


class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (_) => RegisterViewModel(),
      child: Consumer<RegisterViewModel>(
        builder: (context, vm, child) {

          return Scaffold(
            appBar: AppBarWithBackOnly(
                context, Translations.of(context)!.New_user),
            backgroundColor: Colors.white,
            body:LoadingOverlay(
                isLoading: vm.isLoading,
                opacity: 0.2,
                color: Style.MainColor,
                progressIndicator: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Style.MainColor),),
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: Form(
              key: vm.formKey,
              child: SingleChildScrollView(
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  SizedBox(height: 2.0.h,),
                Image(image: AssetImage('lib/assets/logo.png'),
                  width: 60.0.w,
                  height: 20.0.h,),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 2.0.h),
                  child:
                  Column(
                  children: [

                    GlobalTextField(
                      controller: vm.firstNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return Translations.of(context)!.First_name_Validation;
                        }
                        if (value.trim().length < 2) {
                          return Translations.of(context)!.name_Validation;
                        }

                        return null;
                      },
                      icon: Icons.person_pin_sharp,
                      label: Translations.of(context)!.First_name,
                      onChanged: (String p1) {  },
                    ),

                     SizedBox(height: 1.0.h),

                    GlobalTextField(
                      controller: vm.lastNameController,

                      validator: (value) {
                        if(value ==null || value.isEmpty) {
                          return Translations.of(context)!.Last_name_Validation;
                        }
                        if (value.trim().length < 2) {
                          return Translations.of(context)!.name_Validation;
                        }

                        return null;
                      },
                      label: Translations.of(context)!.Last_name,
                      icon: Icons.person_pin_sharp,
                      onChanged: (String p1) {  },
                    ),

                     SizedBox(height: 1.0.h),

                    GlobalTextField(
                      controller: vm.emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return Translations.of(context)!.Email_Validation;
                        }

                        final emailRegex = RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        );

                        if (!emailRegex.hasMatch(value.trim())) {
                          return Translations.of(context)!.Email_Validation;
                        }
                        return null;
                      },
                      icon: Icons.email,
                      label:  Translations.of(context)!.Email,
                      onChanged: (String p1) {  },
                    ),

                     SizedBox(height: 1.0.h),

                    GlobalTextField(
                      controller: vm.phoneController,
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
                      controller: vm.passwordController,
                      label: Translations.of(context)!.Password,
                      validator:(value){
                        if (value == null || value.isEmpty) {
                          return Translations.of(context)!.Password_Validation;
                        }

                        if (value.length < 6) {
                          return Translations.of(context)!.password_is_too_short;
                        }

                        return null;
                      } ,
                      password: true,
                      icon: Icons.lock,
                      onChanged: (value) {},
                    ),

                     SizedBox(height: 1.0.h),

                    AnimatedButton(
                      text: Translations.of(context)!.Login_btn,
                      onTapped: ()=> vm.register(context),
                    ),
                  ],
                ),
              ),])
            )))),
          );
        },
      ),
    );
  }
}