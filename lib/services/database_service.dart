import 'package:observable_ish/observable_ish.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stacked/stacked.dart';

import 'package:aiavatar/locator.dart';
import 'package:aiavatar/models/models.dart';
import 'package:aiavatar/services/services.dart';
import 'package:aiavatar/utils/utils.dart';

class DBService with ListenableServiceMixin {
  final _databaseRx = RxValue<Database?>(null);
  Database? get database => _databaseRx.value;

  DBService() {
    listenToReactiveValues([
      _databaseRx,
    ]);
  }

  Future<String> getDBPath() async {
    return join(await getDatabasesPath(), kDBName);
  }

  Future<DBService> init() async {
    try {
      var path = await getDBPath();
      logger.d(path);

      _databaseRx.value = await openDatabase(
        path,
        version: 1,
        onCreate: (Database db, int version) async {
          logger.d('db onCreate --- $db');
          await db.execute('''
CREATE TABLE $tableUser (
  id INTEGER PRIMARY KEY, 
  $columnUserAddress TEXT, 
  $columnUserAvatar TEXT, 
  $columnUserFirstName TEXT, 
  $columnUserLastName TEXT)
  ''');
        },
      );

      logger.d(path);
    } catch (e) {
      logger.e(e);
      await close();
    }
    return this;
  }

  Future<UserModel?> getUser() async {
    var maps = await database?.query(
      tableUser,
      columns: [
        columnUserID,
        columnUserAddress,
        columnUserAvatar,
        columnUserFirstName,
        columnUserLastName,
      ],
    );
    if (maps?.isNotEmpty ?? false) {
      return UserModel.fromJson(maps!.first);
    }
    return null;
  }

  Future<void> setUser(UserModel model) async {
    var user = await getUser();
    if (user == null) {
      await database?.insert(
        tableUser,
        model.toJson(),
      );
    } else {
      await database?.update(
        tableUser,
        model.toJson(),
        where: '$columnUserID= ?',
        whereArgs: [user.id],
      );
    }
  }

  Future close() async => database?.close();
}

class DBHelper {
  static DBService get service => locator<DBService>();

  static Future<UserModel?> get user => service.getUser();
  static Future<void> setUser(UserModel user) => service.setUser(user);
}
