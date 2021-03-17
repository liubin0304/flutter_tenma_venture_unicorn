import 'package:flutter_tenma_venture_unicorn/database/tm_field.dart';
import 'package:flutter_tenma_venture_unicorn/database/tm_insert_field.dart';
import 'package:flutter_tenma_venture_unicorn/database/tm_query_delete_field.dart';
import 'package:flutter_tenma_venture_unicorn/utils/tm_logger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// 下载
/// iOS端配置：
/// 1、启用background mode
/// 2、添加 sqlite 依赖库
/// 3、设置 HTTP 请求支持
/// Android端配置：
/// <provider
///     android:name="vn.hunghd.flutterdownloader.DownloadedFileProvider"
///     android:authorities="${applicationId}.flutter_downloader.provider"
///     android:exported="false"
///     android:grantUriPermissions="true">
///     <meta-data
///         android:name="android.support.FILE_PROVIDER_PATHS"
///         android:resource="@xml/provider_paths"/>
/// </provider>
class TMDbHelper {
  factory TMDbHelper() => _getInstance();

  static TMDbHelper _instance;

  bool _initialized = false;

  String defaultDbName = "unicorn.db";
  Database database;

  static TMDbHelper _getInstance() {
    if (_instance == null) {
      _instance = TMDbHelper._init();
    }
    return _instance;
  }

  TMDbHelper._init() {
    print("TMDbHelper._init");
  }

  init({String dbName}) async {
    if (!_initialized) {
      defaultDbName = dbName ?? defaultDbName;
      String databasePath = await createDatabase();
      Database database = await openMDatabase(databasePath);
      this.database = database;
      _initialized = true;
    }
  }

  /// 生成数据库
  Future<String> createDatabase() async {
    var databasesPath = await getDatabasesPath();
    return join(databasesPath, defaultDbName);
  }

  /// 打开数据库
  Future<Database> openMDatabase(String databasePath) async {
    Database database =
        await openDatabase(databasePath, singleInstance: false, version: 1);
    return database;
  }

  /// 删除数据库
  deleteMDatabase() async {
    createDatabase().then((path) => {deleteDatabase(path)});
  }

  /// 关闭数据库
  closeDatabase() async {
    if (database == null) {
      throw Exception("database is not init");
    }
    await database.close();
  }

  /// 创建数据库表
  createTable(String tableName, List<TMField> fields) async {
    if (database == null) {
      throw Exception("database is not init");
    }
    if (fields.isEmpty) {
      throw Exception("table field is empty");
    }
    StringBuffer createTableSql =
        StringBuffer("CREATE TABLE IF NOT EXISTS $tableName (");

    for (int i = 0; i < fields.length; i++) {
      TMField element = fields[i];
      createTableSql.write(" ${element.name}");
      createTableSql.write(" ${enumToString(element.type)}");
      if (element.isPrimaryKey) {
        createTableSql.write(" PRIMARY KEY");
        if (element.isAutoIncrement) {
          createTableSql.write(" AUTOINCREMENT");
        }
      }

      if (i != fields.length - 1) {
        createTableSql.write(",");
      }
    }

    createTableSql.toString().contains(",");

    createTableSql.write(")");

    print("create table : ${createTableSql.toString()}");

    return database.execute(createTableSql.toString());
  }

  /// 插入数据
  /// tableName 数据表名
  /// fields 插入的数据集合
  Future<int> insert(String tableName, List<TMInsertField> fields) async {
    if (database == null) {
      throw Exception("database is not init");
    }
    if (fields.isEmpty) {
      throw Exception("table field is empty");
    }
    StringBuffer insertSql = StringBuffer("INSERT INTO $tableName (");

    for (int i = 0; i < fields.length; i++) {
      TMInsertField element = fields[i];
      insertSql.write(" ${element.key}");

      if (i != fields.length - 1) {
        insertSql.write(",");
      }
    }

    insertSql.write(") VALUES (");

    for (int i = 0; i < fields.length; i++) {
      TMInsertField element = fields[i];
      insertSql.write("'${element.value}'");

      if (i != fields.length - 1) {
        insertSql.write(",");
      }
    }

    insertSql.write(")");

    print("insert data : ${insertSql.toString()}");

    return await database.transaction((txn) async {
      return await txn.rawInsert(insertSql.toString());
    });
  }

  /// 查询数据
  /// tableName 数据表名
  /// whereArgs 条件参数
  /// limit 分页查询
  /// offset 数据偏移量; offset不能单独使用
  Future<List<Map<String, dynamic>>> query(String tableName,
      {List<TMQueryDelField> whereArgs = const [],
      int limit = 0,
      int offset = -1}) async {
    if (database == null) {
      throw Exception("database is not init");
    }

    StringBuffer querySql = StringBuffer('SELECT * FROM $tableName');

    if (whereArgs.isNotEmpty) {
      querySql.write(" WHERE ");
      for (int i = 0; i < whereArgs.length; i++) {
        TMQueryDelField element = whereArgs[i];
        querySql.write(" ${element.key}");
        querySql.write(" ${convertQueryType(element.type)} ");
        if (element.type == TMQueryDelFieldType.LIKE) {
          querySql.write("'%${element.value}%'");
        } else if (element.type == TMQueryDelFieldType.IN ||
            element.type == TMQueryDelFieldType.NOT_IN) {
          querySql.write("('${element.value}')");
        } else {
          querySql.write("'${element.value}'");
        }

        if (limit > 0) {
          querySql.write(" limit ($limit)");

          if (offset > -1) {
            querySql.write(" offset ($offset)");
          }
        }
      }
    }

    print("query data : ${querySql.toString()}");

    return await database.rawQuery(querySql.toString());
  }

  /// 删除数据
  /// tableName 数据表名
  /// whereArgs 条件参数
  /// limit 分页查询
  /// offset 数据偏移量; offset不能单独使用
  Future<List<Map<String, dynamic>>> delete(String tableName,
      {List<TMQueryDelField> whereArgs = const []}) async {
    if (database == null) {
      throw Exception("database is not init");
    }

    StringBuffer deleteSql = StringBuffer('DELETE FROM $tableName');

    if (whereArgs.isNotEmpty) {
      deleteSql.write(" WHERE ");
      for (int i = 0; i < whereArgs.length; i++) {
        TMQueryDelField element = whereArgs[i];
        deleteSql.write(" ${element.key}");
        deleteSql.write(" ${convertQueryType(element.type)} ");
        if (element.type == TMQueryDelFieldType.LIKE) {
          deleteSql.write("'%${element.value}%'");
        } else if (element.type == TMQueryDelFieldType.IN ||
            element.type == TMQueryDelFieldType.NOT_IN) {
          deleteSql.write("('${element.value}')");
        } else {
          deleteSql.write("'${element.value}'");
        }
      }
    }

    print("delete data : ${deleteSql.toString()}");

    return await database.rawQuery(deleteSql.toString());
  }

  /// 修改数据
  /// tableName 数据表名
  /// fields 需要修改的值
  /// whereArgs 条件参数
  /// limit 分页查询
  /// offset 数据偏移量; offset不能单独使用
  Future<List<Map<String, dynamic>>> update(
      String tableName, List<TMInsertField> fields,
      {List<TMQueryDelField> whereArgs = const []}) async {
    if (database == null) {
      throw Exception("database is not init");
    }

    if (fields.isEmpty) {
      throw Exception("table update field is empty");
    }

    StringBuffer updateSql = StringBuffer('UPDATE $tableName SET ');

    for (int i = 0; i < fields.length; i++) {
      TMInsertField field = fields[i];
      updateSql.write(field.key);
      updateSql.write(" = ");
      updateSql.write("'${field.value}'");
      if (i != fields.length - 1) {
        updateSql.write(",");
      }
    }

    if (whereArgs.isNotEmpty) {
      updateSql.write(" WHERE ");
      for (int i = 0; i < whereArgs.length; i++) {
        TMQueryDelField element = whereArgs[i];
        updateSql.write(" ${element.key}");
        updateSql.write(" ${convertQueryType(element.type)} ");
        if (element.type == TMQueryDelFieldType.LIKE) {
          updateSql.write("'%${element.value}%'");
        } else if (element.type == TMQueryDelFieldType.IN ||
            element.type == TMQueryDelFieldType.NOT_IN) {
          updateSql.write("('${element.value}')");
        } else {
          updateSql.write("'${element.value}'");
        }
      }
    }

    print("update data : ${updateSql.toString()}");

    return await database.rawQuery(updateSql.toString());
  }

  String convertQueryType(TMQueryDelFieldType type) {
    if (type == TMQueryDelFieldType.EQ) {
      return "==";
    } else if (type == TMQueryDelFieldType.NOT_EQ) {
      return "!=";
    } else if (type == TMQueryDelFieldType.GT) {
      return ">";
    } else if (type == TMQueryDelFieldType.LT) {
      return "<";
    } else if (type == TMQueryDelFieldType.GE) {
      return ">=";
    } else if (type == TMQueryDelFieldType.LE) {
      return "<=";
    } else if (type == TMQueryDelFieldType.LIKE) {
      return "like";
    } else if (type == TMQueryDelFieldType.IN) {
      return "in";
    } else if (type == TMQueryDelFieldType.NOT_IN) {
      return "not in";
    }
    return "=";
  }

  String enumToString(dynamic e) {
    return e.toString().split(".").last;
  }
}
