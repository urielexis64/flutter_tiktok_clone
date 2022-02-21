import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/views/widgets/custom_icon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          pages[pageIndex],
          Align(
              alignment: Alignment.bottomCenter,
              child: BottomNavigationBar(
                onTap: (value) => setState(() => pageIndex = value),
                currentIndex: pageIndex,
                backgroundColor: Colors.black38,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.grey[400],
                type: BottomNavigationBarType.fixed,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home, size: 24),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search, size: 24),
                    label: 'Search',
                  ),
                  BottomNavigationBarItem(
                    icon: CustomIcon(),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.message, size: 24),
                    label: 'Message',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person, size: 24),
                    label: 'Profile',
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
