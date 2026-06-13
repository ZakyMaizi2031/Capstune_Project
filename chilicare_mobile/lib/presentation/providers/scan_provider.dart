import 'package:flutter/material.dart';
import '../../data/models/detection_model.dart';
import '../../data/repositories/api_repository.dart';
import 'dart:io';
import 'dart:typed_data';

class ScanProvider extends ChangeNotifier {
  final _repo = ApiRepository();
  bool isLoading = false;
  DetectionModel? result;
  String? errorMessage;

  // UNTUK MOBILE (File)
  Future<void> detectDisease(File image, int userId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await _repo.predictDisease(image, userId);
      result = DetectionModel.fromJson(response);
    } catch (e) {
      errorMessage = e.toString();
      debugPrint("Error deteksi: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // UNTUK WEB (Bytes)
  Future<void> detectDiseaseFromBytes(Uint8List imageBytes, int userId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await _repo.predictDiseaseFromBytes(imageBytes, userId);
      result = DetectionModel.fromJson(response);
    } catch (e) {
      errorMessage = e.toString();
      debugPrint("Error deteksi web: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
