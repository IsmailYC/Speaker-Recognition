function net= BuildNetwork2(directory,fw, fi,persons, tracks, delS, delta, deltadelta, neuralTrainFcn, grad, useGpu)
[data, target]= PrepareData2(directory,fw, fi,persons, tracks, delS, delta, deltadelta);
[~, mPersons]= size(persons);
[~, mTracks]= size(tracks);
net= network;
net.numInputs=2;
net.numLayers=4;
net.biasConnect= [1;1;1;1];
net.inputConnect= [1,0;0,1;0,0;0,0];
net.layerConnect= [0,0,0,0;0,0,0,0;1,1,0,0;0,0,1,0];
net.inputs{1}.size= 36;
net.inputs{2}.size= 14;
net.outputConnect= [0,0,0,1];
net.layers{1}.size= 44;
net.layers{1}.transferFcn= 'logsig';
net.layers{1}.initFcn= 'initnw';
net.layers{2}.size= 44;
net.layers{2}.transferFcn= 'logsig';
net.layers{2}.initFcn= 'initnw';
net.layers{3}.size= 44;
net.layers{3}.transferFcn= 'logsig';
net.layers{3}.initFcn= 'initnw';
net.layers{4}.size= 15;
net.layers{4}.transferFcn= 'logsig';
net.layers{4}.initFcn= 'initnw';
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
while accuracy<0.001
    net= init(net);
    net= train(net, data, target, 'useGpu', useGpu);
    output= net(data);
    [~, n]= size(output);
    error= target-output;
    error= error*error';
    accuracy= error/n;
end;