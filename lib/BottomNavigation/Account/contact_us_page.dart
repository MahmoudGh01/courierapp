import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:courier_app/Components/continue_button.dart';
import 'package:courier_app/Components/entry_field.dart';
import 'package:courier_app/locale/locales.dart';
import 'package:flutter/material.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ContactUsBody();
  }
}

class ContactUsBody extends StatefulWidget {
  const ContactUsBody({super.key});

  @override
  State<ContactUsBody> createState() => _ContactUsBodyState();
}

class _ContactUsBodyState extends State<ContactUsBody> {
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(locale.contactUs),
      ),
      body: Stack(
        children: [
          FadedSlideAnimation(
            beginOffset: const Offset(0, 0.3),
            endOffset: const Offset(0, 0),
            slideCurve: Curves.linearToEaseOut,
            child: SafeArea(
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(35.0),
                  ),
                ),
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        '\n${locale.feedbackText}',
                        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                              color: theme.primaryColorDark,
                              fontSize: 20,
                            ),
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    EntryField(
                      label: locale.yourMessage,
                      hint: locale.entermsg,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
            ),
          ),
          PositionedDirectional(
            bottom: 0,
            start: 0,
            end: 0,
            child: CustomButton(
              text: locale.submitText,
              radius: const BorderRadius.only(topLeft: Radius.circular(35.0)),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
