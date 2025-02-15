import 'package:flutter/material.dart';
import 'package:flutterfloor/database/app_database.dart';


class CustomSearchBar extends StatelessWidget {
  final AppDatabase database;
  final TextEditingController controller;
  final Function(String)? onChanged;

  const CustomSearchBar({required this.controller, this.onChanged, required this.database});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: screenHeight * 0.02,
      ),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
          decoration: BoxDecoration(
            color: Colors.white, 
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8.0,
                spreadRadius: 1.0,
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: Colors.green,
                size: 24,
              ),
              SizedBox(width: screenWidth * 0.03),
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  decoration: InputDecoration(
                    hintText: 'Search employee',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.green),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}