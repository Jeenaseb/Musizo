
import '../model/favouritesmodel.dart';



addToFavorites(int id, ) async {

if(favouritedb.values.contains(id)){
  return;
}
else{
  favouritedb.put(id, FavoriteModel(id: id));
}
  
}


removeFromFavorites(int id) async {
  favouritedb.delete(id);
  
  

}

bool isalready(id) {
  List<FavoriteModel> favouritesongs = [];
  favouritesongs = favouritedb.values.toList();

  if (favouritesongs.any((element) => element.id == id)) {
    return true;
  } else {
    return false;
  }
}

