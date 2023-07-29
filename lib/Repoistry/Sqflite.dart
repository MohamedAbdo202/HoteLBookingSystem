import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../Model/ModelClass.dart';
import '../Shared/constants.dart';

class SqfliteDataSource {
  Database? database;
  List<Map>Rooms=[];


  void _initSqflite() {
    databaseFactory = databaseFactoryFfi;
    sqfliteFfiInit();
  }

  Future<void> createDatabase() async {
    _initSqflite(); // Initialize sqfliteFfi before opening the database

    database = await openDatabase(
      'Hotel.db',
      version: 4,
      onCreate: (database, version) async {
        await database.execute(
          'CREATE TABLE ROOMS(id INTEGER PRIMARY KEY,BuildingNumber INTEGER,RoomNumber INTEGER,GuestName TEXT,CheckInDate TEXT,CheckOutDate TEXT,)',
        );
        print('Table Created');
      },
      onUpgrade: (database, oldVersion, newVersion) async {
        if (oldVersion < 4) {
          await database.execute('ALTER TABLE ROOMS ADD COLUMN isBooked INTEGER');
        }
      },
         onOpen: (database) async {

        await GetDatabase(database).then((value) {

          Rooms=value;


        });        print('database open ');


      },

    );
  }



  Future<List<Map>> GetDatabase(database) async{
    return await database!.rawQuery('SELECT* FROM ROOMS');


  }




  Future<List<Map>> GetDataBooked(database) async{
    return await database!.rawQuery('SELECT * FROM ROOMS WHERE isBooked = ?', [0]);


  }


  Future<void> deletedatabase(int requiredid) async {
    // Replace 'sql' with the actual SQL query you want to execute.
    String sql = 'DELETE FROM ROOMS WHERE id = ?';

    // Perform the raw SQL delete operation asynchronously using 'rawDelete'.
    await database!.rawDelete(sql, [requiredid]);
    await GetDatabase(database).then((value) {

      Rooms=value;
    });
  }
  Future<List<Map>>getBookingsForRoom(int buildingNumber, int roomNumber) async {


    return await database!.rawQuery(
      'SELECT * FROM ROOMS WHERE BuildingNumber = ? AND RoomNumber = ?',
      [buildingNumber, roomNumber],
    );
  }
  Future<void> insertBooking(Booking booking) async {
      final db = await database; // Make sure the database is initialized before calling this function

      try {
        await db!.transaction((txn) async {
          await txn.insert(
            'ROOMS',
            booking.toMap(), // Convert the Booking object to a map of values
            conflictAlgorithm: ConflictAlgorithm.replace, // Optional: Handle conflicts
          );
        });
        await GetDatabase(database).then((value) {

          Rooms=value;
          print(Rooms);
        });
        print('Booking inserted successfully');
      } catch (error) {
        print('Error in insert: ${error.toString()}');
      }
    }
   }
