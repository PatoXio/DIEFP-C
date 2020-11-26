import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diefpc/Clases/Producto.dart';
import 'package:diefpc/Clases/Tienda.dart';
import 'package:diefpc/screens/home.dart';
import 'package:diefpc/states/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

//import 'login.dart';

class CrearProducto extends StatefulWidget {
  @override
  _CrearProductoState createState() => _CrearProductoState();
}

class _CrearProductoState extends State<CrearProducto> {
  double screenHeight;
  Producto modelProducto = new Producto();
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  Tienda _user;

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Set intial mode to login
  @override
  void initState() {
    super.initState();
  }

  List<String> reportList = [
    "Bebé e infantil",
    "Belleza",
    "Bienestar sexual",
    "Cuidado personal",
    "Maternidad",
    "Nutrición",
    "Medicamentos",
    "Medicamentos naturales",
    "Veterinaria"
  ];

  List<String> selectedReportList = List();

  _showReportDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //Here we will build the content of the dialog
          return AlertDialog(
            title: Text("Seleccione Categoria"),
            content: MultiSelectChip(
              reportList,
              onSelectionChanged: (selectedList) {
                setState(() {
                  selectedReportList = selectedList;
                });
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Aceptar"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    _user = Provider.of<AuthService>(context).currentUser();
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            singUpCard(context),
            pageTitle(),
          ],
        ),
      ),
    );
  }

  Widget pageTitle() {
    return Container(
      margin: EdgeInsets.only(top: 50),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.local_hospital,
            size: 48,
            color: Colors.red,
          ),
          Text(
            "DIEFP-C",
            style: TextStyle(
                fontSize: 34, color: Colors.blue, fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
  }

  Widget singUpCard(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: screenHeight / 5),
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Agregar Producto",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        maxLength: 50,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Por favor ingrese el nombre del producto';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Nombre",
                        ),
                        onChanged: (String value) {
                          modelProducto.setNombre(value);
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        maxLength: 50,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Por favor ingrese el codigo';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          labelText: "Codigo",
                        ),
                        onChanged: (String value) {
                          modelProducto.setCodigo(value);
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        maxLength: 9,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Por favor ingrese el peso del producto';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        /*inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly;
                        ]*/
                        decoration: InputDecoration(
                          labelText: "Peso en mg/u",
                        ),
                        onChanged: (String value) {
                          modelProducto.setMgPorU(double.parse(value));
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        maxLength: 9,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Por favor ingrese el precio del producto';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          labelText: "Precio en pesos",
                        ),
                        onChanged: (String value) {
                          modelProducto.setPrecio(int.parse(value));
                        },
                      ),
                      FloatingActionButton.extended(
                        onPressed: () {
                          _showReportDialog();
                        },
                        label: Text("Seleccionar Categorías"),
                        icon: Icon(Icons.category),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(selectedReportList.isEmpty
                          ? "Debe seleccionar al menos una categoría"
                          : "Categorías: " + selectedReportList.join(", ")),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        maxLength: 30,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Por favor ingrese la cantidad de stock';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          labelText: "Ingrese el stock",
                        ),
                        onChanged: (String value) {
                          modelProducto.setStock(int.parse(value));
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: Container(),
                          ),
                          FlatButton(
                              child: Text("Atrás"),
                              color: Colors.blue,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                          SizedBox(
                            width: 20,
                          ),
                          FlatButton(
                              child: Text("Guardar"),
                              color: Colors.blue,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  if (selectedReportList.isNotEmpty) {
                                    String value = _createProducto(
                                        modelProducto.getStock().toString(),
                                        modelProducto.getNombre(),
                                        modelProducto.getCodigo(),
                                        modelProducto.getMgPorU().toString(),
                                        modelProducto.getPrecio().toString(),
                                        selectedReportList);
                                    if (value == null) {
                                      Producto producto = new Producto.carga(
                                          modelProducto.getCodigo(),
                                          modelProducto.getCodigo(),
                                          _user.getEmail(),
                                          _user.getName(),
                                          modelProducto.getNombre(),
                                          selectedReportList, //categoria
                                          modelProducto.getCantidad(),
                                          modelProducto.getPrecio(),
                                          modelProducto.getStock(),
                                          modelProducto.getStockReservado(),
                                          modelProducto.getMgPorU());
                                      _user.setProducto(producto);
                                      Provider.of<AuthService>(context)
                                          .actualizarUser(_user);
                                      Navigator.pop(context);
                                    } else {
                                      _showAlert(value);
                                    }
                                  } else {
                                    _showAlert(
                                        "Debes seleccionar al menos una categoría");
                                  }
                                }
                                /*Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProductosTienda()));
                                Navigator.popAndPushNamed(
                                    context,'');*/
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FlatButton(
                child: Text(
                  "Terminos y Condiciones",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                onPressed: () {},
              ),
            ),
          ],
        ));
  }

  String _createProducto(String stock, String nombre, String codigo,
      String peso, String precio, List<String> categorias) {
    if (_user.getProducto(codigo) == null) {
      Firestore.instance
          .collection('usuarios')
          .document(_user.getEmail())
          .collection('Productos')
          .document(codigo)
          .setData({
        "Stock": stock,
        "Codigo": codigo,
        "Mg/u": peso,
        "Nombre": nombre,
        "Cantidad": "0",
        "Precio": precio,
        "StockReservado": "0",
        "Tienda": _user.getEmail(),
        "nombreTienda": _user.getName(),
        "Categorias": categorias,
      });
      print(_user.email);
      return null;
    } else {
      print("El producto ya existe");
      return "El producto ya existe";
    }
  }

  void _showAlert(String notify) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Aviso"),
          content: new Text(notify),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void goToHomeScreen(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<String> reportList;
  final Function(List<String>) onSelectionChanged;

  MultiSelectChip(this.reportList, {this.onSelectionChanged});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  // String selectedChoice = "";
  List<String> selectedChoices = List();

  _buildChoiceList() {
    List<Widget> choices = List();

    widget.reportList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              widget.onSelectionChanged(selectedChoices);
            });
          },
        ),
      ));
    });

    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}
