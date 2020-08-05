#This is about solving the zero_problem equation by dichotomy method
#Because it uses the dichotomy method, so the equation must be monotonous
#It needs put the result into one file
#!/bin/bash
declare -i i=0
     echo "please input the initial wavelength(at least to one decimal point):"  #this is an interation
     read n                                                                      #it is useless,it will output the same value
     echo "please input the parameter a:"                                        #here it includes four parameter
     read a                                                                      #relevent parameter,but also won't affected this shell
     echo "please input the range of parameter Z(two number with the blank space:"  
     read z1 z2                                                                  #z1 and z2 are adjusted
     ./value $n $a $z1                                                           #value is the using execution program
     while read wavelength a0 za ya                                              #the rest of script are dichotomy method
     do
           echo "the start point  is $za corresponding to $ya" 
           z1=$za 
           length=${#ya}                                                         #it will get the length of this character value
           site=$(echo `expr index "$ya" E`)
           if(( $site )); then
                y1=$(echo "scale=10;${ya:0:(($site-1))}*10^${ya:${site}:${length}}"|bc)   #Because my code will output like 1.2*E-002
                                                                                          #and shell doesn't support this output,it will recognize wrong results				
                echo $y1
           else
                y1=$ya
           fi
      done < Z_a.dat                                                              #this is the execution program outfile,it require output by oder
	                                                                              #like "while read",and only one line 
     ./value $n $a $z2
     while read wavelength a0 zb yb 
     do
           echo "the end point  is $zb corresponding to $yb" 
           z2=$zb 
           length=${#yb}
           site=$(echo `expr index "$yb" E`)
           if(( $site )); then
                y2=$(echo "scale=10;${yb:0:(($site-1))}*10^${yb:$site:$length}"|bc)
                echo $y2
            else
                 y2=$yb
            fi
      done < Z_a.dat
     d=$(echo "$z1-($z2)"|bc)
     while(( $(echo "scale=10;$d<-0.001"|bc) ))                                    #this is using to control the accuracy,scale is about decimal point
     do                                                                            #d is the accuracy of the result 
           c=$(echo "scale=10;($z1+$z2)*0.5"|bc)
           echo "the middle point is $c"
           ./value $n $a $c
           while read wavelength a0 zc yc
           do
              length=${#yc}
              site=$(echo `expr index "$yc" E`)
              if(( $site )); then
                   fc=$(echo "scale=10;${yc:0:((site-1))}*10^${yc:$site:$length}"|bc)
                    echo $fc
              else
                    fc=$yc
               fi
           done < Z_a.dat
           if (( $(echo "scale=10;($y1+0.1)*($fc+0.1)<0"|bc) )); then
               z2=$c
           elif (( $(echo "scale=10;($y1+0.1)*($fc+0.1)>0"|bc) )); then
               z1=$c
               ./value $n $a $z1 
               while read wavelength a0 za ya 
               do
                     echo "the wavelengrh is  $wavelength,and now the parameter is $za corresponding to $ya"  
                     length=${#ya}
                     site=$(echo `expr index "$ya" E`)
                     if(( $site )); then
                          y1=$(echo "scale=10;${ya:0:((site-1))}*10^${ya:$site:$length}"|bc)
                          echo $y1
                      else
                           y1=$ya
                      fi
               done < Z_a.dat
          else
               echo now  $c
               exit
          fi
          d=$(echo "$z1-($z2)"|bc)
       done
