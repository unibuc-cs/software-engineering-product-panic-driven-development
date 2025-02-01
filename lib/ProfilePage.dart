import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'UserSystem.dart';
import 'Main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var name = UserSystem.instance.currentUserData!['name'] ?? 'Unknown User';
  var email = UserSystem.instance.currentUserData!['email'] ?? 'Unknown Email';
  var lastSignInRaw = UserSystem.instance.currentUserData!['lastSignIn'] ?? '';
  var memberSinceRaw = UserSystem.instance.currentUserData!['createdAt'] ?? '';

  String _profileImageUrl = 'https://picsum.photos/200/200?random=1'; 

  String formatLastLogin(String dateString) {
    if (dateString.isEmpty) return "Unknown";
    DateTime date = DateTime.parse(dateString);
    return DateFormat('dd MMM yyyy HH:mm').format(date); 
  }

  String formatMemberSince(String dateString) {
    if (dateString.isEmpty) return "Unknown";
    DateTime date = DateTime.parse(dateString);
    return DateFormat('dd MMM yyyy').format(date); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
          actions: [
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _showImageSelectionDialog, 
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(_profileImageUrl),
                backgroundColor: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              name == 'Guest' ? 'This account is a guest' : name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,  
              ),
            ),
            if (name != 'Guest') ...[
              Text(
                email,  
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,  
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoCard(context, "Last Login", formatLastLogin(lastSignInRaw), "Member Since", formatMemberSince(memberSinceRaw)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showImageSelectionDialog() {
    List<String> imageUrls = List.generate(
      10, (index) => 'https://picsum.photos/200/200?random=${index + 1}'
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Profile Picture', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black, 
          content: SingleChildScrollView(
            child: Wrap(
              spacing: 8.0,
              children: imageUrls.map((imageUrl) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _profileImageUrl = imageUrl;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(imageUrl),
                      backgroundColor: Colors.grey,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _infoCard(BuildContext context, String title1, String value1, String title2, String value2) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width / 2.5,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade600),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title1, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
          const SizedBox(height: 4),
          Text(value1, style: const TextStyle(fontSize: 14, color: Colors.white)),
          const SizedBox(height: 12),
          Text(title2, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
          const SizedBox(height: 4),
          Text(value2, style: const TextStyle(fontSize: 14, color: Colors.white)),
        ],
      ),
    );
  }
}
