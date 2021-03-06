import 'package:flutter/material.dart';

import 'channel_list.dart';

class HomeSmallScreen extends StatefulWidget {
  @override
  _HomeSmallScreenState createState() => _HomeSmallScreenState();
}

class _HomeSmallScreenState extends State<HomeSmallScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: IndexedStack(
        index: currentIndex,
        children: [
          ChannelListPage(),
          Center(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 48.0, vertical: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.rss_feed,
                      size: 50,
                    ),
                    Text('Activity Feed')
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat,
            ),
            label: "Channels",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.rss_feed,
            ),
            label: "Feed",
          ),
        ],
      ),
    );
  }
}
