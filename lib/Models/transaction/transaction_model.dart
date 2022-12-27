import 'package:hive_flutter/adapters.dart';
import 'package:money_manager/Models/category/category_model.dart';

part 'transaction_model.g.dart';

/// final means once assighn aakkiyl pinnee maarandaa aavshyamillaathadhinl
@HiveType(typeId: 3)
class TransactionModel {
  @HiveField(0)
  final String purpose;
  @HiveField(1)
  final double amount;
  @HiveField(2)
  final DateTime date;
  @HiveField(3)
  final CategoryType type;
  @HiveField(4)
  final CategoryModel category;
  @HiveField(5)
  String? id;

  TransactionModel(
      {required this.purpose,
      required this.amount,
      required this.date,
      required this.type,
      required this.category}) {
    id = DateTime.now().millisecondsSinceEpoch.toString();
  }
}

///add terminal;
///flutter packages pub run build_runner watch --use-polling-watcher --delete-conflicting-outputs
