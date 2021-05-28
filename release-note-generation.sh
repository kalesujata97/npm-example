#!/bin/bash
previous_version=$1
previous_date=$2

#Preparing New Verion
#-------------------------------------------------------------------------------
#version = Major.Minor.Patch
version_array=($(echo $previous_version | tr "." "\n"))   # Breaking major minor patch version and storing it in array

major=($(git log --pretty="%h - %s (@%an)" --after=$previous_date --until="today" --grep="major"))  #getting major changes in array
features=($(git log --pretty="%h - %s (@%an)" --after=$previous_date --until="today" --grep="feat")) #getting minor changes in array
patch=($(git log --pretty="%h - %s (@%an)" --after=$previous_date --until="today" --grep="patch")) #getting patch changes in array

if [ ${#major[@]} -gt 0 ]                                           #Checking whether major changes are done after last release
then 
   echo "Breaking changes are done after last release.....updating major version"
   previous_major_version=${version_array[0]}
   new_major_version="$(($previous_major_version + 1))"
   new_version="$new_major_version.0.0"
   echo "Current updated version is ${new_version}"
elif [ ${#features[@]} -gt 0 ]                                      #Checking whether minor changes are done after last release
then
      echo "Feature related changes are there ......so updating minor version"
      previous_minor_version=${version_array[1]}
      new_minor_version="$(($previous_minor_version + 1))"
      new_version="${version_array[0]}.$new_minor_version.0"
      echo "Current updated version is ${new_version}" 
else 
   echo "Bug fixes are there ........ so changing only patch version"
   previous_patch_version=${version_array[2]}
   new_patch_version="$(($previous_patch_version + 1))"
   new_version="${version_array[0]}.${version_array[1]}.$new_patch_version"
   echo "Current updated version is ${new_version}"
fi


#Generating Release Note
#-----------------------------------------------------------------------------
today=`date '+%Y_%m_%d'`;
temp=($(echo $new_version | tr "." "_"))
temp2=($(echo $new_version | tr "." "\n"))
filename="$today.retail-platform-service.v$temp.doc"
dir="v${temp2[0]}"
mkdir $dir
filename="$dir/$filename"
touch $filename

todays_date=`date '+%Y-%m-%d'`;
echo "RELEASE NOTE - v$new_version" >> $filename
echo -e "\nv$new_version ($todays_date)" >> $filename
echo "==================================================================" >> $filename

echo -e "\nBREAKING CHANGES" >> $filename
echo "------------------------" >> $filename
git log --pretty="%h - %s (@%an)" --after=$previous_date --until="today" --grep="feat" >> $filename

echo -e "\nFEATURES" >> $filename
echo "------------------------" >> $filename
git log --pretty="%h - %s (@%an)" --after=$previous_date --until="today" --grep="feat" >> $filename

echo -e "\nBUG FIXES" >> $filename
echo "------------------------" >> $filename
git log --pretty="%h - %s (@%an)" --after=$previous_date --until="today" --grep="feat" >> $filename



#Update new version and date in release-version-date.txt
echo $new_version > release-version-date.txt
echo $todays_date >> release-version-date.txt
echo $filename >> release-version-date.txt
