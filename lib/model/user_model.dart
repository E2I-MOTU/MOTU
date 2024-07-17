class UserModel {
  final String email;
  final String name;
  final int balance;

  UserModel({
    required this.email,
    required this.name,
    required this.balance,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      balance: data['balance'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'balance': balance,
    };
  }
}
