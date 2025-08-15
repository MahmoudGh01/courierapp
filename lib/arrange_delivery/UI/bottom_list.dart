import 'package:courier_app/Components/continue_button.dart';
import 'package:courier_app/Theme/colors.dart';
import 'package:courier_app/locale/locales.dart';
import 'package:flutter/material.dart';

class BottomList {
  final String? title;
  final String? subtitle;
  final String? trailing;

  BottomList({this.title, this.subtitle, this.trailing});
}

class ModalBottomWidget extends StatefulWidget {
  const ModalBottomWidget({super.key});

  @override
  State<ModalBottomWidget> createState() => _ModalBottomWidgetState();
}

class _ModalBottomWidgetState extends State<ModalBottomWidget> {
  int? selectedMode = -1;
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    final List<BottomList> deliveryMode = <BottomList>[
      BottomList(
        title: locale.economyDelivery,
        subtitle: locale.comment1,
        trailing: '\$8.60',
      ),
      BottomList(
        title: (locale.deluxDelivery),
        subtitle: (locale.comment2),
        trailing: ('\$12.50'),
      ),
      BottomList(
        title: (locale.premiumDelivery),
        subtitle: (locale.comment3),
        trailing: ('\$20.00'),
      ),
    ];
    return Stack(
      children: [
        ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                locale.selectDelivery,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Theme.of(context).primaryColorDark),
              ),
            ),
            // RadioButtonGroup(
            //   labelStyle: Theme.of(context).textTheme.bodySmall,
            //   padding: EdgeInsets.only(top: 16.0),
            //   activeColor: Theme.of(context).primaryColor,
            //   onSelected: (String checked) {},
            //   labels: deliveryMode.map((e) => e.title).toList(),
            //   itemBuilder: (Radio radioButton, Text title, int i) {
            //     return Column(
            //       children: <Widget>[
            //         Container(
            //           color: kWhiteColor,
            //           child: Padding(
            //             padding: EdgeInsets.all(8.0),
            //             child: ListTile(
            //               leading: radioButton,
            //               title: Text(
            //                 deliveryMode[i].title,
            //                 style: Theme.of(context)
            //                     .textTheme
            //                     .titleLarge
            //                     .copyWith(
            //                         fontSize: 18.3, color: kContainerTextColor),
            //               ),
            //               subtitle: Text(
            //                 deliveryMode[i].subtitle,
            //                 style: Theme.of(context)
            //                     .textTheme
            //                     .bodyMedium
            //                     .copyWith(color: Theme.of(context).hintColor),
            //               ),
            //               trailing: Text(deliveryMode[i].trailing,
            //                   style: Theme.of(context)
            //                       .textTheme
            //                       .titleLarge
            //                       .copyWith(
            //                           color:
            //                               Theme.of(context).primaryColorDark)),
            //             ),
            //           ),
            //         ),
            //         SizedBox(height: 8),
            //       ],
            //     );
            //   },
            // ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: deliveryMode.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return RadioListTile(
                  activeColor: Theme.of(context).primaryColor,
                  value: index,
                  groupValue: selectedMode,
                  title: Text(
                    deliveryMode[index].title!,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 18.3, color: kContainerTextColor),
                  ),
                  subtitle: Text(
                    deliveryMode[index].subtitle!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Theme.of(context).hintColor),
                  ),
                  secondary: Text(deliveryMode[index].trailing!,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: Theme.of(context).primaryColorDark)),
                  onChanged: (dynamic value) {
                    selectedMode = value;
                    setState(() {});
                  },
                );
              },
            ),
            const SizedBox(height: 64),
          ],
        ),
        Positioned(
          width: MediaQuery.of(context).size.width,
          bottom: 0.0,
          child: CustomButton(
            text: locale.update,
            radius: const BorderRadius.only(topRight: Radius.circular(35.0)),
            onPressed: () => Navigator.pop(context),
          ),
        )
      ],
    );
  }
}
