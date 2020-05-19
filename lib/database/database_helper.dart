import 'package:WaterReminder/models/water_consumption_model.dart';
import 'package:WaterReminder/utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "water_consumption.db";
  static final _databaseVersion = 1;

  static final table = 'water_table';

  static final columnId = 'id';
  static final columnQuantity = 'quantity';
  static final columnTimestamp = 'timestamp';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnQuantity FLOAT NOT NULL,
            $columnTimestamp TEXT NOT NULL
          )
          ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(WaterConsumption consumption) async {
    Database db = await instance.database;
    return await db.insert(table, consumption.toMap());
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table, orderBy: "$columnTimestamp");
  }

  // Queries rows based on the argument received
  Future<List<Map<String, dynamic>>> queryRows(name) async {
    Database db = await instance.database;
    return await db.query(table, where: "$columnQuantity LIKE '%$name%'");
  }

  Future<double> getConsumptionForDate(DateTime dateTime) async {
    Database db = await instance.database;

    var query =
        "SELECT * FROM $table WHERE strftime('%d', $columnTimestamp)='${_twoDigits(dateTime.day)}' AND strftime('%m', $columnTimestamp)='${_twoDigits(dateTime.month)}' AND  strftime('%Y',$columnTimestamp)='${dateTime.year}' ";
    // var query = "SELECT * FROM $table WHERE date($columnTimestamp)= ${dateTime.toString()}";
    var result = await db.rawQuery(query);
    print(query);
    double sum = 0.0;
    result.forEach((obj) {
      sum += obj['quantity'];
    });
    return sum;
  }

  static String _twoDigits(int n) {
    if (n >= 10) return "${n}";
    return "0${n}";
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(WaterConsumption consumption) async {
    Database db = await instance.database;
    int id = consumption.toMap()['id'];
    return await db.update(table, consumption.toMap(),
        where: '$columnId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<void> clearTable() async {
    Database db = await instance.database;
    return await db.rawQuery("DELETE FROM $table");
  }

  Future<List<Map<String, dynamic>>> queryRowsForMonthYear(
      DateTime date) async {
    Database db = await instance.database;
    var whereClause = "strftime('%m', $columnTimestamp) = '${_twoDigits(date.month)}'";
    var query = "SELECT * FROM $table WHERE $whereClause";
    print(query);
    final res = await db.rawQuery(query);
    print(res);
    return res;
  }
}
