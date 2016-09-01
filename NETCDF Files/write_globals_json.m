function e_num = write_globals_json(fileID, ncid, natts)
%E_NUM = WRITE_GLOBALS_JSON(FILEID, NCID, NATTS)
%Writes the global constants from a netcdf file to a json file.
%fileID = json file id
%ncid = netcdf file id
%natts = number of global variables

%Dr. Mark Petzold
%St. Cloud State University
%Visualization Lab
%July 28, 2016

fprintf(fileID, '"Globals":{\n'); %specify the globals
for k = 0:natts-1  %for loop to loop through all the variables
    global_att_name = netcdf.inqAttName(ncid,...
        netcdf.getConstant('NC_GLOBAL'),k);
         %get the global variable names
    att_value = netcdf.getAtt(ncid,netcdf.getConstant('NC_GLOBAL'),...
        global_att_name);
         %get the global variable values
    if isnumeric(att_value) & k < natts-1  %if loop to put the comma in the 
        %right place
        fprintf(fileID, '     "%s":%f,\n',global_att_name, att_value);  
        %comma for numeric value
    elseif ~isnumeric(att_value) & k < natts-1
        fprintf(fileID, '     "%s":"%s",\n',global_att_name, att_value);  
        %comma for string
    elseif isnumeric(att_value) & k == natts-1
        fprintf(fileID, '     "%s":%f\n',global_att_name, att_value);  
        %no comma for numeric value
    elseif ~isnumeric(att_value) & k == natts-1
        fprintf(fileID, '     "%s":"%s"\n',global_att_name, att_value);  
        %no comma for string
    end
end
fprintf(fileID, '},\n');  %closing { for the globals in the json file
e_num = 0;  %success!