#!/bin/awk -f

# Used for duplicate detection in address data
# Method: sorted neighborhood
# Adds blocking keys
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

    # Add blocking key - EmailFnam
    $9 = $8 substr($2,1,1);
    
    # Add blocking key - FnamLnamZIP
    $10 = substr($2,1,4) substr($3,1,4) $5;
 
    print $0;

}
