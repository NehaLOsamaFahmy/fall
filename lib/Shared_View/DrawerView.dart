
import 'package:flutter/material.dart';
import 'package:babco/Shared_Data/ServicesData.dart';
import 'package:scoped_model/scoped_model.dart';
import '../Localization/ScopeModelWrapper.dart';
import '../Localization/Translations.dart';
import 'package:sizer/sizer.dart';

import '../Constans/Style.dart';
import '../Models/DataModel.dart';
import '../Models/LanguageModel.dart';
import '../Routes/route_constants.dart';
import '../Shared_Data/CompanyData.dart';
import '../Shared_Data/DelegateData.dart';
import '../Shared_Data/LanguageData.dart';

DrawerList(BuildContext context,{int id=0})
{
  return SizedBox(
      width: 70.0.w,

      child: Drawer(child: _drawerList(context,id),
        shape: RoundedRectangleBorder(
          borderRadius:LanguageData.languageData=="ar"? BorderRadius.only(topLeft: Radius.circular(50.0.w)):BorderRadius.only(topRight: Radius.circular(50.0.w))
        ),
      ));

}

 _drawerList(BuildContext context, int id) {
   return Column(
     // padding: EdgeInsets.zero,
     children: <Widget>[

       Container(
         height: 30.0.h,
         decoration: LanguageData.languageData == "ar" ? BoxDecoration(
           gradient: LinearGradient(
               begin: Alignment.topRight,
               end: Alignment.bottomLeft,
               colors: [Style.MainColor, Style.MainColor3]),
           borderRadius: BorderRadius.only(
             topLeft: Radius.circular(50.0.w),
           ),) :
         BoxDecoration(
           gradient: LinearGradient(
               begin: Alignment.topRight,
               end: Alignment.bottomLeft,
               colors: [Style.MainColor, Style.MainColor3]),
           borderRadius: BorderRadius.only(
             topRight: Radius.circular(50.0.w),
           ),),
         padding: LanguageData.languageData == "ar" ? EdgeInsets.fromLTRB(
             5.0.w, 0, 0, 0) : EdgeInsets.fromLTRB(0, 0, 5.0.w, 0),
         child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.stretch,
             children: [
               SizedBox(height: 6.0.h,),
               CircleAvatar(
                 backgroundColor: Style.SecondryColor,
                 radius: 70,
                 child:
                 CircleAvatar(
                   // backgroundImage:   AssetImage('lib/assets/logo.png'),
                   child: Image(image: AssetImage('lib/assets/logo.png'),
                     width: 60.0.w,
                     height: 12.0.h,),
                   radius: 65,
                   backgroundColor: Colors.white,
                 ),),

               SizedBox(height: 2.0.h,),
               Expanded(child: Text(
                 DelegateData.delegateData==null ? " Client ":DelegateData.delegateData!.name==null ? " Client ":DelegateData.delegateData!.name!,
                 style: TextStyle(
                     color: Colors.white, fontSize: 16.0.sp, fontWeight: FontWeight.bold),
                 textAlign: TextAlign.center,

               ),)

             ]
         ),
       ),

       Expanded(child:
       SingleChildScrollView(
         child: Column(
           children: [
             Padding(padding: EdgeInsets.all(1.0.h)),

             Drawer_Items(
                 Icons.home, Translations.of(context)!.Home_page,
                 context, "homeRoute"),
             PopupMenuButton(
                 offset: Offset(-18.0.w, 4.0.h),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     Expanded(child: ListTile(
                       leading: Icon(Icons.settings,size: 4.0.h,color: Style.SecondryColor,),
                       title: Text(
                           Translations.of(context)!.Services,
                           style: TextStyle(
                               color: Style.MainTextColor, fontSize: 16.0.sp, fontWeight: FontWeight.bold)
                       ),),),
                     Icon(Icons.arrow_drop_down, color: Style.MainColor,
                         size: 3.0.h),
                   ],
                 ),
                 itemBuilder: (context) {
                   return NewServicesData.serviceData!.map((DataModel choice) {
                     return PopupMenuItem(
                         value: choice,
                         child: Row(
                             children: [
                               (choice.icon !=null && choice.icon!.length>0) ?
                               Image.network(choice.icon!,
                                 fit: BoxFit.contain,
                                 height: 3.0.h,
                                 width: 5.0.w,
                                 errorBuilder: (context, url, error) => Container(),
                                 loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                   if (loadingProgress == null) return child;
                                   return CircularProgressIndicator(
                                     color: Style.MainColor,
                                   );
                                 },):
                               Image(image: AssetImage('lib/assets/icon10.png'),
                                 width: 5.0.w,
                                 height: 5.0.h,),
                               SizedBox(width: 2.0.w,),
                               Text(choice.name!,
                                   style: TextStyle(
                                       color: Style.MainColor, fontSize: 16.0.sp, fontWeight: FontWeight.bold))
                             ]
                         )
                     );
                   }).toList();
                 },
                 onSelected: (DataModel value) {

                   Navigator.pushNamed(context, NewServiceRoute,arguments: value);
                 },),
             Drawer_Items(Icons.star_rate_outlined, Translations.of(context)!.Service_Evaluation, context, ServicesReviewsRoute),
             Drawer_Items(Icons.handshake_outlined, Translations.of(context)!.Loyalty_System, context, LoyaltySystemRoute),
             Drawer_Items(Icons.wallet, Translations.of(context)!.Electronic_Wallet, context, BalanceRoute),

             Drawer_Items(
                 Icons.assured_workload, Translations.of(context)!.About_us,
                 context, "AboutUsRoute"),
             Drawer_Items(Icons.person_pin_outlined, Translations.of(context)!.Info, context, "PersonInformationRoute"),
             Drawer_Items(
                 Icons.chat, Translations.of(context)!.Connect_us,
                 context, "Connect_usRoute"),
            /* Drawer_Items(
                 "icon11", Translations.of(context)!.Language,
                 context, "LanguageRoute"),*/

             ScopedModelDescendant<AppModel>(
               builder: (context, child, model) =>
               ListTile(
                   leading: Icon(Icons.language,size: 4.0.h,color: Style.SecondryColor,),
                   title: Text(
                       Translations.of(context)!.Language,
                       style: TextStyle(
                           color: Style.MainTextColor, fontSize: 16.0.sp, fontWeight: FontWeight.bold)
                   ),
                   onTap: () async {
                     Navigator.pop(context);
                    await Future.delayed(Duration(milliseconds: 300));
                     model.changeDirection();
                     Navigator.pushNamedAndRemoveUntil(
                       context,
                       homeRoute,
                           (route) => false,
                     );
                   }

               ),
             ),
             if(DelegateData.delegateData!= null && DelegateData.delegateData!.id!>0)
               Drawer_Items(Icons.delete_forever_sharp, Translations.of(context)!.delete_account, context,
                 deleteAccountRoute),
              Drawer_Items((DelegateData.delegateData==null||DelegateData.delegateData!.id!<0)?Icons.login:Icons.logout,
                  (DelegateData.delegateData==null||DelegateData.delegateData!.id!<0)?Translations.of(context)!.Login_btn: Translations.of(context)!.Log_out, context, "loginRoute"),
             Padding(padding: EdgeInsets.all(3.5.h)),
           ],
         ),
       ),)


       /*  Expanded(
          child: getListItem(context),
        )
*/
     ],
   );
 }

Space(isTablet) {
  return SizedBox(height: isTablet?1.0.h:0.2.h,);
}

Drawer_Items(IconData icon,String name, BuildContext context, String route) {

  bool isTablet = MediaQuery.of(context).size.width > 600;
  return Column(children: [ ListTile(
      leading: Icon(icon, size: 4.0.h, color: Style.SecondryColor,),
      title: Text(
          name,
          style: TextStyle(
              color: Style.MainTextColor,
              fontSize: 16.0.sp,
              fontWeight: FontWeight.bold)
      ),

      onTap: () {
        if (route != null && route.isNotEmpty)
          Drawer_itemTab(context, route);
      }

  ), Space(isTablet),
  ]);
}

ExpansionTile_Items(String name,BuildContext context, String route)
{
  return ListTile(
      leading:  Container( width: 10.0.w, height: 10.0.h,),
      title: Text(
          "- "+name,
          style: TextStyle(
              color: Style.SecondryColor, fontSize: 16.0.sp, fontWeight: FontWeight.bold),
          textAlign: TextAlign.start,
      ),
      dense:true,
   //   contentPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      visualDensity: VisualDensity(horizontal: 0, vertical: -2),
      onTap: ()=>Drawer_itemTab(context,route)

  );
}

Drawer_itemTab( BuildContext context, String route)async
{
 // Navigator.pop(context);

      if (route == "loginRoute") {
        await removeDelgateDate();
       // await removeCompanyDate();
        Navigator.pop(context);
        Navigator.pushNamed(context, "startRoute");
        
      }
      else
        {
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      }



}




