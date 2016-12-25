function [data, target, fs]= PrepareData2(directory,fw, fi,persons, tracks, delS, delta, deltadelta)

[~,fs]=audioread([directory,'1\Track (1).wav']);
[~, mPersons]= size(persons);
[~, mTracks]= size(tracks);
mfccData= cell(1,mPersons);
lpcData= cell(1,mPersons);
target= cell(1,mPersons);
for i=1:mPersons
    audio= cell(mTracks,1);
    for j=1:mTracks
        audio{j,1}= audioread([directory,num2str(persons(1,i)),'\Track (',num2str(tracks(1,j)),').wav']);
    end;
    audio= cell2mat(audio);
    
    if(delS)
        audio= RemoveSilence(audio,ceil(fs*0.012),0.025);
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
    [~,n]= size(mfcc);
    mfccData{1,i}= mfcc;
    lpcData{1,i}= lpc;
    class= zeros(mPersons,1);
    class(persons(1,i),1)=1;
    target{1,i}= repmat(class,1 , n);
end;
mfccData= cell2mat(mfccData);
lpcData= cell2mat(lpcData);
data= {mfccData;lpcData};
target= cell2mat(target);