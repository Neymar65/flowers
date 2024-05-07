import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Models/product_model.dart';
import 'package:flutter_application_1/screens/custom_header.dart';

import 'package:http/http.dart' as http;

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
                                            Text(
                                                product.price.toString() +
                                                    ' TMT',
                                                style: TextStyle(
                                                    fontSize: 32,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green)),
                                            TextButton(
                                              onPressed: () {},
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
                      ],
                    ),
                  )
                ],
              );
            }

            return const SizedBox();
          }),
    );
  }
}
