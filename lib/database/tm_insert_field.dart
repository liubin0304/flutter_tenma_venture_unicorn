/// 插入数据实体
class TMInsertField {
  /// 对应数据库表的字段名称
  String key;

  /// 需要插入的值
  dynamic value;

  TMInsertField(this.key, this.value);
}
