if ~ismember('magnitude', log.data.wind_estimate_0.Properties.VariableNames)
    try
        log.data.wind_estimate_0.magnitude = sqrt(log.data.wind_estimate_0.windspeed_north.^2 + log.data.wind_estimate_0.windspeed_east.^2);
        log.data.wind_estimate_0.Properties.VariableDescriptions{end} = 'magnitude*';
        disp('[preprocessing]: Added magnitude to wind_estimate_0');
    catch
        disp('[preprocessing]: Failed to add magnitude to wind_estimate_0');
    end
end

if ~ismember('dir', log.data.wind_estimate_0.Properties.VariableNames)
    try
        log.data.wind_estimate_0.dir = atan2(log.data.wind_estimate_0.windspeed_north, log.data.wind_estimate_0.windspeed_east);
        log.data.wind_estimate_0.Properties.VariableDescriptions{end} = 'dir*';
        disp('[preprocessing]: Added dir to wind_estimate_0');
    catch
        disp('[preprocessing]: Failed to add dir to wind_estimate_0');
    end
end

if ~ismember('dir_deg', log.data.wind_estimate_0.Properties.VariableNames)
    try
        log.data.wind_estimate_0.dir_deg = rad2deg(log.data.wind_estimate_0.dir);
        log.data.wind_estimate_0.Properties.VariableDescriptions{end} = 'dir* [deg]';
        disp('[preprocessing]: Added dir_deg to wind_estimate_0');
    catch
        disp('[preprocessing]: Failed to add dir_deg to wind_estimate_0');
    end
end