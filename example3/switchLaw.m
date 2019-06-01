function k = switchLaw(t, T1, T2)

T = T1+T2;

for idPeroid=1:200
    if (T*(idPeroid-1)<=t) && (t<T*idPeroid)
        break;
    end
end

if (T*(idPeroid-1) <= t) && (t < (T*(idPeroid-1)+T1))
    k=1;
elseif (T*(idPeroid-1)+T1 <= t) && (t < T*idPeroid)
    k=2;
end