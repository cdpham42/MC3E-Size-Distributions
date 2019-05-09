%% Extract HVPS Large Particles to csv file
function extract_hvps(HVPS, Time, AirTemp, TAS, PresAlt)

dates = [422, 425, 427, 501, 510, 511,...
    518, 520, 523, 524, 527, 530,...
    601.1, 601.2, 602];

header = {'Date','Time','Hour','Minute','Second','Air Temp [C]','TAS [m/s]','Pres Alt [m]','.3mm','.5mm','.7mm','.9mm',' 1.1mm','1.3mm','1.5mm','1.7mm','2.0mm','2.4mm','2.8mm','3.2mm','3.6mm','4.0mm','4.4mm','4.8mm','5.5mm','6.5mm','7.5mm','8.5mm','9.5mm','11mm','13mm','15mm','17mm','19mm','22.5mm','27.5mm'};

array = [];

for k = 1:15    % Loop through flights
%     array = [];
    for i = 1:size(HVPS,1)  % Loop through times
        for j = 22:size(HVPS,2) % Loop through columns corresponding to >1cm size distribution
            if HVPS(i,j,k) ~= 0 % If large drop is present in column for specified row
                hour = floor(Time(i,k)/3600);
                min = floor(rem(Time(i,k),3600)/60);
                sec = rem(Time(i,k),60);
                array = [array; dates(k), Time(i,k),hour,min,sec, AirTemp(i,k), TAS(i,k), PresAlt(i,k), HVPS(i,:,k)];
                break
            end
        end
    end
%     if ~isempty(array)
%         name = strcat('HVPS Large Particles', date(k),'.csv');
%         name = char(name);
%         csvwrite_with_headers(name, array, header);
%     end
end

csvwrite_with_headers('HVPS Large Particles.csv', array, header);
