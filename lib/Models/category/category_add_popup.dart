import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/Models/category/category_model.dart';
import 'package:money_manager/hive_db/category/category_db.dart';

/// datas add in db;
ValueNotifier<CategoryType> selectedCategoryNotifier =
    ValueNotifier(CategoryType.income);

Future<void> showCategoryAddPopup(BuildContext context) async {
  final _nameEditingController = TextEditingController();
  showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: const Text('Add Category'),
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: _nameEditingController,
                decoration: const InputDecoration(
                    hintText: 'Category', border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  const RadioButton(title: 'income', type: CategoryType.income),
                  const RadioButton(title: 'Expense', type: CategoryType.expense),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(
                        Colors.black),
                  ),
                  onPressed: () {
                    final _name = _nameEditingController.text.trim();
                    // trim()  use space remove first and last.
                    if (_name.isEmpty) {
                      return;
                    }


                    /// save data in get textfield
                    ///  create category model;
                    final _type = selectedCategoryNotifier.value;
                    final _category = CategoryModel(
                        name: _name,
                        type: _type,
                        id: DateTime.now().millisecondsSinceEpoch.toString());
                    CategoryDb.instance.insertCategory(_category);
                    Navigator.pop(ctx);
                  },
                  child: const Text('Add')),
            )
          ],
        );
      });
}

class RadioButton extends StatelessWidget {
  final String title;
  final CategoryType type;

  const RadioButton({super.key, required this.title, required this.type});

  //final CategoryType currentlySelectedType;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
            valueListenable: selectedCategoryNotifier,
            builder: (BuildContext context, CategoryType newCategory, _) {
              return Radio<CategoryType>(
                  value: type,
                  groupValue: newCategory,
                  fillColor:
                  MaterialStateColor.resolveWith((states) => Colors.black),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    selectedCategoryNotifier.value = value;
                    selectedCategoryNotifier.notifyListeners();

                    print(value);
                  });
            }),
        Text(title),
      ],
    );
  }
}
