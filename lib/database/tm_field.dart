/// 数据库字段实体
class TMField {
  /// 数据库表字段名称
  String name;

  /// 字段类型
  TMFieldType type;

  /// 是否是主键
  bool isPrimaryKey;

  /// 是否自增
  bool isAutoIncrement;

  TMField(this.name, this.type,
      {this.isPrimaryKey = false, this.isAutoIncrement = false});
}

enum TMFieldType { INTEGER, TEXT, REAL, BLOB }
