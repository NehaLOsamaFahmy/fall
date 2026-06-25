import 'package:babco/Localization/Translations.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Constans/Style.dart';
import '../../Models/DelegateDataModel.dart';
import '../../Shared_View/AnimatedButton.dart';
import '../../Shared_View/AppBarView.dart';
import '../../Shared_View/GlobalTextField.dart';
import '../../ViewModels/LoginViewModel/OtpViewModel.dart';


class OtpPage extends StatelessWidget {
  final DelegateDataModel data;


  const OtpPage({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OtpViewModel(
        data: data
      )..startTimer(),
      child: Consumer<OtpViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBarWithBack(
              context,
              Translations.of(context)!.verifyAccount,
            ),
            body:LoadingOverlay(
                isLoading: vm.isLoading,
                opacity: 0.2,
                color: Style.MainColor,
                progressIndicator: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Style.MainColor),),
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  child:  Form(
              key: vm.formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.w,
                    vertical: 2.h,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 3.h),

                      Icon(
                        Icons.mark_email_read_outlined,
                        size: 10.h,
                        color: Style.SecondryColor,
                      ),

                      SizedBox(height: 2.h),

                      Text(
                        Translations.of(context)!.verificationCode,
                        style: Style.MainText18Bold
                      ),

                      SizedBox(height: 1.h),

                      Text(
                        Translations.of(context)!.verifyToEmail,
                        textAlign: TextAlign.center,
                          style: Style.MainText16
                      ),

                      SizedBox(height: .5.h),

                      Text(
                        data.email??"",
                        textAlign: TextAlign.center,
                        style: Style.MainText16Bold
                      ),

                      SizedBox(height: 3.h),

                      GlobalTextField(
                        controller: vm.otpController,
                        keyboardType: TextInputType.number,
                        label: Translations.of(context)!.verificationCode,
                        icon: Icons.password,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return Translations.of(context)!.verificationCode_Validation;
                          }
                          return null;
                        },
                        onChanged: (value) {},
                      ),


                      SizedBox(height: 5.h),

                      AnimatedButton(
                        text: Translations.of(context)!.verifyAccount,
                        onTapped: () async {
                          await vm.verifyCode(context);
                        },
                      ),

                      vm.isExpired ? SizedBox.shrink():
                      Container(
                        child: Text(
                            "${Translations.of(context)!.remainingTime} : ${vm.formattedTime}",
                            style:Style.MainText16.copyWith(
                              color: Style.MainColor,
                              //   decoration: TextDecoration.underline,
                            ),
                        ),
                      ),


                     !vm.isExpired
                          ? SizedBox.shrink()
                          :
                      TextButton(
                        onPressed:  () async {
                          await vm.resendCode(context);
                        },
                        child: Text(
                          Translations.of(context)!.resendCode,
                          style: Style.MainText16Bold.copyWith(
                         color: Style.MainColor,
                         //   decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),))
          );
        },
      ),

    );
  }
}
