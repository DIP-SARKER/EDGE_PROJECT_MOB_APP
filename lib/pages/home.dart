import 'package:costtracker/pages/budgetmanagement.dart';
import 'package:costtracker/pages/dashboaard.dart';
import 'package:costtracker/pages/settings.dart';
import 'package:costtracker/pages/transactionpage.dart';
import 'package:costtracker/widgets/utils/navbar.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _homeScreens = [
    DashboardScreen(),
    AddTransactionScreen(),
    BudgetReportsScreen(),
    SettingsScreen(),
  ];
  void _onTapMethod(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _homeScreens[_currentIndex],
      bottomNavigationBar: FBottomBar(
        currentIndex: _currentIndex,
        ontapMethod: _onTapMethod,
      ),
    );
  }
}
