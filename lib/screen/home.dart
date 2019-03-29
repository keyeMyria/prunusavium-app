import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prunusavium/screen/favorite.dart';
import 'package:prunusavium/screen/rank.dart';
import 'package:prunusavium/screen/search.dart';
import 'package:prunusavium/store/favorite.dart';
import 'package:prunusavium/store/search.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences prefs;
FavoriteStore favStore = FavoriteStore();
SearchStore searchStore = SearchStore(prefs);

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _idx = 0;
  List<Widget> pages = List<Widget>();
  List<String> titles = ["收藏", "排行"];

  @override
  initState() {
    super.initState();
    pages..add(FavoritePage(favStore))..add(RankPage());
  }

  Future asyncInit() async {
    prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      body: _buildBody(),
      drawer: _buildDrawer(),
      bottomNavigationBar: _buildBNB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        mini: true,
        onPressed: () {
          showSearch(
            context: context,
            delegate: SearchPage(searchStore),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.portrait, size: 30.0),
        onPressed: () => _scaffoldKey.currentState.openDrawer(),
      ),
      title: Text(titles[_idx]),
    );
  }

  Widget _buildBody() {
    return FutureBuilder(
      future: asyncInit(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return IndexedStack(
          index: _idx,
          children: pages,
        );
      },
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          Container(
            height: 100.0,
            child: DrawerHeader(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
              ),
              child: Center(
                child: FlutterLogo(
                  colors: Theme.of(context).primaryColor,
                  size: 75.0,
                ),
              ),
            ),
          ),
          ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed('/settings');
              }),
          ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed('/about');
              }),
          Divider(),
          ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Sign Out'),
              onTap: () {
                Navigator.pop(context);
              }),
        ],
      ),
    );
  }

  Widget _buildBNB() {
    return BottomAppBar(
      color: Theme.of(context).backgroundColor,
      shape: CircularNotchedRectangle(),
      notchMargin: 1.0,
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          GestureDetector(
            child: Icon(Icons.favorite_border),
            onTap: () {
              setState(() {
                _idx = 0;
              });
            },
            onDoubleTap: () {
              favStore.checkFavritesUpdate();
            },
          ),
          IconButton(
            icon: Icon(Icons.library_books),
            onPressed: () {
              setState(() {
                _idx = 1;
              });
            },
          ),
        ],
      ),
    );
  }
}
