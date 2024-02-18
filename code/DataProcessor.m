
classdef DataProcessor

    properties
        initial_data_lenght;   %Longitud de las señales originales (23seg)
        segmented_data_lenght; %Longitud de las ventanas (1seg)
        num_windows;           %Numero de ventanas por clase
        output_size;           %Tamaño de los datos de salida (para temporal, power spectrum y wavelet)
        f_samp;                %Frecuencia de muestreo        
    end
    
    methods
        
        function obj = DataProcessor()
            obj.initial_data_lenght = 4097;
            obj.segmented_data_lenght = 1730;         
            obj.num_windows = 200;    
            obj.output_size = [obj.num_windows, 10, obj.segmented_data_lenght/10];   
            obj.f_samp = 173.6;
        end
        %Cargar los datos
        function output = loadData(obj,path_a) 
            list = dir(path_a);
            output = zeros(length(list)-2,obj.initial_data_lenght);
            for a=3 : length(list)
                fileID = fopen(strcat(path_a,list(a).name),'r');
                output(a-2,:) = fscanf(fileID,'%f');
                fclose(fileID);
            end            
        end
        %Segmentar los datos en ventanas de 10seg (1730 muestras)
        function output = segmentData(obj, input, is_ictal)
            output = zeros(obj.num_windows,obj.segmented_data_lenght);
            if is_ictal
                output(1:obj.num_windows/2,:) = input(:,1:obj.segmented_data_lenght);
                output(obj.num_windows/2+1:end,:) = input(:,obj.segmented_data_lenght+1:obj.segmented_data_lenght*2);
            else
               output(:,:) = input(:,1:obj.segmented_data_lenght);
            end
        end
        %Temporal processing, standarizacion de los datos y ventaneo en
        %segmentos de 1seg(173muestras)
        function output = temporalProcessing(obj,input)
           output = zeros(obj.output_size);
           for a=1 : obj.output_size(1)
               for b=1 : obj.output_size(2)
                   segment = input(a,(b-1)*obj.output_size(3)+1 : b*obj.output_size(3));
                   output(a,b,:) = (segment-mean(segment))/std(segment);
               end
           end
        end
        %Frecuencial processing,segmentacion en ventanas de 1 segundo y
        %calculo del periodograma en decibeles
        function output = frecuencialProcessing(obj,input)
           output = zeros(obj.output_size);
           for a=1 : obj.output_size(1)
               for b=1 : obj.output_size(2)
                   segment = input(a,(b-1)*obj.output_size(3)+1 : b*obj.output_size(3));
                   output(a,b,:) = 10*log10(periodogram(segment,[],(obj.output_size(3)-1)*2));
               end
           end
           output(output==-Inf)=-100;
        end
        %Statistical processing
        function output = statisticalProcessing(obj, input)
            f_bands = [0.5 4 8 12 25 40]; %Frecuencias de cada banda
            bands = 5;
            f_ord = 2;
            parameters = 7;
            
            b = zeros(5,5);
            a = zeros(5,5);
            for c=1 : bands %Coeficientes del filtro butterworth de 2do. orden 
                [b(c,:), a(c,:)] = butter(f_ord, [f_bands(c) f_bands(c+1)]/(obj.f_samp/2));
            end
            
            sig_bands = zeros(bands, obj.segmented_data_lenght);
            output = zeros(obj.num_windows, bands, parameters);
            for d=1 : obj.num_windows
                for c=1 : bands %Obtencion de las bandas: delta, theta, alfa, beta y gamma
                    sig_bands(c,:) = filter(b(c,:),a(c,:),input(d,:));
                end

                for c=1 : bands
                    Q = periodogram(sig_bands(c,:),[],[],obj.f_samp);
                    [Amax, Bmax] = max(Q);
                    output(d,c,1) = Bmax*((obj.f_samp/2)/length(Q));     %Fmax
                    output(d,c,2) = medfreq(sig_bands(c,:),obj.f_samp);  %Fmean
                    output(d,c,3) = meanfreq(sig_bands(c,:),obj.f_samp); %Fmedian
                    output(d,c,4) = var(sig_bands(c,:));                 %Var 
                    output(d,c,5) = rms(sig_bands(c,:));                 %RMS
                    output(d,c,6) = skewness(sig_bands(c,:));            %Asimetria
                    output(d,c,7) = kurtosis(sig_bands(c,:));            %Curtosis
                end
            end
        end
        
    end
    
end
