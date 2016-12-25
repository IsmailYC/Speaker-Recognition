function y= RemoveSilence(data,w,th)
x= TreatAudio(data);
[m,n]= size(x);
c={};
j=1;
i=1;
while i<m
    if(i+w<m)
        energy=sum(x(i:i+w,1).^2)/w;
    else
        energy=sum(x(i:m,1).^2)/(m-i);
    end;
    if(energy>th)
        if(i+w<m)
            c{1,j}= x(i:i+w,1);
            j = j+1;
        else
            c{1,j}= x(i:m,1);
            j = j+1;
        end;
    end;
    i=i+w+1;
end;
[m,n]= size(c);
y=[];
for i=1:n
    y= [y;c{1,i}];
end;