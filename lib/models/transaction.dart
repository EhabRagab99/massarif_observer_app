class Transaction {
  final String id;
  final String title;
  final double amount;
  late final DateTime date;
  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
  });
}
