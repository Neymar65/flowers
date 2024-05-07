import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Models/product_model.dart';
import 'package:flutter_application_1/screens/custom_header.dart';
import 'package:flutter_application_1/screens/product_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AllProductScreen extends StatefulWidget {
  const AllProductScreen({
    super.key,
  });

  @override
  State<AllProductScreen> createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen> {
  Future<List<ProductModel>> getProducts() async {
    final uri = Uri.parse('https://fakestoreapi.com/products');
    final list = <ProductModel>[];

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final rawList = responseBody as Iterable?; // [] | null
        for (var element in rawList ?? []) {
          final product = ProductModel.fromJson(element);
          list.add(product);
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
      getProducts(),
      getCategories(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: initScreen(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('error'),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final products = snapshot.data?[0] as List<ProductModel>;
            final categories = snapshot.data?[1];
            return CustomScrollView(
              slivers: <Widget>[
                CustomHeader(categories: categories),
                SliverToBoxAdapter(
                  child: Container(
                    width: double.infinity,
                    height: 600,
                    child: Image.asset(
                      '3.jpg',
                      fit: BoxFit.fill,
                      width: double.infinity,
                    ),
                  ),
                ),
                SliverLayoutBuilder(builder: (context, constraints) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: 1250.0,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'icon.png',
                                    height: 42,
                                    width: 42,
                                  ),
                                  const SizedBox(width: 20),
                                  Text(
                                    'Ähli Harytlar',
                                    style: TextStyle(
                                      fontSize: 42,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 25),
                              const Text(
                                'Plants make for the best house companions, suitable for all your moods and every aesthetic. Ugaoo brings you the widest variety of plants to choose from so you can buy plants online from the comfort of your home!',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 100.0),
                              GridView.builder(
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 300.0,
                                    mainAxisExtent: 400.0,
                                    mainAxisSpacing: 35.0,
                                    crossAxisSpacing: 25.0,
                                  ),
                                  itemBuilder: (context, index) {
                                    final product = products[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => ProductScreen(
                                              id: product.id,
                                            ),
                                          ),
                                        );
                                      },
                                      child: ProductWidget(
                                        ontap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => ProductScreen(
                                                id: product.id,
                                              ),
                                            ),
                                          );
                                        },
                                        title: product.title ?? '',
                                        image: product.image ?? '',
                                        price: product.price ?? 0.0,
                                      ),
                                    );
                                  },
                                  itemCount:
                                      // ((products.length) > 8) ? 8 : products.length,
                                      products.length),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                const SliverToBoxAdapter(
                  child: ReklamaVideoWidget(),
                )
              ],
            );
          }),
    );
  }
}

class ReklamaVideoWidget extends StatelessWidget {
  const ReklamaVideoWidget({
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

class ProductWidget extends StatefulWidget {
  final String title;
  final String image;
  final double price;
  final VoidCallback ontap;

  const ProductWidget({
    super.key,
    required this.title,
    required this.image,
    required this.price,
    required this.ontap,
  });

  @override
  _ProductWidgetState createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  bool isButtonHovered = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Image.network(
            widget.image,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 16.0),
        SizedBox(
          width: double.infinity,
          height: 85,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isButtonHovered)
                const Divider(
                  color: Colors.grey,
                  thickness: 1.0,
                ),
            ],
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          '${widget.price.toStringAsFixed(2)}  TMT',
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 15.0),
        MouseRegion(
          onEnter: (_) {
            setState(() {
              isButtonHovered = true;
            });
          },
          onExit: (_) {
            setState(() {
              isButtonHovered = false;
            });
          },
          child: TextButton(
            onPressed: widget.ontap,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                const Color.fromARGB(255, 20, 146, 83),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
            ),
            child: const SizedBox(
              height: 45,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  SizedBox(width: 12.0),
                  Text(
                    'Harydy Görmek',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
