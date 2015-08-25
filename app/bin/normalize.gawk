#!/bin/gawk -f

# Used for duplicate detection in address data
# Method: sorted neighborhood
# Normalizes address fields 
#
# Expected fields:
# iId           = $1;
# sFname        = $2;
# sLname        = $3;
# sStreetAndNr  = $4;
# sZIP          = $5;
# sCity         = $6;
# sCountry      = $7; 
# sEmail        = $8;

BEGIN { FS = "\t"; OFS = "\t" }

{

    # Walk through fields
    for(i = 1; i <= NF; i++) {

        # ToUpper
        $i = toupper($i);

        # Remove titles from names
        if(i == 2 || i == 3 ) {
            gsub(/PROF\.|DR\.|MAG\./, "", $i);
        }

        # Normalize street
        if(i == 4) {
            sub(/STRASSE/, "STR", $i);
        }

        # Remove chars from zipcodes
        # Chars in countries with alphanumeric zipcodes must be kept
        # http://de.wikipedia.org/wiki/Liste_der_Postleitsysteme
        if(i == 5) {
            if(!match($7, /AR|GB|NL|CA/)) {
                gsub(/[a-zA-Z]/, "", $i);
            }
        }

        # Remove special chars and blanks inside fields
        # Special chars in email must be kept
        if(i != 8) { 
            gsub(/[^a-zA-Z0-9]/, "", $i);
        } else {
            gsub(/[<> ]/, "", $i); # Remove brackets and blanks from email addresses
        }

    }
 
    print $0;

}
