List<dynamic> filterBySearch(String letter, List<dynamic> todoList) {
  if (letter.isEmpty) {
    // If the search query is empty, return the original todoList
    return todoList;
  } else {
    // Convert the search query to lowercase for case-insensitive search
    final lowerCaseLetter = letter.toLowerCase();

    // Filter the todoList based on whether the title contains the provided letter
    final filteredList = todoList
        .where((element) =>
            element['title'].toLowerCase().contains(lowerCaseLetter))
        .toList();

    return filteredList;
  }
}
