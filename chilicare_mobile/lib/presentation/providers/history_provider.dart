import 'package:flutter/material.dart';
import '../../../data/models/history_model.dart';

import '../../data/repositories/api_repository.dart';

class HistoryProvider extends ChangeNotifier {
  final ApiRepository _repo = ApiRepository();

  bool isLoading = false;
  String? errorMessage;

  List<HistoryModel> myHistory = [];

  Future<void> fetchMyHistory(int userId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final logs = await _repo.getHistoryMonitor();

      final filtered = logs.where((e) => (e['id_user'] as num?)?.toInt() == userId).toList();

      myHistory = filtered
          .map((e) => HistoryModel.fromJson(e as Map<String, dynamic>))
          .toList()
        ..sort(
          (a, b) => b.tanggalDeteksi.compareTo(a.tanggalDeteksi),
        );

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
    }
  }
}

