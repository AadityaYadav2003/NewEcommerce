import "package:flutter/material.dart";
import "package:new_ecommerce/View/MainPages/Profile.dart";
import "package:new_ecommerce/View/MainPages/homepage.dart";
import "package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart";

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int currentIndex = 0;
  final List<Widget> pages = [HomePage(), ProfilePage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: pages[currentIndex],
      bottomNavigationBar: FluidNavBar(
        defaultIndex: 0,
        scaleFactor: 1.5,
        icons: [
          FluidNavBarIcon(
            backgroundColor: Colors.black,
            icon: Icons.home,
            extras: {"label": "Home"},
          ),
          FluidNavBarIcon(
            backgroundColor: Colors.black,
            icon: Icons.person,
            extras: {"label": "Profile"},
          ),
        ],
        onChange: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        style: FluidNavBarStyle(
            iconSelectedForegroundColor: Colors.white,
            iconUnselectedForegroundColor: Colors.white,
            barBackgroundColor: Color.fromARGB(255, 1478, 195, 234)),
      ),
    );
  }
}
