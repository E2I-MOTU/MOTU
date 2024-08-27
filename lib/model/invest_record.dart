import 'package:motu/service/scenario_service.dart';

class InvestRecord {
  String stock;
  TransactionType type;
  int price;
  int amount;

  InvestRecord({
    required this.stock,
    required this.type,
    required this.price,
    required this.amount,
  });

  InvestRecord.fromMap(Map<String, dynamic> map)
      : stock = map['stock'],
        type = map['type'],
        price = map['price'],
        amount = map['amount'];

  Map<String, dynamic> toMap() {
    return {
      'stock': stock,
      'type': type,
      'price': price,
      'amount': amount,
    };
  }
}
