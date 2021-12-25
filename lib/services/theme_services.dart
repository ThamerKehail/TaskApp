import 'package:flutter/material(1).dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeServices {
  final GetStorage _box = GetStorage();
  final _key = 'isDarkMode';

  _SaveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  bool _loadThemeFormBox() => _box.read<bool>(_key) ?? false;

  ThemeMode get theme => _loadThemeFormBox() ? ThemeMode.dark : ThemeMode.light;

  void switchTheme() {
    Get.changeThemeMode(_loadThemeFormBox() ? ThemeMode.light : ThemeMode.dark);
    _SaveThemeToBox(!_loadThemeFormBox());
  }
}
