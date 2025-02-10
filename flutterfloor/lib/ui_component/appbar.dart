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
    required this.leading,  // Use bool here
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading ? IconButton(
        icon: Icon(Icons.arrow_back),
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
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
