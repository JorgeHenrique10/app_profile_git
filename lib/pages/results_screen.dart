import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:app_git_profile/models/User.dart';

class ResultsScreen extends StatelessWidget {
  final String username;
  const ResultsScreen(this.username, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Resultados'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: FutureBuilder(
          future: _fetchUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final user = snapshot.data;

              return Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        user?.avatarUrl ?? '',
                        height: 200,
                      ),
                    ),
                    Container(height: 10),
                    Text(
                      "${user?.name}",
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Container(height: 10),
                    Text(
                      "(${user?.blog})",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Container(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            "Seguidores: ${user?.followers}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(width: 10),
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            "Repositorios: ${user?.publicRepos}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            } else {
              return Text("Error: ${snapshot.error}");
            }
            return CircularProgressIndicator(
              backgroundColor: Colors.black,
            );
          },
        ),
      ),
    );
  }

  Future<User> _fetchUser() async {
    Uri uri = Uri(
      scheme: 'https',
      host: 'api.github.com',
      path: "users/${username}",
    );
    // await http.get('https://api.github.com/users/carlosfgti');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final user = User.fromJson(json.decode(response.body));
      return user;
    } else {
      throw new Exception('Algo deu errado...');
    }
  }
}
