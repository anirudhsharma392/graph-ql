import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ValueNotifier<Client> client = ValueNotifier(
      Client(
        endPoint: 'http://staginggraphql-348048981.us-east-1.elb.amazonaws.com/graphql',
        cache: InMemoryCache(),
        apiToken: '7766e718aea144866a27b604edf2f8b3759af12e',
      ),
    );

    return GraphqlProvider(
      client: client,
      child: CacheProvider(
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: MyHomePage(title: 'Flutter Demo Home Page'),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key key,
    this.title,
  }) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Query(
            "{" +
            "seasons{" +
            "year"+
            "    }" +
            "  }",
        builder: ({
          bool loading,
          Map data,
          Exception error,
        }) {
          if (error != null) {
            return Text(error.toString());
          }

          if (loading) {
            return Text('Loading');
          }


          // it can be either Map or List
          List feedList = data['seasons'];

          return ListView.builder(
            itemCount: feedList.length,
            itemBuilder: (context, index) {
              final feedListItems = feedList[index];
              // List tagList = feedListItems['name'];
              return new Card(
                margin: const EdgeInsets.all(10.0),
                child: ListTile(
                  title: new Text(feedListItems['year']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}