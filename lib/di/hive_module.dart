
import 'package:contact_app/core/hive/hive_helper.dart';
import 'package:contact_app/pages/main/main_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

GetIt getIt = GetIt.instance;

Future<void> setUpDatabase() async {
  Box box;

  if(await Hive.boxExists(HiveHelper.boxName)) {
    box = await Hive.openBox(HiveHelper.boxName);
  } else {
    box = await Hive.openBox(HiveHelper.boxName);
  }

  getIt.registerLazySingleton(() => HiveHelper(box));
  getIt.registerLazySingleton(() => MainBloc(getIt.get()));

}