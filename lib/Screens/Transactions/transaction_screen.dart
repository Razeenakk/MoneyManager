import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/Models/category/category_model.dart';
import 'package:money_manager/Models/transaction/transaction_model.dart';
import 'package:money_manager/hive_db/category/category_db.dart';
import 'package:money_manager/hive_db/transactions/transaction_db.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CategoryDb.instance.refreshUi();
    TransactionDB.instance.refresh();

    /// uil list of data varaan
    return ValueListenableBuilder(
        valueListenable: TransactionDB.instance.transactionListNotifier,
        builder: (BuildContext ctx, List<TransactionModel> newList, Widget? _) {
          return ListView.separated(
              padding: const EdgeInsets.all(10),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (ctx, index) {
                final _value = newList[index];
                return Slidable(
                  key: Key(_value.id!),
                  startActionPane:
                      ActionPane(motion: const ScrollMotion(), children: [
                    SlidableAction(
                      onPressed: (ctx) {
                        TransactionDB.instance.deleteTransaction(_value.id!);
                      },
                      icon: Icons.delete,
                      label: 'Delete',
                    )
                  ]),
                  child: Card(
                    elevation: 0,
                    child: ListTile(
                      leading: CircleAvatar(
                          backgroundColor: _value.type == CategoryType.income
                              ? Colors.green
                              : Colors.red,
                          radius: 50,
                          child: Text(
                            parseDate(_value.date),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                          )),
                      title: Text('Rs ${_value.amount}'),
                      subtitle: Text(_value.category.name),
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext ctx, index) {
                return const SizedBox(height: 10);
              },
              itemCount: newList.length);
        });
  }

  /// date and month parse function;
  String parseDate(DateTime date) {
    final _date = DateFormat.MMMd().format(date);
    final _splitDate = _date.split('');
    return '${_splitDate.last}\n ${_splitDate.first}';

    // return '${date.day}\n${date.month}';
  }
}
