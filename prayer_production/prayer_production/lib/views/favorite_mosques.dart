import 'package:flutter/material.dart';
import 'package:prayer_production/controller/api_provider.dart';
import 'package:prayer_production/repository/shared_base.dart';

class FavoriteItemPage extends StatelessWidget {
  const FavoriteItemPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites Mosques'),
        actions: [
          IconButton(
            icon: Icon(Icons.get_app),
            onPressed: () async {
              /// get shared preferenc val :
              var res_id = await RepositeryShared().getMosqueID();
              print('******** ID from shared $res_id *********');
              var list_prayer = await PrayerProvider().PostToGetTimePrayer(id_mosque: res_id);
              print(
                  '******** print the resut of data list :  $list_prayer *********');
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Container(
            child: Text('SHOULD CONTAIN INFORMATION ABOUT MOSQUE FAVORITE GET IT EVRY TIME BY ID'),
          ),
        ),
      ),
    );
  }
}

/*
ListView.builder(
          itemCount: widget.list_mosques.length ?? 5,
          itemBuilder: (context, i) {
            String id = widget.list_mosques[i].id;
            bool isSaved = saved_list.contains(id);
            return Padding(
              padding: const EdgeInsets.all(4),
              child: Card(
                elevation: 6,
                child: ListTile(
                  leading: Image.asset('assets/images/prayer_mosque.png'),
                  title: Text(widget.list_mosques[i].designation.toString()),
                  subtitle: Row(
                    children: [
                      Text(widget.list_mosques[i].adresse.toString()),
                      SizedBox(
                        width: 16,
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      isSaved ? Icons.favorite : Icons.favorite_border,
                      color: isSaved ? Colors.red : null,
                      //Icons.favorite_border,
                    ),
                    onPressed: () {
                      /// save into favorite List
                      setState(() {
                       // isSaved =! isSaved;
                        if (isSaved) {
                          saved_list.remove(widget.list_mosques[i].id);
                        } else {
                          saved_list.add(widget.list_mosques[i].id);
                        }
                      });
                    },
                  ),
                  onTap: (){
                    print('---- State of isSaved is ${saved_list.length} ---------');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingPrayer(
                          mosque_name: widget.list_mosques[i].designation ?? 'Mosque',
                          id : widget.list_mosques[i].id ?? '10',
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }),
 */
