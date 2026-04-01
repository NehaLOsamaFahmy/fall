
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../Constans/Style.dart';
import '../Localization/Translations.dart';
import '../Shared_View/AnimatedButton.dart';
import '../Shared_View/AppBarView.dart';
import '../Shared_View/DrawerView.dart';
import '../ViewModel/LoginViewModel.dart';

class deleteAccountPage extends StatefulWidget {
  @override
  _deleteAccountState createState() => _deleteAccountState();
}

class _deleteAccountState extends State<deleteAccountPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithBack(
            context, Translations.of(context)!.delete_account),
        drawer: DrawerList(context),
        body: Consumer<LoginViewModel>(
            builder: (context, viewModel, child) {
              return LoadingOverlay(
                  isLoading: viewModel.loading,
                  opacity: 0.2,
                  color: Style.MainColor,
                  progressIndicator: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Style.MainColor),),
                  child: Padding(
                    padding:  EdgeInsets.symmetric(vertical: 2.0.h,horizontal: 5.0.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                         Text(
                           Translations.of(context)!.warning,
                          style: Style.MainText18Bold.copyWith(color: Colors.red),
                        ),
                         SizedBox(height: 2.0.h),
                         Text(
                           Translations.of(context)!.delete_msg,
                          style: Style.MainText16Bold,
                        ),
                        SizedBox(height: 5.0.h),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 14.0.w),
                            child:
                            AnimatedButton(text:Translations.of(context)!.delete_msg1,onTapped: () => _showDeleteDialog(context, viewModel, child)))

                      ],
                    ),));
            }));
  }

 Future< void> _showDeleteDialog(BuildContext context, LoginViewModel viewModel, Widget? child) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title:  Text(Translations.of(context)!.delete_msg2,style:Style.MainText16Bold ,),
        content:  Text(Translations.of(context)!.delete_msg3,style:Style.MainText16Bold ,),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:  Text(Translations.of(context)!.cancel,style: Style.MainText16Bold,),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              viewModel.deleteAccount(context);
            },
            child: Text(Translations.of(context)!.delete_account,style: Style.Header4),
          ),
        ],
      ),
    );
  }



}