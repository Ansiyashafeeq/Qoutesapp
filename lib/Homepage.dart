import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qoutesapp_api/qoutespage.dart';
import 'package:qoutesapp_api/utils.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> Categories = ["love","inspirational","life","humor"];
  List quotes=[];
  List authors=[];
  bool isDataThere =false;
  void initState(){
    super.initState();
    setState(() {
      getQuotes();
    });
  }
  getQuotes() async {
    String Url ="https://quotes.toscrape.com/";
    Uri uri= Uri.parse(Url);
    http.Response response =await http.get(uri);

    dom.Document document = parser.parse(response.body);
    final quotesclass= document.getElementsByClassName("quote");

    quotes= quotesclass.map((element) => element.getElementsByClassName('text')[0].innerHtml).toList();
    authors= quotesclass.map((element) => element.getElementsByClassName('author')[0].innerHtml).toList();
    setState(() {
      isDataThere=true;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

          backgroundColor: Colors.pinkAccent,
          body: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 40),
                  child: Text('Qoutes app',style: retrostyl(25,Colors.black,FontWeight.bold ,),
                ),
                ),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: Categories.map((Category){
                    return InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Qpage(Category)));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                         color:Colors.white.withOpacity(0.5),borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(Category.toUpperCase(),style: retrostyl(20,Colors.black,FontWeight.bold),),
                        ),
                      ),
                    );
                  }).toList(),

                ),
                SizedBox(height: 40,),
                isDataThere ==false?Center(child: CircularProgressIndicator(),):
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount:quotes.length ,
                    itemBuilder: (context, index){
                      return Container(
                        padding: EdgeInsets.all(10),
                        child: Card(
                          color: Colors.white.withOpacity(0.8),
                          elevation: 10,

                          child: Column(
                            children: [
                              Padding(padding: EdgeInsets.only(top: 20,left: 20,bottom: 20),
                          child: Text(quotes[index],style: retrostyl(18,Colors.black,FontWeight.w700),)
                              ),
                              Padding(padding: EdgeInsets.only(bottom: 15),
                                child: Text(authors[index],style: retrostyl(15,Colors.black,FontWeight.w700),
                              ),),
                            ],
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
    );
  }
}
