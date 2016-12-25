function y= TestNet2(net,directory,fw, fi, persons,tracks,delS,delta,deltadelta)

[~,fs]=audioread([directory,'1\Track (1).wav']);
[~, mPersons]= size(persons);
[~, mTracks]= size(tracks);
mClasses= net.outputs{1,4}.size;
y= zeros(mPersons,mTracks,mClasses);
for i=1:mPersons
    for j=1:mTracks
        audio= audioread([directory,num2str(persons(1,i)),'\Track (',num2str(tracks(1,j)),').wav']);
        
        if(delS)
            audio= RemoveSilence(audio,ceil(fs*0.012), 0.025);
        else
            audio= TreatAudio(audio);
        end;
        
        if(deltadelta)
            mfcc= melcepst(audio, fs, 'dD', 12, floor(3*log(fs)), fw*fs, fi*fs);
        elseif (delta)
            mfcc= melcepst(audio, fs, 'd', 12, floor(3*log(fs)), fw*fs, fi*fs);
        else
            mfcc= melcepst(audio, fs, 12, floor(3*log(fs)), fw*fs, fi*fs);
        end;
        
        lpc= proclpc(audio, fs, 13, fi*1000, fw*1000);
        mfcc= mfcc';
        data= {mfcc;lpc};
        output= net(data);
        output= output{1,1};
        [~,n]= size(output);
        
        for k=1:mClasses
            y(i,j,k)= sum(output(k,:))/n;
        end;
        
    end;
end;