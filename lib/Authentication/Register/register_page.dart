import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:courier_app/Authentication/signin_navigator.dart';
import 'package:courier_app/Components/continue_button.dart';
import 'package:courier_app/Components/custom_app_bar.dart';
import 'package:courier_app/Components/entry_field.dart';
import 'package:courier_app/Service/Auth.dart';
import 'package:courier_app/Theme/colors.dart';
import 'package:courier_app/locale/locales.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) => const RegisterBody();
}

class RegisterBody extends StatefulWidget {
  const RegisterBody({super.key});

  @override
  State<RegisterBody> createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<RegisterBody> {
  final _formKey = GlobalKey<FormState>();
  final _auth = AuthService();

  // Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Company-only controllers
  final companyNameController = TextEditingController();
  final companyRegController = TextEditingController();

  bool isCompany = false;
  String password = '';

  // Password rules
  bool hasMinLength(String pwd) => pwd.length >= 8;
  bool hasNumber(String pwd) => RegExp(r'[0-9]').hasMatch(pwd);
  bool hasLowercase(String pwd) => RegExp(r'[a-z]').hasMatch(pwd);
  bool hasUppercase(String pwd) => RegExp(r'[A-Z]').hasMatch(pwd);

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    companyNameController.dispose();
    companyRegController.dispose();
    super.dispose();
  }

  Widget _buildRequirement(String text, bool met) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0, left: 20),
      child: Row(
        children: [
          Icon(met ? Icons.check_circle : Icons.cancel,
              color: met ? Colors.green : Colors.red, size: 18),
          const SizedBox(width: 6),
          Text(text, style: TextStyle(color: met ? Colors.green : Colors.red, fontSize: 14)),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Passwords do not match")));
      return;
    }
    if (!hasMinLength(password) ||
        !hasNumber(password) ||
        !hasLowercase(password) ||
        !hasUppercase(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password does not meet all requirements")));
      return;
    }

    await _auth.signUpUser(
      context: context,
      email: emailController.text.trim(),
      name: nameController.text.trim(),
      password: passwordController.text,
      phoneNumber: phoneController.text.trim(),
      isCompany: isCompany,
      companyName: companyNameController.text.trim(),
      companyRegistrationNumber: companyRegController.text.trim(),
    );
    // AuthService handles success snackbar + navigation to login.
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final theme = Theme.of(context);

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

                              // Name
                              EntryField(
                                label: locale.nameText,
                                hint: locale.nameHint,
                                controller: nameController,
                                textCapitalization: TextCapitalization.words,
                                validator: (v) =>
                                (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                              ),

                              // Email
                              EntryField(
                                label: locale.emailText,
                                hint: locale.emailHint,
                                controller: emailController,
                                validator: (v) {
                                  final val = v?.trim() ?? '';
                                  final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(val);
                                  if (val.isEmpty) return 'Email is required';
                                  if (!ok) return 'Enter a valid email';
                                  return null;
                                },
                              ),

                              // Phone (optional, adjust validator if you want it required)
                              EntryField(
                                label: locale.phoneText,
                                hint: locale.phoneHint,
                                controller: phoneController,
                              ),

                              // Password
                              EntryField(
                                label: "Password",
                                hint: "Enter your password",
                                controller: passwordController,
                                isPassword: true,
                                validator: (v) => (v == null || v.isEmpty)
                                    ? 'Password is required'
                                    : null,
                                onChanged: (val) => setState(() => password = val),
                              ),

                              // Confirm password
                              EntryField(
                                label: "Confirm Password",
                                hint: "Re-enter your password",
                                controller: confirmPasswordController,
                                isPassword: true,
                                validator: (v) => (v == null || v.isEmpty)
                                    ? 'Confirm your password'
                                    : null,
                              ),

                              // Password requirements indicators
                              _buildRequirement("At least 8 characters", hasMinLength(password)),
                              _buildRequirement("At least 1 number", hasNumber(password)),
                              _buildRequirement("At least 1 lowercase letter", hasLowercase(password)),
                              _buildRequirement("At least 1 uppercase letter", hasUppercase(password)),

                              // Is company?
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: SwitchListTile(
                                  title: Text("Are you a company?", style: theme.textTheme.titleMedium),
                                  value: isCompany,
                                  onChanged: (bool value) => setState(() => isCompany = value),
                                ),
                              ),

                              // Company-only fields
                              if (isCompany) ...[
                                EntryField(
                                  label: "Company Name",
                                  hint: "Enter your company name",
                                  controller: companyNameController,
                                  textCapitalization: TextCapitalization.words,
                                ),
                                EntryField(
                                  label: "Company Registration Number",
                                  hint: "Enter registration number",
                                  controller: companyRegController,
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

          // Bottom button
          PositionedDirectional(
            bottom: 0,
            start: 0,
            end: 0,
            child: CustomButton(
              radius: const BorderRadius.only(topRight: Radius.circular(35.0)),
              text: "Register",
              onPressed: _submit,
            ),
          ),
        ],
      ),
    );
  }
}
