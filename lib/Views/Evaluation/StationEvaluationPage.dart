import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

import '../../Constans/Style.dart';
import '../../Models/EvaluationModel.dart';
import '../../ViewModels/EvaluationViewModel/StationEvaluationViewModel.dart';

class StationEvaluationPage extends StatelessWidget {
  const StationEvaluationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StationEvaluationViewModel(),
      child: const _StationEvaluationBody(),
    );
  }
}class _StationEvaluationBody extends StatefulWidget {
  const _StationEvaluationBody({Key? key}) : super(key: key);

  @override
  State<_StationEvaluationBody> createState() =>
      _StationEvaluationBodyState();
}

class _StationEvaluationBodyState
    extends State<_StationEvaluationBody>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StationEvaluationViewModel>().loadStations(context);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<StationEvaluationViewModel>(
      builder: (context, vm, child) {

        return LoadingOverlay(
          isLoading: vm.loading,
          child: Scaffold(

            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: const Text("تقييم المحطات"),

              bottom: TabBar(
                controller: _tabController,
                onTap: vm.changeTab,
                tabs: const [

                  Tab(
                    icon: Icon(Icons.qr_code_scanner),
                    text: "QR",
                  ),

                  Tab(
                    icon: Icon(Icons.rate_review),
                    text: "تقييم",
                  ),

                ],
              ),
            ),

            body: TabBarView(

              controller: _tabController,

              children: [

                ///=========================
                /// QR TAB
                ///=========================

                Center(
                  child: Icon(
                    Icons.qr_code_scanner,
                    size: 120,
                    color: Colors.grey,
                  ),
                ),

                ///=========================
                /// APP TAB
                ///=========================

                Padding(
                  padding: const EdgeInsets.all(16),

                  child: Column(

                    children: [

                      DropdownButtonFormField(

                        decoration: InputDecoration(

                          labelText: "اختر المحطة",

                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(12),
                          ),

                        ),

                        value: vm.selectedStation,

                        items: vm.stations.map((station) {

                          return DropdownMenuItem(

                            value: station,

                            child: Text(
                              station.name ?? "",
                            ),

                          );

                        }).toList(),

                        onChanged: (value) {

                          vm.selectStation(
                            context,
                            value,
                          );

                        },

                      ),

                      const SizedBox(height: 20),

                      Expanded(

                        child: vm.evaluation == null

                            ? const Center(

                          child: Text(
                            "اختر محطة أولاً",
                          ),

                        )

                            : ListView.builder(

                          itemCount:
                          vm.questionCount,

                          itemBuilder:
                              (context, index) {

                            QuestionModel questionData = vm.getQuestion(index);

                            return Container(

                              margin:
                              const EdgeInsets.only(
                                bottom: 15,
                              ),

                              padding:
                              const EdgeInsets.all(
                                15,
                              ),

                              decoration: BoxDecoration(

                                color: Colors.white,

                                borderRadius:
                                BorderRadius.circular(
                                    12),

                                boxShadow: const [

                                  BoxShadow(
                                    color:
                                    Colors.black12,
                                    blurRadius: 4,
                                  )

                                ],

                              ),

                              child: Column(

                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                                children: [

                                  Text(questionData.question,

                                    style:
                                    const TextStyle(

                                      fontWeight:
                                      FontWeight.bold,

                                      fontSize: 16,

                                    ),

                                  ),

                                  const SizedBox(
                                      height: 15),

                                  QuestionType(vm,questionData),
                                  const SizedBox(height: 15),

                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Style.MainColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      onPressed: () async {
                                        bool success = await vm.submit(context);

                                        if (success) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text("تم إرسال التقييم بنجاح"),
                                            ),
                                          );
                                        }
                                      },
                                      child: const Text(
                                        "إرسال التقييم",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],

                              ),

                            );

                          },

                        ),

                      ),

                    ],

                  ),

                ),

              ],

            ),

          ),

        );

      },

    );

  }


  QuestionType(StationEvaluationViewModel vm, QuestionModel question) {

    switch (question.type) {

    ///=========================
    /// نعم / لا
    ///=========================

      case 1:

        return Row(

          children: [

            Expanded(

              child: RadioListTile<bool>(

                value: true,

                groupValue: question.answer == "true",

                title: const Text("نعم"),

                onChanged: (value) {

                  vm.setYesNoAnswer(
                    question.questionId,
                    true,
                  );

                },

              ),

            ),

            Expanded(

              child: RadioListTile<bool>(

                value: false,

                groupValue: question.answer == "false",

                title: const Text("لا"),

                onChanged: (value) {

                  vm.setYesNoAnswer(
                    question.questionId,
                    false,
                  );

                },

              ),

            ),

          ],

        );

    ///=========================
    /// Text
    ///=========================

      case 2:

      case 6:

        return TextFormField(

          initialValue: question.answer,

          maxLines: 3,

          decoration: InputDecoration(

            hintText: "اكتب هنا",

            border: OutlineInputBorder(

              borderRadius:
              BorderRadius.circular(10),

            ),

          ),

          onChanged: (value) {

            vm.setTextAnswer(

              question.questionId,

              value,

            );

          },

        );

    ///=========================
    /// Radio Choice
    ///=========================

      case 3:

        return Column(

          children:

          question.choices.map((choice) {

            return RadioListTile(

              value: choice.name,

              groupValue: question.answer,

              title: Text(choice.name),

              onChanged: (value) {

                vm.setChoiceAnswer(

                  question.questionId,

                  choice,

                );

              },

            );

          }).toList(),

        );

    ///=========================
    /// Stars
    ///=========================

      case 4:

        return Row(

          mainAxisAlignment:
          MainAxisAlignment.center,

          children: List.generate(

            5,

                (index) {

              final selected =
                  question.answer ==
                      "${index + 1}";

              return IconButton(

                icon: Icon(

                  selected

                      ? Icons.star

                      : Icons.star_border,

                ),

                color: Colors.amber,

                onPressed: () {

                  vm.setRateAnswer(

                    question.questionId,

                    (index + 1).toDouble(),

                  );

                },

              );

            },

          ),

        );

    ///=========================
    /// Emoji
    ///=========================

      case 5:

        final emojis = [

          "😡",

          "🙁",

          "😐",

          "😊",

          "😍"

        ];

        return Row(

          mainAxisAlignment:
          MainAxisAlignment.spaceEvenly,

          children: List.generate(

            emojis.length,

                (index) {

              final value = index + 1;

              final selected =
                  question.answer ==
                      value.toString();

              return InkWell(

                onTap: () {

                  vm.setEmojiAnswer(

                    question.questionId,

                    value,

                  );

                },

                child: AnimatedContainer(

                  duration:
                  const Duration(
                    milliseconds: 250,
                  ),

                  padding:
                  const EdgeInsets.all(8),

                  decoration: BoxDecoration(

                    color: selected

                        ? Colors.orange
                        : Colors.transparent,

                    borderRadius:
                    BorderRadius.circular(30),

                  ),

                  child: Text(

                    emojis[index],

                    style:
                    const TextStyle(

                      fontSize: 30,

                    ),

                  ),

                ),

              );

            },

          ),

        );

      default:

        return const SizedBox();

    }
  }

}