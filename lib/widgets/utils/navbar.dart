import 'package:costtracker/widgets/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class FBottomBar extends StatefulWidget {
  const FBottomBar({
    super.key,
    required this.currentIndex,
    required this.ontapMethod,
  });
  final int currentIndex;
  final Function(int) ontapMethod;

  @override
  State<FBottomBar> createState() => _FBottomBarState();
}

class _FBottomBarState extends State<FBottomBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      selectedLabelStyle: TextStyle(fontSize: 13),
      unselectedLabelStyle: TextStyle(fontSize: 11),
      selectedItemColor: FColors.primary,
      type: BottomNavigationBarType.fixed,
      onTap: widget.ontapMethod,
      items: [
        BottomNavigationBarItem(
          icon: Icon(FontAwesome.house_chimney_solid, size: 20),
          label: "DashBoard",
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesome.money_bill_trend_up_solid, size: 20),
          label: "Transaction",
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesome.book_open_solid, size: 20),
          label: "Report",
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesome.sliders_solid, size: 20),
          label: "Settings",
        ),
      ],
    );
  }
}
