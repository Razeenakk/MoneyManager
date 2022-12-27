import 'package:flutter/material.dart';
import 'package:money_manager/Models/category/category_model.dart';
import 'package:money_manager/Models/transaction/transaction_model.dart';
import 'package:money_manager/hive_db/category/category_db.dart';
import 'package:money_manager/hive_db/transactions/transaction_db.dart';

class AddTransaction extends StatefulWidget {
  static const routeName = 'add_transaction';

  const AddTransaction({Key? key}) : super(key: key);

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  DateTime? _selectedDate;
  CategoryType? _selectedCategoryType;
  CategoryModel? _selectedCategoryModel;
  String? _categoryID;

  final _purposeTextEditingController = TextEditingController();
  final _amountTextEditingController = TextEditingController();

  @override
  void initState() {
    _selectedCategoryType = CategoryType.income;
    super.initState();
  }

  /*
  purpose,
  date,
  amount,
  income/expense
  category type
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// purpose,
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: _purposeTextEditingController,
                decoration: const InputDecoration(
                    hintText: 'Purpose', border: OutlineInputBorder()),
              ),
            ),

            ///amount,
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: _amountTextEditingController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    hintText: 'Amount', border: OutlineInputBorder()),
              ),
            ),

            ///date;

            TextButton.icon(
                onPressed: () async {
                  final _selectedDateTemp = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 30)),
                    lastDate: DateTime.now(),
                  );
                  if (_selectedDateTemp == null) {
                    return;
                  } else {
                    print(_selectedDateTemp.toString());
                    setState(() {
                      _selectedDate = _selectedDateTemp;
                    });
                  }
                },
                icon: const Icon(Icons.calendar_month,color: Colors.black,),
                label: Text(_selectedDate == null
                    ? 'Select Date'
                    : _selectedDate.toString(),style: TextStyle(color: Colors.black),
                ),
            ),

            ///income/expense
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Radio(
                        value: CategoryType.income,
                        fillColor:
                        MaterialStateColor.resolveWith((states) => Colors.black),


                        /// radiobutton yeethu value laan hold cheythadh
                        groupValue: _selectedCategoryType,


                        /// currently selected value.Ie, user select cheytha value aan grp value. ividee grpvalue yum valuem thammil match aayaalee aa radio button clr varollu
                        onChanged: (newValue) {
                          setState(() {
                            _selectedCategoryType = CategoryType.income;
                            _categoryID = null;
                          });
                        }),
                    const Text('Income'),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                        value: CategoryType.expense,
                        fillColor:
                        MaterialStateColor.resolveWith((states) => Colors.black),


                        /// radiobutton yeethu value laan hold cheythadh
                        groupValue: _selectedCategoryType,

                        /// currently selected value
                        onChanged: (newValue) {
                          setState(() {
                            _selectedCategoryType = CategoryType.expense;
                            _categoryID = null;
                          });
                        }),
                    const Text('Expense'),
                  ],
                ),
              ],
            ),

            /// category type
            Center(
              child: DropdownButton<String>(
                hint: const Text('Selected Category'),
                value: _categoryID,

                /// ividee radiobutton anusarich dropdownmenuel list aaki kaanikknm
                items: (_selectedCategoryType == CategoryType.income
                        ? CategoryDb.instance.incomeCategoryListListener
                        : CategoryDb.instance.expenseCategoryListListener)
                    .value
                    .map((e) {
                  return DropdownMenuItem(
                    value: e.id,
                    child: Text(e.name),
                    onTap: () {
                      print(e.toString());
                      _selectedCategoryModel = e;

                      /// e ntee ullil yeethu item aano aa itemthintee  id and name indaakum
                    },

                    ///  _selectedCategoryModel save chyyunnth databasennu value idkkn.
                  );
                }).toList(),
                onChanged: (selectedValue) {
                  print(selectedValue);
                  setState(() {
                    _categoryID = selectedValue;

                    /// id save  cheyyunnath dropdown ntee ullilee id vechu keenikkan
                  });
                },
                onTap: () {},
              ),
            ),

            /// submit
            ElevatedButton(
                onPressed: () {
                  addTransaction();
                },
                style: ButtonStyle(
                    backgroundColor:
                         MaterialStateProperty.all(
                        Colors.black)

                 ),
                child: const Text('Submit'))
          ],
        ),
      ),
    );
  }

  Future<void> addTransaction() async {
    /// first check textfielnnu varunna values crct aano nokknm
    final _purposeText = _purposeTextEditingController.text;
    final _amountText = _amountTextEditingController.text;
    if (_purposeText.isEmpty) {
      return;
    }
    if (_amountText.isEmpty) {
      return;
    }
    if (_categoryID == null) {
      return;
    }
    if (_selectedDate == null) {
      return;
    }
    if (_selectedCategoryModel == null) {
      return;
    }

    /// AMOUNT STRING AAN VARUNNATH APPO ATHINEE DOUBLELOTT CONVERT CHEYYNM.
    final _parsedAmount = double.tryParse(_amountText);
    if (_parsedAmount == null) {
      return;
    }

    ///_selectedDate
    ///_selectedCategoryItem
    ///_categoryDb

    ///create model;
    final _model = TransactionModel(
        purpose: _purposeText,
        amount: _parsedAmount,
        date: _selectedDate!,

        /// ividee null varilla urppllathkondd ! ittkodkkunnath
        type: _selectedCategoryType!,
        category: _selectedCategoryModel!);

    /// add function impliment in ui section;
    await TransactionDB.instance.addTransaction(_model);
    Navigator.pop(context);
    TransactionDB.instance.refresh();
  }
}
