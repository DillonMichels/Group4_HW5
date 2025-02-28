BEGIN {
  # Define the stopwords list
  stopwords["a"] = 1;
  stopwords["about"] = 1;
  stopwords["above"] = 1;
  stopwords["after"] = 1;
  stopwords["again"] = 1;
  stopwords["against"] = 1;
  # Add more stopwords as needed

  # Open the output file
  outputFile = "stop.txt";
  print "Processing stopwords removal...";
}

{
  # For each word in the input text, if it's not a stopword, print it to output
  for (i = 1; i <= NF; i++) {
    if (!(tolower($i) in stopwords)) {
      print $i;
    }
  }
}
