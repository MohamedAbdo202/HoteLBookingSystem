import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../ViewModel/Cubit.dart';
import '../ViewModel/Stats.dart';
import 'HomePage.dart';
import '../Model/ModelClass.dart';
import 'Buildings.dart';

class RoomScreen extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final roomCubit = BlocProvider.of<RoomCubit>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Room List',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _searchController,
              onChanged: (value) {
                roomCubit.updateSearchQuery(value.trim());
                roomCubit.getAllRoomss();
              },
              decoration: InputDecoration(
                hintText: 'Search by guest name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<RoomCubit, MyState>(
                builder: (context, state) {
                  if (state is RoomsLoadedState) {
                    if (roomCubit.rooms.isEmpty) {
                      return Center(
                        child: Text('No rooms found'),
                      );
                    } else {
                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                          columns: [
                            DataColumn(label: Text('ID')),
                            DataColumn(label: Text('Room Number')),
                            DataColumn(label: Text('Building')),
                            DataColumn(label: Text('Guest Name')),
                            DataColumn(label: Text('Check-In Date')),
                            DataColumn(label: Text('Check-Out Date')),
                            DataColumn(label: Text('Remove'))
                          ],
                          rows: roomCubit.rooms.map((roomData) {
                            return DataRow(
                              cells: [
                                DataCell(Text('${roomData['id']}')),
                                DataCell(Text('${roomData['RoomNumber']}')),
                                DataCell(Text('${roomData['BuildingNumber']}')),
                                DataCell(Text('${roomData['GuestName']}')),
                                DataCell(Text('${roomData['CheckInDate']}')),
                                DataCell(Text('${roomData['CheckOutDate']}')),
                                DataCell(IconButton(
                                  onPressed: () {
                                    roomCubit.deletedatabase(roomData['id']);
                                  },
                                  icon: Icon(Icons.delete),
                                )),
                              ],
                            );
                          }).toList(),
                        ),
                      );
                    }
                  } else if (state is DatabaseErrorState) {
                    return Center(
                      child: Text('Error: ${state.errorMessage}'),
                    );
                  } else if (state is InsertErrorState) {
                    return Center(
                      child: Text('Insertion Error: ${state.errorMessage}'),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Buildings()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
