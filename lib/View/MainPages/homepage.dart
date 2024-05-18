import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:new_ecommerce/View/MainPages/ProfileUtils/DetailPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<List<dynamic>> fetchData() async {
    final response =
        await http.get(Uri.parse("https://fakestoreapi.com/products"));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("failed to Load Data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'HomePage',
          style: GoogleFonts.aBeeZee(),
        ),
        actions: const [
          Icon(
            Icons.search,
            color: Colors.black,
          ),
          SizedBox(
            width: 15,
          ),
        ],
      ),
      body: FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<dynamic> data = snapshot.data as List<dynamic>;
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  var Product = data[index];
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: GestureDetector(
                      onTap: () => Get.to(
                        DetailPage(
                          product: Product,
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Column(children: [
                          Row(
                            children: [
                              SizedBox(
                                height: 120,
                                width: 120,
                                child: Image.network(Product['image']),
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    width: 160,
                                    child: Text(
                                      Product['title'],
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.aBeeZee(),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: 160,
                                    child: Text(
                                      Product['category'],
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.aBeeZee(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                      ),
                                      Text(
                                        'Rating: ${Product['rating']['rate']}',
                                        style: GoogleFonts.aBeeZee(),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          )
                        ]),
                      ),
                    ),
                  );
                });
          }
        },
      ),
    );
  }
}