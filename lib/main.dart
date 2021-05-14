import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import './responsive_builder.dart';

// This sample uses GetStream for chat. To get started, please see https://getstream.io/chat/flutter/tutorial/
Future<void> main() async {
  final client = StreamChatClient(
    'YOUR-KEY',
    logLevel: Level.INFO,
  );

  await client.connectUser(
    User(
      id: 'David',
      extraData: {
        'image': 'https://picsum.photos/id/1005/200/300',
      },
    ),
    client.devToken('David'),
  );

  // final channel = client.channel(
  //   "messaging",
  //   id: "flutist",
  //   extraData: {
  //     "name": "Flutist",
  //     "image": "https://source.unsplash.com/Y6Hn79vRcXU",
  //     "members": ['Mike', 'Jhon', 'David'],
  //   },
  // );
  //
  // await channel.watch();

  runApp(StreamDesktop(
    client: client,
  ));
}

class StreamDesktop extends StatelessWidget {
  const StreamDesktop({Key key, this.client}) : super(key: key);
  final StreamChatClient client;

  @override
  Widget build(BuildContext context) {
    return StreamChat(
      client: client,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ResponsiveBuilder(
          smallChild: HomeSmallScreen(),
          largeChild: HomeDesktopScreen(),
        ),
      ),
    );
  }
}

class HomeSmallScreen extends StatefulWidget {
  @override
  _HomeSmallScreenState createState() => _HomeSmallScreenState();
}

class _HomeSmallScreenState extends State<HomeSmallScreen> {
  PageController pageController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: pageController,
          children: [
            ChannelListPage(),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFc3fcff),
                    Color(0xFF6c74ff),
                  ],
                ),
              ),
              child: Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 48.0, vertical: 24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ShaderMask(
                          shaderCallback: (rect) => LinearGradient(colors: [
                            Color(0xFFc3fcff),
                            Color(0xFF6c74ff),
                          ]).createShader(rect),
                          child: CircleAvatar(
                            radius: 48.0,
                            backgroundColor: Colors.white,
                            child: Text(
                              "N",
                              style: TextStyle(fontSize: 36.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        Text(
                          "Hello Nash 👋",
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 36.0),
                        Text(
                          "ID: ${StreamChat.of(context).user.id}",
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
          switch (index) {
            case 0:
              pageController.animateToPage(0,
                  duration: kThemeAnimationDuration, curve: Curves.ease);
              break;
            case 1:
              pageController.animateToPage(1,
                  duration: kThemeAnimationDuration, curve: Curves.ease);
              break;
            default:
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat,
              color: Color(0xFF3d91cc),
            ),
            label: "Conversations",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.supervised_user_circle_rounded,
              color: Color(0xFF6c74ff),
            ),
            label: "Me",
          ),
        ],
      ),
    );
  }
}

class HomeDesktopScreen extends StatelessWidget {
  final ValueNotifier<Channel> _selectedChannel = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  ListHeader(),
                  Divider(),
                  Expanded(
                    child: ChannelListPage(
                      onItemTap: (channel) => _selectedChannel.value = channel,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: ValueListenableBuilder(
                valueListenable: _selectedChannel,
                builder: (BuildContext context, value, placeholder) {
                  if (value == null) {
                    return placeholder;
                  } else {
                    return StreamChannel(
                      key: ValueKey<String>(value.cid),
                      channel: value,
                      child: ChannelPage(
                        showBackButton: false,
                      ),
                    );
                  }
                },
                child: GettingStarted(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChannelPage extends StatelessWidget {
  const ChannelPage({
    Key key,
    this.showBackButton = true,
  }) : super(key: key);
  final bool showBackButton;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChannelHeader(
        showBackButton: showBackButton,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: MessageListView(),
          ),
          MessageInput(
            disableAttachments: true,
          ),
        ],
      ),
    );
  }
}

class ChannelListPage extends StatelessWidget {
  const ChannelListPage({Key key, this.onItemTap}) : super(key: key);

  final ValueChanged<Channel> onItemTap;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ChannelsBloc(
        child: ChannelListView(
          onChannelTap: onItemTap != null
              ? (channel, _) {
                  onItemTap(channel);
                }
              : null,
          filter: {
            'members': {
              '\$in': [StreamChat.of(context).user.id],
            }
          },
          sort: [SortOption('last_message_at')],
          pagination: PaginationParams(
            limit: 20,
          ),
          channelWidget: ChannelPage(),
        ),
      ),
    );
  }
}

class GettingStarted extends StatelessWidget {
  const GettingStarted({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) => LinearGradient(colors: [
        Color(0xFFc3fcff),
        Color(0xFF6c74ff),
      ]).createShader(rect),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.chat,
            size: 100.0,
            color: Colors.white,
          ),
          Text(
            "Select a conversationt to get started!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class ListHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          ShaderMask(
            shaderCallback: (rect) => LinearGradient(colors: [
              Color(0xFFc3fcff),
              Color(0xFF6c74ff),
            ]).createShader(rect),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                "N",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ),
          const SizedBox(width: 12.0),
          Text(
            "Hello Nash 👋",
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
