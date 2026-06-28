import 'package:babco/Constans/Style.dart';
import 'package:babco/Localization/Translations.dart';
import 'package:babco/Shared_View/AnimatedButton.dart';
import 'package:babco/Shared_View/AppBarView.dart';
import 'package:babco/Shared_View/DrawerView.dart';
import 'package:babco/Shared_View/GlobalTextField.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../ViewModels/PersonInformationViewModel.dart';


class PersonInformationPage extends StatelessWidget {
  const PersonInformationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PersonInformationViewModel()..GetData(context),
      child: Consumer<PersonInformationViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBarWithBack(
              context,
              Translations.of(context)!.Info,
            ),
            drawer: DrawerList(context),
            body: SafeArea(
              child: LoadingOverlay(
                isLoading: vm.isLoading,
                opacity: .3,
                color: Style.WhiteColor,
                progressIndicator: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Style.MainColor,
                  ),
                ),
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: _form(context, vm),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _form(
      BuildContext context,
      PersonInformationViewModel vm,
      ) {
    return SingleChildScrollView(
        child: Form(
            key: vm.formKey,
            child: Column(
                children: [
                SizedBox(height: 2.h),

            Image.asset(
              "lib/assets/logo.png",
              width: 60.w,
              height: 20.h,
            ),

            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 5.w,
                vertical: 2.h,
              ),
              child: Column(
                children: [

                /// Name
                GlobalTextField(
                controller: vm.nameController,
                icon: Icons.person_pin_sharp,
                label: Translations.of(context)!.username,
                onChanged: (_) {},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return Translations.of(context)!
                        .username_Validation;
                  }

                  if (value.trim().length < 2) {
                    return Translations.of(context)!
                        .name_Validation;
                  }

                  return null;
                },
              ),

              SizedBox(height: 1.h),

              /// Email
              GlobalTextField(
                controller: vm.emailController,
                keyboardType: TextInputType.emailAddress,
                icon: Icons.email,
                label: Translations.of(context)!.Email,
                onChanged: (_) {},
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return Translations.of(context)!
                        .Email_Validation;
                  }

                  final emailRegex = RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  );

                  if (!emailRegex.hasMatch(value.trim())) {
                    return Translations.of(context)!
                        .Email_Validation;
                  }

                  return null;
                },
              ),

              SizedBox(height: 1.h),

              /// Mobile
              GlobalTextField(
                controller: vm.mobileController,
                keyboardType: TextInputType.phone,
                icon: Icons.phone_android,
                label:
                Translations.of(context)!.Phone_number,
                onChanged: (_) {},
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return Translations.of(context)!
                        .Phone_number_Validation;
                  }

                  final phone = value.trim();

                  final regex =
                  RegExp(r'^05[0-9]{8}$');

                  if (!regex.hasMatch(phone)) {
                    return Translations.of(context)!
                        .phone_invalid;
                  }

                  return null;
                },
              ),

              SizedBox(height: 1.h),

              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 2.w,
                  vertical: .5.h,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 2.w,
                  vertical: .5.h,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: vm.showPasswordFields
                        ? Style
                        .BorderTextFieldFocusedColor
                        : Style.BorderTextFieldColor,
                  ),
                ),
                child: Column(
                    children: [
                Row(
                children: [
                SizedBox(width: 1.w),

                Icon(
                  Icons.lock_outline,
                  color: Style.SecondryColor,
                  size: 3.h,
                ),

                SizedBox(width: 2.w),

                Expanded(
                  child: Text(
                    Translations.of(context)!
                        .Password,
                    style:
                    Style.MainText14Bold,
                  ),
                ),

                TextButton(
                  onPressed:
                  vm.togglePasswordFields,
                  child: Text(
                    vm.showPasswordFields
                        ? Translations.of(
                        context)!
                        .cancel
                        : Translations.of(
                        context)!
                        .edit_data,
                    style: Style.MainText14
                        .copyWith(
                      color: vm
                          .showPasswordFields
                          ? Colors.red
                          : Style.MainColor,
                    ),
                  ),
                ),
                ],
              ),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 250),
                        child: vm.showPasswordFields
                            ? Column(
                          children: [
                            GlobalTextField(
                              controller:
                              vm.currentPasswordController,
                              password: true,
                              icon: Icons.lock_outline,
                              label: Translations.of(context)!
                                  .currentPassword,
                              onChanged: (_) {},
                              validator: (value) => vm
                                  .passwordValidator(
                                  context, value),
                            ),

                            SizedBox(height: 1.h),

                            GlobalTextField(
                              controller:
                              vm.newPasswordController,
                              password: true,
                              icon: Icons.lock,
                              label: Translations.of(context)!
                                  .newPassword,
                              onChanged: (_) {},
                              validator: (value) => vm
                                  .passwordValidator(
                                  context, value),
                            ),
                          ],
                        )
                            : const SizedBox.shrink(),
                      ),
                    ],
                ),
              ),

                  SizedBox(height: 5.h),

                  AnimatedButton(
                    text: Translations.of(context)!.edit_data,
                    onTapped: () => vm.startFun(context),
                  ),
                ],
              ),
            ),
                ],
            ),
        ),
    );
  }
}