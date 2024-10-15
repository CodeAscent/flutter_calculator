import 'dart:convert';

import 'package:flutter_calculator/calc_model.dart';
import 'package:flutter_calculator/local_storage.dart';

class LocalRepo {
  Future<void> addHistoryItem(CalcModel calcModel) async {
    try {
      List<String>? history = await LocalStorage.pref.getStringList('history');
      if (history == null) {
        history = [];
      }
      history.add(jsonEncode(calcModel));
      await LocalStorage.pref.setStringList('history', history);
      print('-------------> History Item added');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> clearHistory() async {
    try {
      await LocalStorage.pref.remove('history');
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CalcModel>> getHistory() async {
    try {
      List<CalcModel> calcHistory = [];
      List<String>? history = await LocalStorage.pref.getStringList('history');
      print(history);
      if (history == null) {
        history = [];
      }
      for (var items in history) {
        calcHistory.add(CalcModel.fromJson(jsonDecode(items)));
      }
      return calcHistory;
    } catch (e) {
      rethrow;
    }
  }
}
