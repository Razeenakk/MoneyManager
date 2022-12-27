import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager/Models/category/category_model.dart';
import 'package:money_manager/Models/transaction/transaction_model.dart';

/// give  name database;
const TRANSACTION_DB_NAME = 'transaction_db';
///***************************************************************************************///

/// abstract cls create only write functions;
abstract class TransactionDbFunctions{
  /// first add function;
  Future<void> addTransaction(TransactionModel obj);
  ///desplay function ;
Future<List<TransactionModel>>getAllTransactions();
///dlt function;
Future<void> deleteTransaction (String id);



}
///********************************************************************************************///




///create cls;
class TransactionDB implements TransactionDbFunctions{
  /// crate singleten;
  TransactionDB._internal();   ///its a default named constructor
  static TransactionDB instance = TransactionDB._internal();  ///TransactionDB._internal() ithintee objct aan instance
  /// factory method;
  factory TransactionDB(){
    return instance;
  }

/// object creation of valuelistanble;
  ValueNotifier<List<TransactionModel>> transactionListNotifier = ValueNotifier([]);



  @override
  Future<void> addTransaction(TransactionModel obj)async {
    /// open box;
   final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
  await  _db.put(obj.id, obj);

  }
/// refresh function
  Future<void> refresh()async{
    final _list = await getAllTransactions();
    _list.sort((first,second)=>second.date.compareTo(first.date));
    transactionListNotifier.value.clear();
    transactionListNotifier.value.addAll(_list);
    transactionListNotifier.notifyListeners();
  }
  @override
  Future<List<TransactionModel>> getAllTransactions() async{
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
   return _db.values.toList();


  }

  @override
  Future<void> deleteTransaction(String id) async{
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await _db.delete(id);
    refresh();


  }

}