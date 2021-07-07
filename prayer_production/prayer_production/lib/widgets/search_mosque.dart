import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart' as english_words;
import 'package:prayer_production/controller/api_provider.dart';
import 'package:prayer_production/repository/shared_base.dart';
import 'package:prayer_production/views/accueil.dart';
import 'package:prayer_production/views/mosques_list.dart';
import 'package:prayer_production/views/resarvation_prayer.dart';

// Adapted from search demo in offical flutter gallery:
// https://github.com/flutter/flutter/blob/master/examples/flutter_gallery/lib/demo/material/search_demo.dart
class AppBarSearchExample extends StatefulWidget {
  final String image_url;
  final String prayer_name;
  final String tranch;
  const AppBarSearchExample(
      {Key key, this.image_url, this.prayer_name, this.tranch})
      : super(key: key);

  @override
  _AppBarSearchExampleState createState() => _AppBarSearchExampleState();
}

class _AppBarSearchExampleState extends State<AppBarSearchExample> {
  final List<String> kPostalList; // should contain list of mosques
  _MySearchDelegate _delegate;
  final List<String> postal_codes = [];
  String id_mosque;
  String designation;
  String code_postal;
  _AppBarSearchExampleState()
      :

        /// here you should inject values into list
        kPostalList = List.from(Set.from(
          List.generate(10000, (index) => index.toString()),
        ))
          ..sort(
            (w1, w2) => w1.toLowerCase().compareTo(
                  w2.toLowerCase(),
                ),
          ),
        super();

  @override
  void initState() {
    super.initState();
    getMosquDetail();
    _delegate = _MySearchDelegate(kPostalList);
  }

  Future getMosquDetail() async {
    var res_id = await RepositeryShared().getMosqueID();
    if (res_id != null) {
      var data = await PrayerProvider().PostToGetMosques(id: res_id);
      print('******* ID for Mosque is ${data[0]['id']} ********');
      print(
          '******* designation for Mosque is ${data[0]['designation']} ********');
      setState(() {
        id_mosque = data[0]['id'];
        designation = data[0]['designation'];
        code_postal = data[0]['code_postal'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          'Cherche {code postale}',
          style: TextStyle(color: Colors.teal),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            tooltip: 'GET',
            icon: const Icon(
              Icons.search,
              color: Colors.teal,
              size: 28,
            ),
            onPressed: () async {
              final String selected = await showSearch<String>(
                context: context,
                delegate: _delegate,
              );
              if (selected != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('You have selected the word: $selected'),
                  ),
                );
              }
            },
          ),
        ],
        leading: IconButton(
          tooltip: 'GET',
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.teal,
            size: 28,
          ),
          onPressed: () async {
            // await getMosquDetail();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AccueilPage(),
              ),
            );
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              designation == null
                  ? Center(
                      child: Text('selection une mosque favorite stp'),
                    )
                  : Card(
                      child: ListTile(
                        leading: Container(
                          child: Image.asset('assets/images/prayer_mosque.png'),
                        ),
                        title: Text(designation ?? 'Mosque name'),
                        subtitle: Text(code_postal ?? 'Code Postal'),
                        trailing: Icon(
                          Icons.favorite,
                          color: Colors.redAccent,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingPrayer(
                                id: id_mosque,
                                mosque_name: designation,
                                image_url: widget.image_url,
                                prayer: widget.prayer_name,
                                tranch: widget.tranch,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

// Defines the content of the search page in `showSearch()`.
// SearchDelegate has a member `query` which is the query string.
class _MySearchDelegate extends SearchDelegate<String> {
  final List<String>
      _words; // you should extract from list of exicte potale in belgim
  final List<String> _history;

  _MySearchDelegate(List<String> words)
      : _words = words,
        _history = <String>['1300', '1650', '1700', '1800'],
        super();

  // Leading icon in search bar.
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        // SearchDelegate.close() can return vlaues, similar to Navigator.pop().
        this.close(context, null);
      },
    );
  }

  // Widget of result page.
  @override
  Widget buildResults(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('les mosque dans cette region : '),
            GestureDetector(
              onTap: () {
                // Returns this.query as result to previous screen, c.f.
                // `showSearch()` above.
                this.close(context, this.query);
              },
              child: Column(
                children: [
                  Text(
                    this.query,
                    style: Theme.of(context).textTheme.headline4.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  RaisedButton(
                      child: Text('Explore'),
                      onPressed: () async {
                        /// Go into Screen of Mosques :
                        var list_inf = await PrayerProvider().PostSearchMosques(
                            postal_code: '${query.toString()}');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MosquesList(
                              list_mosques: list_inf,
//                              image_url: widget.image_url,
//                              prayer_name: widget.prayer_name,
//                              tranch : widget.tranch,
                            ),
                          ),
                        );
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Suggestions list while typing (this.query).
  @override
  Widget buildSuggestions(BuildContext context) {
    final Iterable<String> suggestions = this.query.isEmpty
        ? _history
        : _words.where(
            (word) => word.startsWith(query),
          );
    return _SuggestionList(
      query: this.query,
      suggestions: suggestions.toList(),
      onSelected: (String suggestion) {
        this.query = suggestion;
        this._history.insert(0, suggestion);
        showResults(context);
      },
    );
  }

  // Action buttons at the right of search bar.
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      if (query.isEmpty)
        Container()
      else
        IconButton(
          tooltip: 'Clear',
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        )
    ];
  }
}

// Suggestions list widget displayed in the search page.
class _SuggestionList extends StatelessWidget {
  const _SuggestionList({this.suggestions, this.query, this.onSelected});

  final List<String> suggestions;
  final String query;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.subtitle1;
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int i) {
        final String suggestion = suggestions[i];
        return ListTile(
          leading: query.isEmpty
              ? const Icon(Icons.history)
              : const Icon(Icons.update),
          // Highlight the substring that matched the query.
          title: RichText(
            text: TextSpan(
              text: suggestion.substring(0, query.length),
              style: textTheme.copyWith(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                  text: suggestion.substring(query.length),
                  style: textTheme,
                ),
              ],
            ),
          ),
          onTap: () async {
            /// suggestion contain the postal code
            /*
            print('-------suggestion list is : $suggestion--------');
            List<String> list_add = [];
            var list_inf = await PrayerProvider().PostSearchMosque(postal_code: '${suggestion.toString()}');
            //onSelected(suggestion);
            list_inf.forEach((e) {
              list_add.add(e.adresse.toString());
              onSelected(e.adresse);
            });
            */
            var list_inf = await PrayerProvider()
                .PostSearchMosques(postal_code: '${suggestion.toString()}');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MosquesList(
                  list_mosques: list_inf,
                ),
              ),
            );
            //onSelected(suggestion); /// suggestion
          },
        );
      },
    );
  }
}
