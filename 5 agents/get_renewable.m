function ren = get_renewable(index,input)


global solar_mean;
global solar2_mean;
global wind_mean;
global wind2_mean;


if index == 5
    ren = 0;

else

if index == 1
if input == 1  
    lambda = solar_mean(1);
end
 if input ==2 
    lambda = solar_mean(2);
 end
 
 if input == 3
     lambda = solar_mean(3);
 end
 
 if input == 4
     lambda = solar_mean(4);
 end
 
 
elseif index == 2
    if input == 1  
     lambda = wind_mean(1);
    end
 if input ==2 
    lambda = wind_mean(2);
 end
 
 if input == 3
     lambda = wind_mean(3);
 end
 
 if input == 4
     lambda = wind_mean(4);
 end
 
elseif index == 3 
    
    if input == 1  
    lambda = solar2_mean(1);
    end
 if input ==2 
    lambda = solar2_mean(2);
 end
 
 if input == 3
     lambda = solar2_mean(3);
 end
 
 if input == 4
     lambda = solar2_mean(4);
 end
    
 
else
    
    if input == 1  
    lambda = wind2_mean(1);
    end
 if input ==2 
    lambda = wind2_mean(2);
 end
 
 if input == 3
     lambda = wind2_mean(3);
 end
 
 if input == 4
     lambda = wind2_mean(4);
 end
    
    
 
 
end

  %  ren = 0;
%while(ren == 0)    
ren = poissrnd(lambda) ;
%end
if ren > 8
    ren =8;
end


end
end