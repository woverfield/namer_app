import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_words/english_words.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:namer_app/screens/auth_screen.dart';
import 'package:namer_app/screens/compare_screen.dart';
import 'package:provider/provider.dart';
import 'package:namer_app/screens/profile_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: AuthScreen(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>{};

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
      removeFavoriteFirebase(current);
    } else {
      favorites.add(current);
      addFavoriteFirebase(current);
    }
    notifyListeners();
  }

  void addFavoriteFirebase(WordPair word) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('users').doc(uid);

    try {
      DocumentSnapshot userDoc = await userDocRef.get();

      if (userDoc.exists) {
        List<dynamic> words = userDoc['words'] ?? [];

        List<Map<String, dynamic>> wordsList = words.map((item) {
          if (item is Map<String, dynamic>) {
            return item;
          }
          return <String, dynamic>{};
        }).toList();

        Map<String, dynamic> newWordMap = {
          'first': word.first,
          'second': word.second,
        };

        bool wordExists = wordsList.any((item) {
          return item['first'] == newWordMap['first'] &&
              item['second'] == newWordMap['second'];
        });

        if (wordExists) {
          wordsList.removeWhere((item) =>
              item['first'] == newWordMap['first'] &&
              item['second'] == newWordMap['second']);
        } else {
          wordsList.add(newWordMap);
        }

        await userDocRef.update({
          'words': wordsList,
        });
      } else {
        await userDocRef.set({
          'words': [
            {
              'first': word.first,
              'second': word.second,
            }
          ],
        });
      }
    } catch (e) {
      print('Error updating favorites: $e');
    }
  }

  void removeFavoriteFirebase(WordPair word) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('users').doc(uid);

    try {
      DocumentSnapshot userDoc = await userDocRef.get();

      if (userDoc.exists) {
        List<dynamic> words = userDoc['words'] ?? [];

        List<Map<String, dynamic>> wordsList = words.map((item) {
          if (item is Map<String, dynamic>) {
            return item;
          }
          return <String, dynamic>{};
        }).toList();

        Map<String, dynamic> wordToRemove = {
          'first': word.first,
          'second': word.second,
        };

        wordsList.removeWhere((item) =>
            item['first'] == wordToRemove['first'] &&
            item['second'] == wordToRemove['second']);

        await userDocRef.update({
          'words': wordsList,
        });
      }
    } catch (e) {
      print('Error removing favorite: $e');
    }
  }

  void updateFavorites(List<dynamic> words) {
    favorites = words.map((item) {
      if (item is Map<String, dynamic>) {
        final first = item['first'] as String?;
        final second = item['second'] as String?;

        if (first != null && second != null) {
          return WordPair(first, second);
        } else {
          print('Invalid item format: $item');
          throw FormatException('Invalid format: $item');
        }
      } else {
        print('Item is not a Map<String, dynamic>: $item');
        throw FormatException('Item is not a Map<String, dynamic>: $item');
      }
    }).toSet();

    notifyListeners();
  }

  void removeFavorite(favorite) {
    print('remove favorite called');
    if (favorites.contains(favorite)) {
      favorites.remove(favorite);
      removeFavoriteFirebase(favorite);
      notifyListeners();
    }
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.email});

  @override
  State<MyHomePage> createState() => _MyHomePageState();

  final String email;
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    setupFirestore(widget.email);
  }
  
  Future<void> setupFirestore(String email) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(uid);

      DocumentSnapshot userDoc = await userDocRef.get();

      if (!userDoc.exists) {
        await userDocRef.set({
          'words': [],
          'email': email,
        });
      } else {
        List<dynamic> firestoreWordsDynamic = userDoc['words'];

        context.read<MyAppState>().updateFavorites(firestoreWordsDynamic);
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.error,
              title: Center(
                child: Text('Unexpected Error: $e'),
              ),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    User currUser = FirebaseAuth.instance.currentUser!;
    Widget page;

    switch (selectedIndex) {
      case 0:
        page = ProfileScreen(
          user: currUser,
        );
      case 1:
        page = GeneratorPage();
      case 2:
        page = FavoritesPage();
      case 3:
        page = CompareScreen();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: [
                  NavigationRailDestination(
                      icon: Icon(Icons.account_circle), label: Text('Profile')),
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('Favorites'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.people),
                    label: Text('Compare'),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var favorites = appState.favorites;

    if (favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text('You have ${favorites.length} favorites:'),
          ),
          for (WordPair favorite in favorites)
            ListTile(
              leading: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  appState.removeFavorite(favorite);
                },
              ),
              title: Text(favorite.asLowerCase),
            ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}
