# gtest2html
Convert googletest xml output to html

Use with any xslt processor e.g.
```bash
$ xsltproc gtest2html.xslt test_detail.xml > test_detail.html
```

The css stylesheet was borrowed from here: 
http://red-team-design.com/practical-css3-tables-with-rounded-corners

You can use xslt script with Jenkins variables e.g.
```bash
$ xsltproc gtest2html.xslt test_detail.xml --stringparam 'JOB_NAME' "$JOB_NAME" --stringparam 'BUILD_NUMBER' "$BUILD_NUMBER" > test_detail.html
```

where **$JOB_NAME** and **$BUILD_NUMBER** - standard Jenkins variables
