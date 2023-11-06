import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kyk_menu/constants/constants.dart';
import 'package:kyk_menu/model/menu_model.dart';
import 'package:kyk_menu/repository/menu_repository.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late final MenuRepository menuRepository;
  var isLoaded = false;
  @override
  void initState() {
    _initializeData();

    super.initState();
  }

  Future<void> _initializeData() async {
    menuRepository = MenuRepository();
    await menuRepository.fetchData();
    menuRepository.getMenu(DateTime.now());

    setState(() {
      isLoaded = true;
    }); // Widget'ı güncellemek için setState çağrısı yapılıyor.
  }

  void _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: menuRepository.getLastDate(),
            initialEntryMode: DatePickerEntryMode.calendarOnly)
        .then((value) {
      setState(() {
        menuRepository.selectedDate = value ?? DateTime.now();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoaded
          ? SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 105,
                        width: MediaQuery.of(context).size.width * 0.22,
                        decoration: BoxDecoration(
                            color: MyColors.appMainColor,
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(100),
                            )),
                        child: Center(
                          child: IconButton(
                              iconSize: 35,
                              icon: const Icon(
                                Icons.arrow_back,
                              ),
                              onPressed: () {
                                setState(() {
                                  menuRepository.previousDay();
                                });
                              }),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "KYK\nYemek Listesi",
                          textAlign: TextAlign.center,
                          style: MyTextTheme.appHeadline,
                        ),
                      ),
                      Container(
                        height: 105,
                        width: MediaQuery.of(context).size.width * 0.22,
                        decoration: BoxDecoration(
                            color: MyColors.appMainColor,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(100),
                            )),
                        child: Center(
                          child: IconButton(
                              iconSize: 35,
                              icon: const Icon(
                                Icons.arrow_forward,
                              ),
                              onPressed: () {
                                setState(() {
                                  menuRepository.nextDay();
                                });
                              }),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Kahvaltı",
                          textAlign: TextAlign.start,
                          style: MyTextTheme.menuHeadline,
                        ),
                        Text(
                          menuRepository.getKahvalti(),
                          style: MyTextTheme.menu,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Akşam Yemeği",
                          textAlign: TextAlign.start,
                          style: MyTextTheme.menuHeadline,
                        ),
                        Text(
                          menuRepository.getAksam(),
                          style: MyTextTheme.menu,
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 105,
                        width: MediaQuery.of(context).size.width * 0.22,
                        decoration: BoxDecoration(
                            color: MyColors.appMainColor,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(100),
                            )),
                      ),
                      InkWell(
                        onTap: _showDatePicker,
                        child: Text(
                          menuRepository
                              .datetimeToString(menuRepository.selectedDate),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 23),
                        ),
                      ),
                      Container(
                        height: 105,
                        width: MediaQuery.of(context).size.width * 0.22,
                        decoration: BoxDecoration(
                            color: HexColor("#FEB629"),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(100),
                            )),
                      )
                    ],
                  )
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
