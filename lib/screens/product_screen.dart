import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Models/product_model.dart';
import 'package:flutter_application_1/screens/custom_header.dart';

import 'package:http/http.dart' as http;
late int count = 2;

class ProductScreen extends StatefulWidget {
  final int? id;
  const ProductScreen({super.key, this.id});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  Future<ProductModel> getProduct() async {
    final uri = Uri.parse('https://fakestoreapi.com/products/${widget.id}');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final product = ProductModel.fromJson(responseBody);
        return product;
      } else {
        throw Exception('status code is not equal to 200');
      }
    } catch (e) {
      log(e.toString());
      throw Exception('status code is not equal to 200');
    }
  }

  Future<List<String>> getCategories() async {
    final uri = Uri.parse('https://fakestoreapi.com/products/categories');
    final list = <String>[];

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final rawList = responseBody as Iterable?; // [] | null
        for (var element in rawList ?? []) {
          list.add(element);
        }
        log(rawList.toString());
      } else {
        throw Exception('status code is not equal to 200');
      }
    } catch (e) {
      log(e.toString());
    }
    return list;
  }

  Future<List> initScreen() async {
    return Future.wait([
      getProduct(),
      getCategories(),
    ]);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: initScreen(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            if (snapshot.hasData) {
              final product = snapshot.data?[0] as ProductModel;
              final categories = snapshot.data?[1];
              return CustomScrollView(
                slivers: <Widget>[
                  CustomHeader(categories: categories),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        SizedBox(height: 45),
                        Center(
                          child: Container(
                            color: const Color.fromARGB(255, 255, 246, 244),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: 1250,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        width: 500,
                                        height: 500,
                                        child: Image.network(
                                          product.image.toString(),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(width: 50),
                                      Container(
                                        width: 600,
                                        height: 600,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  product.title.toString(),
                                                  style: TextStyle(
                                                      fontSize: 32,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(height: 20),
                                                Text(
                                                  product.description
                                                      .toString(),
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  product.price.toString() +
                                                      ' TMT',
                                                  style: TextStyle(
                                                      fontSize: 32,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.green),
                                                ),
                                                Spacer(),
                                                NumberRow()
                                              ],
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                double price = product.price!;
                                                showConfirmationDialog(
                                                    context, price * count, count.toString());
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(
                                                  const Color.fromARGB(
                                                      255, 20, 146, 83),
                                                ),
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.zero,
                                                  ),
                                                ),
                                              ),
                                              child: SizedBox(
                                                height: 45,
                                                child: Center(
                                                  child: Text(
                                                    'Zakaz Etmek',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 100),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: ReklamaBottomWidget(),
                  )
                ],
              );
            }

            return const SizedBox();
          }),
    );
  }
}

void showConfirmationDialog(BuildContext context, double price, String count) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        title: Text(
          'Jemi Bahasy: ${price} TMT',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          '''Harydyň sany: ${count}
Siz Hakykatdanam Zakaz Etmek Isleýäňizmi?''',
          style: TextStyle(fontSize: 20),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // No button pressed
            },
            child: Text(
              'Ýok',
              style: TextStyle(
                fontSize: 18,
                color: Colors.red,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Yes button pressed
            },
            child: Text(
              'Hawa',
              style: TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 20, 146, 83),
              ),
            ),
          ),
        ],
      );
    },
  );
}

class NumberRow extends StatefulWidget {
  @override
  _NumberRowState createState() => _NumberRowState();
}

class _NumberRowState extends State<NumberRow> {
  int number = 1; // Initial number
  

  void decreaseNumber() {
    if (number > 1) {
      setState(() {
        number--;
      });
    }
  }

  void increaseNumber() {
    setState(() {
      number++;
    });
  }

  @override
  Widget build(BuildContext context) {
    count = number;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: decreaseNumber,
          color: const Color.fromARGB(255, 20, 146, 83),
        ),
        SizedBox(width: 16.0),
        Text(
          count.toString(),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 16.0),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            increaseNumber();
          },
          color: const Color.fromARGB(255, 20, 146, 83),
        ),
      ],
    );
  }
}

class ReklamaBottomWidget extends StatelessWidget {
  const ReklamaBottomWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 270,
      color: const Color.fromARGB(255, 239, 248, 242),
      child: const Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Text(
              'Biziň Bakjamyz',
              style: TextStyle(
                fontSize: 42,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconCommentWidget(
                icon: Icons.autorenew_outlined,
                text: 'Ygtybarly we Gaýtadan Ulanylýan',
              ),
              IconCommentWidget(
                icon: Icons.assignment_outlined,
                text: 'Amatly Bahadan',
              ),
              IconCommentWidget(
                icon: Icons.yard_outlined,
                text: 'Owadan Görnüşli',
              )
            ],
          ),
        ],
      ),
    );
  }
}

class IconCommentWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  const IconCommentWidget({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 50.0,
        ),
        Container(
          width: 300,
          child: Text(
            textAlign: TextAlign.center,
            maxLines: 2,
            text,
            style: const TextStyle(
              fontSize: 30,
            ),
          ),
        ),
      ],
    );
  }
}
