class WaterConsumption {
  final int id;
  final double quantity;
  final DateTime dateTime;
  WaterConsumption({this.id, this.quantity, this.dateTime});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quantity': quantity,
      'timestamp': dateTime.toIso8601String()
    };
  }

  static List<WaterConsumption> fromMap(List<Map<String, dynamic>> list) {
    return list.map(
      (e) {
        return WaterConsumption(
          id: e['id'],
          quantity: e['quantity'],
          dateTime: DateTime.parse(e['timestamp']),
        );
      },
    ).toList();
  }
}
