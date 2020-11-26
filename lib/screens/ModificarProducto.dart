import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diefpc/Clases/Producto.dart';
import 'package:diefpc/Clases/Tienda.dart';
import 'package:diefpc/screens/home.dart';
import 'package:diefpc/states/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ModificarProducto extends StatefulWidget {
  String codigo;
  ModificarProducto(String value) {
    codigo = value;
  }

  @override
  _ModificarProductoState createState() => _ModificarProductoState();
}

class _ModificarProductoState extends State<ModificarProducto> {
  double screenHeight;
  Producto modelProducto = new Producto();
  Producto producto;
  Tienda _user;
  final _formKey = GlobalKey<FormState>();

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

  List<String> selectedReportList = new List();

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
    producto = _user.getProducto(widget.codigo);
    screenHeight = MediaQuery.of(context).size.height;
    if (producto.getCategoria() != null) {
      selectedReportList = producto.getCategoria();
      print(selectedReportList);
    }
    print(producto.getCategoria());

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
          ),
        ],
      ),
    );
  }

  Widget singUpCard(BuildContext context) {
    return Center(
      child: Form(
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
                    child: Consumer(
                      builder: (BuildContext context, AuthService value,
                          Widget child) {
                        if (producto == null) {
                          return CircularProgressIndicator();
                        } else
                          return child;
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Codigo del producto a modificar: ${producto.getCodigo()}",
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
                            initialValue: producto.getNombre(),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Este campo no puede estar vacío.";
                              } else {
                                modelProducto.setNombre(value);
                                return null;
                              }
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
                            enabled: false,
                            initialValue: producto.getCodigo(),
                            decoration: InputDecoration(
                              labelText: "Codigo (No se puede modificar)",
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            maxLength: 9,
                            initialValue: producto.getMgPorU().toString(),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Este campo no puede estar vacío.";
                              } else {
                                modelProducto.setMgPorU(double.parse(value));
                                return null;
                              }
                            },
                            keyboardType: TextInputType.number,
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
                            initialValue: producto.getPrecio().toString(),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Este campo no puede estar vacío.";
                              } else {
                                modelProducto.setPrecio(int.parse(value));
                                return null;
                              }
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
                            initialValue: producto.getStock().toString(),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Este campo no puede estar vacío.";
                              } else {
                                modelProducto.setStock(int.parse(value));
                                return null;
                              }
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
                                        String value = _modificarProducto(
                                            modelProducto.getStock().toString(),
                                            modelProducto.getNombre(),
                                            producto.getCodigo(),
                                            modelProducto
                                                .getMgPorU()
                                                .toString(),
                                            modelProducto
                                                .getPrecio()
                                                .toString());
                                        if (value == null) {
                                          Producto newProducto = new Producto
                                                  .carga(
                                              producto.getCodigo(),
                                              producto.getCodigo(),
                                              _user.getEmail(),
                                              _user.getName(),
                                              modelProducto.getNombre(),
                                              selectedReportList, //categoria)
                                              modelProducto.getCantidad(),
                                              modelProducto.getPrecio(),
                                              modelProducto.getStock(),
                                              modelProducto.getStockReservado(),
                                              modelProducto.getMgPorU());
                                          _user.editProducto(newProducto);
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
                                  }),
                            ],
                          ),
                        ],
                      ),
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
          )),
    );
  }

  String _modificarProducto(
      String stock, String nombre, String codigo, String peso, String precio) {
    if (_user.getProducto(widget.codigo) != null) {
      Firestore.instance
          .collection('usuarios')
          .document(_user.getEmail())
          .collection('Productos')
          .document(codigo)
          .setData({
        "Stock": stock,
        "Mg/u": peso,
        "Nombre": nombre,
        "Precio": precio,
      }, merge: true);
      return null;
    } else {
      return "Ha ocurrido un error, el producto no existe.\nVuelve a ingresar a la Bodega.";
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
