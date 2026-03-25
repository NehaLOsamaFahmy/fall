

import 'package:http/http.dart' as http;

import '../Shared_Data/CompanyData.dart';
import '../Shared_Data/DelegateData.dart';
import 'Base_Url.dart';

Future<http.Response> Post_Data(String api_url, data) {
  var base_url_data= CompanyData.companyData!.petrolstation_base_url;
  var UriData= Uri.parse(base_url_data! + api_url);
 // var token = DelegateData.delegateData!.token;
  print(UriData);
 // print(token);
  print(data);
    return http.post(
        UriData,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
         // 'Authorization': 'Bearer $token',
        },
        body: data
    );
}

Future<http.Response> Get_Data(String api_url, data) {


  var base_url_data= CompanyData.companyData!.petrolstation_base_url;
  var UriData= Uri.parse(base_url_data! + api_url);
 // var token = DelegateData.delegateData!.token;
  print(UriData);
  final newURI = UriData.replace(queryParameters: data);
  print(newURI);
 // print(token);
    return http.get(
      newURI,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
   //     'Authorization': 'Bearer $token',
      },
    );
}