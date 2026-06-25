import 'package:babco/Models/RegisterResponse.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Shared_View/AnimatedButton.dart';
import '../../Shared_View/AppBarView.dart';
import '../../Shared_View/GlobalTextField.dart';
import '../../ViewModels/LoginViewModel/OtpViewModel.dart';


class OtpPage extends StatelessWidget {
  final RegisterResponse data;


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
              "Verify Account",
            ),
            body: Form(
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
                      ),

                      SizedBox(height: 2.h),

                      Text(
                        "Verification Code",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 1.h),

                      Text(
                        "A verification code has been sent to",
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: .5.h),

                      Text(
                        data.mobile??"",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 3.h),

                      GlobalTextField(
                        controller: vm.otpController,
                        keyboardType: TextInputType.number,
                        label: "Verification Code",
                        icon: Icons.password,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter verification code";
                          }

                          if (value.trim().length < 4) {
                            return "Invalid verification code";
                          }

                          return null;
                        },
                        onChanged: (value) {},
                      ),

                      SizedBox(height: 2.h),

                      Container(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          vm.isExpired
                              ? "Verification code expired"
                              : "Remaining Time : ${vm.formattedTime}",
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: vm.isExpired
                                ? Colors.red
                                : Colors.black,
                          ),
                        ),
                      ),

                      SizedBox(height: 2.h),

                      AnimatedButton(
                        text: "Verify",
                        onTapped: () async {
                          await vm.verifyCode(context);
                        },
                      ),

                      SizedBox(height: 2.h),

                      TextButton(
                        onPressed: vm.isExpired
                            ? () async {
                          await vm.resendCode();
                        }
                            : null,
                        child: Text(
                          vm.isExpired
                              ? "Resend Code"
                              : "Resend available after timer ends",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}