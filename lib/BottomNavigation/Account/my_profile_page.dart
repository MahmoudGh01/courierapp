import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:courier_app/Components/custom_app_bar.dart';
import 'package:courier_app/Components/entry_field.dart';
import 'package:courier_app/Components/continue_button.dart'; // ✅ Add this
import 'package:courier_app/Theme/colors.dart';
import 'package:courier_app/locale/locales.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ViewModels/userprovider.dart';

class MyProfilePage extends StatelessWidget {
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyProfileBody();
  }
}

class MyProfileBody extends StatefulWidget {
  const MyProfileBody({super.key});

  @override
  State<MyProfileBody> createState() => _MyProfileBodyState();
}

class _MyProfileBodyState extends State<MyProfileBody> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _companyNameCtrl;
  late final TextEditingController _companyRegCtrl;

  bool _isCompany = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>().user;
    _nameCtrl = TextEditingController(text: user.name);
    _emailCtrl = TextEditingController(text: user.email);
    _phoneCtrl = TextEditingController(text: user.phoneNumber ?? '');
    _companyNameCtrl = TextEditingController(text: user.companyName ?? '');
    _companyRegCtrl =
        TextEditingController(text: user.companyRegistrationNumber ?? '');
    _isCompany = user.isCompany ?? false;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _companyNameCtrl.dispose();
    _companyRegCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<UserProvider>();
    final user = provider.user;

    await provider.editUser(
      userId: user.idUser,
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      isCompany: _isCompany,
      companyName: _isCompany ? _companyNameCtrl.text.trim() : null,
      companyRegistrationNumber:
      _isCompany ? _companyRegCtrl.text.trim() : null,
      // role/profilePicturePath optional; omit or pass if you support editing them here
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).saved)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: FadedSlideAnimation(
        beginOffset: const Offset(0, 0.3),
        endOffset: const Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
        child: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: mediaQuery.size.height - mediaQuery.padding.vertical,
              child: Stack(
                children: [

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Spacer(),
                      CustomAppBar(title: locale.myProfile),
                      const Spacer(flex: 2),

                      Container(
                        height: mediaQuery.size.height * 0.78,
                        decoration: BoxDecoration(
                          color: kWhiteColor,
                          borderRadius: const BorderRadiusDirectional.only(
                            topStart: Radius.circular(35.0),
                          ),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 16),
                              EntryField(
                                label: locale.fullName,
                                controller: _nameCtrl,
                              ),
                              EntryField(
                                label: locale.emailText,
                                controller: _emailCtrl,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              EntryField(
                                label: locale.phoneText,
                                controller: _phoneCtrl,
                                keyboardType: TextInputType.phone,
                              ),

                              // Company toggle
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 20),
                                child: SwitchListTile(
                                  title: Text(locale.registerAsCompany ?? 'Company account'),
                                  value: _isCompany,
                                  onChanged: (v) => setState(() {
                                    _isCompany = v;
                                  }),
                                ),
                              ),

                              if (_isCompany) ...[
                                EntryField(
                                  label: locale.companyName ?? 'Company Name',
                                  controller: _companyNameCtrl,
                                  textCapitalization: TextCapitalization.words,
                                ),
                                EntryField(
                                  label: locale.companyRegistrationNumber ??
                                      'Company Registration Number',
                                  controller: _companyRegCtrl,
                                ),
                              ],

                              const Spacer(),

                              // Continue button
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 20),
                                child: CustomButton(
                                  text: locale.continueText,
                                  radius: const BorderRadius.only(
                                    topRight: Radius.circular(35.0),
                                  ),
                                  onPressed: _submit,
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
