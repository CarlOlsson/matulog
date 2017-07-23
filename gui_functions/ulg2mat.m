function log = ulg2mat( ulgFileName )
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
log.data = csv_topics_to_d(ulgFileName);
log.FileName = ulgFileName;
log.matulog_version = 1.0;
log.params = '';
log.messages = '';
log.info = '';
save(ulgFileName,'log')
delete(['*' ulgFileName '*.csv'])
end

