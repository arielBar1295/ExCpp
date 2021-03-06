#!/bin/bash
#save the folder name and path
FolderName=$1
exeName=$2
shift 2
arguments=$@ #if there are some arguments ,save them.
cd-
cd $FolderName #enter into the folder.
make >/dev/null 2>&1 #check if there is makefile.
successMake=$? #a variable for checking if make command worked.
if [ $successMake -eq 0 ]
 then successMake=0  
else
  echo "no makefike or compilation wrong"
     exit 7
fi
#check memory leak
valgrind --leak-check=full --error-exitcode=1 ./$exeName $arguments &>/dev/null
successVal=$? # a variable for checking if there is no memory leak.
if [ $successVal -eq 0 ]
then
    
  successVal=0
else
   successVal=1

fi
#check thread race.
valgrind --tool=helgrind --error-exitcode=1 ./$exeName $arguments &>/dev/null
successHal=$? # a variable for checking the threads.
if [ $successHal -eq 0 ]
then
  successHal=0
else
   successHal=1

fi
if [ $successMake -eq 0 ]
then 
      make=PASS
else
      make=FAIL
fi
if [ $successVal -eq 0 ]
then 
      val=PASS
else
      val=FAIL
fi
if [ $successHal -eq 0 ]
then 
      hal=PASS
else
      hal=FAIL
fi

#convert the result to binary and exit the final answer.
(( answer=(( $successMake*4))+(( $successVal*2))+(( $successHal*1)))) 
echo "compilation,"   "Memory leaks,"  "Thread race"
echo   "   "$make "           " $val"        "$hal
echo "final exit :"$answer
     exit $answer
