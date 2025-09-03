import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ViewModels/transport_request_provider.dart';
import 'steps/step1_service_type.dart';
import 'steps/step2_service_details.dart';
import 'steps/step3_merchandise.dart';
import 'steps/step4_vehicle.dart';
import 'steps/step5_payment.dart';
import 'steps/step6_additional.dart';
import 'steps/step7_summary.dart';
import 'steps/step8_success.dart';

class TransportRequestWizard extends StatefulWidget {
  const TransportRequestWizard({super.key});

  @override
  State<TransportRequestWizard> createState() => _TransportRequestWizardState();
}

class _TransportRequestWizardState extends State<TransportRequestWizard> {
  final PageController _pc = PageController();
  int _index = 0;

  void _next() {
    setState(() => _index = (_index + 1).clamp(0, 7));
    _pc.animateToPage(_index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void _prev() {
    setState(() => _index = (_index - 1).clamp(0, 7));
    _pc.animateToPage(_index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransportRequestProvider>();
    final steps = [
      Step1ServiceType(onNext: () {
        if (provider.validateStep1()) _next();
      }),
      Step2ServiceDetails(onNext: () {
        if (provider.validateStep2()) _next();
      }, onBack: _prev),
      Step3Merchandise(onNext: () {
        if (provider.validateStep3()) _next();
      }, onBack: _prev),
      Step4Vehicle(onNext: () {
        if (provider.validateStep4()) _next();
      }, onBack: _prev),
      Step5Payment(onNext: () {
        if (provider.validateStep5()) _next();
      }, onBack: _prev),
      Step6Additional(onNext: () {
        if (provider.validateStep6()) _next();
      }, onBack: _prev),
      Step7Summary(onSubmitSuccess: () => _next(), onBack: _prev),
      const Step8Success(),
    ];

    return Scaffold(
      body: PageView.builder(
        controller: _pc,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: steps.length,
        itemBuilder: (_, i) => steps[i],
      ),
    );
  }
}
