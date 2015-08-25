#!/bin/bash

# Find dupes in input file and write IDs into output files
# Expected input file fields:
# iId           = $1;
# sFname        = $2;
# sLname        = $3;
# sStreetAndNr  = $4;
# sZIP          = $5;
# sCity         = $6;
# sCountry      = $7; 
# sEmail        = $8;

# Start timer
T0=$(date +%s)
echo ""

###############################################################################
# Normalize
###############################################################################
echo 'Normalize input file ...'

# Replace mutated vovels
echo "  Replace mutated vovels"
sed 's/[Üü]/UE/g;s/[Öö]/OE/g;s/[Ää]/AE/g;' ./in/Customers.txt > ./app/trans/1_Customers_ReplacedMutatedVovels

# Convert to ASCII
echo "  Convert to ASCII"
iconv -c -f UTF-8 -t US-ASCII//TRANSLIT ./app/trans/1_Customers_ReplacedMutatedVovels > ./app/trans/2_Customers_ASCII

# Normalize
echo "  Normalize"
gawk -f ./app/bin/normalize.gawk ./app/trans/2_Customers_ASCII > ./app/trans/3_Customers_Normalized 

# Timer
T1=$(date +%s)
TD=$(($T1 - $T0))
echo "  > Done in $TD seconds"
echo ""

###############################################################################
# Add keys and sort files by key
###############################################################################
echo 'Add blocking keys, sorting ...'

# Add keys
echo "  Add blocking keys"
awk -f ./app/bin/addKeys.awk ./app/trans/3_Customers_Normalized > ./app/trans/4_Customers_Keys

# Sort by email key
echo "  Sort by email key"
sort -t$'\t' -k9 ./app/trans/4_Customers_Keys > ./app/trans/5a_Customers_SortedByKeyEmail

# Sort by name key
echo "  Sort by name key"
sort -t$'\t' -k10 ./app/trans/4_Customers_Keys > ./app/trans/5b_Customers_SortedByKeyName

# Timer
T2=$(date +%s)
TD=$(($T2 - $T1))
echo "  > Done in $TD seconds"
echo ""

###############################################################################
# Extract dupes 
###############################################################################
echo 'Extract dupes ...'

# Extract dupes by email key
echo "  Extract dupes by email key"
awk -f ./app/bin/extractDupes.awk -v FK=9 ./app/trans/5a_Customers_SortedByKeyEmail > ./out/DupesByEmail.txt

# Extract dupes by name key
echo "  Extract dupes by name key"
awk -f ./app/bin/extractDupes.awk -v FK=10 ./app/trans/5b_Customers_SortedByKeyName > ./out/DupesByName.txt

# Timer
T3=$(date +%s)
TD=$(($T3 - $T2))
echo "  > Done in $TD seconds"
echo ""

# End timer
TD=$(($T3 - $T0))
echo "-------------------------------------------------------------------------"
echo "Finished! Total runtime: $TD seconds"
echo "-------------------------------------------------------------------------"
