import 'package:courier_app/app_config/app_config.dart';
import 'package:courier_app/app_settings/bloc/language_cubit.dart';
import 'package:courier_app/locale/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageSheet extends StatefulWidget {
  const LanguageSheet({super.key});

  @override
  State<LanguageSheet> createState() => _LanguageSheetState();
}

class _LanguageSheetState extends State<LanguageSheet> {
  final ScrollController _controller = ScrollController();
  late LanguageCubit _languageCubit;

  String? selectedLocale;

  @override
  void initState() {
    super.initState();
    _languageCubit = context.read<LanguageCubit>()..getCurrentLanguage();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              AppLocalizations.of(context).changeLanguage,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge!.copyWith(color: Colors.black),
            ),
            // backgroundColor: theme.scaffoldBackgroundColor,
          ),
          Expanded(
            child: BlocBuilder<LanguageCubit, Locale>(
              builder: (context, currentLocale) {
                selectedLocale ??= currentLocale.languageCode;
                return Scrollbar(
                  controller: _controller,
                  child: ListView.builder(
                    controller: _controller,
                    physics: const BouncingScrollPhysics(),
                    itemCount: AppConfig.languagesSupported.length,
                    itemBuilder: (context, index) {
                      var langCode =
                          AppConfig.languagesSupported.keys.elementAt(index);
                      return RadioListTile(
                        title: Text(
                          AppConfig.languagesSupported[langCode]!,
                          style:
                              theme.textTheme.bodyLarge!.copyWith(fontSize: 16),
                        ),
                        value: langCode,
                        groupValue: selectedLocale,
                        onChanged: (langCode) async {
                          setState(() {
                            selectedLocale = langCode as String;
                          });
                        },
                        activeColor: theme.primaryColor,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.primaryColor,
        onPressed: () {
          _languageCubit.setCurrentLanguage(selectedLocale!);
          Navigator.pop(context);
        },
        child: Icon(Icons.check, size: 24, color: theme.colorScheme.surface,),
      ),
    );
  }
}
