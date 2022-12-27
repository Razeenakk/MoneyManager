import 'package:flutter/material.dart';
import 'package:money_manager/Screens/Category/widgets/expense_category_list.dart';
import 'package:money_manager/Screens/Category/widgets/income_category_list.dart';
import 'package:money_manager/hive_db/category/category_db.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    CategoryDb().refreshUi();
    // CategoryDb().getCategories().then((value){
    //   print('categories get');
    //   print(value.toString());
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
            controller: _tabController,
            labelColor: Colors.blueGrey[900],
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.white,
            tabs: const [
              Tab(
                text: 'Income',
              ),
              Tab(
                text: 'Expense',
              )
            ]),
        Expanded(
          child: TabBarView(
              controller: _tabController,
              children: const [IncomeCategoryList(), ExpenseCategoryList()]),
        )
      ],
    );
  }
}
