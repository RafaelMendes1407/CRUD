import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Post.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _urlBase = "https://jsonplaceholder.typicode.com";

  Future<List<Post>> _recuperarPostagens() async {
    http.Response resp = await http.get("$_urlBase/posts");
    var dadosJson = json.decode(resp.body);
    List<Post> posts = List();
    for (var post in dadosJson) {
      Post p = Post(post["userId"], post["id"], post["title"], post["body"]);
      posts.add(p);
    }
    //print(posts.toString());
    return posts;
  }

  Post post = new Post(120, null, "Titulo", "Corpo da Mensagem");

  _post() async {
    var body = json.encode(post.toJson());

    http.Response resp = await http.post(
      "$_urlBase/posts",
      headers: {"Content-type": "application/json; charset=UTF-8"},
      body: body,
    );
    print("Resposta: ${resp.statusCode}");
    print("Resposta: ${resp.body}");
  }

  _put() async {
    var body = json.encode(
      {
        "userId": 120,
        "id": null,
        "title": "Titulo Alterado",
        "body": "Corpo da Postagem com alteração"
      },
    );

    http.Response resp = await http.put(
      "$_urlBase/posts/2",
      headers: {"Content-type": "application/json; charset=UTF-8"},
      body: body,
    );
    print("Resposta: ${resp.statusCode}");
    print("Resposta: ${resp.body}");
  }

  _patch() async {
    var body = json.encode(
      {"userId": 120, "body": "Corpo da Postagem com alteração"},
    );

    http.Response resp = await http.patch(
      "$_urlBase/posts/2",
      headers: {"Content-type": "application/json; charset=UTF-8"},
      body: body,
    );
    print("Resposta: ${resp.statusCode}");
    print("Resposta: ${resp.body}");
  }

  _delete() async {
    var item = 2;
    http.Response resp = await http.delete(
      "$_urlBase/posts/$item"
    );
    print("Resposta: ${resp.statusCode}");
    print("Resposta: ${resp.body}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consumo de Serviços Avançado"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                RaisedButton(
                  onPressed: _post,
                  child: Text("Salvar"),
                ),
                RaisedButton(
                  onPressed: _put, //pode tambem ser usado o metodo _patch
                  child: Text("Atualizar"),
                ),
                RaisedButton(
                  onPressed: _delete,
                  child: Text("Remover"),
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder<List<Post>>(
                future: _recuperarPostagens(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                      break;
                    case ConnectionState.active:
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        print("Lista Erro ao Carregar");
                      } else {
                        print("Carregada com Sucesso.");
                        return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              List<Post> lista = snapshot.data;
                              Post post = lista[index];

                              return ListTile(
                                title: Text(post.title),
                                subtitle: Text(post.id.toString()),
                              );
                            });
                      }
                      break;
                  }
                  return Center();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
