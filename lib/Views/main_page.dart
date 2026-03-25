import 'package:banner_image/banner_image.dart';
import 'package:flutter/material.dart';
import 'package:babco/Models/DataModel.dart';
import 'package:babco/Models/MainModel.dart';
import 'package:babco/Shared_Data/BalancePointData.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:sizer/sizer.dart';

import '../Api/DataApi.dart';
import '../Constans/Style.dart';
import '../Localization/Translations.dart';
import '../Routes/route_constants.dart';
import '../Shared_Data/ServicesData.dart';
import '../Shared_View/AppBarView.dart';
import '../Shared_View/DrawerView.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isLoading = false;

  List<String> list = [];
  List<OffersAndDiscounts> offers=<OffersAndDiscounts>[];

  @override
  void initState() {
    super.initState();
    GetData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithlanguage(
            context, Translations.of(context)!.Home_page),
        drawer: DrawerList(context),
        body:SafeArea(child: LoadingOverlay(
            isLoading: _isLoading,
            opacity: 0.2,
            color: Style.MainColor,
            progressIndicator: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Style.MainColor),),
            child:BodyUI())));
  }

  BodyUI() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         BannerImage(
            itemLength: list.length,
            imageUrlList: list,
            selectedIndicatorColor: Style.MainColor,
            indicatorColor: Colors.black26,
            indicatorPosition: IndicatorPosition.under,
            autoPlay: false,
            aspectRatio: 16 / 9
          ),
          Row(
            children: [
              PointView("main1",Translations.of(context)!.Points_balance,BalancePointData.Point),
              PointView("main2",Translations.of(context)!.Wallet_balance,BalancePointData.Balance),
            ],
          ),

          title(Translations.of(context)!.Service_Evaluation),
          SizedBox(height: 0.5.h,),
          ServicesRate(),
          SizedBox(height: 1.5.h,),
            title(Translations.of(context)!.Offers_discounts),
            SizedBox(height: 0.5.h,),
            Offer(),
          SizedBox(height: 4.0.h,),
        ],
      ),
    );
  }

  PointView(String img, String title, String value) {
   return Expanded(child: Container(
     margin: EdgeInsets.symmetric(horizontal: 2.0.w,vertical: 2.0.h),
     padding: EdgeInsets.symmetric(horizontal: 1.0.w,vertical: 1.0.h),
     decoration: BoxDecoration(
       color: Colors.grey.withOpacity(0.2),
       borderRadius: BorderRadius.all(Radius.circular(10)),

     ),
     child:Row(
       children: [
         Expanded(child: Column(
           children: [
             Text(title,style: Style.MainText12,),
             SizedBox(height: 1.0.h,),
             Text(value,style: Style.MainText12.copyWith(fontWeight: FontWeight.bold),)
           ],
         )),
         Expanded(child: Image.asset("lib/assets/"+img+".png", height: 6.0.h,),)
       ],
     ),
   ));
  }

  title(String t) {
    return Row(
      children: [
        SizedBox(width: 2.0.w,),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Style.SecondryColor
        ),
          height: 3.0.h,
          width: 2.8.w,
        ),
        SizedBox(width: 2.0.w,),
        Expanded(child: Text(t, style: Style.MainText14Bold,))
      ],
    );
  }

  ServicesRate() {

      return InkWell(child:  Container(
        margin: EdgeInsets.only(left: 7.0.w,right: 7.0.w,top: 0,bottom: 2.0.h),
        child:Row(children: [
        Icon(Icons.qr_code_scanner_outlined,size: 3.0.h,color: Style.SecondryColor,),
          SizedBox(width: 2.0.w,),
          Expanded(child:  Text(
          Translations.of(context)!.ScanQrcode,
          style: TextStyle(
              color: Style.MainTextColor,
              fontSize: 16.0.sp,
              fontWeight: FontWeight.bold
          ),
        )),
      ])),
        onTap: (){
        Navigator.pushNamed(context, ServicesReviewsRoute);
        },
      );
  }

  Offer()
  {
    if (offers != null && offers!.length > 0) {
      return SizedBox(  // Wrap with SizedBox to provide fixed height
          height: 12.0.h,    // Adjust this value based on your needs
          child:  ListView.builder(
              scrollDirection: Axis.horizontal,
             // shrinkWrap: true, // Add this to prevent scrolling issues
             // physics: NeverScrollableScrollPhysics(), // Add this since we're inside SingleChildScrollView
              itemCount: offers.length,
              itemBuilder: (BuildContext ctx, index) {
                return InkWell(
                    onTap: (){
                      setState(() {
                        offers.forEach((element) => element.selected = false);
                        offers[index].selected = true;
                      });
                      Navigator.pushNamed(context, NewOfferRoute, arguments: offers[index]);
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 2.0.w,vertical: 0.2.h),
                        margin: EdgeInsets.symmetric(horizontal: 2.0.w),
                        decoration: BoxDecoration(
                            color: Style.WhiteColor,
                            borderRadius: BorderRadius.circular(15.0),
                            border: offers[index].selected!
                                ? Border.all(color: Style.MainColor)
                                : Border.all(color: Style.LightGreyColor),
                            boxShadow: [BoxShadow(
                                color: Style.LightGreyColor.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(7, 7))]
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                             Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(offers[index].name.toString(),style: Style.MainText12,),
                                SizedBox(height: 1.0.h,),
                                Text(offers[index].discountPercentage!+" "+"%",style: Style.MainText12.copyWith(fontWeight: FontWeight.bold),)
                              ],
                            ),
                            SizedBox(width: 4.0.w,),
                           Image.network(offers[index].image!, height: 20.0.h,)
                          ],
                        ),
                    ));
              }));
    }
    else {
      return Center(
        child: Text(
          Translations.of(context)!.NoData,
          style: Style.MainText14Bold
        ),
      );
    }
  }


  Future<void> GetData() async {
    showLoading();
    try {
        var x= await GetServices(context);
        if(x != null && x.length>0) {
          setState(() {
            NewServicesData.serviceData = x;

          });
        }
      }
      catch(e){}
    var xx= await AppMainPageFun(context);
    if(xx != null )
      {
        setState(() {
          list=[];
          for(var y in xx.slideImages!)
            {
              list.add(y.image.toString());
            }
          offers=xx.offersAndDiscounts!;
          BalancePointData.Balance=xx.walletBalance!;
          BalancePointData.Point=xx.pointsBalance!;
        });
      }
    hideLoading();
  }

  void showLoading() {
    setState(() {
      _isLoading = true;
    });
  }
  void hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }




}
