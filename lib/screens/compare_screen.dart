import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class CompareScreen extends StatefulWidget {
  const CompareScreen({super.key});

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  final TextEditingController emailController = TextEditingController();
  List<WordPair> userFavorites = [];
  List<WordPair> friendFavorites = [];
  List<WordPair> commonFavorites = [];
  List<WordPair> uniqueToUser = [];
  List<WordPair> uniqueToFriend = [];
  String errorMessage = '';

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> _compareFavorites() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        errorMessage = 'Please enter an email address.';
      });
      return;
    }

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final userDocRef =
          FirebaseFirestore.instance.collection('users').doc(uid);
      final friendUserQuery = FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email);

      final userDoc = await userDocRef.get();
      if (userDoc.exists) {
        final userWords = userDoc['words'] ?? [];
        userFavorites = (userWords as List<dynamic>).map((item) {
          if (item is Map<String, dynamic>) {
            return WordPair(item['first'], item['second']);
          } else {
            throw FormatException('Invalid item format: $item');
          }
        }).toList();
      } else {
        setState(() {
          errorMessage = 'Your favorites data not found.';
        });
        return;
      }

      final friendUserSnapshots = await friendUserQuery.get();
      if (friendUserSnapshots.docs.isEmpty) {
        setState(() {
          errorMessage = 'Friend with email $email not found.';
        });
        return;
      }

      final friendUserDoc = friendUserSnapshots.docs.first;
      final friendWords = friendUserDoc['words'] ?? [];
      friendFavorites = (friendWords as List<dynamic>).map((item) {
        if (item is Map<String, dynamic>) {
          return WordPair(item['first'], item['second']);
        } else {
          throw FormatException('Invalid item format: $item');
        }
      }).toList();

      final userFavoritesSet = userFavorites.toSet();
      final friendFavoritesSet = friendFavorites.toSet();

      setState(() {
        commonFavorites =
            userFavoritesSet.intersection(friendFavoritesSet).toList();
        uniqueToUser = userFavoritesSet.difference(friendFavoritesSet).toList();
        uniqueToFriend =
            friendFavoritesSet.difference(userFavoritesSet).toList();
        errorMessage = '';
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Compare'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Friend\'s Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _compareFavorites,
              child: Text('Compare'),
            ),
            if (errorMessage.isNotEmpty) ...[
              SizedBox(height: 16),
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            ],
            SizedBox(height: 16),
            if (commonFavorites.isNotEmpty) ...[
              Text(
                'Common Favorites:',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              ...commonFavorites.map((wordPair) => Text(wordPair.asLowerCase)),
            ] else ...[
              Text(
                'No common favorites.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            SizedBox(height: 16),
            if (uniqueToUser.isNotEmpty) ...[
              Text(
                'Unique to You:',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              ...uniqueToUser.map((wordPair) => Text(wordPair.asLowerCase)),
            ] else ...[
              Text(
                'No unique favorites to you.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            SizedBox(height: 16),
            if (uniqueToFriend.isNotEmpty) ...[
              Text(
                'Unique to Friend:',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              ...uniqueToFriend.map((wordPair) => Text(wordPair.asLowerCase)),
            ] else ...[
              Text(
                'No unique favorites for your friend.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
    );
  }
}
