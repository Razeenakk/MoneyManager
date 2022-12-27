import 'package:flutter/material.dart';
import 'package:money_manager/Screens/Home/home_screen.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: HomeScreen.selectedIndexNotifier,
        builder: (BuildContext ctx, int updatedIndex, _) {
          return BottomNavigationBar(
              selectedItemColor: Colors.blueGrey[900],
              unselectedItemColor: Colors.grey[500],
              currentIndex: updatedIndex,
              onTap: (newIndex) {
                HomeScreen.selectedIndexNotifier.value = newIndex;
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home), label: 'Transactions'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.category), label: 'Category'),
              ]);
        });
  }
}
