import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/cubit/app_states.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  List<Map> tasks = [];
  Database database;

  void createDatabase() {
    openDatabase("todoia", version: 1, onCreate: (db, v) {
      db.execute(
          "CREATE TABLE Tasks (id INTEGER PRIMARY KEY,body TEXT,time TEXT,isDone INTEGER)");
    }, onOpen: (db) {
      getTasks(db);
    }).then((db) {
      database = db;
      emit(CreateDbState());
      print("db created");
    });
  }

  Future insertIntoDb(String body, String time, int isDone) async {
    return await database
        .transaction((txn) => txn.rawInsert(
            "INSERT INTO Tasks(body,time,isDone) VALUES('$body','$time',$isDone)"))
        .then((value) {
      emit(InsertDbState());
      getTasks(database);
      emit(GetDbState());
    });
  }

  void updateDb(
    int id,
    int val,
  ) async {
    await database.rawUpdate(
        "UPDATE Tasks SET isDone=? WHERE id=?", ["$val", id]).then((_) {
      emit(UpdateDbState());

      getTasks(database);
    });
  }

  void getTasks(Database db) {
    db.rawQuery("SELECT * FROM Tasks").then((value) {
      tasks = value;
      print(tasks);
      emit(GetDbState());
    });
  }
}
