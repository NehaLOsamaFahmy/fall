import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../Constans/Api_Services.dart';
import '../Constans/Base_Url.dart';
import '../Localization/Translations.dart';
import '../Models/CompanyModel.dart';
import '../Models/DelegateDataModel.dart';
import '../Shared_Data/CompanyData.dart';
import '../Shared_Data/DelegateData.dart';
import '../Shared_Data/LanguageData.dart';
import '../Shared_Data/NetworkCheckData.dart';
import '../Shared_View/AlertView.dart';

Future<DelegateDataModel?> Login(BuildContext context,String mobile ) async {
  try {
    bool InternetConntected = await hasNetwork();
    if (InternetConntected) {
  try {
    var lang= LanguageData.languageData;
    print(lang);
    var data = jsonEncode(<String, String>{
      'mobile': mobile,
      "lang": lang,
    });

    final response = await Post_Data(login, data);
    print(response.body);
  //  if (response.statusCode == 200) {
      Map valueMap = jsonDecode(response.body);
      if (valueMap['code'] == 200) {
        print( " fn_Login200 ::: ${valueMap['message']} ${valueMap['data']}");
        var obj= DelegateDataModel.fromJson(valueMap['data']);
      //  await saveDelegateData(obj);

        return obj;
      }
      else {
          await AlertView(
              context, "error", Translations.of(context)!.ErrorTitle,valueMap['message'].toString());
        print( "fn_Login400 ::: ${valueMap['message']} ${valueMap['data']}");
        return null;
      }
    /*}
    else {
    await AlertView(
          context, "error", Translations.of(context)!.ErrorTitle,
          "error_statusCode ${response.statusCode} ${response.reasonPhrase}");
      print( "fn_LoginstatusCode400 ::: ${response.statusCode} ");
      return null;
    }*/
  }
  catch(e)
  {
    await AlertView(
        context, "error", Translations.of(context)!.ErrorTitle,
        "Exception : ${e.toString()}");
    print( "fn_LoginException ::: ${e} ");
    return null;
  }
}
    else {
      await AlertView(
          context, "error", Translations.of(context)!.ErrorTitle,
          Translations.of(context)!.CheckInternet);
      print("fn_LoginException ::: checkInternet ");
      return null;
    }
  }
  catch (e) {
    await AlertView(
        context, "error", Translations.of(context)!.ErrorTitle,
        "Exception : ${e.toString()}");
    print("fn_LoginException ::: ${e} ");
    return null;
  }
}

Future<bool?> Registration(BuildContext context,String mobile ,String first_name, String last_name,String email) async {
  try {
    bool InternetConntected = await hasNetwork();
    if (InternetConntected) {
      try {
        var lang= LanguageData.languageData;
        print(lang);
        var data = jsonEncode(<String, String>{
          'mobile': mobile,
          "first_name":first_name,
        "last_name":last_name,
        "email":email,
          "lang": lang,
        });
        final response = await Post_Data(registration, data);
        print(response.body);
      //  if (response.statusCode == 200) {
          Map valueMap = jsonDecode(response.body);
          if (valueMap['code'] == 200) {
            print( " fn_Registration200 ::: ${valueMap['message']} ${valueMap['data']}");
            await AlertView(
                context, "success", Translations.of(context)!.Ok,Translations.of(context)!.success_msg);
            return true;
          }
          else {
            await AlertView(
                context, "error", Translations.of(context)!.ErrorTitle,valueMap['message'].toString());
            print( "fn_Registration400 ::: ${valueMap['message']} ${valueMap['data']}");
            return false;
          }
      /*  }
        else {
          await AlertView(
              context, "error", Translations.of(context)!.ErrorTitle,
              "error_statusCode ${response.statusCode} ${response.reasonPhrase}");
          print( "fn_LRegistrationstatusCode400 ::: ${response.statusCode} ");
          return false;
        }*/
      }
      catch(e)
      {
        await AlertView(
            context, "error", Translations.of(context)!.ErrorTitle,
            "Exception : ${e.toString()}");
        print( "fn_RegistrationException ::: ${e} ");
        return false;
      }
    }
    else {
      await AlertView(
          context, "error", Translations.of(context)!.ErrorTitle,
          Translations.of(context)!.CheckInternet);
      print("fn_RegistrationException ::: checkInternet ");
      return false;
    }
  }
  catch (e) {
    await AlertView(
        context, "error", Translations.of(context)!.ErrorTitle,
        "Exception : ${e.toString()}");
    print("fn_RegistrationException ::: ${e} ");
    return false;
  }
}

Future<DelegateDataModel?> Verifycode(BuildContext context,String mobile ,String code) async {
  try {
    bool InternetConntected = await hasNetwork();
    if (InternetConntected) {
      try {
        var lang= LanguageData.languageData;
        print(lang);
        var data = jsonEncode(<String, String>{
          'mobile': mobile,
          "code":code,
          "lang": lang,
        });
        final response = await Post_Data(verifycode, data);
        print(response.body);
     //   if (response.statusCode == 200) {
          Map valueMap = jsonDecode(response.body);
          if (valueMap['code'] == 200) {
            print( " fn_Verifycode200 ::: ${valueMap['message']} ${valueMap['data']}");
            var obj= DelegateDataModel.fromJson(valueMap['data']);
             await saveDelegateData(obj);

            return obj;
          }
          else {
            await AlertView(
                context, "error", Translations.of(context)!.ErrorTitle,valueMap['message'].toString());
            print( "fn_Verifycode400 ::: ${valueMap['message']} ${valueMap['data']}");
            return null;
          }
      /*  }
        else {
          await AlertView(
              context, "error", Translations.of(context)!.ErrorTitle,
              "error_statusCode ${response.statusCode} ${response.reasonPhrase}");
          print( "fn_VerifycodestatusCode400 ::: ${response.statusCode} ");
          return null;
        }*/
      }
      catch(e)
      {
        await AlertView(
            context, "error", Translations.of(context)!.ErrorTitle,
            "Exception : ${e.toString()}");
        print( "fn_VerifycodeException ::: ${e} ");
        return null;
      }
    }
    else {
      await AlertView(
          context, "error", Translations.of(context)!.ErrorTitle,
          Translations.of(context)!.CheckInternet);
      print("fn_VerifycodeException ::: checkInternet ");
      return null;
    }
  }
  catch (e) {
    await AlertView(
        context, "error", Translations.of(context)!.ErrorTitle,
        "Exception : ${e.toString()}");
    print("fn_VerifycodeException ::: ${e} ");
    return null;
  }
}

Future<DelegateDataModel?> EditCustomer(BuildContext context,String mobile ,String first_name,String email) async {
  try {
    bool InternetConntected = await hasNetwork();
    if (InternetConntected) {
      try {
        var lang= LanguageData.languageData;
        print(lang);
        var data = jsonEncode(<String, String>{
          'phone': mobile,
          "name":first_name,
          "email":email,
          "lang": lang,
        });
        final response = await Post_Data(editcustomer+"/"+DelegateData.delegateData!.id!.toString(), data);
        print(response.body);
      //  if (response.statusCode == 200) {
          Map valueMap = jsonDecode(response.body);
          if (valueMap['code'] == 200) {
            print( " fn_Registration200 ::: ${valueMap['message']} ${valueMap['data']}");
            await AlertView(
                context, "success", Translations.of(context)!.Ok,Translations.of(context)!.success_msg);
            DelegateDataModel x= DelegateDataModel(id: valueMap['data']['id'],name: valueMap['data']['name'],
                mobile:   valueMap['data']['phone'],email: valueMap['data']['email']);
            saveDelegateData(x);
            return x;
          }
          else {
            await AlertView(
                context, "error", Translations.of(context)!.ErrorTitle,valueMap['message'].toString());
            print( "fn_Registration400 ::: ${valueMap['message']} ${valueMap['data']}");
            return null;
          }
       /* }
        else {
          await AlertView(
              context, "error", Translations.of(context)!.ErrorTitle,
              "error_statusCode ${response.statusCode} ${response.reasonPhrase}");
          print( "fn_LRegistrationstatusCode400 ::: ${response.statusCode} ");
          return null;
        }*/
      }
      catch(e)
      {
        await AlertView(
            context, "error", Translations.of(context)!.ErrorTitle,
            "Exception : ${e.toString()}");
        print( "fn_RegistrationException ::: ${e} ");
        return null;
      }
    }
    else {
      await AlertView(
          context, "error", Translations.of(context)!.ErrorTitle,
          Translations.of(context)!.CheckInternet);
      print("fn_RegistrationException ::: checkInternet ");
      return null;
    }
  }
  catch (e) {
    await AlertView(
        context, "error", Translations.of(context)!.ErrorTitle,
        "Exception : ${e.toString()}");
    print("fn_RegistrationException ::: ${e} ");
    return null;
  }
}



Future<CompanyModel?> StartToLogin(BuildContext context,String id) async {
  try {
    bool InternetConntected = await hasNetwork();
    if (InternetConntected) {
      try {

        var base_url_data= company_base_url+id;
        var UriData= Uri.parse(base_url_data);
        print(UriData);
        final response = await http.get(
          UriData,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
        print(response.body);
        if (response.statusCode == 200) {
          Map valueMap = jsonDecode(response.body);
          if (valueMap['code'] == 200) {
            print( " fn_Login200 ::: ${valueMap['message']} ${valueMap['data']}");
            var obj= CompanyModel.fromJson(valueMap['data']);
            await saveCompanyData(obj);

            return obj;
          }
          else {
            if (valueMap['error'] != null)
              await AlertView(
                  context, "error", Translations.of(context)!.ErrorTitle,
                  valueMap['error'].toString());
            else
              await AlertView(
                  context, "error", Translations.of(context)!.ErrorTitle,
                  valueMap['message'].toString());
            print( "fn_Login400 ::: ${valueMap['message']} ${valueMap['data']}");
            return null;
          }
        }
        else {
          await AlertView(
              context, "error", Translations.of(context)!.ErrorTitle,
              "error_statusCode ${response.statusCode} ${response.reasonPhrase}");
          print( "fn_LoginstatusCode400 ::: ${response.statusCode} ");
          return null;
        }
      }
      catch(e)
      {
        await AlertView(
            context, "error", Translations.of(context)!.ErrorTitle,
            "Exception : ${e.toString()}");
        print( "fn_LoginException ::: ${e} ");
        return null;
      }
    }
    else {
      await AlertView(
          context, "error", Translations.of(context)!.ErrorTitle,
          Translations.of(context)!.CheckInternet);
      print("fn_LoginException ::: checkInternet ");
      return null;
    }
  }
  catch (e) {
    await AlertView(
        context, "error", Translations.of(context)!.ErrorTitle,
        "Exception : ${e.toString()}");
    print("fn_LoginException ::: ${e} ");
    return null;
  }
}