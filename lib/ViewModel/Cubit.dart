import 'package:bloc/bloc.dart';

import '../Model/ModelClass.dart';
import '../Repoistry/Repoistry.dart';
import 'Stats.dart';

class RoomCubit extends Cubit<MyState> {
  final MyRepository repository;

  RoomCubit(this.repository) : super(InitialState());

  Future<void> createDatabase() async {
    try {
      await repository.createDatabase();
      emit(DatabaseCreatedState());
      getAllRooms(); // Refresh the room list after successful insertion.

    } catch (error) {
      emit(DatabaseErrorState('Failed to create database: ${error.toString()}'));
    }
  }
  late List<Map> rooms=[];
  late List<Map> notavaliable=[];


  Future<void> getAllRooms() async {
    rooms=[];
    try {
      rooms = await repository.getAllRooms();
      emit(RoomsLoadedState());
    } catch (error) {
      emit(DatabaseGetErrorState('Failed to load rooms: ${error.toString()}'));
    }
  }

  Future<void> getBookedRooms() async {
    notavaliable=[];
    try {
      notavaliable = await repository.getBookedRooms();
      emit(RoomsBookedLoadedState());
      print(notavaliable);
    } catch (error) {
      emit(DatabaseGetBookedErrorState('Failed to load rooms: ${error.toString()}'));
    }
  }
  Future<void> deletedatabase(int id ) async {
    try {
      await repository.deleteBooking(id);
      emit(DatabaseDeletedState());
     await getAllRooms(); // Refresh the room list after successful insertion.
    } catch (error) {
      emit(DeletedErrorState('Failed to insert booking: ${error.toString()}'));
    }
  }
  Future<void> insertBooking(Booking booking) async {

    try {
      await repository.insertBooking(booking);
      emit(DatabaseInsertedState());
      getAllRooms(); // Refresh the room list after successful insertion.
    } catch (error) {
      emit(InsertErrorState('Failed to insert booking: ${error.toString()}'));
    }
  }
  late List<Map> Roomnumber=[];

  Future<void> getBookingsForRoom(int buildingNumber, int roomNumber) async {
    Roomnumber=[];
    try {
      Roomnumber= await repository.getBookingsForRoom(buildingNumber, roomNumber);
      emit(RoomsBookedwithNOLoadedState());
    } catch (error) {
      emit(DatabaseGetBookedErrorState('Failed to load bookings: ${error.toString()}'));
    }
  }

  // Method to check if a specific room is booked for today's date
  bool isRoomBookedForDate(int roomNumber, List<Map> bookedRooms, DateTime date,buildingNumber) {
    for (var room in bookedRooms) {
      if (room['BuildingNumber'] == buildingNumber && room['RoomNumber'] == roomNumber) {
        DateTime checkInDate = _parseDate(room['CheckInDate']);
        DateTime checkOutDate = _parseDate(room['CheckOutDate']);

        // If the current date falls within the booked date range, room is booked for today
        if (date.isAfter(checkInDate) && date.isBefore(checkOutDate)) {
          return true;
        }
      }
    }
    return false;
  }

  DateTime _parseDate(String dateStr) {
    final months = {
      'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4, 'May': 5, 'Jun': 6,
      'Jul': 7, 'Aug': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12
    };

    final parts = dateStr.split(' '); // Split the date string by spaces
    final month = months[parts[0]]; // Get the month value from the months map
    final day = int.parse(parts[1].replaceAll(',', '')); // Parse the day as an integer
    final year = int.parse(parts[2]); // Parse the year as an integer

    return DateTime(year, month!, day);
  }

  int getAvailableRoomsForBuildingToday(List<Map> bookedRooms, int buildingNumber) {
    int totalRoomsInBuilding = 15;
    int bookedRoomsInBuildingToday = 0;
    DateTime today = DateTime.now();

    for (var room in bookedRooms) {
      if (room['BuildingNumber'] == buildingNumber) {
        DateTime checkInDate = _parseDate(room['CheckInDate']);
        DateTime checkOutDate = _parseDate(room['CheckOutDate']);

        // If the current date falls within the booked date range, increment the bookedRoomsInBuildingToday count
        if (today.isAfter(checkInDate) && today.isBefore(checkOutDate)) {
          bookedRoomsInBuildingToday++;
        }
      }
    }

    return totalRoomsInBuilding - bookedRoomsInBuildingToday;
  }



  String _searchQuery = ''; // New field to hold the search query

  void updateSearchQuery(String query) {
    _searchQuery = query;
  }

  // Method to get all rooms with search filtering
  Future<void> getAllRoomss() async {
    try {
      final List<Map> allRooms = await repository.getAllRooms();

      // Apply search filtering based on the guest name
      if (_searchQuery.isNotEmpty) {
        rooms = allRooms.where((roomData) {
          String guestName = roomData['GuestName'].toString().toLowerCase();
          return guestName.contains(_searchQuery.toLowerCase());
        }).toList();
      } else {
        rooms = allRooms;
      }

      emit(RoomsLoadedState());
    } catch (error) {
      emit(DatabaseGetErrorState('Failed to load rooms: ${error.toString()}'));
    }
  }
}
