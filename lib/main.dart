import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

String yearRequest = """
query {
seasons {
  year
}
}
""";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink(
      uri: 'http://staginggraphql-*****.amazonaws.com/graphql',
      headers: <String, String>{
        'x-token': '*******',
      },
    );

    final Link link = httpLink;

    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(cache: InMemoryCache(), link: link),
    );

    return GraphQLProvider(
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Query(
          options: QueryOptions(
            document: yearRequest, // this is the query string you just created
            variables: {
              'nRepositories': 50,
            },
            pollInterval: 10,
          ),
          builder: (QueryResult result) {
            if (result.errors != null) {
              return Text(result.errors.toString());
            }

            if (result.loading) {
              return Text('Loading');
            }

            // it can be either Map or List
            print(result.data);

            return FloatingActionButton(
              onPressed: () => print("pressed"),
              tooltip: 'Star',
              child: Icon(Icons.star),
            );
          },
        ));
  }
}

// Mutation(
//   options: MutationOptions(
//     document: "", // add mutation query here babes
//   ),
//   builder: (
//     RunMutation runMutation,
//     QueryResult result,
//   ) {
//     return FloatingActionButton(
//       onPressed: () => runMutation({

//       }),
//       tooltip: 'Star',
//       child: Icon(Icons.star),
//     );
//   },
// );
