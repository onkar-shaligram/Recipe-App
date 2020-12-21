import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/secrets.dart';
import 'package:recipe_app/views/recipe_view.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  List<Recipe> recipes = List<Recipe>();

  getRecipes() async {

    

    var recipeData = await http.get("https://api.edamam.com/search?q=apple&app_id=$apiId&app_key=$apiKey");

    Map<String,dynamic> jsonData = jsonDecode(recipeData.body);
    print(jsonData);

    jsonData["hits"].forEach((recipeInfo) {
      Recipe recipe = Recipe();
      recipe = Recipe.fromMap(recipeInfo["recipe"]);

      recipes.add(recipe);
     });

     setState(() {
       
     });

  }

  @override
  void initState() {
    getRecipes();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe App'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('What would you like to cook?', style: TextStyle(fontSize: 18,),),
            SizedBox(height: 10,),
            Text("Enter Ingredients you have 😁", style: TextStyle(fontSize: 18),),
          ],
        ),
      ),
    );
  }
}