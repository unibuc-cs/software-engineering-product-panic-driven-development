import 'package:flutter/material.dart';
import 'package:mediamaster/Widgets/themes.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'Services/auth_service.dart';
import 'Menu.dart';
import 'Main.dart';
import 'UserSystem.dart';
import 'ProfilePage.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late Future<List<Map<String, dynamic>>> _usersFuture;
  var currentUserId = UserSystem.instance.getCurrentUserId();

  @override
  void initState() {
    super.initState();
    _usersFuture = AuthService.instance.getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => MenuPage()),
              );
            },
            style: navigationButton(context).filledButtonTheme.style,
            child: Text('Menu'),
          ),
          IconButton(
            onPressed: () {
              AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light
                  ? AdaptiveTheme.of(context).setDark()
                  : AdaptiveTheme.of(context).setLight();
            },
            icon: const Icon(Icons.dark_mode),
            tooltip: 'Toggle dark mode',
          ),
          IconButton(
            onPressed: () {
              UserSystem.instance.logout();
              Navigator.pop(context);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Home()));
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Log out',
          ),
        ],
      ),
     body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _usersFuture,
        builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No users found'));
            }

            List<Map<String, dynamic>> users = snapshot.data!
                .where((user) => user['name']?.toLowerCase() != 'guest')
                .toList();

            if (users.isEmpty) {
            return const Center(child: Text('No valid users found'));
            }

            return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                    final user = users[index];
       
                    String displayName = user['name'] ?? 'Unknown';
                    bool isCurrentUser = user['id'] == currentUserId;

                    return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    color: Colors.grey[800],
                    child: ListTile(
                        title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                        children: [
                            Text(
                            displayName,
                            style: const TextStyle(color: Colors.white),
                            ),
                            if (isCurrentUser)
                            const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(
                                "You",
                                style: TextStyle(color: Colors.green),
                                ),
                            ),
                        ],
                        ),
                        subtitle: Text(
                        user['email'] ?? 'No email',
                        style: const TextStyle(color: Colors.white70),
                        ),
                        leading: const Icon(Icons.person, color: Colors.white),
                         onTap: () {
                   
                            Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilePage(userId: user['id']), 
                            ),
                            );  
                         }
                    ),
                );
      
                },
            );
        },
      ),

    );
  }
}
