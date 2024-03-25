class ColumnModel {
  String name;
  String dataType;
  String option;

  ColumnModel(this.name, this.dataType, this.option);
}

List<String> returnTableName2(String input) {
  List<String> tableStatements = [];

  List<String> statements = input.split(';');

  for (String statement in statements) {
    int startIndex = statement.toLowerCase().indexOf('create table');
    if (startIndex != -1) {
      int endIndex = statement.indexOf('(');
      if (endIndex != -1) {
        String tableName = statement.substring(startIndex, endIndex).trim();

        tableName = capitalizeFirstTwoWords(tableName);
        tableStatements.add(tableName);
      }
    }
  }

  return tableStatements;
}

String capitalizeFirstTwoWords(String text) {
  List<String> words = text.split(' ');
  for (int i = 0; i < words.length; i++) {
    words[i] = words[i].toUpperCase();
    if (i == 1) break;
  }
  return words.join(' ');
}

List<ColumnModel> wordModelling(String input) {
  List<ColumnModel> columns = [];

  List<String> statements = input.trim().split(';');

  for (String statement in statements) {
    if (statement.isNotEmpty) {
      int startIndex = statement.indexOf('(');

      int endIndex = statement.lastIndexOf(')');

      String columnDefinitions = statement.substring(startIndex + 1, endIndex);

      List<String> parts = columnDefinitions.split(',');

      for (String part in parts) {
        String name = '';
        String dataType = '';
        String option = '';

        List<String> tokens = part.trim().split(RegExp(r'\s+(?![^(]*\))'));

        if (tokens.isNotEmpty) {
          name = tokens[0];
          if (tokens.length > 1) {
            dataType = tokens[1];
            if (tokens.length > 2) {
              option = tokens.sublist(2).join(' ');
            }
          }
        }

        columns.add(ColumnModel(name, dataType, option.trim()));
      }
    }
  }

  return columns;
}
