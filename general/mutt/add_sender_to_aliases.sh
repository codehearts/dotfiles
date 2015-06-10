#!/bin/sh
# Code taken from http://wcm1.web.rice.edu/mutt-tips.html

aliases=$HOME/.mutt/aliases
message=$(cat)

new_alias=$(echo "$message" | grep ^"From: " | sed s/[\,\"\']//g | awk '{$1=""; if (NF == 3) {print "alias" $0;} else if (NF == 2) {print "alias" $0 $0;} else if (NF > 3) {print "alias", tolower($(NF-1))"-"tolower($2) $0;}}')

if grep -Fxq "$new_alias" $aliases; then
    :
else
    echo "$new_alias" >> $aliases
fi

echo "$message"
