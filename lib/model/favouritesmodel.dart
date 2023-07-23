import 'package:hive_flutter/hive_flutter.dart';
part 'favouritesmodel.g.dart';

@HiveType(typeId: 2)
class FavoriteModel extends HiveObject{
  @HiveField(0)
  int id;

FavoriteModel({required this.id});


}
late Box<FavoriteModel> favouritedb;
openFavouritesdb() async{
  favouritedb =  await Hive.openBox<FavoriteModel>("all_favsongs");
}