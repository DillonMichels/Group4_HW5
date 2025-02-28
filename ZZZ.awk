BEGIN {
    FS = "[ \t\n]+";    # Split fields on any whitespace.
    DEBUG = 0;          # Set to 1 for debug messages; set to 0 to disable.
}

BEGINFILE {
    if (FILENAME ~ /top\.txt/) {
        RS = "\n";    # For top.txt, each line is a record.
        if (DEBUG) print "DEBUG: Setting RS to newline for " FILENAME > "/dev/stderr";
    } else if (FILENAME ~ /cleaned\.txt/) {
        RS = "";      # For cleaned.txt, paragraphs (separated by blank lines) are records.
        if (DEBUG) print "DEBUG: Setting RS to blank for " FILENAME > "/dev/stderr";
    }
}

# PASS==1: Process top.txt (list of top words)
PASS == 1 {
    gsub(/\r/, "", $1);
    gsub(/^[ \t]+|[ \t]+$/, "", $1);
    if (DEBUG) {
        print "DEBUG: Read top word: [" $1 "]" > "/dev/stderr";
    }
    topCount++;
    order[topCount] = $1;
    top[$1] = 1;
    next;
}

# PASS==2: Process cleaned.txt (each record is a paragraph)
PASS == 2 {
    if (!headerPrinted) {
        header = "";
        for (i = 1; i <= topCount; i++) {
            header = header (i == 1 ? order[i] : "," order[i]);
        }
        print header;
        headerPrinted = 1;
        if (DEBUG) {
            print "DEBUG: Printed header: " header > "/dev/stderr";
        }
    }
    
    for (i = 1; i <= topCount; i++) {
        count[ order[i] ] = 0;
    }
    
    for (i = 1; i <= NF; i++) {
        word = $i;
        gsub(/\r/, "", word);
        gsub(/^[ \t]+|[ \t]+$/, "", word);
        if (DEBUG) {
            print "DEBUG: Processing word [" word "]" > "/dev/stderr";
        }
        if (word in top) {
            count[word]++;
            if (DEBUG) {
                print "DEBUG: Incremented count for [" word "]: " count[word] > "/dev/stderr";
            }
        }
    }
    
    output = "";
    for (i = 1; i <= topCount; i++) {
        output = output (i==1 ? count[order[i]] : "," count[order[i]]);
    }
    
    if (DEBUG) {
        print "DEBUG: Final CSV output: " output > "/dev/stderr";
    }
    print output;
}
