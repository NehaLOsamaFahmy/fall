
import 'package:babco/Localization/Translations.dart';
import 'package:babco/Views/Evaluation/TabBar.dart';
import 'package:babco/Shared_View/AppBarView.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Constans/Style.dart';
import '../../Models/EvaluationModel.dart';
import '../../Models/PinDataModel.dart';
import '../../ViewModels/EvaluationViewModel/StationEvaluationViewModel.dart';
import 'TabBar.dart';

class StationEvaluationPage extends StatelessWidget {
  const StationEvaluationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StationEvaluationViewModel(),
      child: const _StationEvaluationBody(),
    );
  }
}

class _StationEvaluationBody extends StatefulWidget {
  const _StationEvaluationBody({Key? key}) : super(key: key);

  @override
  State<_StationEvaluationBody> createState() =>
      _StationEvaluationBodyState();
}

class _StationEvaluationBodyState
    extends State<_StationEvaluationBody>
    with SingleTickerProviderStateMixin {

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );

    _animController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StationEvaluationViewModel>().loadStations(context);
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<StationEvaluationViewModel>(
      builder: (context, vm, child) {

        return
          Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBarWithBack(
              context,
              Translations.of(context)!.Service_Evaluation,
            ),
            body: LoadingOverlay(
              isLoading: vm.loading,
                opacity: 0.3,
                color: Style.WhiteColor,
                progressIndicator: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Style.MainColor),),
              child:
              Column(
              children: [

                SizedBox(height: 2.h),

                AnimatedTabBar(
                  tabs: [
                    TabItem(
                      label: Translations.of(context)!.Service_Evaluation,
                      icon: Icons.star_rate_rounded,
                    ),
                    TabItem(
                      label: "QR",
                      icon: Icons.qr_code_scanner,
                    ),
                  ],
                  selectedIndex: vm.currentTab,
                  onTabChanged: (index) => vm.changeTab(index),
                ),

                SizedBox(height: 2.h),

                Expanded(
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 400),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(0.1, 0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: vm.currentTab == 0
                        ? KeyedSubtree(
                            key: ValueKey('eval_tab'),
                            child: _buildEvaluationTab(vm),
                          )
                        : KeyedSubtree(
                            key: ValueKey('qr_tab'),
                            child: _buildQrTab(vm),
                          ),
                  ),
                ),

              ],
            ),)
          );

      },
    );

  }

  Widget _buildQrTab(StationEvaluationViewModel vm) {

    return Stack(
      children: [

        MobileScanner(
          controller: vm.qrScannerController,
          onDetect: (capture) => vm.onQrDetect(context, capture),
        ),

        CustomPaint(
          painter: _QrOverlayPainter(),
          child: Center(
            child: SizedBox(
              width: 65.w,
              height: 65.w,
            ),
          ),
        ),

        Positioned(
          top: 3.h,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 6.w,
                vertical: 1.2.h,
              ),
              decoration: BoxDecoration(
                color: Style.MainColor.withOpacity(0.85),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.qr_code_scanner,
                    color: Colors.white,
                    size: 2.5.h,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    "\u0627\u0645\u0633\u062D \u0631\u0645\u0632 QR \u0644\u0644\u062A\u0642\u064A\u064A\u0645",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        if (vm.qrResult != null)
          Positioned(
            bottom: 5.h,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () => vm.restartQrScanner(),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 1.5.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: Style.LinearGradient1,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Style.MainColor.withOpacity(0.4),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.refresh, color: Colors.white, size: 2.5.h),
                      SizedBox(width: 2.w),
                      Text(
                        "\u0645\u0633\u062D \u0645\u062C\u062F\u062F\u0627\u064B",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

      ],
    );

  }

  Widget _buildEvaluationTab(StationEvaluationViewModel vm) {

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              _buildStationDropdown(vm),

              SizedBox(height: 3.h),

              if (vm.evaluation != null) ...[

                _buildEvaluationHeader(vm),

                SizedBox(height: 3.h),

                ...List.generate(vm.questionCount, (index) {
                  final questionData = vm.getQuestion(index);
                  return _buildQuestionCard(vm, questionData, index);
                }),

                SizedBox(height: 2.h),

                _buildSubmitButton(vm),

                SizedBox(height: 3.h),

              ] else if (!vm.loading)

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.rate_review_outlined,
                        size: 10.h,
                        color: Style.GreyColor.withOpacity(0.3),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        "\u0627\u062E\u062A\u0631 \u0645\u062D\u0637\u0629 \u0623\u0648\u0644\u0627\u064B",
                        style: TextStyle(
                          color: Style.GreyColor,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),

            ],
          ),
        ),
      ),
    );

  }

  Widget _buildStationDropdown(StationEvaluationViewModel vm) {

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 4.w,
        vertical: 1.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "\u0627\u062E\u062A\u0631 \u0627\u0644\u0645\u062D\u0637\u0629",
            style: TextStyle(
              color: Style.MainTextColor,
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 1.h),
          DropdownButtonHideUnderline(
            child: DropdownButton2<PinDataModel>(
              isExpanded: true,
              hint: Text(
                "\u0627\u062E\u062A\u0631 \u0627\u0644\u0645\u062D\u0637\u0629",
                style: TextStyle(
                  color: Style.GreyColor,
                  fontSize: 12.sp,
                ),
              ),
              value: vm.selectedStation,
              items: vm.stations.map((station) {
                return DropdownMenuItem<PinDataModel>(
                  value: station,
                  child: Text(
                    station.name ?? "",
                    style: TextStyle(
                      color: Style.MainTextColor,
                      fontSize: 12.sp,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                vm.selectStation(context, value);
              },
              buttonStyleData: ButtonStyleData(
                height: 6.h,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Style.BorderTextFieldColor,
                  ),
                ),
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 35.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                elevation: 8,
              ),
              iconStyleData: IconStyleData(
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Style.MainColor,
                  size: 3.h,
                ),
              ),
              menuItemStyleData: MenuItemStyleData(
                height: 5.5.h,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
              ),
              selectedItemBuilder: (context) {
                return vm.stations.map((station) {
                  return Text(
                    station.name ?? "",
                    style: TextStyle(
                      color: Style.MainTextColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ],
      ),
    );

  }

  Widget _buildEvaluationHeader(StationEvaluationViewModel vm) {

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: Style.LinearGradient1,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Style.MainColor.withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.assignment_outlined,
            color: Colors.white,
            size: 5.h,
          ),
          SizedBox(height: 1.h),
          Text(
            vm.evaluation!.evaluationName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

  }

  Widget _buildSubmitButton(StationEvaluationViewModel vm) {

    return SizedBox(
      width: double.infinity,
      height: 6.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () async {
          bool success = await vm.submit(context);
          if (success) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "\u062A\u0645 \u0625\u0631\u0633\u0627\u0644 \u0627\u0644\u062A\u0642\u064A\u064A\u0645 \u0628\u0646\u062C\u0627\u062D",
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Style.SecondryColor,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }
          }
        },
        child: Ink(
          decoration: BoxDecoration(
            gradient: Style.LinearGradient1,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Style.MainColor.withOpacity(0.4),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.send, color: Colors.white, size: 2.5.h),
                SizedBox(width: 2.w),
                Text(
                  "\u0625\u0631\u0633\u0627\u0644 \u0627\u0644\u062A\u0642\u064A\u064A\u0645",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }

  Widget _buildQuestionCard(
      StationEvaluationViewModel vm,
      QuestionModel question,
      int index,
      ) {

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                  Style.SecondryColor.withOpacity(0.05),
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
                    gradient: Style.LinearGradient1,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    "${index + 1}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    question.question,
                    style: TextStyle(
                      color: Style.MainTextColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.all(4.w),
            child: _buildQuestionInput(vm, question),
          ),

        ],
      ),
    );

  }

  Widget _buildQuestionInput(
      StationEvaluationViewModel vm,
      QuestionModel question,
      ) {

    switch (question.type) {

      case 1:
        return Row(
          children: [

            Expanded(
              child: GestureDetector(
                onTap: () => vm.setYesNoAnswer(question.questionId, true),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 250),
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  decoration: BoxDecoration(
                    color: question.answer == "true"
                        ? Style.SecondryColor.withOpacity(0.15)
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
                        "\u0646\u0639\u0645",
                        style: TextStyle(
                          color: question.answer == "true"
                              ? Style.SecondryColor
                              : Style.GreyColor,
                          fontSize: 13.sp,
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
                onTap: () => vm.setYesNoAnswer(question.questionId, false),
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
                        "\u0644\u0627",
                        style: TextStyle(
                          color: question.answer == "false"
                              ? Colors.red
                              : Style.GreyColor,
                          fontSize: 13.sp,
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
                ? "\u0627\u0643\u062A\u0628 \u0631\u0633\u0627\u0644\u0629 \u0627\u0644\u0634\u0643\u0631..."
                : "\u0627\u0643\u062A\u0628 \u0627\u0642\u062A\u0631\u0627\u062D\u0643...",
            hintStyle: TextStyle(
              color: Style.GreyColor.withOpacity(0.5),
              fontSize: 12.sp,
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
                color: Style.MainColor,
                width: 1.5,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 1.5.h,
            ),
          ),
          onChanged: (value) {
            vm.setTextAnswer(question.questionId, value);
          },
        );

      case 3:
        return Column(
          children: question.choices.map((choice) {
            final isSelected = question.answer == choice.name;
            return GestureDetector(
              onTap: () => vm.setChoiceAnswer(question.questionId, choice),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 250),
                margin: EdgeInsets.only(bottom: 1.h),
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 1.5.h,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Style.MainColor.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? Style.MainColor
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
                          ? Style.MainColor
                          : Style.GreyColor,
                      size: 2.5.h,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      choice.name,
                      style: TextStyle(
                        color: isSelected
                            ? Style.MainColor
                            : Style.MainTextColor,
                        fontSize: 12.sp,
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
            final selected = question.answer == "${index + 1}";
            return GestureDetector(
              onTap: () => vm.setRateAnswer(
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
              onTap: () => vm.setEmojiAnswer(question.questionId, value),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 250),
                padding: EdgeInsets.all(1.5.h),
                decoration: BoxDecoration(
                  color: selected
                      ? Style.MainColor.withOpacity(0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                  border: selected
                      ? Border.all(
                          color: Style.MainColor.withOpacity(0.3),
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
        return SizedBox();

    }

  }

}

class _QrOverlayPainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {

    final paint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    final scanSize = size.width * 0.65;
    final scanRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: scanSize,
      height: scanSize,
    );

    final clearPaint = Paint()..blendMode = BlendMode.clear;
    canvas.drawRRect(
      RRect.fromRectAndRadius(scanRect, Radius.circular(20)),
      clearPaint,
    );

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawRRect(
      RRect.fromRectAndRadius(scanRect, Radius.circular(20)),
      borderPaint,
    );

    final cornerPaint = Paint()
      ..color = Style.SecondryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final cornerLength = scanSize * 0.15;

    canvas.drawLine(
      scanRect.topLeft,
      Offset(scanRect.left + cornerLength, scanRect.top),
      cornerPaint,
    );
    canvas.drawLine(
      scanRect.topLeft,
      Offset(scanRect.left, scanRect.top + cornerLength),
      cornerPaint,
    );

    canvas.drawLine(
      scanRect.topRight,
      Offset(scanRect.right - cornerLength, scanRect.top),
      cornerPaint,
    );
    canvas.drawLine(
      scanRect.topRight,
      Offset(scanRect.right, scanRect.top + cornerLength),
      cornerPaint,
    );

    canvas.drawLine(
      scanRect.bottomLeft,
      Offset(scanRect.left + cornerLength, scanRect.bottom),
      cornerPaint,
    );
    canvas.drawLine(
      scanRect.bottomLeft,
      Offset(scanRect.left, scanRect.bottom - cornerLength),
      cornerPaint,
    );

    canvas.drawLine(
      scanRect.bottomRight,
      Offset(scanRect.right - cornerLength, scanRect.bottom),
      cornerPaint,
    );
    canvas.drawLine(
      scanRect.bottomRight,
      Offset(scanRect.right, scanRect.bottom - cornerLength),
      cornerPaint,
    );

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

}
