import 'package:sqflite/sqflite.dart';


class LocaleDatabase{

  LocaleDatabase({
    required this.rootPath
  }){_createDatabase();}

  Future<void> _createDatabase()async{
    db = await openDatabase(rootPath);
  }

  late final String rootPath;
  late final Database db ;

  Future<Database> create(String path) async{
    rootPath = path;
    db = await openDatabase(path);
    return db;
  }

}