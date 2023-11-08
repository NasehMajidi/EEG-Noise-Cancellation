clear all
close all
%% loading data
Name='slp41m';
infoName = strcat(Name, '.info');
matName = strcat(Name, '.mat');
Octave = exist('OCTAVE_VERSION');
load(matName);
fid = fopen(infoName, 'rt');
fgetl(fid);
fgetl(fid);
fgetl(fid);
[freqint] = sscanf(fgetl(fid), 'Sampling frequency: %f Hz  Sampling interval: %f sec');
interval = freqint(2);
fgetl(fid);

if(Octave)
    for i = 1:size(val, 1)
       R = strsplit(fgetl(fid), char(9));
       signal{i} = R{2};
       gain(i) = str2num(R{3});
       base(i) = str2num(R{4});
       units{i} = R{5};
    end
else
    for i = 1:size(val, 1)
      [row(i), signal(i), gain(i), base(i), units(i)]=strread(fgetl(fid),'%d%s%f%f%s','delimiter','\t');
    end
end

fclose(fid);
val(val==-32768) = NaN;

for i = 1:size(val, 1)
    val(i, :) = (val(i, :) - base(i)) / gain(i);
end

x = (1:size(val, 2)) * interval;
ecg=val(1,:)';
eeg=val(3,:)';
eog=val(6,:)';
%% first lms
fs=freqint(1); 
N_lms1=16;
N=length(val(3,:));
t=0:1/fs:10;
for i=1:N
     n0(i)=sin(2*pi*50*t(i));
end
 win1=zeros(N_lms1,1);
[w1,e1,y1]=my_nlms(n0',eeg,0.04,N_lms1,win1);
[f1,fr1_1]=pwelch(eeg,[],[],[],fs);
[q1,fr2_1]=pwelch(e1,[],[],[],fs);
figure(1)
    subplot(2,1,1)
        plot(fr1_1,pow2db(f1))
        title('psd of eeg')
        ylabel('PSD(dB)')
    subplot(2,1,2)
        plot(fr2_1,pow2db(q1))
        title('psd of eeg without 50hz artifact')
        xlabel('Hz')
        ylabel('PSD(dB)')
figure(2)
    subplot(3,1,1)
        plot(x,eeg)
        title(' eeg')
    subplot(3,1,2)
        plot(x,y1)
        title('y1')
    subplot(3,1,3)
        plot(x,e1)
        title(' eeg without 50hz artifact')
%% first lms for different mu
[w11,e11,y11]=my_nlms(n0',eeg,0.04,N_lms1,win1);
[w12,e12,y12]=my_nlms(n0',eeg,0.5,N_lms1,win1);
[w13,e13,y13]=my_nlms(n0',eeg,3,N_lms1,win1);
figure(3)
    subplot(3,1,1)
        plot(x,e11)
        title('u=0.04')
        ylabel('e1')
    subplot(3,1,2)
        plot(x,e12)
        title('u=0.5')
        ylabel('e1')
    subplot(3,1,3)
        plot(x,e13)
        title(' u=3')
        ylabel('e1')
%% second lms
N_lms2=32;
win2=zeros(N_lms2,1);
[w2,e2,y2]=my_nlms(ecg,e1',0.03,N_lms2,win2);
[f2,fr1_2]=pwelch(e1,[],[],[],fs);
[q2,fr2_2]=pwelch(e2,[],[],[],fs);
figure(4)
    subplot(2,1,1)
        plot(fr1_2,pow2db(f2))
        title('psd of eeg without 50 hz artifact(e1)')
    subplot(2,1,2)
        plot(fr2_2,pow2db(q2))
        title('psd of eeg without 50hz artifact and ecg')
figure(5)
    subplot(4,1,1)
        plot(x,e1)
        title(' eeg without 50 hz artifact(e1)')
    subplot(4,1,2)
        plot(x,ecg)
        title('ecg')
    subplot(4,1,3)
        plot(x,y2)
        title(' y2')
    subplot(4,1,4)
        plot(x,e2)
        title('eeg without 50 hz artifact and ecg(e2)')
        ylim([-0.1,0.1])
%% second lms for different mu
[w21,e21,y21]=my_nlms(ecg,e1',0.03,N_lms2,win2);
[w22,e22,y22]=my_nlms(ecg,e1',0.5,N_lms2,win2);
[w23,e23,y23]=my_nlms(ecg,e1',1,N_lms2,win2);
figure(6)
    subplot(3,1,1)
        plot(x,e21)
        title('u=0.03')
        ylabel('e2')
    subplot(3,1,2)
        plot(x,e22)
        title('u=0.5')
        ylabel('e2')
    subplot(3,1,3)
        plot(x,e23)
        title(' u=1')
        ylabel('e2')
 %% third lms
 N_lms3=16;
win3=zeros(N_lms3,1);
[w3,e3,y3]=my_nlms(eog,e2',0.01,N_lms3,win3);
[f3,fr1_3]=pwelch(e2,[],[],[],fs);
[q3,fr2_3]=pwelch(e3,[],[],[],fs);
figure(7)
    subplot(2,1,1)
        plot(fr1_3,pow2db(f3))
        title('psd of eeg without 50 hz artifact and ecg(e1)')
    subplot(2,1,2)
        plot(fr2_3,pow2db(q3))
        title('psd of eeg without artifacts')
figure(8)
    subplot(4,1,1)
        plot(x,e2)
        title(' eeg without 50 hz artifact(e2) and ecg')
    subplot(4,1,2)
        plot(x,eog)
        title('eog')
    subplot(4,1,3)
        plot(x,y3)
        title(' y3')
    subplot(4,1,4)
        plot(x,e3)
        title('eeg without artifacts(e3)')
%% third lms for different mu
[w31,e31,y31]=my_nlms(eog,e2',0.01,N_lms3,win3);
[w32,e32,y32]=my_nlms(eog,e2',0.5,N_lms3,win3);
[w33,e33,y33]=my_nlms(eog,e2',0.1,N_lms3,win3);
figure(9)
    subplot(3,1,1)
        plot(x,e31)
        title('u=0.01')
        ylabel('e2')
    subplot(3,1,2)
        plot(x,e32)
        title('u=0.5')
        ylabel('e2')
    subplot(3,1,3)
        plot(x,e33)
        title(' u=1')
        ylabel('e2')