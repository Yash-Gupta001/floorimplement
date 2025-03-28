import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controller/search_employee_controller.dart';

class CustomSearchBar extends StatelessWidget {
  final FocusNode unfocus = FocusNode();
  final TextEditingController controller;
  final Function(String)? onChanged;

  //instance of your search controller
  final Searchemployeecontroller searchController =
      Get.put(Searchemployeecontroller(updateController: Get.find()));

  CustomSearchBar({super.key, required this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: screenHeight * 0.01,
      ),
      child: GestureDetector(
        onTap: () {
          // Dismiss the keyboard when tapping outside of the search field
          unfocus.unfocus();
          FocusScope.of(context).requestFocus(FocusNode());
          SystemChannels.textInput.invokeMethod('TextInput.hide');
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
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
                  focusNode: unfocus,
                  controller: controller,
                  onChanged: (value) {
                    if (onChanged != null) {
                      onChanged!(value);
                    } else {
                      //searchController to search employees
                      searchController.searchEmployees(value);
                    }
                  },
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