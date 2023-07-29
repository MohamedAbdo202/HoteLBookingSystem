import '../Model/ModelClass.dart';
import 'Sqflite.dart';

class MyRepository {
  final SqfliteDataSource dataSource;

  MyRepository(this.dataSource);

  Future<void> createDatabase() async {
    await dataSource.createDatabase();
  }

  Future<List<Map>> getAllRooms() async {
    // Make sure the database is created before accessing it.
    await dataSource.createDatabase();
    return await dataSource.GetDatabase(dataSource.database);
  }

  Future<List<Map>> getBookedRooms() async {
    await dataSource.createDatabase();

    return await dataSource.GetDataBooked(dataSource.database);
  }


  Future<void> insertBooking(Booking booking) async {
    // Make sure the database is created before inserting the booking.
    await dataSource.createDatabase();
    await dataSource.insertBooking(booking);
  }

  Future<void> deleteBooking(int id) async {
    // Make sure the database is created before deleting the booking.
    await dataSource.createDatabase();
    await dataSource.deletedatabase(id);
  }

  Future<List<Map>> getBookingsForRoom(int buildingNumber, int roomNumber) async {
    await dataSource.createDatabase();
    return await dataSource.getBookingsForRoom(buildingNumber, roomNumber);
  }

}

