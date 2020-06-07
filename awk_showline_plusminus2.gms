$ontext
Author: Uwe Schneider
last modified June 7th 2020

Description:
Awk script for GAMS to identify a pattern in a certain line and print to output
5 lines from the original file with the identified line in the middle
(Note at the beginning and end the number of lines printed is reduced.
 For example, if the identified pattern is in the second line,
 only four lines will be printed to the output.)

The illustrative program has four distinct parts:
1 the awk script is written to a file called script.awk
2 a sample input file is generated and namede inputdata.txt
3 the awk script is executed in GAMS via a $call command
4 the output file is shown in the log file using the 'more' command available in windows

To use the script for identifying other patterns, simply change the search string or
implement another option to flag a certain line. 
$offtext



$onecho >script.awk
BEGIN {searchstring = "jihye";
       printline1 = 0; printline2 = 0; printline3 = 0; printline4 = 0; printline5 = 0;
       line_minus_5=""; line_minus_4=""; line_minus_3=""; line_minus_2=""; line_minus_1="";
       line_current="";  }
{
 line_minus_5 = line_minus_4;
 line_minus_4 = line_minus_3;
 line_minus_3 = line_minus_2;
 line_minus_2 = line_minus_1;
 line_minus_1 = line_current;
 line_current = $0;

 printline5 = 0; if(printline4 > 0.5)  printline5 = 1;
 printline4 = 0; if(printline3 > 0.5)  printline4 = 1;
 printline3 = 0; if(printline2 > 0.5)  printline3 = 1;
 printline2 = 0; if(printline1 > 0.5)  printline2 = 1;
 printline1 = 0; if($0 ~ searchstring) printline1 = 1;

if(printline3 > 0.5) {
 print "**** problem in line " NR-2;
 if(NR-4 > 0.5) print "line " NR-4 " " line_minus_4;
 if(NR-3 > 0.5) print "line " NR-3 " " line_minus_3;
 if(NR-2 > 0.5) print "line " NR-2 " " line_minus_2;
 if(NR-1 > 0.5) print "line " NR-1 " " line_minus_1;
 if(NR   > 0.5) print "line " NR   " " line_current;
 print " "; }

}
END {
if(printline2 > 0.5) {
 print "**** problem in line " NR-1 " (second last line)";
 print "line " NR-3 " " line_minus_3;
 print "line " NR-2 " " line_minus_2;
 print "line " NR-1 " " line_minus_1;
 print "line " NR   " " line_current;
 print " "; }

if(printline1 > 0.5) {
 print "**** problem in line " NR " (last line)";
 print "line " NR-2 " " line_minus_2;
 print "line " NR-1 " " line_minus_1;
 print "line " NR   " " line_current;
 print " "; }
}
$offecho

$onecho >inputdata.txt
123
4
325
4136
1363  ji hye
1678
894065
21jihye374
05
272458
83650034
4752896
3334
22345
2232   jihye
$offecho

$call awk -f script.awk inputdata.txt  >output.txt
$call sleep 1
$call more output.txt
