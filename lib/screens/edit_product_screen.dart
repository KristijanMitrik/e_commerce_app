import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce_app/models/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = 'edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final priceFocus = FocusNode();
  final descriptionFocus = FocusNode();
  final imageUrlControler = TextEditingController();
  final imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var product = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };
  var isInit = true;
  var isLoading = false;

  @override
  void initState() {
    imageUrlFocusNode.addListener(_updateImageUrl);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      final productId = ModalRoute.of(context).settings.arguments;
      if (productId != null) {
        product =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': product.title,
          'description': product.description,
          'price': product.price.toString(),
          'imageUrl': '',
        };
        imageUrlControler.text = product.imageUrl;
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    priceFocus.dispose();
    descriptionFocus.dispose();
    imageUrlControler.dispose();
    imageUrlFocusNode.removeListener(_updateImageUrl);
    imageUrlFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      isLoading = true;
    });
    if (product.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(product.id, product);
      Navigator.of(context).pop();
      setState(() {
        isLoading = false;
      });
    } else {
      try {
        await Provider.of<Products>(context, listen: false).addProduct(product);
      } catch (error) {
        print('sadsdsa mdkLSA MLKD SMALK DLKMSAD LKMSA');
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('edit product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(15),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      cursorColor: Colors.black,
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(
                        labelText: 'title',
                        labelStyle: TextStyle(color: Colors.black),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black38),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(priceFocus);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'please provide a title';
                        } else
                          return null;
                      },
                      onSaved: (value) {
                        product = Product(
                            title: value,
                            id: product.id,
                            isFavourite: product.isFavourite,
                            price: product.price,
                            description: product.description,
                            imageUrl: product.imageUrl);
                      },
                    ),
                    TextFormField(
                      cursorColor: Colors.black,
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(
                        labelText: 'price',
                        labelStyle: TextStyle(color: Colors.black),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black38),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: priceFocus,
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).requestFocus(descriptionFocus);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'please provide a price';
                        } else if (double.tryParse(value) == null) {
                          return 'please enter a valid number';
                        } else if (double.parse(value) < 0) {
                          return 'please enter a number bigger than 0';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        product = Product(
                            title: product.title,
                            id: product.id,
                            isFavourite: product.isFavourite,
                            price: double.parse(value),
                            description: product.description,
                            imageUrl: product.imageUrl);
                      },
                    ),
                    TextFormField(
                      cursorColor: Colors.black,
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(
                        labelText: 'discription',
                        labelStyle: TextStyle(color: Colors.black),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black38),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: descriptionFocus,
                      onSaved: (value) {
                        product = Product(
                            title: product.title,
                            id: product.id,
                            isFavourite: product.isFavourite,
                            price: product.price,
                            description: value,
                            imageUrl: product.imageUrl);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'please provide a description';
                        }
                        if (value.length < 10) {
                          return 'description should be at least 10 characters long';
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: imageUrlControler.text.isNotEmpty
                                ? FittedBox(
                                    child:
                                        Image.network(imageUrlControler.text),
                                  )
                                : Text('data')),
                        Expanded(
                          child: TextFormField(
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              labelText: 'url',
                              labelStyle: TextStyle(color: Colors.black),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black38),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: imageUrlControler,
                            focusNode: imageUrlFocusNode,
                            onFieldSubmitted: (v) {
                              _saveForm();
                            },
                            onSaved: (value) {
                              product = Product(
                                  title: product.title,
                                  id: product.id,
                                  isFavourite: product.isFavourite,
                                  price: product.price,
                                  description: product.description,
                                  imageUrl: value);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'please provide a image URL';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'please enter valid URL';
                              }
                              if (!value.endsWith('png') &&
                                  !value.endsWith('jpg') &&
                                  !value.endsWith('jpeg')) {
                                return 'please enter a valid URL';
                              }
                              return null;
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
