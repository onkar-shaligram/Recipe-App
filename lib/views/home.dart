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

  String ingredient;

  bool loading = false;

  getRecipes() async {

    setState(() {
      loading = true;
    });

    var recipeData = await http.get("https://api.edamam.com/search?q=$ingredient&app_id=$apiId&app_key=$apiKey");

    Map<String,dynamic> jsonData = jsonDecode(recipeData.body);
    print(jsonData);

    jsonData["hits"].forEach((recipeInfo) {
      Recipe recipe = Recipe();

      Map<String, dynamic> recipeInfo2 = recipeInfo["recipe"];
      recipe = Recipe(
        imgUrl: recipeInfo2["image"],
        label: recipeInfo2["label"],
        source: recipeInfo2["source"],
        url: recipeInfo2["url"],
      );
      //recipe = Recipe.fromMap(recipeInfo["recipe"]);
      recipes.add(recipe);
    });

    setState(() {
      loading = false;
    });
    
  }

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe App'),
      ),
      body: SingleChildScrollView(
              child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('What would you like to cook?', style: TextStyle(fontSize: 18,),),
              SizedBox(height: 10,),
              Text("Enter Ingredients you have 😁", style: TextStyle(fontSize: 18),),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        ingredient = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter ingredient',
                        labelText: 'Search'
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      if(ingredient != "") {
                        recipes = [];
                        getRecipes();
                        setState(() {
                          
                        });
                      }
                    },
                    child: Icon(Icons.search)
                    ),
                ],
              ),

              loading ? Container(
                height: MediaQuery.of(context).size.height - 200,
                child: Center(child: CircularProgressIndicator()),
              ) : 
              GridView(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0
                ),
                children: List.generate(recipes.length, (index) {
                        return RecipeTile(
                          imgUrl: recipes[index].imgUrl,
                          label: recipes[index].label,
                          source: recipes[index].source,
                          url: recipes[index].url,
                        );
                      }),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecipeTile extends StatelessWidget {
  final String label, source, imgUrl, url;
  RecipeTile({this.url, this.imgUrl, this.label, this.source});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RecipeView(url)));
      },
      child: Container(
        child: Stack(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(imgUrl)),
            Container(
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8),
                  Text(
                    source,
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}