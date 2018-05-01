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
%**************** Things to do**********************************************
 
% 1. Re-check the code correctly.


%*************************************************************************


%Full_Demand = [6;8;10]

%ADL1 = [1 2]
%ADL2 = [1 3]
%ADL3 = [2 4]
%c_vector = [0;5;10;30];
c_vector = [0;5;10;30];
no_of_agents = 3;
testing_reward = zeros(no_of_agents,size(c_vector,1));



for c_index = 1:size(c_vector,1)
    
    c = c_vector(c_index);


demand_values = [2;4;6]; % Actual Demand Values
full_demand_values = [6;8;10]; % Demand values added with ADL demand


ADL_levels = 3 + 1;

total_ADL_actions = 3 +1; % +1 to include not to schedule any ADL

max_battery = 8;
max_renewable = 8; %Constraint on maximum renewable available.

min_state = max(demand_values); %For indexing purposes. 
max_state = max_battery + max_renewable - min(demand_values);

total_state_units = min_state + max_state+1; % +1 to incorporate 0 state.


max_givable = max_battery + max_renewable;
%max_askable = max(full_demand_values) + max_battery;
max_askable = 10;
%max_givable = 10;

total_decision_units = max_givable + max_askable + 1;

price_vector = [5;10;15];
time_stamp = 4;

Q = zeros(no_of_agents,time_stamp,total_state_units,ADL_levels,size(price_vector,1),total_decision_units,total_ADL_actions);
count_Q = ones(no_of_agents,time_stamp,total_state_units,ADL_levels,size(price_vector,1),total_decision_units,total_ADL_actions);

%Q2 = zeros(time_stamp,total_state_units,size(price_vector,1),total_decision_units);
%count_Q2 = ones(time_stamp,total_state_units,size(price_vector,1),total_decision_units);


no_of_iterations = 10001000;



adl_units(1) = 1; % within 2nd time
adl_units(2) = 1; % within 3rd time
adl_units(3) = 2; % within 4th time
adl_units(4) = 0; % Dummy variable. 


demand = 2 * ones(no_of_agents,1);
adl = 1 *ones(no_of_agents,1);
price = 5 ;
battery = 0 * ones(no_of_agents,1);
time = 1;


%ren = get_renewable(time(1))*ones(no_of_agents,1) ;

for i = 1:no_of_agents
 
    ren(i,:) = get_renewable(i,time);

end

%alpha = 1;
%alpha = 1;
discount = 0.6; %Not used anywhere
%c = max(price_vector) + 15;
total_reward = zeros(no_of_agents,1);
abs_count = zeros(no_of_agents,1);

constant_time = 4;
constant_state = 2 + min_state +1;
constant_price = 3;
constant_adl = 4;
constant_adl_action = 4;

constant_action_set = (-6:2) + max_askable+1;



%**********************************************************************
d_size = size(demand_values,1);
p_size = size(price_vector,1);


P2 = [0.2 0.4 0.4;0.1 0.5 0.4;0.5 0.4 0.1];
  

P_1 = [0.2 0.6 0.2;0.1 0.2 0.7;0.8 0.1 0.1];
P_2 = [0.2 0.2 0.6;0.8 0.1 0.1;0.2 0.7 0.1];
P_3 = [0.5 0.5 0;0 0.5 0.5;1 0 0];


%*************************************************************************



for main_iter = 1:no_of_iterations
    
    if main_iter <= no_of_iterations/5
       exploration = 0.8;
    elseif main_iter > no_of_iterations/5 && main_iter <= (2/5)*no_of_iterations
        exploration = 0.6;
    elseif main_iter > (2/5)*no_of_iterations && main_iter <= (3/5)*no_of_iterations
        exploration = 0.4;
    elseif main_iter > (3/5)*no_of_iterations && main_iter <= (4/5)*no_of_iterations
        exploration = 0.2;
    else
        exploration = 0;
    end
    
    
     [~,next_price] = get_next(1,demand(1),price);
    next_time = time +1;
    if next_time > time_stamp
         next_adl = 1;
        next_time = 1;
    end
    
    
for mini_iter = 1:no_of_agents    
        

    quasi_state = (battery(mini_iter) + ren(mini_iter)) - demand(mini_iter);
    state1 = quasi_state + 1 + min_state;
    state2 = find(ismember(price_vector,price,'rows'),1);
    
    if quasi_state <= 0  %It means microgris is in the need of power
    
        diff_power = max(-max_askable,quasi_state - max_battery);
        action_set = (diff_power : 0) + max_askable+1;
        
    else
        
        rem_battery =  quasi_state - max_battery;
        action_set = (rem_battery : quasi_state) + max_askable+1;
        
    end
    
    if rand() < exploration
        
        adl_action = randi([adl(mini_iter) 4]);
        max_index = randi([min(action_set) max(action_set)]);
    else
        
        adl_set = [adl(mini_iter):4];
        
        [~,quasi_max_index] = max(Q(mini_iter,time,state1,adl(mini_iter),state2,action_set,adl_set)); 
        
         [~, adl_action] = max(max(Q(mini_iter,time,state1,adl(mini_iter),state2,action_set,adl_set)));
        
        max_index = action_set(quasi_max_index(1));
        
        adl_action = adl_set(adl_action);
    end
    

   adl_action_demand = 0;
    
    if adl_action < 4
    for j = adl(mini_iter):adl_action
    
    
        adl_action_demand = adl_action_demand +  adl_units(j);
        
    end
    end
    
    real_demand = demand(mini_iter) + adl_action_demand;


    action_taken = max_index - (max_askable+1); %actual action, not the index
    
    [next_demand,~] = get_next(mini_iter,demand(mini_iter),price);
        
 %Below finds the next ADL level and ADL penalty    
    
if adl(mini_iter) == 4
    next_adl = 4;
elseif adl_action == 4
  
    next_adl = adl(mini_iter);
else
    next_adl = adl_action + 1;
end


    penalty = 0;

    if time == 2 && next_adl == 1
        penalty = 1;
    elseif time ==3 && next_adl == 1
        penalty = 2;
    elseif time == 3 && next_adl == 2
        penalty = 1;
    elseif time == 4 && next_adl == 1
        penalty = 4;
    elseif time == 4 && next_adl == 2
        penalty = 3;
    elseif time == 4 && next_adl == 3
        penalty = 2;
    end
      
    
    if next_time == 1
        next_adl = 1;
    end
    
    next_ren = get_renewable(mini_iter, next_time);
    real_action = action_taken - adl_action_demand;
    
    
    next_battery = max(battery(mini_iter)+ren(mini_iter) - action_taken - demand(mini_iter),0);
    
   reward = real_action*price + c*(min(0,(battery(mini_iter)+ren(mini_iter)-action_taken) - demand(mini_iter))- penalty);

    
    if main_iter >= no_of_iterations - 1000
        testing_reward(mini_iter,c_index) = testing_reward(mini_iter,c_index) + reward;
       % fprintf('time : %d dem: %d ren: %d battery: %d state: %d ADL : %d Price: %d action_taken: %d nextbatt: %d adl_action : %d \n', time,demand(mini_iter),ren(mini_iter),battery(mini_iter),quasi_state,adl(mini_iter),price,action_taken,next_battery,adl_action);
       % pause;
    end
    %*******************************************************************
    
    next_quasi_state = (next_battery + next_ren) - next_demand;
    next_state1 = next_quasi_state + 1 + min_state;
    next_state2 = find(ismember(price_vector,next_price,'rows'),1);
    
    if next_quasi_state <= 0
    
        next_diff_power =  max(-max_askable,next_quasi_state-max_battery);
        next_action_set = (next_diff_power : 0) + max_askable+1;
        
    else
        
       next_rem_battery =  next_quasi_state - max_battery;
        
       next_action_set = (next_rem_battery : next_quasi_state) + max_askable+1;
       
    end
    
    next_max_reward =  max(max(Q(mini_iter,next_time,next_state1,next_adl,next_state2,next_action_set,[next_adl :4])));
    
    %*******************************************************************
    
    
    %Write Q-Update
    
   alpha = log(count_Q(mini_iter,time,state1,adl(mini_iter),state2,max_index,adl_action))/(count_Q(mini_iter,time,state1,adl(mini_iter),state2,max_index,adl_action));
   
   
    Q(mini_iter,time,state1,adl(mini_iter),state2,max_index,adl_action) = (1-alpha)*Q(mini_iter,time,state1,adl(mini_iter),state2,max_index,adl_action) + alpha*(reward + next_max_reward - max(Q(mini_iter,constant_time,constant_state,constant_adl,constant_price,constant_action_set,constant_adl_action)));
    count_Q(mini_iter,time,state1,adl(mini_iter),state2,max_index,adl_action) = count_Q(mini_iter,time,state1,adl(mini_iter),state2,max_index,adl_action) + 1; 
    
    demand(mini_iter) = next_demand;
    battery(mini_iter) = next_battery;
    ren(mini_iter) = next_ren;
    adl(mini_iter) = next_adl;
  %  time(mini_iter) = next_time;
    %price(mini_iter) = next_price;
    
    total_reward(mini_iter) = total_reward(mini_iter) + reward;

    
%     
    if rem(main_iter,100) == 0
     
        demand(mini_iter) = demand_values (randi(3)); %6; %demand_values (randi(3));
        battery(mini_iter) = randi(8);%4;%randi(4);
        ren(mini_iter) = randi(8);%4;%randi(4);
        adl(mini_iter) = randi(4);%4;
      %  time(mini_iter) = 2;%randi(4);
      %  price(mini_iter) = 15;%price_vector(randi(3));
      
      abs_count(mini_iter) = abs_count(mini_iter) +1;
      store_reward(c_index,mini_iter,abs_count(mini_iter)) = total_reward(mini_iter);
      store_constant_reward(c_index,mini_iter,abs_count(mini_iter)) = max(Q(mini_iter,constant_time,constant_state,constant_adl,constant_price,constant_action_set,constant_adl_action));
      total_reward(mini_iter) = 0;
      
      
    
    end
    
    if rem(main_iter,1000) == 0
     
        demand(mini_iter) = 6; %demand_values (randi(3));
        battery(mini_iter) = 4;%randi(4);
        ren(mini_iter) = 4;%randi(4);
        adl(mini_iter) = 4;
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
     price = price_vector(randi(3));% 15;
     time =randi(4);% 4;
 end
 
 if rem(main_iter,1000) == 0
     price = 15;
     time = 4;
    % fprintf('\n Iteration: %d\n',main_iter);
 end
 
 
%fprintf('\n ****************\n');

%save('multiagent_main.mat');

end


% for index = 1:no_of_agents
% beta = 100;
% mgl = store_reward(index,:);
% cum_mgl = cumsum(mgl);
% for j = 1:size(mgl,2)
% norm_mgl(index,j) = cum_mgl(1,j)/beta;
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
save('multiagent_main.mat');
end
%plot(1:100:no_of_iterations,store_constant_reward(1,:))
%fprintf('%d\n',testing_reward);
fprintf('\n____________________________________\n');
toc;





