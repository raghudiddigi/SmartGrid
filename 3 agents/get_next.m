function [dem,pr] = get_next(index,inp1,inp2)

global demand_values;
global price_vector;
global P_1;
global P_2;
global P_3;
global P2;


%***********************************************************************


if inp1 == demand_values(1)
    temp = 1;
else if inp1 == demand_values(2)
        temp = 2;
    else if inp1 == demand_values(3)
            temp = 3;
        end
    end
end

if index == 1
mat = P_1(temp,:);
elseif index == 2
    mat = P_2(temp,:);
else
    mat = P_3(temp,:);

end

mat2 = cumsum(mat) ;
x = rand();
%fprintf('\n random is %f\n',x);
temp2 = find(mat2 > x , 1);

dem = demand_values(temp2);


%************************************************************************


if inp2 == price_vector(1)
    temp = 1;
else if inp2 == price_vector(2)
        temp = 2;
    else if inp2 == price_vector(3)
            temp = 3;
        end
    end
end

mat = P2(temp,:);

mat2 = cumsum(mat) ;
x = rand();
%fprintf('\n random is %f\n',x);
temp2 = find(mat2 > x , 1);

if isempty(temp2)

    mat
    mat2
    temp2


end

pr = price_vector(temp2);











end