import 'package:flutter/material.dart';
import 'package:qoutesapp_api/utils.dart';
import 'Homepage.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
class Qpage extends StatefulWidget {
  final String Categoryname;

  Qpage(this.Categoryname) ;

  @override
  State<Qpage> createState() => _QpageState();
}

class _QpageState extends State<Qpage> {
  List qoutes=[];
  List autors =[];
  bool isDataThere = false;
  @override
  void initState(){
    super.initState();
    setState(() {
      getQuotes();
    });
  }
  getQuotes() async {
    String Url ="https://quotes.toscrape.com/tag/${widget.Categoryname}";
    Uri uri= Uri.parse(Url);
    http.Response response =await http.get(uri);

    dom.Document document = parser.parse(response.body);
    final quotesclass= document.getElementsByClassName("quote");

    qoutes= quotesclass.map((element) => element.getElementsByClassName('text')[0].innerHtml).toList();
    autors= quotesclass.map((element) => element.getElementsByClassName('author')[0].innerHtml).toList();
    setState(() {
      isDataThere=true;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pinkAccent,
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column
          (
          children: [
            Container(

              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 60),
              child: Text('${widget.Categoryname}Quotes',style: retrostyl(30,Colors.black,FontWeight.w700 ,),),
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount:qoutes.length,
                itemBuilder: (context, index){
                  return Container(
                    padding: EdgeInsets.all(10),
                    child: Card(
                      color: Colors.white.withOpacity(0.8),
                      elevation: 10,

                      child: Column(
                        children: [
                          Padding(padding: EdgeInsets.only(top: 20,left: 20,bottom: 20),
                              child: Text(qoutes[index],style: retrostyl(18,Colors.black,FontWeight.w700),)
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 15),
                            child: Text(autors[index],style: retrostyl(15,Colors.black,FontWeight.w700),
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
