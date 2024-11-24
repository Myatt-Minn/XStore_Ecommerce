class Region {
  final String id; // Document ID
  final String name;
  final List<City> cities;

  Region({
    required this.id,
    required this.name,
    required this.cities,
  });

  // Factory method to create a Region from Firestore data
  factory Region.fromMap(String id, Map<String, dynamic> map) {
    return Region(
      id: id,
      name: map['name'] ?? '',
      cities: (map['cities'] as List<dynamic>)
          .map((city) => City.fromMap(city))
          .toList(),
    );
  }

  // Method to convert a Region into Firestore-compatible data
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'cities': cities.map((city) => city.toMap()).toList(),
    };
  }
}

class City {
  final String name;
  final int deliveryFee;

  City({
    required this.name,
    required this.deliveryFee,
  });

  // Factory method to create a City from Firestore data
  factory City.fromMap(Map<String, dynamic> map) {
    return City(
      name: map['name'] ?? '',
      deliveryFee: map['deliveryFee'] ?? 0,
    );
  }

  // Method to convert a City into Firestore-compatible data
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'deliveryFee': deliveryFee,
    };
  }
}
