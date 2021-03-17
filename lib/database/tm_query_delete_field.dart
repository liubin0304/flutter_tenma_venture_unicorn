/// 数据库查询实体
class TMQueryDelField {
  /// 对应数据库表的字段名称
  String key;

  /// 需要插入的值
  dynamic value;

  /// 查询的类型
  TMQueryDelFieldType type;

  TMQueryDelField(this.key, this.value, this.type);
}

enum TMQueryDelFieldType {
  EQ, // == 等于
  NOT_EQ, // != 不等于
  GT, // > 大于
  LT, // < 小于
  GE, // >= 大于等于
  LE, // <= 小于等于
  LIKE, // 包含
  BETWEEN, // 两者之间
  IN, // 在某个值内
  NOT_IN, // 不在某个值内
}
