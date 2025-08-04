import 'package:courier_app/Components/continue_button.dart';
import 'package:courier_app/Components/custom_app_bar.dart';
import 'package:courier_app/Theme/colors.dart';
import 'package:courier_app/Theme/style.dart';
import 'package:courier_app/locale/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

class Measured {
  final double? height;
  final double? length;
  final double? width;

  Measured(this.height, this.length, this.width);
}

class Measurement extends StatefulWidget {
  const Measurement({super.key});

  @override
  State<Measurement> createState() => _MeasurementState();
}

class _MeasurementState extends State<Measurement> {
  double? width = 50;
  double? length = 50;
  double? height = 0;

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    var mediaQuery = MediaQuery.of(context);
    var theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(
                height: 20,
              ),
              CustomAppBar(title: locale.courierInfo),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: mediaQuery.size.height * 0.8,
                decoration: BoxDecoration(
                  color: kButtonColor,
                  borderRadius: borderRadius,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const Spacer(),
                    Text(
                      locale.measurement,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: theme.primaryColorDark),
                    ),
                    const Spacer(),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(width: 36.0),
                          RichText(
                            textAlign: TextAlign.right,
                            text: TextSpan(children: [
                              TextSpan(
                                text: '\n\n\n\n\n${locale.length}\n',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              TextSpan(
                                text: '${length!.toInt()} ${locale.cm}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(color: theme.primaryColor),
                              ),
                            ]),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Image.asset(
                            'images/box.png',
                            height: 118.7,
                            width: 118.7,
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text: '\n\n${locale.height}\n',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              TextSpan(
                                text: '${height!.toInt()} ${locale.cm}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(color: theme.primaryColor),
                              ),
                            ]),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                          text: '${locale.width}\n',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        TextSpan(
                          text: '${width!.toInt()} ${locale.cm}',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: theme.primaryColor),
                        ),
                      ]),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        heightSlider(theme, context),
                        const SizedBox(width: 6),
                        Expanded(
                          child: SizedBox(
                            height: 305.0,
                            child: Column(
                              children: [
                                lengthSlider(theme, context),
                                const SizedBox(height: 6),
                                widthSlider(theme, context),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ],
          ),
          PositionedDirectional(
            bottom: 0,
            start: 0,
            end: 0,
            child: CustomButton(
              text: locale.update,
              onPressed: () {
                Measured measured = Measured(height, length, width);
                Navigator.pop(context, measured);
              },
              radius: const BorderRadius.only(topRight: Radius.circular(35.0)),
            ),
          ),
        ],
      ),
    );
  }

  Widget widthSlider(ThemeData theme, BuildContext context) {
    return Container(
      height: 149,
      color: kWhiteColor,
      padding: const EdgeInsets.only(top: 11.0),
      child: Column(
        children: [
          Text(AppLocalizations.of(context).width),
          FlutterSlider(
            handlerHeight: 60,
            handler: FlutterSliderHandler(
              child: Container(
                height: 16,
                width: 2,
                color: theme.primaryColor,
                margin: const EdgeInsets.only(bottom: 20),
              ),
              decoration: const BoxDecoration(shape: BoxShape.rectangle),
            ),
            hatchMark: FlutterSliderHatchMark(
              density: 0.5,
              bigLine: FlutterSliderSizedBox(
                  height: 16,
                  width: 2,
                  decoration: BoxDecoration(
                      color: theme.disabledColor.withOpacity(0.3))),
              smallLine: FlutterSliderSizedBox(
                  height: 8,
                  width: 1,
                  decoration: BoxDecoration(
                      color: theme.disabledColor.withOpacity(0.3))),
              displayLines: true,
              linesAlignment: FlutterSliderHatchMarkAlignment.left,
              labelsDistanceFromTrackBar: 28,
              labels: [
                FlutterSliderHatchMarkLabel(
                    label: Text(
                      '55 cm',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    percent: 10),
                FlutterSliderHatchMarkLabel(
                    label: Text(
                      '75 cm',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    percent: 50),
                FlutterSliderHatchMarkLabel(
                    label: Text(
                      '95 cm',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    percent: 90),
              ],
            ),
            values: [width!],
            min: 50,
            max: 100,
            onDragging: (index, lowerValue, upperValue) {
              setState(() {
                width = lowerValue;
              });
            },
            trackBar: FlutterSliderTrackBar(
                activeTrackBarHeight: 0.1,
                activeTrackBar: BoxDecoration(
                  color: kWhiteColor,
                ),
                inactiveTrackBarHeight: 0.1),
          ),
        ],
      ),
    );
  }

  Widget lengthSlider(ThemeData theme, BuildContext context) {
    return Container(
      height: 147,
      color: kWhiteColor,
      padding: const EdgeInsets.only(top: 11.0),
      child: Column(
        children: [
          Text(AppLocalizations.of(context).length),
          FlutterSlider(
            handlerHeight: 58,
            handler: FlutterSliderHandler(
              child: Container(
                height: 16,
                width: 2,
                color: theme.primaryColor,
                margin: const EdgeInsets.only(bottom: 20),
              ),
              decoration: const BoxDecoration(shape: BoxShape.rectangle),
            ),
            hatchMark: FlutterSliderHatchMark(
              density: 0.5,
              bigLine: FlutterSliderSizedBox(
                  height: 16,
                  width: 2,
                  decoration: BoxDecoration(
                      color: theme.disabledColor.withOpacity(0.3))),
              smallLine: FlutterSliderSizedBox(
                  height: 8,
                  width: 1,
                  decoration: BoxDecoration(
                      color: theme.disabledColor.withOpacity(0.3))),
              displayLines: true,
              linesAlignment: FlutterSliderHatchMarkAlignment.left,
              labelsDistanceFromTrackBar: 28,
              labels: [
                FlutterSliderHatchMarkLabel(
                    label: Text(
                      '60 cm',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    percent: 10),
                FlutterSliderHatchMarkLabel(
                    label: Text(
                      '75 cm',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    percent: 50),
                FlutterSliderHatchMarkLabel(
                    label: Text(
                      '90 cm',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    percent: 90),
              ],
            ),
            values: [length!],
            min: 50,
            max: 100,
            onDragging: (index, lowerValue, upperValue) {
              setState(() {
                length = lowerValue;
              });
            },
            trackBar: FlutterSliderTrackBar(
                activeTrackBarHeight: 0.1,
                activeTrackBar: BoxDecoration(
                  color: kWhiteColor,
                ),
                inactiveTrackBarHeight: 0.1),
          ),
        ],
      ),
    );
  }

  Widget heightSlider(ThemeData theme, BuildContext context) {
    return Container(
      height: 300,
      width: MediaQuery.of(context).size.width / 3,
      color: kWhiteColor,
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(
        children: [
          Text(AppLocalizations.of(context).height),
          Expanded(
            child: FlutterSlider(
              axis: Axis.vertical,
              handlerWidth: 60,
              handler: FlutterSliderHandler(
                child: Container(
                  height: 2,
                  width: 16,
                  color: theme.primaryColor,
                  margin: const EdgeInsetsDirectional.only(start: 20),
                ),
                decoration: const BoxDecoration(shape: BoxShape.rectangle),
              ),
              hatchMark: FlutterSliderHatchMark(
                density: 0.5,
                bigLine: FlutterSliderSizedBox(
                    height: 16,
                    width: 2,
                    decoration: BoxDecoration(
                        color: theme.disabledColor.withOpacity(0.3))),
                smallLine: FlutterSliderSizedBox(
                    height: 8,
                    width: 1,
                    decoration: BoxDecoration(
                        color: theme.disabledColor.withOpacity(0.3))),
                displayLines: true,
                labelsDistanceFromTrackBar: -32,
                labels: [
                  FlutterSliderHatchMarkLabel(
                      label: Text(
                        '10 cm',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      percent: 10),
                  FlutterSliderHatchMarkLabel(
                      label: Text(
                        '90 cm',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      percent: 90),
                  FlutterSliderHatchMarkLabel(
                      label: Text(
                        '50 cm',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      percent: 50),
                ],
              ),
              values: [height!],
              min: 0,
              max: 100,
              onDragging: (index, lowerValue, upperValue) {
                setState(() {
                  height = lowerValue;
                });
              },
              trackBar: FlutterSliderTrackBar(
                  activeTrackBarHeight: 0.1,
                  activeTrackBar: BoxDecoration(
                    color: kWhiteColor,
                  ),
                  inactiveTrackBarHeight: 0.1),
            ),
          ),
        ],
      ),
    );
  }
}
