import 'package:contact_list/services/jsons.dart';
import 'package:contact_list/services/share.dart';
import 'package:contact_list/services/time_format.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ListOfContactsPage extends StatefulWidget {
  const ListOfContactsPage({Key? key}) : super(key: key);

  @override
  _ListOfContactsPageState createState() => _ListOfContactsPageState();
}

class _ListOfContactsPageState extends State<ListOfContactsPage> {
  int initialCount = 5;
  bool isOriginal = false;
  List<bool> isSelected = [true, false];

  ScrollController sController = ScrollController();
  final _box = GetStorage();
  var shareTo = ShareContentService();
  //var store = LocalStorageService();

  @override
  void initState() {
    super.initState();

    if (_box.read("isOriginal") != null) {
      isOriginal = _box.read("isOriginal");
      if (isOriginal) {
        isSelected = [false, true];
      } else {
        isSelected = [true, false];
      }
    }

    sController.addListener(() {
      if (sController.position.atEdge) {
        var isTop = sController.position.pixels == 0;

        if (!isTop) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "You have reached end of the list",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 10,
            duration: Duration(milliseconds: 1000),
            backgroundColor: Color.fromARGB(255, 20, 67, 22),
          ));
        }
      }
    });
  }

  getCountList() async {
    var service = JsonServices();
    int maxitem = 0;
    await service.getUsers().then((value) {
      print(value.length);
      maxitem = value.length;
    });

    print("The max item is " + maxitem.toString());

    if (initialCount < maxitem) {
      return service.userCountController(initialCount);
    } else {
      return service.userCountController(maxitem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        backgroundColor: Colors.green[500],
        actions: [
          ToggleButtons(
            borderRadius: BorderRadius.circular(25),
            color: Colors.white,
            selectedColor: Colors.green,
            fillColor: Colors.green[200],
            isSelected: isSelected,
            children: [
              Icon(
                Icons.timer_outlined,
              ),
              Icon(
                Icons.timer_off_outlined,
              ),
            ],
            onPressed: (selectedIndex) {
              setState(() {
                for (var i = 0; i < isSelected.length; i++) {
                  if (i == selectedIndex) {
                    isSelected[i] = true;
                    isOriginal = true;
                  } else {
                    isSelected[i] = false;
                    isOriginal = false;
                  }
                }

                isOriginal != true
                    ? _box.write("isOriginal", false)
                    : _box.write("isOriginal", true);
              });
            },
          ),
        ],
        title: Text(
          "Contact List",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'Abril',
          ),
        ),
      ),
      body: FutureBuilder(
        future: getCountList(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Some error has occured"));
          } else if (snapshot.hasData) {
            var contact = snapshot.data as List;
            return RefreshIndicator(
              onRefresh: () async {
                print("Hello");
                setState(() {
                  initialCount += 5;
                });
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: sController,
                itemCount: (contact.length),
                itemBuilder: (context, i) {
                  return Card(
                    color: Color.fromRGBO(128, 255, 128, 100),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    elevation: 2,
                    // used intl package to format datetime
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      style: ListTileStyle.drawer,
                      subtitle: Text(TimeFormatingService(
                              loadedTime: contact[i].checkinTime)
                          .toReadable()),
                      title: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(
                          contact[i].phone,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ),
                      leading: Text(
                        contact[i].user,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      trailing: isOriginal != true
                          ? Text(
                              TimeFormatingService(
                                      loadedTime: contact[i].checkinTime)
                                  .convetToAgoTime(),
                            )
                          : Text(contact[i].checkinTime),
                      onTap: () => shareTo.shareContextDetails(
                          contact[i].user,
                          contact[i].phone,
                          TimeFormatingService(
                                  loadedTime: contact[i].checkinTime)
                              .toReadable()),
                    ),
                  );
                },
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
