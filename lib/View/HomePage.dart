  import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
  import 'package:sqflite/sqflite.dart';
  import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:ssss/Shared/Compenents.dart';


import '../Model/ModelClass.dart';
import '../Repoistry/Repoistry.dart';
import '../Repoistry/Sqflite.dart';
import '../Shared/constants.dart';
import '../ViewModel/Cubit.dart';
import '../ViewModel/Stats.dart';
import 'home2.dart';

  class Homee extends StatelessWidget {

    final _formKey = GlobalKey<FormState>();

    TextEditingController buildingNumberController = TextEditingController();

    TextEditingController roomNumberController = TextEditingController();

    TextEditingController guestNameController = TextEditingController();

    TextEditingController checkInDateController = TextEditingController();

    TextEditingController checkOutDateController = TextEditingController();
    int isBooked = 0;


    @override

    Widget build(BuildContext context) {
      return      BlocConsumer<RoomCubit, MyState>(
            listener: (context, state) {

            },
            builder: (context, state) {
              var roomCubit = BlocProvider.of<RoomCubit>(context);
                 return Scaffold(
                  appBar: AppBar(title: Text('myhome')),
                  body: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [

                          defaultFormField(
                            controller: buildingNumberController, type:  TextInputType.number,
                            label: 'BuildingNumber',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Building Number';
                              }
                              return null;

                            },

                          ),

                          defaultFormField(controller: roomNumberController, type:  TextInputType.number,
                            label: 'RoomNumber',
                            validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Room Number';
                            }
                            return null;

                            },

                          ),

                          defaultFormField(controller: guestNameController, type:  TextInputType.name,
                            label: 'Guest Name',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Guest Name';
                              }
                              return null;

                            },

                          ),
                          defaultFormField(controller: checkInDateController,
                              label: 'CheckInDate',
                              prefix: Icons.calendar_month,
                              type: TextInputType.datetime,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Check-In Date';
                                }
                                return null;
                              },
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2023, 9, 1), // Use DateTime object with valid format
                                ).then((DateTime? value) {
                                  if (value != null) {
                                    print(DateFormat.yMMMd().format(value));
                                    checkInDateController.text=DateFormat.yMMMd().format(value);
                                  } else {
                                    // The user canceled the date picker, handle the null value case here if needed.
                                  }
                                });
                              }


                          ),
                          defaultFormField(controller: checkOutDateController,
                              prefix: Icons.calendar_month,
                              type: TextInputType.datetime,
                              label: 'CheckOutDate',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Check-OUT Date';
                                }
                                return null;
                              },
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2030, 9, 1), // Use DateTime object with valid format
                                ).then((DateTime? value) {
                                  if (value != null) {
                                    print(DateFormat.yMMMd().format(value));
                                    checkOutDateController.text=DateFormat.yMMMd().format(value);
                                  } else {
                                    // The user canceled the date picker, handle the null value case here if needed.
                                  }
                                });
                              }

                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                // Create a Booking object from the form fields
                                Booking newBooking = Booking(
                                  isBooked: isBooked,
                                  buildingNumber: int.parse(
                                      buildingNumberController.text),
                                  roomNumber: int.parse(roomNumberController.text),
                                  guestName: guestNameController.text,
                                  checkInDate: checkInDateController.text,
                                  checkOutDate: checkOutDateController.text,
                                );
                               await roomCubit.insertBooking(newBooking);

                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => RoomScreen ()));

                                // Call the function to insert the Booking object into the database
                              }
                            },
                            child: Text('Submit'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );

              }

          );



      // void _initSqflite() {
      //   databaseFactory = databaseFactoryFfi;
      //   sqfliteFfiInit();
      // }
      //
      // Future<void> createDatabase() async {
      //   _initSqflite(); // Initialize sqfliteFfi before opening the database
      //
      //    database = await openDatabase(
      //     'Hotel.db',
      //     version: 1,
      //     onCreate: (database, version) async {
      //       await database.execute(
      //         'CREATE TABLE ROOMS(id INTEGER PRIMARY KEY,BuildingNumber INTEGER,RoomNumber INTEGER,GuestName TEXT,CheckInDate TEXT,CheckOutDate TEXT)',
      //       );
      //       print('Table Created');
      //     },
      //     onOpen: (database) async {
      //       await GetDatabase(database).then((value) {
      //
      //         Rooms=value;
      //         print(Rooms);
      //       });        print('database open ');
      //     },
      //   );
      // }
      // Future<void> insertBooking(Booking booking) async {
      //   final db = await database; // Make sure the database is initialized before calling this function
      //
      //   try {
      //     await db!.transaction((txn) async {
      //       await txn.insert(
      //         'ROOMS',
      //         booking.toMap(), // Convert the Booking object to a map of values
      //         conflictAlgorithm: ConflictAlgorithm.replace, // Optional: Handle conflicts
      //       );
      //     });
      //     await GetDatabase(database).then((value) {
      //
      //       Rooms=value;
      //       print(Rooms);
      //     });
      //     print('Booking inserted successfully');
      //   } catch (error) {
      //     print('Error in insert: ${error.toString()}');
      //   }
      // }
      // Future<List<Map>> GetDatabase(database) async{
      //   return await database!.rawQuery('SELECT* FROM ROOMS');
      //
      //
      // }
    }}
