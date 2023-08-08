import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pyramidion_two/controller/provider/provider.dart';
import 'package:pyramidion_two/view/favourite_screen.dart';
import 'package:pyramidion_two/view/home_screen.dart';

class BottomNav extends StatelessWidget {
  BottomNav({super.key});

  List<Widget> screens = [
    const HomeScreen(),
    FavouriteScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Consumer<ProviderClass>(
        
        builder: (context, value, child) => BottomNavigationBar(
          currentIndex: value.currentBottomIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: const Color.fromARGB(255, 120, 120, 120),

          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_outlined,
                ),
                label: "Home"),
            BottomNavigationBarItem(
              
                icon: Icon(Icons.favorite), label: "Favourite"),
          ],
          onTap: (index) {
            value.setBottomIndex(index);
          },
        ),
      ),
      body: screens[Provider.of<ProviderClass>(context).currentBottomIndex],
    );
  }
}
