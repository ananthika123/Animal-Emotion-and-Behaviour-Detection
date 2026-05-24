// import 'package:aura/addAnimal.dart';
// import 'package:aura/login.dart';
// import 'package:aura/rateandreview.dart';
// import 'package:aura/view_animal.dart';
// import 'package:aura/view_breed.dart';
// import 'package:aura/view_user.dart';
// import 'package:flutter/material.dart';
// import 'audio_upload.dart';
// import 'video_upload.dart';
//
// void main() {
//   runApp(const Home());
// }
//
// class Home extends StatelessWidget {
//   const Home({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: HomeSub(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
//
// class HomeSub extends StatefulWidget {
//   const HomeSub({Key? key}) : super(key: key);
//
//   @override
//   State<HomeSub> createState() => _HomeSubState();
// }
//
// class _HomeSubState extends State<HomeSub> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Home"),
//         centerTitle: true,
//         backgroundColor: Colors.blue,
//       ),
//       body: ListView(
//         children: [
//
//           const Divider(),
//
//           ListTile(
//             leading: const Icon(Icons.person),
//             title: const Text("Profile"),
//             onTap: () {
//               Navigator.push(
//                   context, MaterialPageRoute(builder: (context) => userview()));
//             },
//           ),
//           const Divider(),
//           ListTile(
//             leading: const Icon(Icons.person),
//             title: const Text("Audio Upload"),
//             onTap: () {
//               Navigator.push(
//                   context, MaterialPageRoute(builder: (context) => audio_upload()));
//             },
//           ),
//           const Divider(),
//           ListTile(
//             leading: const Icon(Icons.person),
//             title: const Text("Video Upload"),
//             onTap: () {
//               Navigator.push(
//                   context, MaterialPageRoute(builder: (context) => video_upload()));
//             },
//           ),
//           const Divider(),
//
//           ListTile(
//             leading: const Icon(Icons.pets),
//             title: const Text("View Animal"),
//             onTap: () {
//               Navigator.push(context,
//                   MaterialPageRoute(builder: (context) => animalview()));
//             },
//           ),
//           const Divider(),
//
//           ListTile(
//             leading: const Icon(Icons.category),
//             title: const Text("View Breed"),
//             onTap: () {
//               Navigator.push(context,
//                   MaterialPageRoute(builder: (context) => breedview()));
//             },
//           ),
//           const Divider(),
//
//           ListTile(
//             leading: const Icon(Icons.add_circle_outline),
//             title: const Text("Add Pet"),
//             onTap: () {
//               Navigator.push(
//                   context, MaterialPageRoute(builder: (context) => add_pet()));
//             },
//           ),
//           const Divider(),
//           ListTile(
//             leading: const Icon(Icons.star),
//             title: const Text("Rate And Review"),
//             onTap: () {
//               Navigator.push(context,
//                   MaterialPageRoute(builder: (context) => rateandreview()));
//             },
//           ),
//
//         ],
//       ),
//     );
//   }
// }




import 'package:aura/addAnimal.dart';
import 'package:aura/login.dart';
import 'package:aura/rateandreview.dart';
import 'package:aura/view_animal.dart';
import 'package:aura/view_breed.dart';
import 'package:aura/view_user.dart';
import 'package:flutter/material.dart';
import 'audio_upload.dart';
import 'video_upload.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'view_pet.dart';
import 'view_vaccinations.dart';

void main() {
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeSub(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeSub extends StatefulWidget {
  const HomeSub({Key? key}) : super(key: key);

  @override
  State<HomeSub> createState() => _HomeSubState();
}

class _HomeSubState extends State<HomeSub> with SingleTickerProviderStateMixin {
  String userName = "User";
  String userMail = "user@gmail.com";
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;



  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();
    _loadUserData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('uname') ?? 'User';
      userMail = prefs.getString('umail') ?? 'User@gmail.com';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          "Aura",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutDialog();
            },
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          slivers: [
            // Welcome Header
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4158D0), Color(0xFFC850C0)],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 26,
                              backgroundImage: NetworkImage(
                                'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
                                // 'https://www.flaticon.com/free-icon/profile_3135715',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome back,',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                userName,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E1E1E),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 20),
            ),


            // Quick Actions Section
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 15),
            ),

            // Quick Action Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                delegate: SliverChildListDelegate([
                  _buildQuickActionCard(
                    icon: Icons.pets,
                    title: 'Add Pet',
                    color: const Color(0xFF4158D0),
                    onTap: () => _navigateTo(context, add_pet()),
                  ),
                  _buildQuickActionCard(
                    icon: Icons.audiotrack,
                    title: 'Audio Upload',
                    color: const Color(0xFFC850C0),
                    onTap: () => _navigateTo(context, audio_upload()),
                  ),
                  _buildQuickActionCard(
                    icon: Icons.videocam,
                    title: 'Video Upload',
                    color: const Color(0xFFFF6B6B),
                    onTap: () => _navigateTo(context, video_upload()),
                  ),
                  _buildQuickActionCard(
                    icon: Icons.star,
                    title: 'Rate & Review',
                    color: const Color(0xFFFFA500),
                    onTap: () => _navigateTo(context, rateandreview()),
                  ),
                ]),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 25),
            ),

            // Features Section Header
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Features',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 15),
            ),

            // Features List
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildFeatureTile(
                    icon: Icons.pets,
                    title: 'View Animal',
                    subtitle: 'Browse all animals',
                    color: const Color(0xFF4158D0),
                    onTap: () => _navigateTo(context, animalview()),
                  ),
                  _buildFeatureTile(
                    icon: Icons.category,
                    title: 'View Breed',
                    subtitle: 'Explore different breeds',
                    color: const Color(0xFFC850C0),
                    onTap: () => _navigateTo(context, breedview()),
                  ),
                  _buildFeatureTile(
                    icon: Icons.person,
                    title: 'Profile',
                    subtitle: 'View and edit your profile',
                    color: const Color(0xFFFF6B6B),
                    onTap: () => _navigateTo(context, userview()),
                  ),
                ]),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 30),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.grey.shade50,
            ],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4158D0), Color(0xFFC850C0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 28,
                        backgroundImage: NetworkImage(
                          'https://i.pravatar.cc/150?img=12',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    userName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    userMail,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(
              icon: Icons.home_outlined,
              title: 'Home',
              onTap: () => Navigator.pop(context),
            ),
            _buildDrawerItem(
              icon: Icons.person_outline,
              title: 'Profile',
              onTap: () {
                Navigator.pop(context);
                _navigateTo(context, userview());
              },
            ),
            _buildDrawerItem(
              icon: Icons.pets_outlined,
              title: 'My Pets',
              onTap: (){
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => view_pets()));
              },
            ),
            _buildDrawerItem(
              icon: Icons.vaccines,
              title: 'Vaccinations',
              onTap: (){
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => vaccination_view()));
              },
            ),

            const Divider(),
            _buildDrawerItem(
              icon: Icons.logout,
              title: 'Logout',
              color: Colors.red,
              onTap: _showLogoutDialog,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.grey.shade700),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? Colors.grey.shade800,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 30,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E1E1E),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E1E1E),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 13,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey.shade400,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildPetCard(String name, String breed, String imagePath) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF4158D0).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.pets,
              color: Color(0xFF4158D0),
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Text(
            breed,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const login()),
                      (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('LOGOUT'),
            ),
          ],
        );
      },
    );
  }
}