function B = filterEdge(A,v,T)
% [outup] = filterEdge(input,window,treshold)
% Mediun filter with edge preserving


[x,y] = size(A);
B = zeros(x,y);
aa = zeros(x+2*v,y+2*v);
for i=(v+1):(x+v)
    for j=(v+1):(y+v)
           aa(i,j)=A(i-v,j-v);
    end
end
    
for i=(v+1):(x+v)
    for j=(v+1):(y+v)
        count=0;
        soma=0;
        for ki=-v:v
            for kj=-v:v
                if(abs(aa(i,j)-aa(i+ki,j+kj))<T)
                    soma=soma+aa(i+ki,j+kj);
                    count = count+1;                
                end
            end
        end
        B(i-v,j-v)=soma/count;
    end
end

end