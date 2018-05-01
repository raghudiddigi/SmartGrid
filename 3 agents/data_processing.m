data = csvread('first_model.csv',1,1);

global solar_mean;
global solar2_mean;
global wind_mean;


wind = data(:,3);
solar = data(:,5);
solar2 = data(:,7);

no_of_days = size(data,1)/24;
no_of_decision_hours = 4;


solar_data = zeros(no_of_days,no_of_decision_hours);
wind_data = zeros(no_of_days,no_of_decision_hours);
solar2_data = zeros(no_of_days,no_of_decision_hours);


index1 = 1;

count_day = 0;
count_hour = 1;

for i = 1:size(solar,1)
    index2 = floor(count_hour/6) + 1;
    if rem(count_hour,6) == 0 
        index2 = index2-1;
    end

    solar_data(index1,index2) = solar_data(index1,index2) + solar(i);
    
    count_day = count_day+1;
    count_hour = count_hour +1;
    if rem(count_day,24) ==0
        index1 = index1 + 1;
        count_hour = 1;
    end
      
end

index1 = 1;

count_day = 0;
count_hour = 1;



for i = 1:size(solar2,1)
    index2 = floor(count_hour/6) + 1;
    if rem(count_hour,6) == 0 
        index2 = index2-1;
    end

    solar2_data(index1,index2) = solar2_data(index1,index2) + solar2(i);
    
    count_day = count_day+1;
    count_hour = count_hour +1;
    if rem(count_day,24) ==0
        index1 = index1 + 1;
        count_hour = 1;
    end
      
end




index1 = 1;

count_day = 0;
count_hour = 1;


for i = 1:size(wind,1)
    index2 = floor(count_hour/6) + 1;
    if rem(count_hour,6) == 0 
        index2 = index2-1;
    end

    wind_data(index1,index2) = wind_data(index1,index2) + wind(i);
    
    count_day = count_day+1;
    count_hour = count_hour +1;
    if rem(count_day,24) ==0
        index1 = index1 + 1;
        count_hour = 1;
    end
      
end

solar_mean = poissfit(solar_data)/100;
wind_mean = poissfit(wind_data)/100;
solar2_mean = poissfit(solar2_data)/100;








