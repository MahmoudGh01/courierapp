import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:courier_app/BottomNavigation/Account/account_page.dart';
import 'package:courier_app/BottomNavigation/Home/dashboard.dart';
import 'package:courier_app/BottomNavigation/MyDeliveries/my_deliveries.dart';
import 'package:courier_app/BottomNavigation/Support/chatbot.dart';
import 'package:courier_app/Theme/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'Home/home_page.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 1;
  final List<Widget> _children = <Widget>[
    const MyDeliveriesPage(),
    const DashboardScreen(),
    const HomeScreen(),
    const ChatbotScreen(),
    const AccountPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<BottomNavigationBarItem> bottomBarItems = [
      BottomNavigationBarItem(
        icon: FadedScaleAnimation(
          child: SvgPicture.asset('images/bottom_menu/ic_deliveries.svg'),
        ),
        activeIcon:
            SvgPicture.asset('images/bottom_menu/ic_deliveries_act.svg'),
        label: '',
      ),
      BottomNavigationBarItem(
        icon: FadedScaleAnimation(
          child: const Icon(Icons.dashboard_outlined, color: Colors.grey),
        ),
        activeIcon:
            Icon(Icons.dashboard, color: Theme.of(context).primaryColor),
        label: '',
      ),
      BottomNavigationBarItem(
        icon: FadedScaleAnimation(
          child: SvgPicture.asset('images/bottom_menu/ic_home.svg'),
        ),
        activeIcon: SvgPicture.asset('images/bottom_menu/ic_home_act.svg'),
        label: '',
      ),   BottomNavigationBarItem(
        icon: FadedScaleAnimation(
          child: const Icon(Icons.support_agent_outlined, color: Colors.grey),
        ),
        activeIcon:
        Icon(Icons.support_agent, color: Theme.of(context).primaryColor),
        label: '',
      ),
      BottomNavigationBarItem(
        icon: FadedScaleAnimation(
          child: SvgPicture.asset('images/bottom_menu/ic_profile.svg'),
        ),
        activeIcon: SvgPicture.asset('images/bottom_menu/ic_profile_act.svg'),
        label: '',
      ),
    ];
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 64.0),
                  child: _children[_currentIndex],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BottomNavigationBar(
                        items: bottomBarItems,
                        currentIndex: _currentIndex,
                        showSelectedLabels: false,
                        onTap: _onItemTapped,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
