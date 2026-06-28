import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:sizer/sizer.dart';

import '../Constans/Style.dart';
import '../Localization/Translations.dart';
import '../Shared_View/AnimatedButton.dart';
import '../Shared_View/AppBarView.dart';
import '../Shared_View/DrawerView.dart';
import '../Shared_View/GlobalTextField.dart';
import '../ViewModels/ConnectUsViewModel.dart';

class ConnectUsPage extends StatelessWidget {

  const ConnectUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(

      create: (_) =>
      ConnectUsViewModel()
        ..init(context),
      child: Consumer<ConnectUsViewModel>(
        builder: (_, vm, __) {
          return Scaffold(
            appBar: AppBarWithBack(
              context,
              Translations.of(context)!.Connect_us,
            ),
            drawer: DrawerList(context),
            backgroundColor: Colors.white,
            body: LoadingOverlay(
              isLoading: vm.isLoading,
              opacity: .2,
              color: Style.MainColor,
              progressIndicator: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Style.MainColor),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Form(
                      key: vm.formKey,
                      child: Column(
                        children: [
                          Image.asset(
                            "lib/assets/logo.png",
                            width: 60.w,
                            height: 15.h,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            Translations.of(context)!.help,
                            style: Style.BlackText18Bold,
                          ),

                          SizedBox(height: 3.h),

                          _whatsAppCard(vm, context),

                          SizedBox(height: 2.h),

                          _websiteCard(vm, context),

                          SizedBox(height: 3.h),

                          GlobalTextField(
                            controller: vm.mobileController,
                            keyboardType: TextInputType.phone,
                            icon: Icons.phone_android,
                            label: Translations.of(context)!.Phone_number,
                            validator: (value) {
                              if (value == null || value
                                  .trim()
                                  .isEmpty) {
                                return Translations.of(context)!
                                    .Phone_number_Validation;
                              }

                              final regex =
                              RegExp(r'^05[0-9]{8}$');

                              if (!regex.hasMatch(value.trim())) {
                                return Translations.of(context)!.phone_invalid;
                              }

                              return null;
                            },
                            onChanged: (_) {},
                          ),

                          SizedBox(height: 1.h),

                          GlobalTextField(
                            controller: vm.commentController,
                            icon: Icons.comment,
                            label: Translations.of(context)!.comment,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return Translations.of(context)!
                                    .comment_Validation;
                              }

                              if (value
                                  .trim()
                                  .length < 2) {
                                return Translations.of(context)!
                                    .name_Validation;
                              }

                              return null;
                            },
                            onChanged: (_) {},
                          ),

                          SizedBox(height: 3.h),

                          AnimatedButton(
                            text: Translations.of(context)!.sendMsg,
                            onTapped: vm.sendMessage,
                          ),

                          SizedBox(height: 5.h),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  Widget _whatsAppCard(
      ConnectUsViewModel vm,
      BuildContext context,
      ) {
    return Card(
      color: const Color(0xFFE8F5E9),
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 2.0.w,
          vertical: 0.5.h,
        ),
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
        title: Text(
          Translations.of(context)!.whatsApp,
          style: Style.MainText14Bold,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Translations.of(context)!.contactWhatsApp,
              style: Style.MainText14,
            ),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 2.0.h,
        ),
        onTap: vm.whatsappNumber.isEmpty ? null : vm.openWhatsApp,
      ),
    );
  }
  Widget _websiteCard(
      ConnectUsViewModel vm,
      BuildContext context,
      ) {
    return Card(
      color: const Color(0xFFE3F2FD),
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 2.0.w,
          vertical: 0.5.h,
        ),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.language,
            color: Colors.blue,
            size: 3.5.h,
          ),
        ),
        title: Text(
          Translations.of(context)!.webSite,
          style: Style.MainText14Bold,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Translations.of(context)!.contactWebSite,
              style: Style.MainText14,
            ),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 2.0.h,
        ),
        onTap: vm.websiteUrl.isEmpty ? null : vm.openWebsite,
      ),
    );
  }
}
