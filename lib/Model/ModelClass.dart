class Booking {
  final int buildingNumber;
  final int roomNumber;
  final String guestName;
  final String checkInDate;
  final String checkOutDate;
  final int isBooked;


  Booking({
    required this.buildingNumber,
    required this.roomNumber,
    required this.guestName,
    required this.checkInDate,
    required this.checkOutDate,
    required this.isBooked
  });

  // Named constructor for creating a Booking object from JSON data
  Booking.fromJson(Map<String, dynamic> json)
      :
        buildingNumber = json['buildingNumber'],
        roomNumber = json['roomNumber'],
        guestName = json['guestName'],
        isBooked=json['isBooked'],
        checkInDate = json['checkInDate'],
        checkOutDate = json['checkOutDate'];

  Map<String, dynamic> toMap() {
    return {
      'buildingNumber': buildingNumber,
      'roomNumber': roomNumber,
      'guestName': guestName,
      'checkInDate': checkInDate,
      'checkOutDate': checkOutDate,
      'isBooked': isBooked
    };
  }
}
