import 'package:flutter/material.dart';
import '../sceens/addProduct.dart';
import '../sceens/chat.dart';

void main() {
  runApp(MaterialApp(
    home: ChatMembersScreen(),
  ));
}

class ChatMembersScreen extends StatelessWidget {


  List<Message> _messages = [
  Message('Hello!', true, DateTime.now().subtract(Duration(minutes: 5))),
  Message('Hi there!', false, DateTime.now().subtract(Duration(minutes: 3))),
  Message('How are you?', true, DateTime.now().subtract(Duration(minutes: 2))),
];

// Function to get unique members from messages
List<String> _getAllMembers() {
  Set<String> allMembers = Set<String>();
  for (Message message in _messages) {
    allMembers.add(message.senderName);
  }
  return allMembers.toList();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleIconButton(
              onPressed: () {
                Navigator.pop(context); // Handle back button press
              },
              icon: Icons.arrow_back_ios,
              backgroundColor: Color(0xFF3CF6B5),
            ),
            SizedBox(width: 20.0),
            Center(
              child: Text(
                'Chat Members',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 80.0,
            child: _buildOnlineMembers(),
          ),
          Container(
            margin: EdgeInsets.only(top: 30.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
          Flexible(
            child: ListView.builder(
              itemCount: chatMembers.length,
              itemBuilder: (context, index) {
                return _buildChatMemberTile(chatMembers[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnlineMembers() {
  List<String> allMembers = _getAllMembers();

  return ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: allMembers.length,
    itemBuilder: (context, index) {
      return GestureDetector(
        onTap: () {
          // Navigate to the chat page with the receiver's name
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(receiverName: allMembers[index]),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 30,
                // Assuming you have an online status property in Message class
                backgroundColor: _isMemberOnline(allMembers[index]) ? Colors.green : Colors.grey,
                child: Text(allMembers[index][0]), // Display the first letter of the name
              ),
              SizedBox(height: 8.0),
              Text(allMembers[index]),
            ],
          ),
        ),
      );
    },
  );
}
bool _isMemberOnline(String memberName) {
  // Implement your logic to check if the member is online
  // You can use the latest timestamp of their messages for this
  // For simplicity, let's assume they are online if they have sent a message in the last 5 minutes
  DateTime now = DateTime.now();
  DateTime lastMessageTimestamp = _messages
      .where((message) => message.senderName == memberName)
      .map((message) => message.timestamp)
      .fold(DateTime(2000), (prev, curr) => curr.isAfter(prev) ? curr : prev);

  return now.difference(lastMessageTimestamp).inMinutes <= 5;
}


  Widget _buildChatMemberTile(ChatMember chatMember) {
    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: AssetImage(chatMember.profileImage),
      ),
      title: Text(chatMember.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            chatMember.lastMessage,
            style: TextStyle(fontSize: 14.0),
          ),
          Text(
            chatMember.timestamp,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
        ],
      ),
      onTap: () {
        
      },
    );
  }
}

class ChatMember {
  final String name;
  final String profileImage;
  final bool isOnline;
  final String lastMessage;
  final String timestamp;

  ChatMember({
    required this.name,
    required this.profileImage,
    required this.isOnline,
    required this.lastMessage,
    required this.timestamp,
  });
}

final List<ChatMember> onlineMembers = [
  ChatMember(
    name: 'John Doe',
    profileImage: 'assets/images/profile1.jpg',
    isOnline: true,
    lastMessage: 'Hello, how are you?',
    timestamp: '9:30 AM',
  ),
  ChatMember(
    name: 'Jane Smith',
    profileImage: 'assets/images/profile2.jpg',
    isOnline: true,
    lastMessage: 'Sure, let\'s meet tomorrow.',
    timestamp: 'Yesterday',
  ),
];

final List<ChatMember> chatMembers = [
  ChatMember(
    name: 'Alice Johnson',
    profileImage: 'assets/images/profile3.jpg',
    isOnline: false,
    lastMessage: 'I will be there!',
    timestamp: 'Yesterday',
  ),
  ChatMember(
    name: 'Bob Williams',
    profileImage: 'assets/images/profile4.jpg',
    isOnline: false,
    lastMessage: 'Thanks for the update.',
    timestamp: '2 days ago',
  ),
  // Add more chat members as needed
];