import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';


import '../ViewModel/Cubit.dart';
import '../ViewModel/Stats.dart';

class RoomPagee extends StatefulWidget {
  final int buildingNumber;
  final int roomNumber;

  RoomPagee({required this.buildingNumber, required this.roomNumber});

  @override
  _RoomPageeState createState() => _RoomPageeState();
}

class _RoomPageeState extends State<RoomPagee> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();

    // Fetch booked rooms data using the RoomCubit

  }

  @override
  Widget build(BuildContext context) {
    final roomCubit = BlocProvider.of<RoomCubit>(context);
    roomCubit.getBookedRooms();
    return BlocBuilder<RoomCubit, MyState>(
      builder: (context, state) {
        if (state is RoomsBookedLoadedState) {
          // Data loaded successfully, get the booked rooms list from the state
          final bookedRooms = roomCubit.notavaliable;

          // Find all bookings for the specified building and room
          List<Map> bookings = bookedRooms.where(
                (room) =>
            room['BuildingNumber'] == widget.buildingNumber &&
                room['RoomNumber'] == widget.roomNumber,
          ).toList();

          // Check if the room is booked for the selected date
          bool isBooked = false;
          if (bookings.isNotEmpty) {
            for (var booking in bookings) {
              DateTime checkInDate = _parseDate(booking['CheckInDate']);
              DateTime checkOutDate = _parseDate(booking['CheckOutDate']);
              if (selectedDate.isAfter(checkInDate) &&
                  selectedDate.isBefore(checkOutDate)) {
                isBooked = true;
                break;
              }
            }
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Room ${widget.roomNumber} in Building ${widget.buildingNumber}",
              ),
            ),
            body: Column(
              children: [
                SizedBox(height: 20),
                Center(
                  child: Text(
                    isBooked
                        ? 'Room is booked for the selected date.'
                        : 'Room is available for the selected date.',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: TableCalendar(
                    focusedDay: selectedDate,
                    firstDay: DateTime.now(),
                    lastDay: DateTime.now().add(Duration(days: 365)),
                    calendarFormat: CalendarFormat.month,
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        selectedDate = selectedDay;
                      });
                    },
                    calendarBuilders:
                    CalendarBuilders(
                      // Customize the appearance of each day cell in the calendar
                      // Inside the defaultBuilder of calendarBuilders
                      defaultBuilder: (context, date, events) {
                        bool isSelected = isSameDay(selectedDate, date);

                        // Find bookings for the current date
                        List<Map> bookingsForDate = bookings.where((booking) {
                          DateTime checkInDate = _parseDate(booking['CheckInDate']);
                          DateTime checkOutDate = _parseDate(booking['CheckOutDate']);
                          return date.isAfter(checkInDate) && date.isBefore(checkOutDate) ||
                              isSameDay(date, checkOutDate); // Include the checkOutDate in the booked range
                                            }).toList();

                        // Check if the room is booked for the current date
                        bool isBooked = bookingsForDate.isNotEmpty;

                        // Get guest names for the current date and join them into a single string
                        String guestNamesString = '';
                        if (isBooked) {
                          List<String> guestNames = [];
                          for (var booking in bookingsForDate) {
                            guestNames.add(booking['GuestName']); // Add each guest name to the list
                          }
                          guestNamesString = guestNames.join(', ');
                        }

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedDate = date;
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: isSelected ? Border.all(color: Colors.blue) : Border.all(color: Colors.grey),
                              color: isBooked ? Colors.red : Colors.green,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  date.day.toString(),
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: isSelected ? Colors.blue : Colors.white,
                                  ),
                                ),
                                if (isBooked)
                                  Text(
                                    guestNamesString,
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: isSelected ? Colors.blue : Colors.white,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },

                    ),
                  ),


                ),
              ],
            ),
          );
        } else if (state is DatabaseGetBookedErrorState) {
          // Show error UI if loading booked rooms data failed
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Room ${widget.roomNumber} in Building ${widget.buildingNumber}",
              ),
            ),
            body: Center(
              child: Text(
                'Failed to load booked rooms: ${(state as DatabaseGetBookedErrorState).errorMessage}',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          );
        } else {
          // Show loading UI while fetching booked rooms data
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Room ${widget.roomNumber} in Building ${widget.buildingNumber}",
              ),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
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
}
