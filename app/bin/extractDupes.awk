#!/bin/awk -f

# Extracts IDs of duplicate customers from file_in
# file_in must be sorted by blocking key
# Data sets with Identical blocking keys are considered duplicates
# Field containing the customer ID must be the first field in file_in
# Field containing the blocking key must be passed by parameter "FK"
#
# Usage examples:
# extractDupes.awk -v FK=12 Customers_SortedByKeyEmail > DupesByEmail
# extractDupes.awk -v FK=13 6ustomers_SortedByKeyName > DupesByName

BEGIN { FS = "\t"; }

{

    if(!FK) {
        exit "Please provide Field No. containing blocking key.";
    }

	sId  = $1;    # Customer ID
    sKey = $FK;   # Blocking key

    # Count occurs
	a[sKey]++;

    # Dupe found?
	if(a[sKey] > 1 && index(sKey, "NULL") == 0) { 

		if(!bDupeInPreviousLine) {
		
            # Start output line
			printf("%s\t", sKey);
		
		}
		
		printf("%s,", sPrevId);

		bDupeInPreviousLine = 1;

	} else {
	    
		if(bDupeInPreviousLine) {
		
            # Finish output line
			printf("%s\n", sPrevId);
		
		}
	
		bDupeInPreviousLine = 0;
		
	}
	
	sPrevId = sId; # Remember this line's Id for matching in next line

}
