import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:courier_app/Routes/routes.dart';
import 'package:courier_app/Theme/colors.dart';
import 'package:courier_app/app_settings/ui/language_sheet.dart';
import 'package:courier_app/locale/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AccountBody();
  }
}

class AccountBody extends StatefulWidget {
  const AccountBody({super.key});

  @override
  State<AccountBody> createState() => _AccountBodyState();
}

class _AccountBodyState extends State<AccountBody> {
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    var mediaQuery = MediaQuery.of(context);
    var theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: mediaQuery.size.height - mediaQuery.padding.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    locale.accountText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kWhiteColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () =>
                      Navigator.pushNamed(context, PageRoutes.myProfilePage),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: Row(
                      children: [
                        FadedScaleAnimation(
                          child: const CircleAvatar(
                            radius: 36.0,
                            backgroundImage: AssetImage('images/profile.png'),
                          ),
                        ),
                        const SizedBox(width: 24.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Samantha Smith',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              locale.viewProfile,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  height: mediaQuery.size.height * 0.75,
                  decoration: BoxDecoration(
                    color: kWhiteColor,
                    borderRadius: const BorderRadiusDirectional.only(
                      topStart: Radius.circular(35.0),
                    ),
                  ),
                  child: ListView(
                    children: [
                      const SizedBox(height: 16),
                      buildListTile(
                        Icons.account_balance_wallet,
                        locale.wallet,
                        locale.yourTransaction,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            PageRoutes.walletPage,
                          );
                        },
                      ),
                      buildListTile(
                        Icons.mail,
                        locale.contactUs,
                        locale.contactQuery,
                        onTap: () {
                          Navigator.pushNamed(
                              context, PageRoutes.contactUsPage);
                        },
                      ),
                      buildListTile(
                        Icons.description,
                        locale.tnc,
                        locale.knowtnc,
                        onTap: () {
                          Navigator.pushNamed(context, PageRoutes.tncPage);
                        },
                      ),
                      buildListTile(
                        Icons.assignment,
                        locale.privacyPolicy,
                        locale.companyPrivacyPolicies,
                        onTap: () {
                          Navigator.pushNamed(context, PageRoutes.privacyPolicyPage);
                        },
                      ),
                      buildListTile(
                        Icons.public,
                        locale.changeLanguage,
                        locale.changeLanguage,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => const LanguageSheet(),
                          );
                        },
                      ),
                      buildListTile(
                        Icons.exit_to_app,
                        locale.logout,
                        locale.signoutAccount,
                        onTap: () {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    locale.loggingout,
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  content: Text(locale.sureText),
                                  actions: <Widget>[
                                    MaterialButton(
                                      textColor: theme.primaryColor,
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: kWhiteColor)),
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(locale.no),
                                    ),
                                    MaterialButton(
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: kWhiteColor)),
                                        textColor: theme.primaryColor,
                                        onPressed: () {
                                          Phoenix.rebirth(context);
                                        },
                                        child: Text(locale.yes))
                                  ],
                                );
                              });
                        },
                      ),
                      const SizedBox(
                        height: 140,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildListTile(IconData icon, String title, String subtitle,
      {Function? onTap}) {
    var theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20.0),
      child: ListTile(
        horizontalTitleGap: 12,
        leading: FadedScaleAnimation(
          child: Icon(
            icon,
            color: theme.primaryColor.withOpacity(0.35),
          ),
        ),
        title: Text(
          title,
          style: theme.textTheme.headlineSmall!.copyWith(
            color: theme.primaryColorDark,
            height: 1.72,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            subtitle,
            style:
                theme.textTheme.titleMedium!.copyWith(height: 1.3, fontSize: 14),
          ),
        ),
        onTap: onTap as void Function()?,
      ),
    );
  }
}
