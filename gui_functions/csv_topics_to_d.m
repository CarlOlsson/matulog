function data = csv_topics_to_d( ulgFileName )
all_topics = dir(['*' ulgFileName '*.csv']);
h = waitbar(0,'Converting .ulg till .mat file. Please wait...');
steps = length(all_topics);
for i = 1:length(all_topics)
    waitbar(i / steps)
    tmp = strsplit(all_topics(i).name(1:end-4),[ulgFileName '_']);
    topic_i = tmp{2};
    data.(topic_i) = readtable(all_topics(i).name);
    fid = fopen(all_topics(i).name); % text mode: CRLF -> LF on windows (no-op on linux)
    tline = fgetl(fid);
    fclose(fid);
    data.(topic_i).Properties.VariableDescriptions = strsplit(tline,',');
end
close(h) 
end

