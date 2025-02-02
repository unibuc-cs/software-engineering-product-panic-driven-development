import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mediamaster/Widgets/themes.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:collection/collection.dart';
import 'Services/media_user_service.dart';
import 'Services/media_service.dart';
import 'Services/auth_service.dart';
import 'UserSystem.dart';
import 'Main.dart';
import 'Menu.dart';
import 'UserListPage.dart';

class ProfilePage extends StatefulWidget {
  final String userId;
  const ProfilePage({Key? key, required this.userId}) : super(key: key); 

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String name; 
  late String visitedUserId;
  late Map<String, dynamic> visitedUser;
  late String email;
  late String lastSignInRaw;
  late String memberSinceRaw;
  late String photoUrl = '';
  bool _isLoading = true;
  String _profileImageUrl = 'https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png';
  var currentUserId = UserSystem.instance.getCurrentUserId();

  bool _isEditing = false; 
  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    visitedUserId = widget.userId;
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      visitedUser = await AuthService.instance.getUserById(visitedUserId);
      
      setState(() {
        name = visitedUser['name'] ?? 'Unknown User';
        name = name[0].toUpperCase() + name.substring(1);
        email = visitedUser['email'] ?? 'Unknown Email';
        lastSignInRaw = visitedUser['lastSignIn'] ?? '';
        memberSinceRaw = visitedUser['createdAt'] ?? '';
        photoUrl = visitedUser['photoUrl'] ?? _profileImageUrl;
        _nameController.text = name; 
        _isLoading = false;
      });
    }
    catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        _isLoading = false; 
      });
    }
  }
  
  String _pluralize(String word, int count) {
    word = word.replaceAll('_', ' '); 
    if (count == 1) return word; 
    if (word.endsWith('s')) return word; 
    if (word.endsWith('y')) {
      return word.substring(0, word.length - 1) + 'ies'; 
    }
    if (word.endsWith('s') || word.endsWith('x') || word.endsWith('z') || 
        word.endsWith('sh') || word.endsWith('ch')) {
      return word + 'es'; 
    }
    return word + 's'; 
  }

  String formatLastLogin(String dateString) {
    if (dateString.isEmpty) {
      return 'Unknown';
    }
    DateTime date = DateTime.parse(dateString).toLocal(); 
    return DateFormat('dd MMM yyyy HH:mm').format(date);
  }

  String formatMemberSince(String dateString) {
    if (dateString.isEmpty) {
      return 'Unknown';
    }
    DateTime date = DateTime.parse(dateString);
    return DateFormat('dd MMM yyyy').format(date); 
  }

  Map<String, int> getUserMediaCounts(String currentUserId) {
    var userMedia = MediaUserService
      .instance
      .items
      .where((mu) => mu.userId == currentUserId);
    var mediaMap = Map.fromEntries(MediaService
      .instance
      .items
      .map((media) => MapEntry(media.id, media.mediaType))
    );
    var groupedMedia = groupBy(userMedia, (mu) => mediaMap[mu.mediaId] ?? 'Unknown');

    return groupedMedia.map((key, value) => MapEntry(key, value.length));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profile Page'),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: CircularProgressIndicator(), 
        ),
      );
    }

    Map<String, int> userMediaCounts = getUserMediaCounts(currentUserId);

    String mediaCountsText;

    if (visitedUserId == currentUserId) {
      mediaCountsText = userMediaCounts.isEmpty
        ? "You don't have items in the library"
        : userMediaCounts.entries
          .map((entry) => '• ${entry.value} ${_pluralize(entry.key, entry.value)}')
          .join('\n');
    } else {
      mediaCountsText = userMediaCounts.isEmpty
        ? "This user doesn't have items in the library"
        : userMediaCounts.entries
          .map((entry) => '• ${entry.value} ${_pluralize(entry.key, entry.value)}')
          .join('\n');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
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
          if (visitedUserId != currentUserId) 
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(userId: currentUserId), 
                  ),
                );
              },
              icon: const Icon(Icons.account_circle), 
              tooltip: 'My Profile', 
              ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => UserListPage()),
              );
            },
            style: navigationButton(context).filledButtonTheme.style,
            child: Text('See Users'),
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
              onTap: () {
                if (visitedUserId == currentUserId) {
                  _showImageSelectionDialog();  
                }
              }, 
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(photoUrl),
                backgroundColor: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            if (name == 'Guest') 
              Text(
                'This account is a guest',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,  
                ),
            ),
            if (name != 'Guest' && currentUserId != visitedUserId)
              Text(
                name,  
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white, 
                  fontWeight: FontWeight.bold, 
                ),
              ),
            if (name != 'Guest' && currentUserId == visitedUserId) 
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!_isEditing)
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  else
                    Container(
                      width: MediaQuery.of(context).size.width * 0.07, 
                      child: TextField(
                        controller: _nameController,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        onChanged: (newText) {
                          setState(() {
                            name = newText; 
                          });
                        },
                      ),
                    ),
                  IconButton(
                    icon: Icon(_isEditing ? Icons.save : Icons.edit, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _isEditing = !_isEditing;
                        if (!_isEditing) {
                          name = _nameController.text; 
                          AuthService.instance.updateUserProfile(name, photoUrl); 
                        }
                      });
                    },
                  ),
                ],
              ),
            if (name != 'Guest')
              Text(
                email,  
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white, 
                  fontWeight: FontWeight.bold, 
                ),
              ),
            
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _infoCard(context, 'Last Login', formatLastLogin(lastSignInRaw), 
                          'Member Since', formatMemberSince(memberSinceRaw)),
                _infoCard(context, 'Library', mediaCountsText, '', ''),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showImageSelectionDialog() {
    List<String> imageUrls = List.generate(
      40, (index) => 'https://picsum.photos/200/200?random=${index + 1}'
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
                  onTap: () async { 
                    setState(() {
                      photoUrl = imageUrl; 
                    });

                    try {
                      await AuthService.instance.updateUserProfile(name, imageUrl); 
                      Navigator.of(context).pop(); 
                    } catch (error) {
                      print('Error updating profile: $error');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to update profile image'))
                      );
                    }
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
      height: 190, 
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
          if(title2 != '')
            ...[
              const SizedBox(height: 12),
              Text(title2, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
              const SizedBox(height: 4),
              Text(value2, style: const TextStyle(fontSize: 14, color: Colors.white)),
            ],
        ],
      ),
    );
  }
}
