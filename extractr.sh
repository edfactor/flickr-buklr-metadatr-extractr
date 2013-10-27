#!/bin/bash

# This script will create a .csv file out of a group
# of metadata files for Flickr photos as downloaded
# by the Bulkr Flickr utility, which manages and 
# downloads photo collections. It also allows you
# to download separate metadata files for each photo.
# 
# This script reads all of the metadata files - which
# end in *.txt in a directory and creates a .csv file
# for all of the photos, allowing you to import that
# data into another application, such as a CartoDB
# map.
# 
# It will create a first line in the csv for the 
# fields that are being used, for example:
#
# photographer,url,license,taken,uploaded,lat,long,title,desc,tags
#
# Which fields you use will be chosen based on the variables at
# the top of this file
#
# 
# There are three parameters in this script:
# 
# 1. directory of metadata files (mandatory)
# 2. output file name (mandatory)
# 3. name of collection (optional)
#
# Note: this script was written to work on Mac OS X
# Mavericks and you may have to adjust the regex in 
# the sed lines for your system.

# Check arguments

# We have to have at least two
if [[ "$#" -lt 2 ]]
then
  echo "Usage: You need to have two parameters at least: directory and output file"
  exit 1
fi

# We cannot have more than 3
if [[ "$#" -gt 3 ]]
then
  echo "Usage: Only three parameters allowed: directory, output file, and collection name"
  exit 1
fi

directory=$1
outputfile=$2
collection=$3

echo "Directory is $directory"
echo "Output File is $outputfile"


directorystring="$directory/*.txt"

# Settings for each metadata field
use_photographer=false
use_url=true
use_license=false
use_taken=true
use_uploaded=false
use_lat=true
use_long=true
use_title=false
use_desc=false
use_tags=false

# Create top line of csv

buildstring=""
first_there=false

# first check set

if [ "$collection" ]; then
	buildstring="collection"
	first_there=true 
fi

if [ $use_photographer == true ]; then
	if [ $first_there == true  ]; then
	   buildstring="$buildstring,photographer"	
    else
	   buildstring="photographer"
	   first_there=true
    fi  
fi

if [ $use_url == true ]; then
	if [ $first_there == true  ]; then
	   buildstring="$buildstring,url"	
    else
	   buildstring="url"
	   first_there=true
    fi  
fi

if [ $use_license == true  ]; then
	if [ $first_there == true  ]; then
	   buildstring="$buildstring,license"	
    else
	   buildstring="license"
	   first_there=true
    fi  
fi

if [ $use_taken == true  ]; then
	if [ $first_there == true  ]; then
	   buildstring="$buildstring,taken"	
    else
	   buildstring="taken"
	   first_there=true
    fi  
fi

if [ $use_uploaded == true  ]; then
	if [ $first_there == true  ]; then
	   buildstring="$buildstring,uploaded"	
    else
	   buildstring="uploaded"
	   first_there=true
    fi  
fi

if [ $use_lat == true  ]; then
	if [ $first_there == true  ]; then
	   buildstring="$buildstring,lat"	
    else
	   buildstring="lat"
	   first_there=true
    fi  
fi

if [ $use_long == true  ]; then
	if [ $first_there  == true ]; then
	   buildstring="$buildstring,long"	
    else
	   buildstring="long"
	   first_there=true
    fi  
fi

if [ $use_title == true  ]; then
	if [ $first_there == true ]; then
	   buildstring="$buildstring,title"	
    else
	   buildstring="title"
	   first_there=true
    fi  
fi

if [ $use_desc == true  ]; then
	if [ $first_there == true  ]; then
	   buildstring="$buildstring,desc"	
    else
	   buildstring="desc"
	   first_there=true
    fi  
fi

if [ $use_tags == true  ]; then
	if [ $first_there == true  ]; then
	   buildstring="$buildstring,tags"	
    else
	   buildstring="tags"
	   first_there=true
    fi  
fi

echo $buildstring > $outputfile

for file in $directorystring 
do

 # Photographer
 if [ $use_photographer == true ];
 then
   photographer=$(cat "$file" | sed -n 's/.*Photographer[[:space:]]*:[^A-Z]\(.*\)/\1/p') 
 fi 

 # URL
 if [ $use_url == true  ];
 then
   url=$(cat "$file" | sed -n 's/.*Photo URL.*\(http.*\).*/\1/p')
 fi 

 # License
 if [ $use_license == true  ];
 then
   license=$(cat "$file" | sed -n 's/.*License[[:space:]]*:[^A-Z]\(.*\)/\1/p') 
 fi 

 # Taken
 if [ $use_taken == true  ];
 then
   taken=$(cat "$file" | sed -n 's/Taken Date[[:space:]]*:[^A-Z]\(.*\)/\1/p') 
 fi 


 # Uploaded
 if [ $use_uploaded == true  ];
 then
   uploaded=$(cat "$file" | sed -n 's/.*Upload Date[[:space:]]*:[^A-Z]\(.*\)/\1/p') 
 fi 

 # Lat
 if [ $use_lat == true  ];
 then
   lat=$(cat "$file" | sed -n 's/.*Latitude:\(.*\),.*/\1/p')
 fi 

 # Long
 if [ $use_long == true  ]; 
 then
   long=$(cat "$file" | sed -n 's/.*Longitude:\(.*\).*/\1/p')
 fi 

 # Title
 if [ $use_title == true  ];
 then
 # Note, title is always 13th line from end
   title=$(cat "$file" | sed -n '17p')
 fi 

 # Desc
 if [ $use_desc == true  ]; 
 then
 # Note, description is always 7th line from end
   desc=$(cat "$file" | sed -n '23p')
 fi 

 # Tags
 if [ $use_tags == true ]; 
 then
   # Note that tags are always the last line of the file
   tags=$(cat "$file" | tail -n 1) 
 fi 
 
 #
 #OK, let's try to echo them all
 # 
 
 outputstring=""
 first_there=false

 if [ "$collection" ]; then
 	outputstring="$collection"
 	first_there=true 
 fi

 if [ $use_photographer == true ]; then
 	if [ $first_there == true  ]; then
 	   outputstring="$outputstring,$photographer"	
     else
 	   outputstring="$photographer"
 	   first_there=true
     fi  
 fi
 
 if [ $use_license == true  ]; then
 	if [ $first_there == true  ]; then
 	   outputstring="$outputstring,$license"	
     else
 	   outputstring="$license"
 	   first_there=true
     fi  
 fi
 
 if [ $use_url == true  ]; then
 	if [ $first_there == true  ]; then
 	   outputstring="$outputstring,$url"	
     else
 	   outputstring="$url"
 	   first_there=true
     fi  
 fi

 if [ $use_taken == true  ]; then
 	if [ $first_there == true  ]; then
 	   outputstring="$outputstring,$taken"	
     else
 	   outputstring="$taken"
 	   first_there=true
     fi  
 fi

 if [ $use_uploaded == true  ]; then
 	if [ $first_there == true  ]; then
 	   outputstring="$outputstring,$uploaded"	
     else
 	   outputstring="$uploaded"
 	   first_there=true
     fi  
 fi

 if [ $use_lat == true  ]; then
 	if [ $first_there == true  ]; then
 	   outputstring="$outputstring,$lat"	
     else
 	   outputstring="$lat"
 	   first_there=true
     fi  
 fi

 if [ $use_long == true  ]; then
 	if [ $first_there  == true ]; then
 	   outputstring="$outputstring,$long"	
     else
 	   outputstring="$long"
 	   first_there=true
     fi  
 fi

 if [ $use_title == true  ]; then
 	if [ $first_there == true ]; then
 	   outputstring="$outputstring,$title"	
     else
 	   outputstring="$title"
 	   first_there=true
     fi  
 fi

 if [ $use_desc == true  ]; then
 	if [ $first_there == true  ]; then
 	   outputstring="$outputstring,$desc"	
     else
 	   outputstring="$desc"
 	   first_there=true
     fi  
 fi

 if [ $use_tags == true  ]; then
 	if [ $first_there == true  ]; then
 	   outputstring="$outputstring,$tags"	
     else
 	   outputstring="$tags"
 	   first_there=true
     fi  
 fi

 echo $outputstring >> $outputfile
 
done 
