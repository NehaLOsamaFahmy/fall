
import 'package:flutter/material.dart';
import 'package:babco/Shared_Data/LanguageData.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart' as intl;
import '../Constans/Style.dart';

class GlobalTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final Function(String) onChanged;
  final String? hint;
  final bool? password;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final IconData? icon;

  const GlobalTextField({
    Key? key,
    required this.controller,
    required this.label,
    required this.onChanged,
     this.hint,
     this.password,
    this.keyboardType,
    this.validator,this.icon
  }) : super(key: key);

  @override
  _GlobalTextFieldState createState() => _GlobalTextFieldState();
}

class _GlobalTextFieldState extends State<GlobalTextField> {
  @override
  void initState() {
    super.initState();

    textDirection= (widget.controller!=null
        && widget.controller.text !=null && widget.controller.text.isNotEmpty)?
    intl.Bidi.detectRtlDirectionality(widget.controller.text)? TextDirection.rtl:
    TextDirection.ltr:LanguageData.languageData=="ar"?TextDirection.rtl:TextDirection.ltr;

    print("*****_GlobalTextField "+widget.controller.text);
  }

  TextDirection textDirection= LanguageData.languageData=="ar"?TextDirection.rtl:TextDirection.ltr;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 2.0.w),
      //  padding: EdgeInsets.symmetric(vertical: 0.0.h, horizontal: 3.0.w),
        decoration:BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.transparent, width: 1.0),
            boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.7),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(2, 4))
            ],
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(5.0),
            topRight: const Radius.circular(5.0),
            bottomRight: const Radius.circular(5.0),
            bottomLeft: const Radius.circular(5.0),
          ),
        ),
        child:  Theme(
        data: Theme.of(context).copyWith(primaryColor: Style.SecondryColor),
       child: TextFormField(
         textDirection: textDirection,
         scrollPadding: EdgeInsets.only(bottom:MediaQuery.of(context).viewInsets.bottom),
         autovalidateMode :AutovalidateMode.onUserInteraction,
         controller: widget.controller,
         cursorErrorColor: Style.SecondryColor,
         cursorColor: Style.SecondryColor,
         style: TextStyle(color: Style.MainTextColor,fontSize: 16.0.sp,fontWeight: FontWeight.bold),
         obscureText: widget.password??false,
         keyboardType: widget.keyboardType??TextInputType.emailAddress,
         decoration: InputDecoration(
           isDense: true,
           contentPadding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 2.0.w),
           prefixIcon:Icon(widget.icon!, size: 3.0.h,color: Style.SecondryColor,) ,
           // icon: Icon(Icons.home_work_outlined, size: 3.0.h,color: Style.SecondryColor,),
           //  border: InputBorder.none,
             labelText: widget.label,
             labelStyle:TextStyle(color: Style.MainTextColor,fontSize: 16.0.sp,fontWeight: FontWeight.bold),
             hintStyle: TextStyle(color: Style.MediumGreyColor,fontSize: 16.0.sp,),
             hintText: widget.hint??"",
            errorStyle: TextStyle(color: Style.MainTextColor,fontSize: 16.0.sp,).copyWith(color:Style.MainTextColor),
           border: OutlineInputBorder(),
           focusedBorder: OutlineInputBorder(
             borderSide: BorderSide(color: Style.BorderTextFieldFocusedColor, width: 1.0), // Border when focused
           ),
           enabledBorder: OutlineInputBorder(
             borderSide: BorderSide(color: Style.BorderTextFieldColor, width: 1.0), // Border when enabled
           ),
           errorBorder: OutlineInputBorder(
             borderSide: BorderSide(color:Style.MainTextColor, width: 1.0), // Border when there's an error
           ),
           focusedErrorBorder: OutlineInputBorder(
             borderSide: BorderSide(color:Style.MainTextColor, width: 1.0), // Border when there's an error
           ),
         ),
         validator: widget.validator,
         onEditingComplete: () {
           FocusScope.of(context).unfocus();
         },
      onChanged: (value) {
           print("GlobalTextField  "+ value);
        if(value != null && value.isNotEmpty)
        {
          setState(() {
            if(intl.Bidi.detectRtlDirectionality(value))
              {
                textDirection=TextDirection.rtl;
              }
            else
              {
                textDirection= TextDirection.ltr;
              }
          });
        }
        // Call the onChanged function passed from the parent
        widget.onChanged(value);
      },
    )));
  }
}