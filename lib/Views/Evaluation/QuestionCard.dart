
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../Constans/Style.dart';
import '../../Localization/Translations.dart';
import '../../Models/EvaluationModel.dart';

class QuestionCard extends StatelessWidget {

  final QuestionModel question;
  final int index;
  final void Function(int questionId, bool value) onYesNoAnswer;
  final void Function(int questionId, String value) onTextAnswer;
  final void Function(int questionId, ChoiceModel choice) onChoiceAnswer;
  final void Function(int questionId, double value) onRateAnswer;
  final void Function(int questionId, int value) onEmojiAnswer;

  const QuestionCard({
    Key? key,
    required this.question,
    required this.index,
    required this.onYesNoAnswer,
    required this.onTextAnswer,
    required this.onChoiceAnswer,
    required this.onRateAnswer,
    required this.onEmojiAnswer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 1.2.h,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Style.MainColor.withOpacity(0.1),
                  Style.MainColor.withOpacity(0.4),
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 3.h,
                  height: 3.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: Style.Tab,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                      "${index + 1}",
                      style: Style.Header7
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                      question.question,
                      style: Style.MainText15Bold
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.all(4.w),
            child: _buildQuestionInput(context),
          ),

        ],
      ),
    );

  }

  Widget _buildQuestionInput(BuildContext context) {

    switch (question.type) {

      case 1:
        return Row(
          children: [

            Expanded(
              child: GestureDetector(
                onTap: () => onYesNoAnswer(question.questionId, true),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 250),
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  decoration: BoxDecoration(
                    color: question.answer == "true"
                        ? Style.SecondryColor.withOpacity(0.05)
                        : Colors.grey.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: question.answer == "true"
                          ? Style.SecondryColor
                          : Colors.grey.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        question.answer == "true"
                            ? Icons.check_circle
                            : Icons.check_circle_outline,
                        color: question.answer == "true"
                            ? Style.SecondryColor
                            : Style.GreyColor,
                        size: 2.5.h,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        Translations.of(context)!.yes,
                        style: TextStyle(
                          color: question.answer == "true"
                              ? Style.SecondryColor
                              : Style.GreyColor,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(width: 3.w),

            Expanded(
              child: GestureDetector(
                onTap: () => onYesNoAnswer(question.questionId, false),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 250),
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  decoration: BoxDecoration(
                    color: question.answer == "false"
                        ? Colors.red.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: question.answer == "false"
                          ? Colors.red
                          : Colors.grey.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        question.answer == "false"
                            ? Icons.cancel
                            : Icons.cancel_outlined,
                        color: question.answer == "false"
                            ? Colors.red
                            : Style.GreyColor,
                        size: 2.5.h,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        Translations.of(context)!.no,
                        style: TextStyle(
                          color: question.answer == "false"
                              ? Colors.red
                              : Style.GreyColor,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          ],
        );

      case 2:
      case 6:
        return TextFormField(
          initialValue: question.answer,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: question.type == 6
                ? Translations.of(context)!.writeThanksMessage
                : Translations.of(context)!.writeSuggestion,
            hintStyle: TextStyle(
              color: Style.GreyColor.withOpacity(0.8),
              fontSize: 15.sp,
            ),
            filled: true,
            fillColor: Colors.grey.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Style.SecondryColor,
                width: 1.5,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 1.5.h,
            ),
          ),
          onChanged: (value) {
            onTextAnswer(question.questionId, value);
          },
        );

      case 3:
        return Column(
          children: question.choices.map((choice) {
            final isSelected = question.answer == choice.name;
            return GestureDetector(
              onTap: () => onChoiceAnswer(question.questionId, choice),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 250),
                margin: EdgeInsets.only(bottom: 1.h),
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 1.5.h,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Style.SecondryColor.withOpacity(0.05)
                      : Colors.grey.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? Style.SecondryColor
                        : Colors.grey.withOpacity(0.15),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: isSelected
                          ? Style.SecondryColor
                          : Style.GreyColor,
                      size: 2.5.h,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      choice.name,
                      style: TextStyle(
                        color: isSelected
                            ? Style.SecondryColor
                            : Style.MainTextColor,
                        fontSize: 15.sp,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );

      case 4:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final rating = int.tryParse(question.answer ?? "0") ?? 0;
            final selected = index + 1 <= rating;
            return GestureDetector(
              onTap: () => onRateAnswer(
                question.questionId,
                (index + 1).toDouble(),
              ),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                child: Icon(
                  selected ? Icons.star : Icons.star_border,
                  color: selected
                      ? Colors.amber
                      : Colors.amber.withOpacity(0.3),
                  size: selected ? 4.5.h : 4.h,
                ),
              ),
            );
          }),
        );

      case 5:
        final emojis = ["\u{1F621}", "\u{1F641}", "\u{1F610}", "\u{1F60A}", "\u{1F60D}"];
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(emojis.length, (index) {
            final value = index + 1;
            final selected = question.answer == value.toString();
            return GestureDetector(
              onTap: () => onEmojiAnswer(question.questionId, value),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 250),
                padding: EdgeInsets.symmetric(horizontal: 2.0.w,vertical: 0.0.h),
                decoration: BoxDecoration(
                  color: selected
                      ? Style.SecondryColor.withOpacity(0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                  border: selected
                      ? Border.all(
                    color: Style.SecondryColor.withOpacity(0.3),
                    width: 2,
                  )
                      : null,
                ),
                child: Text(
                  emojis[index],
                  style: TextStyle(
                    fontSize: selected ? 4.h : 3.5.h,
                  ),
                ),
              ),
            );
          }),
        );

      default:
        return TextFormField(
          initialValue: question.answer,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: Translations.of(context)!.writeSuggestion,
            hintStyle: TextStyle(
              color: Style.GreyColor.withOpacity(0.8),
              fontSize: 15.sp,
            ),
            filled: true,
            fillColor: Colors.grey.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Style.SecondryColor,
                width: 1.5,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 1.5.h,
            ),
          ),
          onChanged: (value) {
            onTextAnswer(question.questionId, value);
          },
        );

    }

  }

}
