function done= PlotResult(result)
[n,m,l]= size(result);
y= zeros(l,n*m);
for i=1:n
    for j=1:m
        for k=1:l
            y(k,(i-1)*m+j)= result(i,j,k);
        end;
    end;
end;
[n,m]=size(y);
x=1:m;
figure;
grids= ceil(sqrt(n));
for i=1:n
    subplot(grids,grids,i);
    plot(x,y(i,:));
end;
done=true;