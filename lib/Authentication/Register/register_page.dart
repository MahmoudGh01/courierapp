import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:courier_app/Authentication/signin_navigator.dart';
import 'package:courier_app/Components/continue_button.dart';
import 'package:courier_app/Components/custom_app_bar.dart';
import 'package:courier_app/Components/entry_field.dart';
import 'package:courier_app/Theme/colors.dart';
import 'package:courier_app/locale/locales.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const RegisterBody();
  }
}

class RegisterBody extends StatefulWidget {
  const RegisterBody({super.key});

  @override
  State<RegisterBody> createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<RegisterBody> {
  final _formKey = GlobalKey<FormState>();
  bool isCompany = false;
  String password = '';

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  bool hasMinLength(String pwd) => pwd.length >= 8;
  bool hasNumber(String pwd) => RegExp(r'[0-9]').hasMatch(pwd);
  bool hasLowercase(String pwd) => RegExp(r'[a-z]').hasMatch(pwd);
  bool hasUppercase(String pwd) => RegExp(r'[A-Z]').hasMatch(pwd);

  Widget _buildRequirement(String text, bool met) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0, left: 20),
      child: Row(
        children: [
          Icon(
            met ? Icons.check_circle : Icons.cancel,
            color: met ? Colors.green : Colors.red,
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: met ? Colors.green : Colors.red,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    var mediaQuery = MediaQuery.of(context);
    var theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          FadedSlideAnimation(
            beginOffset: const Offset(0, 0.3),
            endOffset: const Offset(0, 0),
            slideCurve: Curves.linearToEaseOut,
            child: SafeArea(
              child: Column(
                children: [
                  CustomAppBar(title: locale.registerText),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: kWhiteColor,
                        borderRadius: const BorderRadiusDirectional.only(
                          topStart: Radius.circular(35.0),
                        ),
                      ),
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.only(bottom: 120),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 24),
                              EntryField(
                                label: locale.nameText,
                                hint: locale.nameHint,
                                textCapitalization: TextCapitalization.words,
                              ),
                              EntryField(
                                label: locale.emailText,
                                hint: locale.emailHint,
                              ),
                              EntryField(
                                label: locale.phoneText,
                                hint: locale.phoneHint,
                              ),
                              EntryField(
                                label: "Password",
                                hint: "Enter your password",
                                controller: passwordController,
                                isPassword: true,
                                onChanged: (val) {
                                  setState(() {
                                    password = val;
                                  });
                                },
                              ),
                              EntryField(
                                label: "Confirm Password",
                                hint: "Re-enter your password",
                                controller: confirmPasswordController,
                                isPassword: true,
                              ),
                              _buildRequirement("At least 8 characters", hasMinLength(password)),
                              _buildRequirement("At least 1 number", hasNumber(password)),
                              _buildRequirement("At least 1 lowercase letter", hasLowercase(password)),
                              _buildRequirement("At least 1 uppercase letter", hasUppercase(password)),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: SwitchListTile(
                                  title: Text("Are you a company?", style: theme.textTheme.titleMedium),
                                  value: isCompany,
                                  onChanged: (bool value) {
                                    setState(() {
                                      isCompany = value;
                                    });
                                  },
                                ),
                              ),
                              if (isCompany) ...[
                                EntryField(
                                  label: "Company Name",
                                  hint: "Enter your company name",
                                  textCapitalization: TextCapitalization.words,
                                ),
                                EntryField(
                                  label: "Company Registration Number",
                                  hint: "Enter registration number",
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ✅ Bottom Button
          PositionedDirectional(
            bottom: 0,
            start: 0,
            end: 0,
            child: CustomButton(
              radius: const BorderRadius.only(topRight: Radius.circular(35.0)),
              text: "Register",
              onPressed: () {
                FocusScope.of(context).unfocus();
                if (_formKey.currentState!.validate()) {
                  if (password != confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Passwords do not match")),
                    );
                    return;
                  }
                  if (!hasMinLength(password) ||
                      !hasNumber(password) ||
                      !hasLowercase(password) ||
                      !hasUppercase(password)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Password does not meet all requirements")),
                    );
                    return;
                  }
                  Navigator.pushNamed(context, SignInRoutes.verification);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
