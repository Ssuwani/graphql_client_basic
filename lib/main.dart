import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  runApp(MaterialApp(
    title: "GQL APP",
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink =
        HttpLink(uri: 'http://countries.trevorblades.com/');
    final ValueNotifier<GraphQLClient> client = ValueNotifier(GraphQLClient(
      cache: InMemoryCache(),
      link: httpLink,
    ));
    return GraphQLProvider(
      child: HomePage(),
      client: client,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String readRepo = """
  query GetContinents{
    continents{
      name
    }  
  }
  """;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GraphQL Client"),
      ),
      body: Query(
        options: QueryOptions(documentNode: gql(readRepo)),
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          if (result.data == null) {
            return Text("No Data Fount");
          }
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                  title: Text(result.data['continents'][index]['name']));
            },
            itemCount: result.data['continents'].length,
          );
        },
      ),
    );
  }
}
