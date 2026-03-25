
import 'package:flutter/material.dart';
import 'package:babco/Localization/Translations.dart';
import 'package:babco/Models/DataModel.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sizer/sizer.dart';

import '../Api/DataApi.dart';
import '../Constans/Style.dart';
import '../Shared_Data/formatDateTime.dart';
import '../Shared_View/AlertView.dart';
import '../Shared_View/AppBarView.dart';
import '../Shared_View/DrawerView.dart';

class NewServicesPage extends StatefulWidget {
  final DataModel data;
  NewServicesPage({required this.data,Key? key}) : super(key: key);

  @override
  _NewServicesPageState createState() => _NewServicesPageState();
}

class _NewServicesPageState extends State<NewServicesPage> {

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    GetData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithBack(
            context, widget.data.name!),
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
        children: [
          SizedBox(height: 4.0.h,),
          (widget.data!.img !=null && widget.data!.img!.length>0) ?
          Image.network(widget.data!.img!,
            fit: BoxFit.contain,
            height: 18.0.h,
            errorBuilder: (context, url, error) => Container(),
            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return CircularProgressIndicator(
                color: Style.MainColor,
              );
            },):Container(),
         // Text(Translations.of(context)!.New_user,style: Style.Secondry16Bold,),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 2.0.h),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  SizedBox(height: 2.0.h,),
                  Container(
                    decoration: Style.BoxDecorationRadius,
                    padding: EdgeInsets.symmetric(vertical: 0.5.h,horizontal: 4.0.w),
                    child: Text(widget.data!.name!, style: Style.MainText14Bold),
                  ),
                  SizedBox(height: 1.0.h,),
            Container(
             // decoration: Style.BoxDecorationRadius,
              padding: EdgeInsets.symmetric(vertical: 0.5.h,horizontal: 4.0.w),
              child:    Row(children: [
                    Expanded(child: Text(widget.data.desc!, style: Style.MainText14,
                    )),
                  ],)),

                ],
              ),

          ),


        ],
      ),
    );
  }

  Future<void> GetData()
  async {
    showLoading();
    print(widget.data.name);
    print(widget.data.desc);
    hideLoading();
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


}