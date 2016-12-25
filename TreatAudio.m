function y=TreatAudio(x)
y=x;
[m,n]= size(x);
xdc= sum(x)/m;
y= y-xdc;
xmax= max(x);
y= y/xmax;