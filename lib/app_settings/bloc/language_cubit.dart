import 'package:courier_app/app_config/app_config.dart';
import 'package:courier_app/app_settings/data/app_settings_local_data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit() : super(const Locale(AppConfig.defaultLanguage));

  final AppSettingsLocalDataSource _source = AppSettingsLocalDataSource();

  void _selectLanguage(String languageCode) {
    emit(Locale(languageCode));
  }

  void getCurrentLanguage() async {
    String? languageCode = await _source.getCurrentLanguage();
    languageCode ??= AppConfig.defaultLanguage;
    _selectLanguage(languageCode);
  }

  void setCurrentLanguage(String languageCode) async {
    await _source.setCurrentLanguage(languageCode);
    _selectLanguage(languageCode);
  }
}
