BEGIN {
  split("is the in but can a the is in of to a that it for on with as this was at by an be from or are", words)

  for (i in words) {
    stopwords[words[i]] = 1
  }

  outputFile = "stop.txt";
}

{
  line = "";
  for (i = 1; i <= NF; i++) {
    original = $i;
    clean = tolower($i);

    gsub(/^[^a-zA-Z0-9]+/, "", clean);
    gsub(/[^a-zA-Z0-9]+$/, "", clean);

    if (!(clean in stopwords)) {
      line = (line == "") ? original : line " " original;
    }
  }

  print line > outputFile;
}
