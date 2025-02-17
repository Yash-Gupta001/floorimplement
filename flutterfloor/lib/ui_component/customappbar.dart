import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final double elevation;
  final bool leading; 
  const CustomAppbar({
    super.key,
    required this.title,
    this.backgroundColor = Colors.lightGreen,
    this.elevation = 4.0,
    required this.leading,  // true or false for back button iin appbar
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    
    double appBarHeight = screenHeight * 0.08;

    return AppBar(
      leading: leading ? IconButton(
        icon: Icon(Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () {
          Get.back();
        },
      ) : null,
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
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
