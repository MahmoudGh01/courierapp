import 'package:animation_wrappers/animations/faded_scale_animation.dart';
import 'package:courier_app/Components/continue_button.dart';
import 'package:courier_app/Routes/routes.dart';
import 'package:courier_app/Theme/colors.dart';
import 'package:courier_app/locale/locales.dart';
import 'package:flutter/material.dart';

class TransactionItem {
  String image;
  String title;
  String date;
  String amount;

  TransactionItem(this.image, this.title, this.date, this.amount);
}

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final List<TransactionItem> _transactions = [];

  @override
  void didChangeDependencies() {
    final locale = AppLocalizations.of(context);
    _transactions.addAll([
      TransactionItem('images/home1.png', locale.smallParcel,
          '20 Jun 2020, 11:40 am', '\$ 6.80'),
      TransactionItem('images/home2.png', locale.mediumParcel,
          '20 Jun 2020, 11:35 am', '\$ 12.50'),
      TransactionItem('images/home3.png', locale.largeParcel,
          '18 Jun 2020, 01:48 pm', '\$ 20.00'),
      TransactionItem('images/home1.png', locale.moneyAdded,
          '18 Jun 2020, 11:40 am', '\$ 100.80'),
      TransactionItem('images/home1.png', locale.smallParcel,
          '17 Jun 2020, 11:40 am', '\$ 6.80'),
      TransactionItem('images/home2.png', locale.mediumParcel,
          '16 Jun 2020, 11:35 am', '\$ 12.50'),
      TransactionItem('images/home3.png', locale.largeParcel,
          '14 Jun 2020, 01:48 pm', '\$ 20.00'),
      TransactionItem('images/home1.png', locale.moneyAdded,
          '14 Jun 2020, 11:40 am', '\$ 100.80'),
    ]);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          locale.wallet,
          style: theme.textTheme.headlineSmall?.copyWith(fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 20.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        locale.balanceAmount,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$ 350.50',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontSize: 26,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 140,
                  child: CustomButton(
                    padding: 12,
                    color: theme.colorScheme.surface,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, PageRoutes.addMoneyPage);
                    },
                    text: '+  ${locale.addMoney}',
                    radius: BorderRadius.circular(40),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadiusDirectional.only(
                  topStart: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      locale.recentTransactions,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: theme.hoverColor.withOpacity(0.5),
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.only(bottom: 20),
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14.0),
                            color: kWhiteColor,
                          ),
                          child: ListTile(
                            contentPadding:
                                const EdgeInsetsDirectional.only(end: 16),
                            leading: FadedScaleAnimation(
                              child: Image.asset(_transactions[index].image),
                            ),
                            title: Text(
                              locale.smallParcel,
                              style: theme.textTheme.titleMedium!.copyWith(
                                color: theme.primaryColorDark,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              _transactions[index].date,
                              style: theme.textTheme.titleMedium!
                                  .copyWith(fontSize: 12),
                            ),
                            trailing: RichText(
                              textAlign: TextAlign.right,
                              text: TextSpan(children: [
                                TextSpan(
                                  text: '${_transactions[index].amount}\n',
                                  style: theme.textTheme.titleMedium!.copyWith(
                                    height: 1.5,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                TextSpan(
                                    text: '#BA5421',
                                    style: theme.textTheme.titleMedium!
                                        .copyWith(fontSize: 12, height: 1.5)),
                              ]),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 10);
                      },
                      itemCount: _transactions.length,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
