
import 'package:babco/Localization/Translations.dart';
import 'package:babco/Shared_View/AnimatedButton.dart';
import 'package:babco/Shared_View/DropDownView.dart';
import 'package:babco/Views/Evaluation/QuestionCard.dart';
import 'package:babco/Views/Evaluation/TabBar.dart';
import 'package:babco/Shared_View/AppBarView.dart';
import 'package:babco/Views/Evaluation/QrScannerView.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Constans/Style.dart';
import '../../Models/ServicesModel.dart';
import '../../Shared_View/DrawerView.dart';
import '../../ViewModels/EvaluationViewModel/ServiceEvaluationViewModel.dart';

class ServiceEvaluationPage extends StatelessWidget {
  const ServiceEvaluationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ServiceEvaluationViewModel(),
      child: const _ServiceEvaluationBody(),
    );
  }
}

class _ServiceEvaluationBody extends StatefulWidget {
  const _ServiceEvaluationBody({Key? key}) : super(key: key);

  @override
  State<_ServiceEvaluationBody> createState() =>
      _ServiceEvaluationBodyState();
}

class _ServiceEvaluationBodyState
    extends State<_ServiceEvaluationBody> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServiceEvaluationViewModel>().loadServices(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<ServiceEvaluationViewModel>(
      builder: (context, vm, child) {

        return
          Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBarWithBack(
              context,
              Translations.of(context)!.Service_Evaluation,
            ),
            drawer: DrawerList(context),
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

                Flexible(
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
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

  Widget _buildQrTab(ServiceEvaluationViewModel vm) {
    return QrScannerView(
      controller: vm.qrScannerController,
      onDetect: (capture) => vm.onQrDetect(context, capture),
      scannedResult: vm.qrResult,
      onRestart: () => vm.restartQrScanner(),
    );

  }

  Widget _buildEvaluationTab(ServiceEvaluationViewModel vm) {

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildServiceDropdown(vm),

          SizedBox(height: 3.h),

          if (vm.evaluation != null) ...[


            ...List.generate(vm.questionCount, (index) {
              final questionData = vm.getQuestion(index);
              return QuestionCard(
                question: questionData,
                index: index,
                onYesNoAnswer: vm.setYesNoAnswer,
                onTextAnswer: vm.setTextAnswer,
                onChoiceAnswer: vm.setChoiceAnswer,
                onRateAnswer: vm.setRateAnswer,
                onEmojiAnswer: vm.setEmojiAnswer,
              );
            }),

            SizedBox(height: 2.h),

            _buildSubmitButton(vm),

            SizedBox(height: 3.h),

          ]

        ],
      ),
    );

  }

  Widget _buildServiceDropdown(ServiceEvaluationViewModel vm) {

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
            color: Colors.black.withOpacity(0.25),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child:  CustomDropdownButton2<ServicesModel>(
          hint: Translations.of(context)!.SelectServices,
          value: vm.selectedService,
          dropdownWidth: 60.0.w,
          dropdownItems: vm.services,
          onChanged: (ServicesModel? value) {
            vm.selectService(context,value);
          },
        )
    );

  }


  Widget _buildSubmitButton(ServiceEvaluationViewModel vm) {
    return AnimatedButton(
      text: Translations.of(context)!.send,
      onTapped: () async {
        await vm.submit(context);
      },
    );
  }

}
