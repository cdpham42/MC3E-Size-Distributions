function export_rainrate(comb, combrate, date, Time, AirTemp, TAS, PresAlt)

comb_head = {'Time','Hour','Minute','Second','Air Temp [C]','TAS [m/s]','Pres Alt [m]','Rainrate [mm/hr]','.0075mm','.0125mm','.0175mm','.0225mm','.0275mm','.0325mm','.0375mm','.04375mm','.05125mm','.05875mm','.06625mm','.075mm','.085mm','.095mm','.11mm','.13mm','.15mm','.17mm','.20mm','.24mm','.28mm','.32mm','.36mm','.40mm','.44mm','.48mm','.55mm','.65mm','.75mm','.85mm','.95mum','1.1mm','1.3mm','1.5mm','1.7mm','1.9mm','22.5mm','27.5mm'};

hms = zeros(14925,3,15);

for k = 1:15
    
    hms(:,1,k) = floor(Time(:,k)./3600);
    hms(:,2,k) = floor(rem(Time(:,k),3600)./60);
    hms(:,3,k) = rem(Time(:,k),60);

end

for k = 1:15
    
    array = [Time(:,k), hms(:,1,k), hms(:,2,k), hms(:,3,k), AirTemp(:,k), TAS(:,k), PresAlt(:,k)];
    
    comb_out = cat(2,array,combrate(:,:,k),comb(:,:,k));

    csvwrite_with_headers(char(strcat('Rainrate and Distribution Combined Spectrum',{' '},date(k),'.csv')),comb_out,comb_head);
end