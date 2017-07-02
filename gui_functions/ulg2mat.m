function ulg2mat( ulgFileName )
%ulg2mat Converts a .ulg file to a .mat file
if exist([ulgFileName '.mat'])
    disp('ERROR: mat file already exists');
    return;
end
command = ['!ulog2csv ' ulgFileName '.ulg'];
try
	eval(command);
catch
	disp('ERROR: failed to run ulog2csv, try: pip install pyulog');
end
data = csv_topics_to_d(ulgFileName);
save(ulgFileName,'data')
clear data
delete(['*' ulgFileName '*.csv'])
end

