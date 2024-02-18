
DataProcessor1 = DataProcessor();
fs = 173.61;

%Loading all the data
path_a = '.\DataSet\RawData\Normal\';
NormalData = DataProcessor1.loadData(path_a);
path_a = '.\DataSet\RawData\InterIctal\';
InterData = DataProcessor1.loadData(path_a);
path_a = '.\DataSet\RawData\Ictal\';
IctalData = DataProcessor1.loadData(path_a);

%Segmenting data to 10s windows
NormalSegmented = DataProcessor1.segmentData(NormalData,0);
InterSegmented = DataProcessor1.segmentData(InterData,0);
IctalSegmented = DataProcessor1.segmentData(IctalData,1);
path_a = '.\DataSet\SegmentedData\Normal';
save(path_a,'NormalSegmented')
path_a = '.\DataSet\SegmentedData\InterIctal';
save(path_a,'InterSegmented')
path_a = '.\DataSet\SegmentedData\Ictal';
save(path_a,'IctalSegmented')

%Clear original data
clear NormalData
clear InterData
clear IctalData

%Plot Data
figure(1)
x = [1:size(NormalSegmented,2)]*1/fs;

subplot(3,1,1)
plot(x,NormalSegmented(4,:),'r')
xlabel('Tiempo(s)')
ylabel('Amplitud')
title('Señal de EEG de Persona Sana','FontWeight','bold')
xlim([0 x(end)])

subplot(3,1,2)
plot(x,InterSegmented(4,:),'b')
xlabel('Tiempo(s)')
ylabel('Amplitud')
title('Señal InterIctal','FontWeight','bold')
xlim([0 x(end)])

subplot(3,1,3)
plot(x,IctalSegmented(4,:),'k')
xlabel('Tiempo(s)')
ylabel('Amplitud')
title('Señal Ictal','FontWeight','bold')
xlim([0 x(end)])

%Temporal processing
NormalTemporal = DataProcessor1.temporalProcessing(NormalSegmented);
InterTemporal = DataProcessor1.temporalProcessing(InterSegmented);
IctalTemporal = DataProcessor1.temporalProcessing(IctalSegmented);
path_a = '.\DataSet\Temporal\Normal';
save(path_a,'NormalTemporal')
path_a = '.\DataSet\Temporal\InterIctal';
save(path_a,'InterTemporal')
path_a = '.\DataSet\Temporal\Ictal';
save(path_a,'IctalTemporal')

%Temporal Plotting
C = reshape(NormalTemporal(1,:,:),size(NormalTemporal,2),[],1);
imagesc(C)
cb = colorbar; colormap jet
cb.Label.String = 'Amplitud';
xlabel('Muestras')
ylabel('Ventanas')
set(gca, 'YTick', [1:10],'YTickLabel', {'1','2','3','4','5','6','7','8','9','10'});

%Clear temporal processed data
clear NormalTemporal
clear InterTemporal
clear IctalTemporal

%Frecuencial processing
NormalFreq = DataProcessor1.frecuencialProcessing(NormalSegmented);
InterFreq = DataProcessor1.frecuencialProcessing(InterSegmented);
IctalFreq = DataProcessor1.frecuencialProcessing(IctalSegmented);
path_a = '.\DataSet\Frecuencial\Normal';
save(path_a,'NormalFreq')
path_a = '.\DataSet\Frecuencial\InterIctal';
save(path_a,'InterFreq')
path_a = '.\DataSet\Frecuencial\Ictal';
save(path_a,'IctalFreq')

%Plot a single signal
figure(2)
x = linspace(0,fs/2,173);
C = reshape(IctalFreq(1,1,:),size(IctalFreq,3),[]);
plot(x,C)
xlabel('Frecuencia(Hz)')
ylabel('db/Hz')
title('Power Spectrum','FontWeight','bold')
xlim([0 x(end)])
grid on

%Freq Matrix Plotting
C = reshape(IctalFreq(2,:,:),size(IctalFreq,2),[],1);
imagesc(C)
cb = colorbar; colormap jet
cb.Label.String = 'Amplitud (dB/Hz)';
xlabel('Frecuencia (Hz)')
ylabel('Ventanas')
set(gca, 'YTick', [1:10],'YTickLabel', {'1','2','3','4','5','6','7','8','9','10'});
set(gca, 'XTick', linspace(1,173,6),'XTickLabel', linspace(0,173/2,6));

%Clear temporal frecuencial data
clear NormalFreq
clear InterFreq
clear IctalFreq

%Statistical processing
NormalStat = DataProcessor1.statisticalProcessing(NormalSegmented);
InterStat = DataProcessor1.statisticalProcessing(InterSegmented);
IctalStat = DataProcessor1.statisticalProcessing(IctalSegmented);
path_a = '.\DataSet\StaParameters\Normal';
save(path_a,'NormalStat')
path_a = '.\DataSet\StaParameters\InterIctal';
save(path_a,'InterStat')
path_a = '.\DataSet\StaParameters\Ictal';
save(path_a,'IctalStat')

%Statistical Matrix Plotting
C = reshape(InterStat(10,:,:),size(InterStat,2),7);
imagesc(C)
cb = colorbar; colormap summer
cb.Label.String = 'Amplitud sin normalizar';
xlabel('Par�metros','Fontsize',15)
ylabel('Bandas','Fontsize',15)
set(gca, 'XTick', [1:7],'XTickLabel', {'fmax','fmdn','fmn','Var','RMS','Asim','Curt'},'Fontsize',12);
set(gca, 'YTick', [1:5],'YTickLabel', {'Delta','Theta','Alfa','Beta','Gamma'});
for a=1 : 5
    for b=1 : 7
        text(b-0.3,a,num2str(round(C(a,b)*100)/100),'FontWeight','bold')
    end
end

clear all
close all
