#!/bin/bash

mkdocs build --clean
# some theme use link css in HTML head
grep -lr "href='https://fonts.googleapis.com/css" ./site/ && (grep -lr "href='https://fonts.googleapis.com/css" ./site/ | xargs sed -i "s/href='https:\/\/fonts\.googleapis\.com\/css/href='https:\/\/fonts\.gmirror\.org\/css/g") || echo 'replace nothing'
# some theme use import in css file
grep -lr "//fonts.googleapis.com/css" ./site/css/ && (grep -lr "//fonts.googleapis.com/css" ./site/css/ | xargs sed -i "s/\/\/fonts\.googleapis\.com\/css/\/\/fonts\.gmirror\.org\/css/g") || echo 'replace nothing'

# change css file uri, else it will cached by browser
for file in `find ./site/css/ -name '*.css'`; do
    md5=`md5sum $file | awk '{print $1}'`
    filename=`basename $file`
    grep -lr "css/$filename\"" ./site/ && (grep -lr "css/$filename\"" ./site/ | xargs sed -i "s/css\/$filename\"/css\/$filename?md5=$md5\"/g") || echo 'replace nothing'
done
