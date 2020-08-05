#This is add one function:it can sumbit more tasks by serveral times
# a single thread program to parallel running 
#It requires the code which supports passing the parameter when executing the program

#!/bin/bash
      declare -i wavelength
      declare -i number=12    #the number of tasks by once
      declare -i next=12      #always be the same as $number
      declare -i needs=48     #the number of tasks
      declare -i count_int    #the rest of them are used to decide whether it is the last part
      declare -i count_remainder
      declare -i count=1
      declare -i start
      declare -i flag=0

     echo   you use  $number threads
            count_int=needs/number
      count_remainder=needs%number
         #   echo $count_int $count_remainder
      if [ "$count_remainder" -gt 0 ]; then   #whether it is divided evenly
          flag=1                              #if it can't be divided evemly, it need one more time
      fi
      until (($count>($count_int+$flag)))
        do
            start=$next-$number+1
            if [ "$count" -gt "$count_int" ]; then #'<='
               next=$needs 
            fi
            for var in $(seq $start $next)
            do
             wavelength=2030+$var*20
             nohup ./test $wavelength > ${wavelength}.dat 2>&1 &
                 
                echo you will calculate  the wavelength as ${wavelength}nm           
            done

            wait
            next=$next+$number
            let count++
        done