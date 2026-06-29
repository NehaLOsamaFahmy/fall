import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../Constans/Api_Services.dart';
import '../../Constans/Base_Url.dart';
import '../../Localization/Translations.dart';
import '../../Models/EvaluationModel.dart';
import '../../Shared_Data/DelegateData.dart';
import '../../Shared_Data/LanguageData.dart';
import '../../Shared_Data/NetworkCheckData.dart';
import '../../Shared_View/AlertView.dart';

Future<bool?> submitEvaluation(BuildContext context,SubmitEvaluationModel model) async {
  try {
    bool InternetConntected = await hasNetwork();
    if (InternetConntected) {
      try {
        final response = await Post_Data(
          evaluations_store,
          jsonEncode(model.toJson()),
        );

        print(response.body);

        if (response.statusCode == 200) {
          Map valueMap = jsonDecode(response.body);
          if (valueMap['code'] == 200) {
            print( " fn_WalletRequest200 ::: ${valueMap['message']} ${valueMap['data']}");
            await AlertView(context, "success", Translations.of(context)!.Ok,valueMap['data']['message']);
            return  true;
          }
          else {
            await AlertView(
                context, "error", Translations.of(context)!.ErrorTitle,valueMap['data'].toString());
            print( "fn_WalletRequest400 ::: ${valueMap['message']} ${valueMap['data']}");
            return null;
          }
        }
        else {
          await AlertView(
              context, "error", Translations.of(context)!.ErrorTitle,
              "error_statusCode ${response.statusCode} ${response.reasonPhrase}");
          print( "fn_LWalletRequeststatusCode400 ::: ${response.statusCode} ");
          return null;
        }
      } catch (e) {

        return false;
      }
    }
    else {
      await AlertView(
          context, "error", Translations.of(context)!.ErrorTitle,
          Translations.of(context)!.CheckInternet);
      print("fn_ConvertPointsException ::: checkInternet ");
      return null;
    }
  }
  catch (e) {
    await AlertView(
        context, "error", Translations.of(context)!.ErrorTitle,
        "Exception : ${e.toString()}");
    print("fn_ConvertPointsException ::: ${e} ");
    return null;
  }
}
