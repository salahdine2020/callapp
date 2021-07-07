import 'package:flutter/material.dart';
import 'package:prayer_production/repository/shared_base.dart';
import 'package:prayer_production/views/resarvation_prayer.dart';

class MosquesList extends StatefulWidget {
  final List<dynamic> list_mosques;
  final String image_url;
  final String prayer_name;
  final String tranch;
  MosquesList({this.list_mosques, this.image_url, this.prayer_name, this.tranch});
  @override
  _MosquesListState createState() => _MosquesListState();
}

class _MosquesListState extends State<MosquesList> {
  List<dynamic> saved_list = [];
  bool isSaved = false;
  int _i;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.teal,
        title: Text('Mosques List'),
      ),
      body: ListMosques(),
    );
  }

  Widget ListMosques() {
    return Container(
      child: Center(
        child: Center(
          child: widget.list_mosques != null ?
          ListView.builder(
              itemCount: widget.list_mosques.length ?? 5,
              itemBuilder: (context, i) {
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
                          _i == i ? Icons.favorite : Icons.favorite_border,
                          color: _i == i ? Colors.red : null,
                          //Icons.favorite_border,
                        ),
                        onPressed: () async {
                          /// save into favorite List
                          setState(() {
                            _i = i;
                          });
                          print('---- State of isSaved is ${widget.list_mosques[i].id} ---------');
                          await RepositeryShared().saveMosqueID(id_mosque: widget.list_mosques[i].id);
                        },

                      ),
                      onTap: (){
                        print('---- State of isSaved is ${saved_list.length} ---------');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingPrayer(
                              mosque_name: widget.list_mosques[i].designation ?? 'Mosque',
                              id : widget.list_mosques[i].id.toString(),//widget.list_mosques[i].id ?? '10',
                              image_url: widget.image_url,
                              prayer: widget.prayer_name,
                              tranch : widget.tranch,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }) : Center(child : Container(child: Text('Il n y a pas de mosquées disponibles sur ce site'),),),
        ),
      ),
    );
  }
}