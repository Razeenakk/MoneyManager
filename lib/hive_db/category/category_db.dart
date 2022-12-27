import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager/Models/category/category_model.dart';

/// 3 functions;
/// category insert function, category dlt function,category get function.



const CATEGORY_DB_NAME ='category_database';





abstract class CategoryDbFunctions{
 Future <List<CategoryModel>>getCategories(); /// get list of data
Future<void> insertCategory(CategoryModel value);
Future<void> deleteCategory(String categoryID); /// dlt function
}




class CategoryDb implements CategoryDbFunctions{
/// create singleten;
  /// // first create a object of  catgrydb then call a variable in this object when return

CategoryDb._internal();  ///  create a named cnstructor aan _internal
static CategoryDb instance = CategoryDb._internal();  /// instancelott CategoryDb._internal() aychuu
/// new new object create aavaathee   orattee objectee creataavolluu .aa oratta objectnee return cheyyukayumollu  factory method;
/// /// in factory method oratta cnstcr illengil new cnstrctr crrerate aakki aykkm
/// factory method;
factory CategoryDb(){  /// when create catogerydb return cheyyl instance aan. athyth ini yeethu ctgrydbntee object create cheythlm instance aan thirich aykkal
  return instance;
}


ValueNotifier<List<CategoryModel>> incomeCategoryListListener = ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> expenseCategoryListListener = ValueNotifier([]);


  @override
  Future<void> insertCategory(CategoryModel value)async {
   final _categoryDb = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
 await   _categoryDb.put(value.id , value); /// put function add key and its value
 refreshUi();

  }

  @override
  Future<List<CategoryModel>> getCategories() async{
    final _categoryDb = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
   return  _categoryDb.values.toList();

  }


  /// ui refresh function when insert time;
Future<void> refreshUi ()async{
    final _allCategories = await getCategories();
    /// clear all data in each categories code;
    incomeCategoryListListener.value.clear();
    expenseCategoryListListener.value.clear();
    /// split income and expense in getCategories function its we can use for each loop;
  await Future.forEach(_allCategories, (CategoryModel category) {
    /// check type ie, income or expense;
    if(category.type == CategoryType.income ){
      incomeCategoryListListener.value.add(category);
    }else{
     expenseCategoryListListener.value.add(category) ;
    }
  });
    incomeCategoryListListener.notifyListeners();  /// this code listen for  incomeCategoryList
  expenseCategoryListListener.notifyListeners();

}




///dlt function;
  @override
  Future<void> deleteCategory(String categoryID) async {
    /// first open box;
    final _categoryDb = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await _categoryDb.delete(categoryID);
    refreshUi();

  }
}