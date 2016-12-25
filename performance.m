function [y,threshhold]= performance(x,th)
count=0;
threshhold=0;
[n,m,p]= size(x);
total=n*m;
for i=1:n
    for j=1:m
        tempMax= max(x(i,j,:));
        if(x(i,j,i)==tempMax)
            if(x(i,j,i)>=th)
                count= count+1;
            end;
        elseif(tempMax>threshhold)
                threshhold=tempMax;
        end;
    end;
end;
y=count/total;