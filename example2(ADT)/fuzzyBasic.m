%=========================================================================%
%  Description£ºFuzzy basic function
%  Parameter: Z: independent variable; 
%             l: rule index; 
%             N: number of rules
%  Date£º2018-04-12
%=========================================================================%
function y = fuzzyBasic(Z, l, L, widthArr)

numerator = 1;
for idX = 1:length(Z)
    numerator = numerator*menFun(Z(idX), l, widthArr(idX));
end

denominator = 0;
for idN = 1:L
    tmp = 1;
    for idX = 1:length(Z)
        tmp = tmp*menFun(Z(idX), idN, widthArr(idX));
    end
    denominator = denominator+tmp;
end

y = numerator/denominator;


%%%%%%%%%%%%%%%%%%%%%%%%%
% member function
%%%%%%%%%%%%%%%%%%%%%%%%%
function mu = menFun(x, l, w)

mu = exp(-(x-3+l)^2/w);
