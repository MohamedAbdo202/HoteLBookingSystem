abstract class MyState {}

class InitialState extends MyState {}

class DatabaseCreatedState extends MyState {}

class DatabaseInsertedState extends MyState {}
class DatabaseDeletedState extends MyState {}

class RoomsLoadedSearchState extends MyState {

  RoomsLoadedSearchState();
}

class RoomsLoadedState extends MyState {

  RoomsLoadedState();
}
class RoomsBookedLoadedState extends MyState {

  RoomsBookedLoadedState();
}class RoomsBookedwithNOLoadedState extends MyState {

  RoomsBookedwithNOLoadedState();
}
class DatabaseErrorState extends MyState {
  final String errorMessage;

  DatabaseErrorState(this.errorMessage);
}
class DatabaseGetErrorState extends MyState {
  final String errorMessage;

  DatabaseGetErrorState(this.errorMessage);
}
class DatabaseGetBookedErrorState extends MyState {
  final String errorMessage;

  DatabaseGetBookedErrorState(this.errorMessage);
}
class DeletedErrorState extends MyState {
  final String errorMessage;

  DeletedErrorState(this.errorMessage);
}

class InsertErrorState extends MyState {
  final String errorMessage;

  InsertErrorState(this.errorMessage);
}
class SearchErrosState extends MyState {
  final String errorMessage;

  SearchErrosState(this.errorMessage);
}