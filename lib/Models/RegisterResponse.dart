class RegisterResponse {

   String? message;
   bool? requiresVerification;
   String? mobile;
   String? email;
   String? id;
   String? name;
   String? token;

  RegisterResponse({
    this.message,
    this.requiresVerification,
  });

  RegisterResponse.fromJson(Map<String, dynamic> json) {
    requiresVerification = json['requires_verification']??true;
    message = json['message']??"";
    mobile = json['mobile'].toString()??"";
    email = json['email'].toString()??"";
    id = json['id'].toString()??"";
    name = json['name'].toString()??"";
    token = json['token'].toString()??"";
  }
}