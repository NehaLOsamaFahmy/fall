
import 'package:babco/Models/EvaluationModel.dart';
import 'package:babco/Models/PinDataModel.dart';
import 'package:flutter/material.dart';

import '../../Api/EvaluationApi/getEvaluation.dart';
import '../../Api/EvaluationApi/submitEvaluation.dart';
import '../../Api/stations_servicesApi.dart';

class StationEvaluationViewModel extends ChangeNotifier {

  /// Loading
  bool loading = false;

  /// Tabs
  int currentTab = 0;

  /// Stations
  List<PinDataModel> stations = [];

  PinDataModel? selectedStation;

  /// Evaluation
  EvaluationModel? evaluation;

  /// Controllers
  final TextEditingController qrController = TextEditingController();

  //----------------------------------------------------
  // Change Tab
  //----------------------------------------------------

  void changeTab(int index) {
    currentTab = index;
    notifyListeners();
  }

  //----------------------------------------------------
  // Load Stations
  //----------------------------------------------------

  Future loadStations(BuildContext context) async {

    loading = true;
    notifyListeners();

    stations = await Allstations(context) ?? [];

    loading = false;
    notifyListeners();
  }

  //----------------------------------------------------
  // Select Station
  //----------------------------------------------------

  Future selectStation(
      BuildContext context,
      PinDataModel? station,
      ) async {

    selectedStation = station;

    notifyListeners();

    if (station == null) {
      evaluation = null;
      notifyListeners();
      return;
    }

    await loadEvaluation(context, station.id!);

  }

  //----------------------------------------------------
  // Load Evaluation
  //----------------------------------------------------

  Future loadEvaluation(
      BuildContext context,
      int stationId,
      ) async {

    loading = true;

    notifyListeners();

    evaluation = await getEvaluation(
      context,
      stationId,
    );

    loading = false;

    notifyListeners();

  }

  //----------------------------------------------------
  // Get Question
  //----------------------------------------------------

  QuestionModel getQuestion(int index) {

    return evaluation!.questions[index];

  }

  //----------------------------------------------------
  // Questions Count
  //----------------------------------------------------

  int get questionCount {

    if (evaluation == null) {
      return 0;
    }

    return evaluation!.questions.length;

  }
  //----------------------------------------------------
  // Yes / No
  //----------------------------------------------------

  void setYesNoAnswer(
      int questionId,
      bool value,
      ) {
    final question = evaluation!.questions.firstWhere(
          (e) => e.questionId == questionId,
    );

    question.answer = value.toString();

    notifyListeners();
  }

  //----------------------------------------------------
  // Text Answer
  //----------------------------------------------------

  void setTextAnswer(
      int questionId,
      String value,
      ) {
    final question = evaluation!.questions.firstWhere(
          (e) => e.questionId == questionId,
    );

    question.answer = value;

    notifyListeners();
  }

  //----------------------------------------------------
  // Radio Choice
  //----------------------------------------------------

  void setChoiceAnswer(
      int questionId,
      ChoiceModel choice,
      ) {
    final question = evaluation!.questions.firstWhere(
          (e) => e.questionId == questionId,
    );

    /// الباك اند طالب اسم الاختيار
    question.answer = choice.name;

    notifyListeners();
  }

  //----------------------------------------------------
  // Stars
  //----------------------------------------------------

  void setRateAnswer(
      int questionId,
      double value,
      ) {
    final question = evaluation!.questions.firstWhere(
          (e) => e.questionId == questionId,
    );

    question.answer = value.toInt().toString();

    notifyListeners();
  }

  //----------------------------------------------------
  // Emoji
  //----------------------------------------------------

  void setEmojiAnswer(
      int questionId,
      int value,
      ) {
    final question = evaluation!.questions.firstWhere(
          (e) => e.questionId == questionId,
    );

    question.answer = value.toString();

    notifyListeners();
  }

  //----------------------------------------------------
  // Get Current Answer
  //----------------------------------------------------

  dynamic getAnswer(int questionId) {

    final question = evaluation!.questions.firstWhere(
          (e) => e.questionId == questionId,
    );

    return question.answer;
  }

  //----------------------------------------------------
  // Is Question Answered
  //----------------------------------------------------

  bool isAnswered(QuestionModel question) {

    if (question.answer == null) {
      return false;
    }

    if (question.answer is String) {
      return question.answer.toString().trim().isNotEmpty;
    }

    return true;
  }

  //----------------------------------------------------
  // Clear Answers
  //----------------------------------------------------

  void clearAnswers() {

    if (evaluation == null) return;

    for (var q in evaluation!.questions) {
      q.answer = null;
    }

    notifyListeners();
  }

  //----------------------------------------------------
  // Get Emoji
  //----------------------------------------------------

  String emojiFace(int value) {

    switch (value) {
      case 1:
        return "😡";

      case 2:
        return "🙁";

      case 3:
        return "😐";

      case 4:
        return "😊";

      case 5:
        return "😍";

      default:
        return "😐";
    }
  }
  //----------------------------------------------------
  // Validate
  //----------------------------------------------------

  bool validateAnswers() {
    if (evaluation == null) {
      return false;
    }

    for (final question in evaluation!.questions) {
      if (question.answer == null) {
        return false;
      }

      if (question.answer is String &&
          question.answer.toString().trim().isEmpty) {
        return false;
      }
    }

    return true;
  }

  //----------------------------------------------------
  // Build Submit Model
  //----------------------------------------------------

  SubmitEvaluationModel buildSubmitModel() {
    return SubmitEvaluationModel(
      evaluationId: evaluation!.evaluationId,
      answers: evaluation!.questions.map((q) {
        return AnswerModel(
          questionId: q.questionId,
          answer: q.answer.toString(),
        );
      }).toList(),
    );
  }

  //----------------------------------------------------
  // Submit
  //----------------------------------------------------

  Future<bool> submit(BuildContext context) async {
    if (evaluation == null) {
      return false;
    }

    if (!validateAnswers()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("برجاء الإجابة على جميع الأسئلة"),
        ),
      );
      return false;
    }

    loading = true;
    notifyListeners();

    final model = buildSubmitModel();

    final result = await submitEvaluation(
      context,
      model,
    );

    loading = false;
    notifyListeners();

    if (result == true) {
      clearAfterSubmit();
      return true;
    }

    return false;
  }

  //----------------------------------------------------
  // Clear
  //----------------------------------------------------

  void clearAfterSubmit() {
    evaluation = null;
    selectedStation = null;

    qrController.clear();

    notifyListeners();
  }

  //----------------------------------------------------
  // Load By QR
  //----------------------------------------------------

  Future<void> loadByQr(
      BuildContext context,
      int stationId,
      ) async {
    selectedStation = stations.cast<PinDataModel?>().firstWhere(
          (e) => e?.id == stationId,
      orElse: () => null,
    );

    notifyListeners();

    await loadEvaluation(
      context,
      stationId,
    );
  }

  //----------------------------------------------------
  // Dispose
  //----------------------------------------------------

  @override
  void dispose() {
    qrController.dispose();
    super.dispose();
  }
}