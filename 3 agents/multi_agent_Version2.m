tic;
%clear;
%clc;
global demand_values;
global price_vector;
global max_renewable;
global P_1;
global P_2;
global P_3;
global P2;

c_vector = [0;5;10;30];
%c_vector = [10];
no_of_agents = 3;

testing_reward = zeros(no_of_agents,size(c_vector,1));


for c_index = 1:size(c_vector,1)
    
    c = c_vector(c_index);



demand_values = [2;4;6];

max_demand_value = 10;
min_demand_value = 2;

max_battery = 8;
max_renewable = 8;

min_state = max_demand_value;
max_state = max_battery + max_renewable - min_demand_value;

total_state_units = min_state + max_state+1+1;


max_givable = max_battery + max_renewable;
%max_askable = max(demand_values) + max_battery;
max_askable = 10;


total_decision_units = max_givable + max_askable + 1;

price_vector = [5;10;15];
time_stamp = 4;

Q = zeros(no_of_agents,time_stamp,total_state_units,size(price_vector,1),total_decision_units);
count_Q = ones(no_of_agents,time_stamp,total_state_units,size(price_vector,1),total_decision_units);

%Q2 = zeros(time_stamp,total_state_units,size(price_vector,1),total_decision_units);
%count_Q2 = ones(time_stamp,total_state_units,size(price_vector,1),total_decision_units);

abs_count = zeros(no_of_agents,1);

no_of_iterations = 10001000;

demand = 2 * ones(no_of_agents,1);
price = 5 ;
battery = 0 * ones(no_of_agents,1);
time = 1;


%ren = get_renewable(time(1))*ones(no_of_agents,1) ;

for i = 1:no_of_agents
 
    ren(i,:) = get_renewable(i,time);

end

%alpha = 1;
%alpha = 1;
initial_constant = 1000;
discount = 0.6;
%c = max(price_vector) + 15;
total_reward = zeros(no_of_agents,1);

constant_time = 4;
constant_state = 2 + min_state +1;
constant_price = 3;
constant_adl = 4;
constant_adl_action = 4;

constant_action_set = (-6:2) + max_askable+1;

%**********************************************************************
d_size = size(demand_values,1);
p_size = size(price_vector,1);

%t_size = d_size * p_size;

% P = zeros(d_size,d_size);
% P2 = zeros(p_size,p_size);
% 
% for i = 1:d_size
%     
%    P(i,:) = rand(d_size,1);
%    P(i,:) = P(i,:)/sum(P(i,:));
% end
% 
% for i = 1:p_size
%     
%    P2(i,:) = rand(p_size,1);
%    P2(i,:) = P2(i,:)/sum(P2(i,:));
% end
% 



% P = [    0.1579    0.3473    0.4948;
%     0.2092    0.5410    0.2498;
%     0.3741    0.4441    0.1818];
% 
% 
% 
% P2 =  [   0.3016    0.4100    0.2884;
%     0.6925    0.2470    0.0605;
%     0.4901    0.4241    0.0859];


%   P =  [ 0.6069    0.3484    0.0447;
%     0.1498    0.7879    0.0623;
%     0.1697    0.1027    0.7276;];
% 
% 
% 
% P2 =  [  0.4632    0.2906    0.2462;
 %   0.5376    0.2170    0.2454;
  %  0.6762    0.0388    0.2850;];

 


%*************************************************************************



for main_iter = 1:no_of_iterations
    
     [~,next_price] = get_next(1,demand(1),price);
    next_time = time +1;
    if next_time > time_stamp
     
        next_time = 1;
    end
    
    if main_iter < no_of_iterations/5
       exploration = 0.8;
    elseif main_iter > no_of_iterations/5 && main_iter < (2/5)*no_of_iterations
        exploration = 0.6;
    elseif main_iter > (2/5)*no_of_iterations && main_iter < (3/5)*no_of_iterations
        exploration = 0.4;
    elseif main_iter > (3/5)*no_of_iterations && main_iter < (4/5)*no_of_iterations
        exploration = 0.2;
    else
        exploration = 0;
    end
    
    
    
for mini_iter = 1:no_of_agents    
    
%      demand = demand_values (randi(3));
%         battery = randi(4);
%         ren = randi(4);
%         time = randi(2);
%         price = price_vector(randi(3));
    actual_demand = demand(mini_iter);
    
    if time == 1
        demand(mini_iter) = demand(mini_iter) +4;
    end
    
    
    
    

    quasi_state = (battery(mini_iter) + ren(mini_iter)) - demand(mini_iter);
    state1 = quasi_state + 1 + min_state;
    state2 = find(ismember(price_vector,price,'rows'),1);
    
    if quasi_state <= 0
    
        diff_power = max(-max_askable,quasi_state - max_battery);
        action_set = (diff_power : 0) + max_askable+1;
        
    else
        
        rem_battery =  quasi_state - max_battery;
        
        action_set = (rem_battery : quasi_state) + max_askable+1;
        
    end
 %   if main_iter < no_of_iterations - 100
    if rand() < exploration
        
        max_index = randi([min(action_set) max(action_set)]);
    else
        
        [~,quasi_max_index] = max(Q(mini_iter,time,state1,state2,action_set));    
        
        max_index = action_set(quasi_max_index);
        
    end
%     else
%         
%         [~,quasi_max_index] = max(count_Q(time,state1,state2,action_set));    
%         
%         max_index = action_set(quasi_max_index);
%     end
    
    action_taken = max_index - (max_askable+1);
    
    [next_demand,~] = get_next(mini_iter,actual_demand,price);
    
    actual_next_demand = next_demand;
    if next_time == 1
        next_demand = next_demand + 4;
    end
    
        
    
    %next_price = next_actual_price;
    
    
    next_ren = get_renewable(mini_iter, next_time);
    
    next_battery = max(battery(mini_iter)+ren(mini_iter) - action_taken - demand(mini_iter),0);
    
 reward = action_taken*price + c*(min(0,(battery(mini_iter)+ren(mini_iter)-action_taken) - demand(mini_iter)));

    
    
    if main_iter > no_of_iterations - 1000
         testing_reward(mini_iter,c_index) = testing_reward(mini_iter,c_index) + reward;
        
  % fprintf('time : %d dem: %d ren: %d battery: %d state: %d Price: %d action_taken: %d nextbatt: %d \n', time,demand(mini_iter),ren(mini_iter),battery(mini_iter),quasi_state,price,action_taken,next_battery);
   % pause;
  %  total_reward = total_reward + reward;
    end
    %*******************************************************************
    
    next_quasi_state = (next_battery + next_ren) - next_demand;
    next_state1 = next_quasi_state + 1 + min_state;
    next_state2 = find(ismember(price_vector,next_price,'rows'),1);
    
    if next_quasi_state <= 0
    
        next_diff_power =  max(-max_askable,next_quasi_state-max_battery);
        next_action_set = (next_diff_power : 0) + max_askable+1;
        
    else
        
      %  next_rem_battery = max_battery - next_battery;
        
       % next_action_set = (next_quasi_state - next_rem_battery : next_quasi_state) + max_askable+1;
        
       next_rem_battery =  next_quasi_state - max_battery;
        
       next_action_set = (next_rem_battery : next_quasi_state) + max_askable+1;
       
    end
    
    next_max_reward =  max(Q(mini_iter,next_time,next_state1,next_state2,next_action_set));
    
    %*******************************************************************
    
    
    %Write Q-Update
    
   % alpha = log(count_Q(mini_iter,time,state1,state2,max_index))/(count_Q(mini_iter,time,state1,state2,max_index));
    alpha = 1/(count_Q(mini_iter,time,state1,state2,max_index));

    Q(mini_iter,time,state1,state2,max_index) = (1-alpha)*Q(mini_iter,time,state1,state2,max_index) + alpha*(reward + next_max_reward - max(Q(mini_iter,constant_time,constant_state,constant_price,constant_action_set)));
    count_Q(mini_iter,time,state1,state2,max_index) = count_Q(mini_iter,time,state1,state2,max_index) + 1; 
    
    demand(mini_iter) = actual_next_demand;
    battery(mini_iter) = next_battery;
    ren(mini_iter) = next_ren;
  %  time(mini_iter) = next_time;
    %price(mini_iter) = next_price;
%     

  
  total_reward(mini_iter) = total_reward(mini_iter) + reward;


    if rem(main_iter,100) == 0
     
        demand(mini_iter) = demand_values (randi(3));
        battery(mini_iter) = randi(8);
        ren(mini_iter) = randi(8);
       % adl(mini_iter) = 4;
      %  time(mini_iter) = 2;%randi(4);
      %  price(mini_iter) = 15;%price_vector(randi(3));
      abs_count(mini_iter) = abs_count(mini_iter) +1;
      store_reward(c_index,mini_iter,abs_count(mini_iter)) = total_reward(mini_iter);
      store_constant_reward(c_index,mini_iter,abs_count(mini_iter)) = max(Q(mini_iter,constant_time,constant_state,constant_price,constant_action_set));

      total_reward(mini_iter) = 0;
    
    end
    
    if rem(main_iter,1000) == 0
     
        demand(mini_iter) = 6; %demand_values (randi(3));
        battery(mini_iter) = 4;%randi(4);
        ren(mini_iter) = 4;%randi(4);
      %  time(mini_iter) = 2;%randi(4);
      %  price(mini_iter) = 15;%price_vector(randi(3));
    
    end
    
   % alpha = initial_constant/main_iter;
    
    
   % total_reward = total_reward + reward;
   
%*************************************** 2nd Grid***************************************   


 
end

price = next_price;
time = next_time;
 if rem(main_iter,100) == 0
     price = price_vector(randi(3));
     time = randi(4);
 end
 
 if rem(main_iter,1000) == 0
     price = 15;
     time = 4;
 end
 
%fprintf('\n ****************\n');


end

% for index = 1:no_of_agents
% beta = 100;
% mgl = store_reward(2,index,:);
% cum_mgl = cumsum(mgl);
% for j = 1:size(mgl,3)
% norm_mgl(index,j) = cum_mgl(1,1,j)/beta;
% beta = beta + 100;
% end
% end
% 
% 
% x_indices = [100:100:no_of_iterations];
% 
% for i = 1:no_of_agents
% 
%     
%    figure;
%    plot(x_indices,norm_mgl(i,:));
%    
%     
% 
% 
% end
fprintf('\n %d',testing_reward(:,c_index));
fprintf('\n ***************************\n');
save('multiagent_comp3.mat');
end
fprintf('%d\n',testing_reward);
fprintf('\n_____________________________\n');


%plot(1:100:no_of_iterations,store_constant_reward(1,:));

toc;


%fprintf('Average Reward is %f\n',total_reward);%/no_of_iterations);

