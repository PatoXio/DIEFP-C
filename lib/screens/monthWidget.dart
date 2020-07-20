import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'graficoVentas.dart';

class MonthWidget extends StatefulWidget{
  final List<DocumentSnapshot> documents;
  final double total;
  final List<double> perDay;
  final Map<String, double> farmacos;
  MonthWidget({this.documents, days})
      :
        total = documents.map((doc) => int.parse(doc['Precio'])).fold(0.0, (a, b) => a+b),
        perDay = List.generate(days, (int index) {
          return documents.where((doc) => doc['day'] == ("${index + 1}"))
              .map((doc) => int.parse(doc['Precio']))
              .fold(0.0, (a, b) => a+b);
        }), 
        farmacos = documents.fold({}, (Map<String, double> map, document){
          if(!map.containsKey(document['Nombre'])){
            map[document['Nombre']]= 0.0;
          }
          map[document['Nombre']] += int.parse(document['Precio']);
          return map;
        });
  @override
  _MonthWidgetState createState() => _MonthWidgetState();
}

class _MonthWidgetState extends State<MonthWidget>{
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          _expenses(),
          _graph(),
          Container(
            color: Colors.blueAccent.withOpacity(0.15),
            height: 24.0,
          ),
          _list(),
        ],
      ),
    );
  }
  Widget _expenses() {
    return Column(
      children: <Widget>[
        Text("\$${widget.total.toStringAsFixed(2)}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 40.0,
          ),
        ),
        Text("Ganancias Del Mes",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: Colors.blueGrey,
          ),
        ),
      ],
    );
  }

  Widget _graph() {
    return Container(
      height: 250.0,
      child: GraficoVentas(perDay: widget.perDay),
    );
  }
  Widget _list() {
    return Expanded(
      child: ListView.separated(
        itemCount: widget.farmacos.keys.length,
        itemBuilder: (BuildContext context, int index){
          var key = widget.farmacos.keys.elementAt(index);
          var data = widget.farmacos[key];
          return _item(FontAwesomeIcons.shoppingCart, key, 100*data~/widget.total, data);
        },
        separatorBuilder: (BuildContext context, int index) {
          return Container(
            color: Colors.blueAccent.withOpacity(0.15),
            height: 8.0,
          );
        },
      ),
    );
  }
  Widget _item(IconData icon, String name, int percent, double value) {
    return ListTile(
      leading: Icon(icon, size: 32.0,),
      title: Text(name,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0
        ),
      ),
      subtitle: Text("$percent% de las ganancias",
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.blueGrey,
        ),
      ),
      trailing: Container(
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.2),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("\$$value",
            style: TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }
}