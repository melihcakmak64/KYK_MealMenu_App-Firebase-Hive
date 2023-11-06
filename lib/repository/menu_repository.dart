import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:kyk_menu/model/menu_model.dart';

class MenuRepository {
  final Stream<QuerySnapshot<Map<String, dynamic>>> menuReference =
      FirebaseFirestore.instance.collection("menus").snapshots();
  List<MenuModel> menus = <MenuModel>[];
  DateTime selectedDate = DateTime.now();
  var box = Hive.box("local");

  Future<void> fetchData() async {
    if (box.get("menus") != null) {
      bool isExist = false;
      var data = box.get("menus");
      String now = datetimeToString(DateTime.now());

      for (var map in data) {
        if (map["date"] == now) {
          isExist = true;
          break;
        }
      }
      if (isExist) {
        for (var menu in data) {
          menus.add(MenuModel(
              date: menu["date"],
              kahvalti: menu["kahvalti"],
              aksam: menu["aksam"]));
        }

        return;
      } else {
        try {
          box.clear();
          print("firebasea gidildi");
          QuerySnapshot<Map<String, dynamic>> querySnapshot =
              await FirebaseFirestore.instance.collection("menus").get();

          menus = querySnapshot.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return MenuModel.fromJson(data);
          }).toList();
          box.put("menus", menus.map((e) => e.toJson()).toList());
        } catch (e) {
          print("Hata: $e");
        }
      }
    } else {
      try {
        print("Firebase a gidildi");
        QuerySnapshot<Map<String, dynamic>> querySnapshot =
            await FirebaseFirestore.instance.collection("menus").get();

        menus = querySnapshot.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          return MenuModel.fromJson(data);
        }).toList();
        box.put("menus", menus.map((e) => e.toJson()).toList());
      } catch (e) {
        print("Hata: $e");
      }
    }
  }

  MenuModel getMenu(DateTime date) {
    var selectedMenu = menus.where((element) {
      return element.date == datetimeToString(date);
    }).toList();

    if (selectedMenu.isNotEmpty) {
      return selectedMenu[0];
    } else {
      return MenuModel.fromJson({
        "date": datetimeToString(date),
        "kahvalti": [],
        "aksam": [],
      });
    }
  }

  void nextDay() {
    var date = selectedDate.add(const Duration(days: 1));

    try {
      MenuModel menu = getMenu(date);
      if (menu.kahvalti.isNotEmpty) {
        selectedDate = date;
      }
    } catch (e) {}
  }

  void previousDay() {
    var date = selectedDate.subtract(const Duration(days: 1));

    if (date.isAfter(DateTime.now().subtract(const Duration(days: 1)))) {
      try {
        getMenu(date);
        selectedDate = date;
      } catch (e) {
        print("Hata: $e");
      }
    }
  }

  String menuToString(List<String> menu) {
    String stringMenu = "";
    for (var element in menu) {
      stringMenu += "•$element\n";
    }
    return stringMenu;
  }

  String getKahvalti() {
    MenuModel menuModel = getMenu(selectedDate);
    String menu = menuToString(menuModel.kahvalti);
    return menu;
  }

  String getAksam() {
    MenuModel menuModel = getMenu(selectedDate);
    String menu = menuToString(menuModel.aksam);
    return menu;
  }

  DateTime getLastDate() {
    menus.sort((a, b) {
      DateTime dateA = stringToDate(a.date);
      DateTime dateB = stringToDate(b.date);
      return dateA.compareTo(dateB);
    });

    return stringToDate(menus.last.date);
  }

  DateTime stringToDate(String date) {
    final dateArray = date.split("/");
    return DateTime(int.parse(dateArray[2]), int.parse(dateArray[1]),
        int.parse(dateArray[0]));
  }

  String datetimeToString(DateTime date) {
    var day = date.day;
    var month = date.month;
    var year = date.year;
    return "$day/$month/$year";
  }
}
