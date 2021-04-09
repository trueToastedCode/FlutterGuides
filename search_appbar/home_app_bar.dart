import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:guides/backend_service.dart';
import 'package:guides/search_history_service.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  BackendService _backendService = BackendService();
  SearchHistoryService _searchHistoryService = SearchHistoryService();
  final String title;
  final onSelect;

  HomeAppBar({this.title, this.onSelect});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      onTap: () => _onSearch(context),
      appBar: AppBar(
        centerTitle: true,
        title: Text(title == null ? "Search" : title),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(Icons.search),
          ),
        ],
      ),
    );
  }

  /// starts the search
  void _onSearch(BuildContext context) {
    showSearch(
      context: context,
      delegate: MySearch(
        getBackendSuggestions: (text) => _backendService.futureSearch(text),
        getRecentSuggestions: _searchHistoryService.getSearchHistory,
        onSelect: (text) => _onSelect(context, text),
      ),
    );
  }

  /// manage search history, close search and call public onSelect
  void _onSelect(BuildContext context, String text) {
    _searchHistoryService.setSearchHistory(text);
    Navigator.pop(context);
    onSelect(text);
  }
}

/// This exists in order to make the hole appbar clickable
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onTap;
  final AppBar appBar;

  const CustomAppBar({Key key, this.onTap,this.appBar}) : super(key: key);

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap,child: appBar);
  }
}

/// This is the custom search delegate
class MySearch extends SearchDelegate<String> {
  final Function
      getBackendSuggestions,
      getRecentSuggestions,
      onSelect;
  Widget _lastFutureBuilder; // this exists because we do not need a new async call (backend or recent) for every change in the ui

  MySearch({
    @required this.getBackendSuggestions,
    @required this.getRecentSuggestions,
    @required this.onSelect,
  });

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: Icon(Icons.clear), onPressed: () => query = ""), // clear query button
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton( // close search button
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _lastFutureBuilder;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      // recent searches for no search text
      _lastFutureBuilder = FutureBuilder(
        future: getRecentSuggestions(),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapchot) {
          if (snapchot.connectionState == ConnectionState.done) {
            return _getRecentListView(snapchot.data);
          }else return SizedBox();
        },
      );
    }else {
      // backend result for search
      _lastFutureBuilder = FutureBuilder(
        future: getBackendSuggestions(query),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapchot) {
          if (snapchot.connectionState == ConnectionState.done) {
            if (snapchot.data == null) {
              // error loading the data
              return Row(
                children: [
                  Icon(Icons.error),
                  Text("Unable to load the data"),
                ],
              );
            }else {
              // list the results
              return _getSearchListView(snapchot.data);
            }
          }else {
            // loading in progress
            return SpinKitRipple(
              color: Colors.blue,
              size: 140,
            );
          }
        },
      );
    }
    return _lastFutureBuilder;
  }

  /// build a listview for the recent search history
  Widget _getRecentListView(List<dynamic> list) => ListView.builder(itemBuilder: (context, index) => ListTile(
      leading: Icon(Icons.refresh),
      title: Text(list[index].toString()),
      onTap: () => onSelect(list[index].toString()),
    ),
    itemCount: list.length,
  );

  /// build a listview for the backend suggestions
  Widget _getSearchListView(List<dynamic> list) {
    if (query.isNotEmpty) {
      // make sure that the query is listed as first result
      final pos = list.indexOf(query);
      if (pos > 0) list.removeAt(pos);
      if (pos == -1 || pos != 0) list.insert(0, query);
    }
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        leading: Icon(Icons.search),
        title: RichText(text: TextSpan(
          children: _getTextSpans(list[index].toString()),
        )),
        onTap: () => onSelect(list[index].toString()),
      ),
      itemCount: list.length,
    );
  }

  // style for the textspans
  static const
      _TEXT_STYLE_UNMARKED = TextStyle(color: Colors.black), // style for unmarked text
      _TEXT_STYLE_MARKED = TextStyle(fontWeight: FontWeight.bold, color: Colors.blue); // style for marked text

  /// create textspans for the text, the query will be marked in the text
  List<TextSpan> _getTextSpans(String text) {
    final pos = text.indexOf(query);
    if (pos == -1) return [TextSpan(text: text, style: _TEXT_STYLE_UNMARKED)];
    List<TextSpan> textSpans = [];
    if (pos != 0) textSpans.add(TextSpan(text: text.substring(0, pos), style: _TEXT_STYLE_UNMARKED));
    textSpans.add(TextSpan(
      text: text.substring(pos, pos+query.length),
      style: _TEXT_STYLE_MARKED,
    ));
    if (pos+query.length < text.length) textSpans.add(TextSpan(text: text.substring(pos+query.length), style: _TEXT_STYLE_UNMARKED));
    return textSpans;
  }
}