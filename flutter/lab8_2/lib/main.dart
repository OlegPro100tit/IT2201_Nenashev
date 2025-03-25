import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

void main() {
  HttpOverrides.global = MyHttpOverrides(); // Установка глобального обработчика для игнорирования ошибок сертификата
  runApp(MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Лента новостей',
      theme: ThemeData(primarySwatch: Colors.green),
      home: NewsScreen(),
    );
  }
}

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late Future<List<News>> futureNews;
  final http.Client client = http.Client();

  @override
  void initState() {
    super.initState();
    futureNews = fetchNews(client);
  }

  @override
  void dispose() {
    client.close();
    super.dispose();
  }

  Future<List<News>> fetchNews(http.Client client) async {
    try {
      final response = await client.get(
        Uri.parse(
          'https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=dada1848422e4126971518dfaaff6ab8',
        ),
      );

      if (response.statusCode == 200) {
        // Логируем JSON-ответ для отладки
        print('Ответ сервера: ${response.body}');

        // Декодируем JSON как список
        final Map<String, dynamic> body = jsonDecode(response.body);

        // Преобразуем список в List<News>
        List<News> news = (body['articles'] as List)
            .map((dynamic item) => News.fromJson(item))
            .toList();
        return news;
      } else {
        throw Exception('Ошибка загрузки: ${response.statusCode}');
      }
    } catch (e) {
      print('Ошибка: $e');
      throw Exception('Не удалось загрузить новости: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: Text(
          'Лента новостей',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<News>>(
        future: futureNews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Новости не найдены'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                News news = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Отображаем изображение, если URL есть
                      if (news.previewPictureSrc.isNotEmpty)
                        CachedNetworkImage(
                          imageUrl: news.previewPictureSrc,
                          placeholder:
                              (context, url) => CircularProgressIndicator(),
                          errorWidget:
                              (context, url, error) => Icon(Icons.error),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                        ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Bidi.stripHtmlIfNeeded(news.title),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '${news.date}\n${Bidi.stripHtmlIfNeeded(news.previewText)}',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class News {
  final String id;
  final String date;
  final String title;
  final String previewText;
  final String previewPictureSrc;
  final String detailPageUrl;
  final String detailText;

  News({
    required this.id,
    required this.date,
    required this.title,
    required this.previewText,
    required this.previewPictureSrc,
    required this.detailPageUrl,
    required this.detailText,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['source']['id'] ?? 'Нет ID',
      date: json['publishedAt'] ?? 'Нет даты',
      title: json['title'] ?? 'Нет заголовка',
      previewText: json['description'] ?? 'Нет содержимого',
      previewPictureSrc: json['urlToImage'] ?? '',
      detailPageUrl: json['url'] ?? '',
      detailText: json['content'] ?? '',
    );
  }
}
