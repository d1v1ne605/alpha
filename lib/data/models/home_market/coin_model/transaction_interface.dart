abstract class ITransaction {
  int get id;
  dynamic get price;
  dynamic get amount;
  dynamic get total;
  dynamic get market;
  dynamic get createdAt;
  String get takerType;
}
