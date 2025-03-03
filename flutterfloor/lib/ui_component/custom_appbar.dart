import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final double elevation;
  final bool leading; // true or false for back button in appbar

  const CustomAppbar({
    super.key,
    required this.title,
    this.backgroundColor = Colors.lightGreen,
    this.elevation = 4.0,
    required this.leading,  // true or false for back button in appbar
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    
    double appBarHeight = screenHeight * 0.08; // Dynamic app bar height based on screen size

    return AppBar(
      leading: leading 
        ? IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ) 
        : null,
      backgroundColor: backgroundColor,
      elevation: elevation,
      title: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: screenWidth * 0.06,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      toolbarHeight: appBarHeight,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(MediaQuery.of(Get.context!).size.height * 0.08);
}