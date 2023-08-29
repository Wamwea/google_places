import 'package:flutter/material.dart';
import 'package:flutter_ioc_container/flutter_ioc_container.dart';
import 'package:ioc_container/ioc_container.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:location_app/composition.dart';
import 'package:location_app/models/places_prediction.dart';
import 'package:location_app/search_service.dart';
import 'package:location_app/utils/debounce.dart';

late final IocContainer serviceLocator;

void main() async {
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();
  serviceLocator = compose().toContainer();

  runApp(CompositionRoot(
    container: compose().toContainer(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Location Search'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final TextEditingController _searchController;

  List<Prediction> _predictions = [];

  @override
  void initState() {
    _searchController = TextEditingController();
    _searchController.addListener(() {
      onSearchChange();
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchController.removeListener(() {});
    super.dispose();
  }

  void onSearchChange() {
    TextDebounce().debouncing(
      fn: () {
        final query = _searchController.text;
        if (query.isNotEmpty) {
          searchPlace(query);
        }
      },
      waitForMs: 2000,
    );
  }

  void searchPlace(String query) async {
    final service = serviceLocator<SearchService>();
    final response = await service.searchCity(query);
    print('Predictions: ${response.predictions}');
    if (response.status == 'OK') {
      print(response.predictions);
      setState(() {
        _predictions = response.predictions;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _searchController,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                hintText: "Search for city",
                suffixIcon: Icon(Icons.search),
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(200),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Results : ${_predictions.length}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            SingleChildScrollView(
              child: Column(children: [
                ..._predictions.map((prediction) {
                  return ListTile(
                    title: Text(prediction.description),
                    shape: Border(
                      bottom: BorderSide(color: Colors.grey[300]!),
                    ),
                    leading: Icon(Icons.location_on, color: Colors.red),
                  );
                }).toList()
              ]),
            )
          ],
        ),
      ),
    );
  }
}
