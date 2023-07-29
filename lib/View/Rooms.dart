  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';


  import '../ViewModel/Cubit.dart';
import '../ViewModel/Stats.dart';
import 'inside.dart';

  class RoomPage extends StatefulWidget {
    final int buildingNumber;

    RoomPage({required this.buildingNumber});

    @override
    _RoomPageState createState() => _RoomPageState();
  }

  class _RoomPageState extends State<RoomPage> {
    late DateTime currentDate;

    @override
    void initState() {
      super.initState();
      currentDate = DateTime.now();
    }

    @override
    Widget build(BuildContext context) {
      final roomCubit = BlocProvider.of<RoomCubit>(context);
      roomCubit.getBookedRooms();

      return Scaffold(
        appBar: AppBar(title: Text("Rooms for Building ${widget.buildingNumber}")),
        body: BlocConsumer<RoomCubit, MyState>(
          listener: (context, state) {},
          builder: (context, state) {
            late List<Map> bookedRooms = [];
            if (state is RoomsBookedLoadedState) {
              bookedRooms = roomCubit.notavaliable;
            }

            int startRoom = (widget.buildingNumber - 1) * 15 + 1;
            int endRoom = widget.buildingNumber * 15;

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: endRoom - startRoom + 1,
              itemBuilder: (context, index) {
                int roomNumber = startRoom + index;

                // Check if the room is booked for today's date
                bool isRoomBookedForToday = roomCubit.isRoomBookedForDate(roomNumber, bookedRooms, currentDate,widget.buildingNumber);

                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RoomPagee(roomNumber: roomNumber, buildingNumber: widget.buildingNumber),
                      ),
                    );
                    print("Room $roomNumber tapped!");
                  },
                  child: Container(
                    color: isRoomBookedForToday ? Colors.red : Colors.green,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.bed, size: 70),
                        Text(
                          "Room $roomNumber",
                          style: TextStyle(fontSize: 20.0),
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


  }
