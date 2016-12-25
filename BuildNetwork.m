function [net,accuracy]= BuildNetwork(design, data, target, neuralTrainFcn, layerFcn, grad, useGpu, targetAccuracy)

%get design parameters
[mLayers,~] = size(design);
if(iscell(data))
    [mInputs,~]= size(data);
else
    mInputs= 1;
end;

%declare network
net = network;

net.numInputs=mInputs;
if mInputs==1
    net.inputs{1}.exampleInput= data(:,1);
else
    for i=1:mInputs
        net.inputs{i}.exampleInput= data{i,1}(:,1);
    end;
end;

net.numLayers=mLayers;

%set bias connections
connections= ones(mLayers,1);
net.biasConnect= connections;

%set input layer connections
inputConnections= zeros(mLayers,mInputs);
layersConnections= zeros(mLayers,mLayers);
outputConnections= zeros(1,mLayers);
outputConnections(1,mLayers)=1;
for i=1:mLayers
    net.layers{i}.size= design(i,1);
    net.layers{i}.transferFcn= layerFcn(i,:);
    net.layers{i}.initFcn='initnw';
    if(design(i,2)<0)
        inputConnections(i,-design(i,2))=1;
    elseif(design(i,2)<10)
        layersConnections(i,design(i,2))=1;
    else
        layersConnections(i,mod(design(i,2),10))=1;
        layersConnections(i,floor(design(i,2)/10))=1;
    end;
end

net.inputConnect= inputConnections;
net.layerConnect= layersConnections;
net.outputConnect= outputConnections;

%initialize the neural network parameters
net.initFcn= 'initlay';
net.performFcn='mse';
net.trainFcn=neuralTrainFcn;
net.divideFcn='dividerand';
net.trainParam.min_grad= grad;
net.trainParam.max_fail= 6;

for i=1:gpuDeviceCount
    gpu= gpuDevice(i);
    display(gpu);
end;

accuracy=1;
while accuracy>targetAccuracy
    net= init(net);
    net= train(net, data, target, 'useGpu', useGpu);
    output= net(data);
    if(iscell(output))
        output= output{1,1};
    end;
    [~, n]= size(output);
    error= target-output;
    error= error*error';
    accuracy= error/n;
end;