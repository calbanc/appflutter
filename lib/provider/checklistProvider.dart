import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CheckListProvider extends ChangeNotifier {
  bool _brazonok = false;
  set brazonok(bool value) {
    _brazonok = value;
    notifyListeners();
  }

  bool get brazonok => _brazonok;

  bool _helicesok = false;
  set helicesok(bool value) {
    _helicesok = value;
    notifyListeners();
  }

  bool get helicesok => _helicesok;

  bool _maletaok = false;
  set maletaok(bool value) {
    _maletaok = value;
    notifyListeners();
  }

  bool get maletaok => _maletaok;

  bool _gimbalok = false;
  set gimbalok(bool value) {
    _gimbalok = value;
    notifyListeners();
  }

  bool get gimbalok => _gimbalok;

  final ImagePicker _picker = ImagePicker();
  final List<XFile> _fotos = [];

  List<XFile> get fotos => List.unmodifiable(_fotos);

  Future<void> tomarFoto() async {
    final XFile? foto = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70, // opcional
    );

    if (foto != null) {
      _fotos.add(foto);
      notifyListeners();
    }
  }

  void limpiarFotos() {
    _fotos.clear();
    notifyListeners();
  }

  bool get todoOk => _brazonok && _helicesok && _maletaok && _gimbalok;
}
