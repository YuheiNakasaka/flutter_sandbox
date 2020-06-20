import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      home: AnimatedListPage(),
    );
  }
}

class AnimatedAlignPage extends StatefulWidget {
  static const routeName = 'animatedAlign';

  @override
  _AnimatedAlignPageState createState() => _AnimatedAlignPageState();
}

class _AnimatedAlignPageState extends State<AnimatedAlignPage> {
  static const _alignments = [
    Alignment.topLeft,
    Alignment.topRight,
    Alignment.bottomRight,
    Alignment.bottomLeft,
  ];

  var _index = 0;
  AlignmentGeometry get _alignment => _alignments[_index % _alignments.length];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _index++;
          });
        },
        child: const Icon(Icons.refresh),
      ),
      body: Padding(
        padding: EdgeInsets.all(60),
        child: AnimatedAlign(
          alignment: _alignment,
          duration: const Duration(milliseconds: 100),
          child: Container(
            width: 100,
            height: 100,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}

class AnimatedContainerPage extends StatefulWidget {
  static const routeName = 'animatedAlign';

  @override
  _AnimatedContainerPageState createState() => _AnimatedContainerPageState();
}

class _AnimatedContainerPageState extends State<AnimatedContainerPage> {
  static const _alignments = [
    Alignment.topLeft,
    Alignment.topRight,
    Alignment.bottomRight,
    Alignment.bottomLeft,
  ];

  static const _colors = [
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.blue,
  ];

  var _index = 0;
  AlignmentGeometry get _alignment => _alignments[_index % _alignments.length];
  Color get _color => _colors[_index % _colors.length];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _index++;
          });
        },
        child: const Icon(Icons.refresh),
      ),
      body: Padding(
        padding: EdgeInsets.all(0),
        child: AnimatedContainer(
          alignment: _alignment,
          color: _color,
          duration: const Duration(milliseconds: 100),
          margin: EdgeInsets.all(20 * ((3 - _index).toDouble() % 4)),
          padding: EdgeInsets.all(20 * ((_index).toDouble() % 4)),
          child: Container(
            width: 100,
            height: 100,
            color: Colors.blue,
          ),
          curve: Curves.easeInOut,
        ),
      ),
    );
  }
}

class UserModel {
  UserModel({this.firstName, this.lastName, this.profileImageUrl});
  String firstName;
  String lastName;
  String profileImageUrl;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          firstName == other.firstName &&
          lastName == other.lastName &&
          profileImageUrl == other.profileImageUrl;

  @override
  int get hashCode =>
      firstName.hashCode ^ lastName.hashCode ^ profileImageUrl.hashCode;
}

List<UserModel> listData = [
  UserModel(
      firstName: 'A',
      lastName: 'a',
      profileImageUrl:
          'https://img.gifmagazine.net/gifmagazine/images/1290357/medium_thumb.png'),
  UserModel(
      firstName: 'B',
      lastName: 'b',
      profileImageUrl:
          'https://img.gifmagazine.net/gifmagazine/images/1290357/medium_thumb.png'),
  UserModel(
      firstName: 'C',
      lastName: 'c',
      profileImageUrl:
          'https://img.gifmagazine.net/gifmagazine/images/1290357/medium_thumb.png'),
];

class AnimatedListPage extends StatefulWidget {
  @override
  _AnimatedListState createState() => _AnimatedListState();
}

class _AnimatedListState extends State<AnimatedListPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  void addUser() {
    int index = listData.length;
    listData.add(
      UserModel(
        firstName: 'D',
        lastName: 'd',
        profileImageUrl:
            'https://img.gifmagazine.net/gifmagazine/images/1290357/medium_thumb.png',
      ),
    );
    _listKey.currentState.insertItem(
      index,
      duration: Duration(milliseconds: 500),
    );
  }

  void deleteUser(int index) {
    var user = listData.removeAt(index);
    _listKey.currentState.removeItem(
      index,
      (BuildContext context, Animation<double> animation) {
        return FadeTransition(
          opacity:
              CurvedAnimation(parent: animation, curve: Interval(0.5, 1.0)),
          child: SizeTransition(
            sizeFactor:
                CurvedAnimation(parent: animation, curve: Interval(0.0, 1.0)),
            axisAlignment: 0.0,
            child: _buildItem(user),
          ),
        );
      },
      duration: Duration(milliseconds: 600),
    );
  }

  Widget _buildItem(UserModel user, [int index]) {
    return ListTile(
      key: ValueKey<UserModel>(user),
      title: Text(listData[index].firstName),
      subtitle: Text(listData[index].lastName),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(listData[index].profileImageUrl),
      ),
      onLongPress: index != null ? () => deleteUser(index) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animated List'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.add),
          onPressed: addUser,
        ),
      ),
      body: SafeArea(
        child: AnimatedList(
          key: _listKey,
          initialItemCount: listData.length,
          itemBuilder: (BuildContext context, int index, Animation animation) {
            return FadeTransition(
              opacity: animation,
              child: _buildItem(listData[index], index),
            );
          },
        ),
      ),
    );
  }
}
