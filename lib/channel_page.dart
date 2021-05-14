import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

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
