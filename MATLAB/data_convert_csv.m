%% Rewrite data to CSV

[mc3e, comb, DC, CIP, HVPS, mc3eAll, combAll, DCAll, CIPAll, HVPSAll, date, prefix, AirTemp, Time, TAS, PresAlt] = data_read();

date = {' 2011 04 22';' 2011 04 25';' 2011 04 27';' 2011 05 01';' 2011 05 10';' 2011 05 11';...
    ' 2011 05 18';' 2011 05 20';' 2011 05 23';' 2011 05 24';' 2011 05 27';' 2011 05 30';...
    ' 2011 06 01-1';' 2011 06 01-2';' 2011 06 02'};

for k = 1:15
    name = strcat(date(k),' mc3e.csv');
    name = char(name);
    csvwrite(name, mc3e(:,:,k));
    
    name = strcat(date(k),' CIP.csv');
    name = char(name);
    csvwrite(name, [Time(:,k) AirTemp(:,k) TAS(:,k) PresAlt(:,k) CIP(:,:,k)]);
    
    name = strcat(date(k),' 2DC.csv');
    name = char(name);
    csvwrite(name, [Time(:,k) AirTemp(:,k) TAS(:,k) PresAlt(:,k) DC(:,:,k)]);
    
    name = strcat(date(k),' HVPS.csv');
    name = char(name);
    csvwrite(name, [Time(:,k) AirTemp(:,k) TAS(:,k) PresAlt(:,k) HVPS(:,:,k)]);
    
    name = strcat(date(k),' Combined Spectrum.csv');
    name = char(name);
    csvwrite(name, [Time(:,k) AirTemp(:,k) TAS(:,k) PresAlt(:,k) comb(:,:,k)]);
end
    