import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

Future<String?> _getIpAddress() async {
  try {
    final response =
        await http.get(Uri.parse('https://api.ipify.org?format=json'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['ip'];
    }
  } catch (e) {
    print('Error getting IP address: $e');
  }
  return null;
}

List<String> brodyLunchList = [];
List<String> brodyDinnerList = [];
List<String> akersLunchList = [];
List<String> akersDinnerList = [];
List<String> caseLunchList = [];
List<String> caseDinnerList = [];
List<String> shawLunchList = [];
List<String> shawDinnerList = [];
List<String> snyphiLunchList = [];
List<String> snyphiDinnerList = [];
List<String> likedFoods = [];

class BackendBloc extends Cubit<List<List<String>>> {
  BackendBloc() : super([]);

  Future<void> fetchData() async {
    String? ipAddress = await _getIpAddress();
    final response =
        await http.get(Uri.parse('http://$ipAddress:5000/api/data'));
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      final List<List<String>> dataLists = responseData
          .map<List<String>>((data) =>
              (data as List<dynamic>).map<String>((e) => e.toString()).toList())
          .toList();
      emit(dataLists);

      // Set each of the 10 lists equal to each list coming from the Flask server
      brodyLunchList = dataLists[0];
      brodyDinnerList = dataLists[1];
      akersLunchList = dataLists[2];
      akersDinnerList = dataLists[3];
      caseLunchList = dataLists[4];
      caseDinnerList = dataLists[5];
      shawLunchList = dataLists[6];
      shawDinnerList = dataLists[7];
      snyphiLunchList = dataLists[8];
      snyphiDinnerList = dataLists[9];
    } else {
      emit([]);
    }
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => BackendBloc(),
        child: MyWidget(),
      ),
    );
  }
}

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<BackendBloc>(context).fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Builder(
          builder: (context) {
            //final backendBloc = BlocProvider.of<BackendBloc>(context);

            return BlocBuilder<BackendBloc, List<List<String>>>(
              builder: (context, state) {
                if (state.isEmpty) {
                  return Text('Failed to fetch data');
                } else {
                  // No need to display lists, they are already set
                  return HomeScreen(); // Display the HomeScreen widget
                }
              },
            );
          },
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dishes MSU',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 50.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Font3',
          ),
        ),
        backgroundColor: Colors.green[800],
        centerTitle: true, // Center the title
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/dining_image_1.webp',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(
                      255, 219, 228, 232), // Dark gray background
                  borderRadius:
                      BorderRadius.circular(15.0), // Adjust the radius
                ),
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Add To Library',
                  style: TextStyle(
                    color: Color.fromARGB(255, 21, 23, 26),
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Font3',
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LunchDiningHalls()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green[800],
                  padding: EdgeInsets.symmetric(
                    horizontal: 100.0,
                    vertical: 60.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: Text(
                  'Lunch',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50.0,
                    fontFamily: 'Chuck_Noon',
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DinnerDiningHalls()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green[800],
                  padding: EdgeInsets.symmetric(
                    horizontal: 90.0,
                    vertical: 60.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: Text(
                  'Dinner',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50.0,
                    fontFamily: 'Chuck_Noon',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                // Action when heart button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavoritesScreen()),
                );
              },
              icon: Icon(Icons.favorite),
              iconSize: 70.0,
              color: Colors.red,
            ),
            IconButton(
              onPressed: () {
                // Action when gear button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
              icon: Icon(Icons.settings),
              iconSize: 70.0,
              color: Color.fromARGB(255, 121, 124, 125),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Favorites',
          style: TextStyle(
            color: Colors.black,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Font3',
          ),
        ),
        backgroundColor: Colors.green[900],
        centerTitle: true,
      ),
      body: Container(
        // Set the background color of the entire screen to solid green
        color: Colors.green[800],
        child: ListView.builder(
          itemCount: likedFoods.length,
          itemBuilder: (context, index) {
            String foodItem = likedFoods[index];

            return Container(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors
                    .green[900], // Keep the dark green box around each item
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                title: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        likedFoods.contains(foodItem)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color:
                            likedFoods.contains(foodItem) ? Colors.red : null,
                      ),
                      onPressed: () {
                        setState(() {
                          if (likedFoods.contains(foodItem)) {
                            likedFoods.remove(foodItem);
                          } else {
                            likedFoods.add(foodItem);
                          }
                        });
                      },
                    ),
                    Text(
                      foodItem,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Back',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Font3',
          ),
        ),
        backgroundColor: Colors.green[800],
      ),
      body: Container(
        color: Colors.green[900], // Set background color to green 900
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SettingsBox(text: 'Quiet Notifications'),
          ],
        ),
      ),
    );
  }
}

class SettingsBox extends StatefulWidget {
  final String text;

  SettingsBox({required this.text});

  @override
  _SettingsBoxState createState() => _SettingsBoxState();
}

class _SettingsBoxState extends State<SettingsBox> {
  bool isToggled = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.green[700],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
          Switch(
            value: isToggled,
            onChanged: (value) {
              setState(() {
                isToggled = value;
              });
            },
            activeColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

class LunchDiningHalls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Dining Hall',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
            fontFamily: 'Font3',
          ),
        ),
        backgroundColor: Colors.green[800],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/new_dining_image.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LunBrodyScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green[800],
                  minimumSize: Size(200, 60), // Set the size of the button
                ),
                child: Text('Brody',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: 35.0,
                      fontFamily: 'Chuck_Noon',
                    )),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LunAkersScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green[800],
                  minimumSize: Size(200, 60), // Set the size of the button
                ),
                child: Text('Akers',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: 35.0,
                      fontFamily: 'Chuck_Noon',
                    )),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LunCaseScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green[800],
                  minimumSize: Size(200, 60), // Set the size of the button
                ),
                child: Text('Case',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: 35.0,
                      fontFamily: 'Chuck_Noon',
                    )),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LunShawScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green[800],
                  minimumSize: Size(200, 60), // Set the size of the button
                ),
                child: Text('Shaw',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: 35.0,
                      fontFamily: 'Chuck_Noon',
                    )),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LunSnyderPhillipsScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green[800],
                  minimumSize: Size(200, 60), // Set the size of the button
                ),
                child: Text('Snyder Phillips',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: 35.0,
                      fontFamily: 'Chuck_Noon',
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DinnerDiningHalls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Dining Hall',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
            fontFamily: 'Font3',
          ),
        ),
        backgroundColor: Colors.green[800],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/new_dining_image_dinner.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LunBrodyScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green[800],
                  minimumSize: Size(200, 60), // Set the size of the button
                ),
                child: Text('Brody',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: 35.0,
                      fontFamily: 'Chuck_Noon',
                    )),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LunAkersScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green[800],
                  minimumSize: Size(200, 60), // Set the size of the button
                ),
                child: Text('Akers',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: 35.0,
                      fontFamily: 'Chuck_Noon',
                    )),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LunCaseScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green[800],
                  minimumSize: Size(200, 60), // Set the size of the button
                ),
                child: Text('Case',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: 35.0,
                      fontFamily: 'Chuck_Noon',
                    )),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LunShawScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green[800],
                  minimumSize: Size(200, 60), // Set the size of the button
                ),
                child: Text('Shaw',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: 35.0,
                      fontFamily: 'Chuck_Noon',
                    )),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LunSnyderPhillipsScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green[800],
                  minimumSize: Size(200, 60), // Set the size of the button
                ),
                child: Text('Snyder Phillips',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: 35.0,
                      fontFamily: 'Chuck_Noon',
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LunBrodyScreen extends StatefulWidget {
  @override
  _LunBrodyScreenState createState() => _LunBrodyScreenState();
}

class _LunBrodyScreenState extends State<LunBrodyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add To Favorites - Brody',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 35.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Font3',
          ),
        ),
        backgroundColor: Colors.green[800],
      ),
      body: Container(
        color: Colors.green[900], // Dark green background
        child: ListView.builder(
          itemCount: brodyLunchList.length,
          itemBuilder: (context, index) {
            String foodItem = brodyLunchList[index];

            return Container(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.green[900],
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                title: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        likedFoods.contains(foodItem)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color:
                            likedFoods.contains(foodItem) ? Colors.red : null,
                      ),
                      onPressed: () {
                        setState(() {
                          if (likedFoods.contains(foodItem)) {
                            likedFoods.remove(foodItem);
                          } else {
                            likedFoods.add(foodItem);
                          }
                        });
                      },
                    ),
                    Flexible(
                      child: Text(
                        foodItem,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25.0,
                          fontFamily: 'Chuck_Noon',
                        ),
                        maxLines: 2, // Adjust the number of lines as needed
                        overflow: TextOverflow
                            .ellipsis, // Handle overflow with ellipsis if maxLines is exceeded
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class LunAkersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add To Favorites - Akers',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 35.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Font3',
          ),
        ),
        backgroundColor: Colors.green[800],
      ),
      body: Container(
        color: Colors.green[900], // Dark green background
        child: ListView.builder(
          itemCount: akersLunchList.length,
          itemBuilder: (context, index) {
            String foodItem = akersLunchList[index];

            return Container(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.green[900],
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                title: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        likedFoods.contains(foodItem)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color:
                            likedFoods.contains(foodItem) ? Colors.red : null,
                      ),
                      onPressed: () {
                        // Use Bloc or any other state management approach to handle the likedFoods state
                        // For simplicity, I'm not handling state here. You may want to use a StatefulWidget.
                        if (likedFoods.contains(foodItem)) {
                          likedFoods.remove(foodItem);
                        } else {
                          likedFoods.add(foodItem);
                        }
                      },
                    ),
                    Flexible(
                      child: Text(
                        foodItem,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25.0,
                          fontFamily: 'Chuck_Noon',
                        ),
                        maxLines: 2, // Adjust the number of lines as needed
                        overflow: TextOverflow
                            .ellipsis, // Handle overflow with ellipsis if maxLines is exceeded
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class LunCaseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add To Favorites - Case',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 35.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Font3',
          ),
        ),
        backgroundColor: Colors.green[800],
      ),
      body: Container(
        color: Colors.green[900], // Dark green background
        child: ListView.builder(
          itemCount: caseLunchList.length,
          itemBuilder: (context, index) {
            String foodItem = caseLunchList[index];

            return Container(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.green[900],
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                title: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        likedFoods.contains(foodItem)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color:
                            likedFoods.contains(foodItem) ? Colors.red : null,
                      ),
                      onPressed: () {
                        // Use Bloc or any other state management approach to handle the likedFoods state
                        // For simplicity, I'm not handling state here. You may want to use a StatefulWidget.
                        if (likedFoods.contains(foodItem)) {
                          likedFoods.remove(foodItem);
                        } else {
                          likedFoods.add(foodItem);
                        }
                      },
                    ),
                    Flexible(
                      child: Text(
                        foodItem,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25.0,
                          fontFamily: 'Chuck_Noon',
                        ),
                        maxLines: 2, // Adjust the number of lines as needed
                        overflow: TextOverflow
                            .ellipsis, // Handle overflow with ellipsis if maxLines is exceeded
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class LunShawScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add To Favorites - Shaw',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 35.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Font3',
          ),
        ),
        backgroundColor: Colors.green[800],
      ),
      body: Container(
        color: Colors.green[900], // Dark green background
        child: ListView.builder(
          itemCount: shawLunchList.length,
          itemBuilder: (context, index) {
            String foodItem = shawLunchList[index];

            return Container(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.green[900],
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                title: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        likedFoods.contains(foodItem)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color:
                            likedFoods.contains(foodItem) ? Colors.red : null,
                      ),
                      onPressed: () {
                        // Use Bloc or any other state management approach to handle the likedFoods state
                        // For simplicity, I'm not handling state here. You may want to use a StatefulWidget.
                        if (likedFoods.contains(foodItem)) {
                          likedFoods.remove(foodItem);
                        } else {
                          likedFoods.add(foodItem);
                        }
                      },
                    ),
                    Flexible(
                      child: Text(
                        foodItem,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25.0,
                          fontFamily: 'Chuck_Noon',
                        ),
                        maxLines: 2, // Adjust the number of lines as needed
                        overflow: TextOverflow
                            .ellipsis, // Handle overflow with ellipsis if maxLines is exceeded
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class LunSnyderPhillipsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add To Favorites - Snyder-Phillips',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 35.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Font3',
          ),
        ),
        backgroundColor: Colors.green[800],
      ),
      body: Container(
        color: Colors.green[900], // Dark green background
        child: ListView.builder(
          itemCount: snyphiLunchList.length,
          itemBuilder: (context, index) {
            String foodItem = snyphiLunchList[index];

            return Container(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.green[900],
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                title: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        likedFoods.contains(foodItem)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color:
                            likedFoods.contains(foodItem) ? Colors.red : null,
                      ),
                      onPressed: () {
                        // Use Bloc or any other state management approach to handle the likedFoods state
                        // For simplicity, I'm not handling state here. You may want to use a StatefulWidget.
                        if (likedFoods.contains(foodItem)) {
                          likedFoods.remove(foodItem);
                        } else {
                          likedFoods.add(foodItem);
                        }
                      },
                    ),
                    Flexible(
                      child: Text(
                        foodItem,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25.0,
                          fontFamily: 'Chuck_Noon',
                        ),
                        maxLines: 2, // Adjust the number of lines as needed
                        overflow: TextOverflow
                            .ellipsis, // Handle overflow with ellipsis if maxLines is exceeded
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
