import 'package:flutter/material.dart';
import 'package:money_manager/Models/category/category_model.dart';
import 'package:money_manager/hive_db/category/category_db.dart';

class IncomeCategoryList extends StatelessWidget {
  const IncomeCategoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: CategoryDb().incomeCategoryListListener,
        builder: (BuildContext ctx, List<CategoryModel> newList, Widget? _) {
          return ListView.separated(
              padding: const EdgeInsets.all(10),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (ctx, index) {
                final category = newList[index];
                return Card(
                    elevation: 0,
                    child: ListTile(
                      title: Text(category.name),
                      trailing: IconButton(
                        onPressed: () {
                          CategoryDb.instance.deleteCategory(category.id);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ));
              },
              separatorBuilder: (BuildContext ctx, index) {
                return const SizedBox(height: 10);
              },
              itemCount: newList.length);
        });
  }
}
