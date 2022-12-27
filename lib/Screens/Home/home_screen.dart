import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_manager/Models/category/category_add_popup.dart';

import 'package:money_manager/Screens/Category/category%20_screen.dart';
import 'package:money_manager/Screens/Home/widgets/bottom_navigation.dart';
import 'package:money_manager/Screens/Transactions/transaction_screen.dart';
import 'package:money_manager/Screens/add_transaction/add_transaction_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);
  final _pages = [const TransactionScreen(), const CategoryScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.grey,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: Colors.grey,
        title: const Text(
          'MONEY MANAGER',
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: const BottomNavigation(),
      body: SafeArea(
          child: ValueListenableBuilder(
              valueListenable: selectedIndexNotifier,
              builder: (BuildContext ctx, int updatedIndex, _) {
                return _pages[updatedIndex];
              })),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey,
        onPressed: () {
          if (selectedIndexNotifier.value == 0) {
            print("Add Transaction");
            Navigator.of(context).pushNamed(AddTransaction.routeName);
          } else {
            print("Add Category");
            showCategoryAddPopup(context);
            // final _sample = CategoryModel(name: 'Travel', type:CategoryType.expense , id: DateTime.now().microsecondsSinceEpoch.toString());
            // CategoryDb().insertCategory(_sample);
            // // then((value) {
            // //
            // // });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
