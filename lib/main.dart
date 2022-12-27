import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager/Models/category/category_model.dart';
import 'package:money_manager/Models/transaction/transaction_model.dart';
import 'package:money_manager/Screens/add_transaction/add_transaction_screen.dart';
import 'package:money_manager/hive_db/category/category_db.dart';
import 'package:money_manager/splash_screen/splash_screen.dart';

Future<void> main() async {
  final obj1 = CategoryDb();
  final obj2 = CategoryDb();
  print(obj1 == obj2);

  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(CategoryTypeAdapter().typeId)) {
    Hive.registerAdapter(CategoryTypeAdapter());
  }
  if (!Hive.isAdapterRegistered(CategoryModelAdapter().typeId)) {
    Hive.registerAdapter(CategoryModelAdapter());
  }
  if (!Hive.isAdapterRegistered(TransactionModelAdapter().typeId)) {
    Hive.registerAdapter(TransactionModelAdapter());
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      routes: {
        AddTransaction.routeName: (ctx) => const AddTransaction(),
      },
    );
  }
}
