import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Constans/Style.dart';
import '../../Localization/Translations.dart';
import '../../Routes/route_constants.dart';
import '../../Shared_View/AnimatedButton.dart';
import '../../Shared_View/AppBarView.dart';
import '../../Shared_View/GlobalTextField.dart';
import '../../ViewModels/LoginViewModel/LoginViewModel.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: Consumer<LoginViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBarWithBackOnly(context, ""),

            body: LoadingOverlay(
                isLoading: vm.isLoading,
                opacity: 0.2,
                color: Style.MainColor,
                progressIndicator: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Style.MainColor),),
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  //decoration: Style.BoxDecoration1,
                  child:
                  Form(
              key: vm.formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 2.0.h,),
                    Image(image: AssetImage('lib/assets/logo.png'),
                      width: 60.0.w,
                      height: 20.0.h,),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 2.0.h),
                      child: Column(
                        children: [

                          /// Email or Mobile
                          GlobalTextField(
                            controller: vm.identifierController,
                            keyboardType: TextInputType.emailAddress,
                            label:Translations.of(context)!.EmailorMobile,
                            icon: Icons.person,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return Translations.of(context)!.EmailorMobile_Validation;
                              }
                              return null;
                            },
                            onChanged: (_) {},
                          ),

                          SizedBox(height: 2.h),

                          /// Password
                          GlobalTextField(
                            controller: vm.passwordController,
                            label:Translations.of(context)!.password,
                            icon: Icons.lock,
                            password: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return Translations.of(context)!.Password_Validation;
                              }
                              if (value.length < 6) {
                                return Translations.of(context)!.password_is_too_short;
                              }
                              return null;
                            },
                            onChanged: (_) {},
                          ),

                          SizedBox(height: 4.h),

                          AnimatedButton(
                            text: Translations.of(context)!.login,
                            onTapped:() async => await vm.login(context),
                          ),

                        //  SizedBox(height: 3.h),

                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, newUserRoute);
                            },
                            child:  Text(
                              Translations.of(context)!.New_user,
                              style: Style.MainText16Bold.copyWith(
                                color: Style.MainColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ))),
          );
        },
      ),
    );
  }
}