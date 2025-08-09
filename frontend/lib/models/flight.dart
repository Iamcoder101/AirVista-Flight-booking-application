class Flight {
  final String flightNumber;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final double price;
  final String origin;
  final String destination;
  final int adults;

  Flight({
    required this.flightNumber,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.price,
    required this.origin,
    required this.destination,
    required this.adults,
  });

  factory Flight.fromJson(Map<String, dynamic> json) {
    return Flight(
      flightNumber: json['flightNumber'] ?? '',
      departureTime: json['departureTime'] ?? '',
      arrivalTime: json['arrivalTime'] ?? '',
      duration: json['duration'] ?? '',
      price: json['price']?.toDouble() ?? 0.0,
      origin: json['origin'] ?? '',
      destination: json['destination'] ?? '',
      adults: json['adults'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'flightNumber': flightNumber,
      'departureTime': departureTime,
      'arrivalTime': arrivalTime,
      'duration': duration,
      'price': price,
      'origin': origin,
      'destination': destination,
      'adults': adults,
    };
  }
}
