import 'package:flutter_calculator/core/snackbar.dart';
import 'package:flutter_calculator/models/calc_model.dart';
import 'package:flutter_calculator/repo/local_repo.dart';

class CalcController {
  final LocalRepo localRepo;

  CalcController({required this.localRepo});

  Future<List<CalcModel>> getHistory(context) async {
    try {
      List<CalcModel> history = await localRepo.getHistory();
      return history;
    } catch (e) {
      kCommonSnackbar(context, e.toString());
    }
    return [];
  }

  Future<void> addHistoryItem(context, CalcModel calcModel) async {
    try {
      localRepo.addHistoryItem(calcModel);
    } catch (e) {
      kCommonSnackbar(context, e.toString());
    }
  }

  Future<void> clearHistory(context) async {
    try {
      localRepo.clearHistory();
      kCommonSnackbar(context, "History cleared!");
    } catch (e) {
      kCommonSnackbar(context, e.toString());
    }
  }
}
