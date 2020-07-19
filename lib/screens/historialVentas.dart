import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diefpc/app/app.dart';
import 'package:diefpc/states/login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'monthWidget.dart';


class HistorialVentas extends StatefulWidget {
  @override
  _HistorialVentasState createState() => _HistorialVentasState();
}

class _HistorialVentasState extends State<HistorialVentas> {
  PageController _controller;
  int currentPage = DateTime.now().month;
  Stream<QuerySnapshot> _query;
  FirebaseUser _user;

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      initialPage: currentPage,
      viewportFraction: 0.4,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginState>(
      builder: (BuildContext context, LoginState state, Widget child) {
        _user = Provider.of<LoginState>( context ).currentUser( );
        _query = Firestore.instance
            .collection( 'usuarios' )
            .document( _user.uid )
            .collection( 'HistorialVentas' ).where(
            "month", isEqualTo: "${currentPage + 1}" )
            .snapshots( );
        return Scaffold(
          appBar: AppBar(
            title: Text( "Ventas del mes" ),
            actions: <Widget>[
              IconButton( icon: Icon( Icons.list ),
                  tooltip: 'Configuración',
                  onPressed: () {
                    configMenu( context );
                  }
              ),
            ],
          ),
          body: _body( ),
        );
      }
    );
  }

  Widget _body() {
    return SafeArea(
      child: Column(
        children: <Widget>[
          _selector(),
          StreamBuilder<QuerySnapshot>(
            stream: _query,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data) {
              if (data.hasData) {
                return MonthWidget(documents: data.data.documents, days: daysInMonth(currentPage + 1));
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _pageItem(String name, int position) {
    var _alignment;
    final selected = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Colors.blueGrey,
    );
    final unselected = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.normal,
      color: Colors.blueGrey.withOpacity(0.4),
    );

    if (position == currentPage) {
      _alignment = Alignment.center;
    } else if (position > currentPage) {
      _alignment = Alignment.centerRight;
    } else {
      _alignment = Alignment.centerLeft;
    }

    return Align(
      alignment: _alignment,
      child: Text(name,
        style: position == currentPage ? selected : unselected,
      ),
    );
  }

  Widget _selector() {
    return SizedBox.fromSize(
      size: Size.fromHeight(70.0),
      child: PageView(
        onPageChanged: (newPage) {
          setState(() {
            currentPage = newPage;
          });
        },
        controller: _controller,
        children: <Widget>[
          _pageItem("Enero", 0),
          _pageItem("Febrero", 1),
          _pageItem("Marzo", 2),
          _pageItem("Abril", 3),
          _pageItem("Mayo", 4),
          _pageItem("Junio", 5),
          _pageItem("Julio", 6),
          _pageItem("Agosto", 7),
          _pageItem("Septiembre", 8),
          _pageItem("Octubre", 9),
          _pageItem("Noviembre", 10),
          _pageItem("Diciembre", 11),
        ],
      ),
    );
  }
  int daysInMonth(int month){
    var now = DateTime.now();
    var lastDayDateTime = (month <12) ? new DateTime(now.year, month + 1, 0) : new DateTime(now.year + 1, 1, 0);
    return lastDayDateTime.day;
  }
}