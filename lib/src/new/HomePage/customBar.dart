import 'package:flutter/material.dart';

class CustomBar extends StatefulWidget {
  const CustomBar({Key? key}) : super(key: key);

  @override
  _CustomBarState createState() => _CustomBarState();
}

class _CustomBarState extends State<CustomBar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _currentIndex = 0;
              });
            },
            icon: Icon(
              Icons.home,
              size: _currentIndex == 0 ? 30 : 25,
              color: _currentIndex == 0 ? Color(0xff4245ff) : Colors.grey,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _currentIndex = 1;
              });
            },
            icon: Icon(
              Icons.person,
              size: _currentIndex == 1 ? 30 : 25,
              color: _currentIndex == 1 ? Color(0xff4245ff) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
