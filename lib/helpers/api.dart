import 'package:http/http.dart' as http;
import 'package:html/dom.dart' show Document, Element, Node;
// import 'package:html/dom_parsing.dart';
import 'package:html/parser.dart' show parse;
import 'package:radio_mesias/pages/home.dart';

class Api {
  static Future<List<RecientementeContainer>> getRecientes() async {
    http.Response res = await http.get('https://www.radiomesias.cl/');
    Document html = parse(res.body);
    List<RecientementeContainer> result = [];

    for (int i = 0; i <= 4; ++i) {
      Element news = html
          .getElementsByClassName("td-big-grid-flex-post-$i")[0]
          .children[0];

      result.add(
        RecientementeContainer(
          image: news.children[0].children[0].children[0].children[0]
              .attributes['data-img-url'],
          category: news.children[1].children[0].firstChild.text,
          title: news
              .children[1].children[1].children[0].children[0].firstChild.text,
        ),
      );
    }

    return result;
  }

  static Future<List<ArticleTile>> getNoticias() async {
    http.Response res = await http.get('https://www.radiomesias.cl/');
    Document html = parse(res.body);
    Element leftColumn =
        html.getElementsByClassName("td-pb-span8")[0].children[1].children[0];

    Element block = leftColumn.children[0].children[2].children[0];

    List<ArticleTile> result = [];

    result.add(
      ArticleTile(
        image: block.children[0].children[0].children[0].children[0].children[0]
            .children[0].attributes['data-img-url'],
        title: block.children[0].children[0].children[0].children[0].children[0]
            .attributes['title'],
        date: block.children[0].children[0].children[2].children[1].children[0]
            .firstChild.text,
      ),
    );
    result.add(
      ArticleTile(
        image: block.children[0].children[0].children[0].children[0].children[0]
            .children[0].attributes['data-img-url'],
        title: block.children[0].children[0].children[0].children[0].children[0]
            .attributes['title'],
        date: block.children[0].children[0].children[2].children[1].children[0]
            .firstChild.text,
      ),
    );
    result.add(
      ArticleTile(
        image: block.children[0].children[0].children[0].children[0].children[0]
            .children[0].attributes['data-img-url'],
        title: block.children[0].children[0].children[0].children[0].children[0]
            .attributes['title'],
        date: block.children[0].children[0].children[2].children[1].children[0]
            .firstChild.text,
      ),
    );

    // for (int i = 0; i <= 4; ++i) {
    //   Element news = html
    //       .getElementsByClassName("td-big-grid-flex-post-$i")[0]
    //       .children[0];

    //   result.add(
    //     RecientementeContainer(
    //       image: news.children[0].children[0].children[0].children[0]
    //           .attributes['data-img-url'],
    //       icon: news.children[1].children[0].firstChild.text,
    //       title: news
    //           .children[1].children[1].children[0].children[0].firstChild.text,
    //     ),
    //   );
    // }

    return result;
  }
}
