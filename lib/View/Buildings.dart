import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../ViewModel/Cubit.dart';
import '../ViewModel/Stats.dart';
import 'Rooms.dart';

class Buildings extends StatelessWidget {
  const Buildings({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    // Access the RoomCubit instance
    final roomCubit = BlocProvider.of<RoomCubit>(context);
    roomCubit.getBookedRooms();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            await roomCubit.getAllRooms();
            Navigator.pop(context);
          },
        ),
        title: Text("Buildings"),
      ),
      body: BlocBuilder<RoomCubit, MyState>(
        builder: (context, state) {
          // Check the state and update the bookedRooms list accordingly
          late List<Map> bookedRooms = [];
          if (state is RoomsBookedLoadedState) {
            bookedRooms = roomCubit.notavaliable;
            print(bookedRooms);
          }

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: 40,
            itemBuilder: (context, index) {
              int buildingNumber = 1 + index;

              int availableRoomsInBuilding = roomCubit.getAvailableRoomsForBuildingToday(bookedRooms, buildingNumber);

              return InkWell(
                onTap: () {
                  // Handle building tap if needed
                  print("Building $buildingNumber tapped!");
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => RoomPage(buildingNumber: buildingNumber)),
                  );
                },
                child: Container(
                  color: Colors.grey[300],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.apartment_outlined, size: 70),
                      Text(
                        "Building $buildingNumber",
                        style: TextStyle(fontSize: 20.0),
                      ),
                      if (availableRoomsInBuilding > 0)
                        Text(
                          "Available rooms: $availableRoomsInBuilding",
                          style: TextStyle(fontSize: 12.0),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
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
