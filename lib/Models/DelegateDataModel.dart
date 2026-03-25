
import 'package:shared_preferences/shared_preferences.dart';

class DelegateDataModel {
  int? id;
  String? name;
  String? mobile;
  String? email;

  DelegateDataModel({this.id, this.name, this.mobile, this.email});

  DelegateDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mobile = json['mobile'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    return data;
  }
}


