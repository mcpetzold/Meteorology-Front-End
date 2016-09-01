function [err_out, varlist] = netcdf_json(filename, varnamelist, interpvalues)
%convert netcdf file to an equivalent json file.
%data gets stored in sub json files.
%Dr. Mark Petzold
%St. Cloud State University Visualization lab

%filename = 'cm1out.nc';  %filename of netcdf file
dotpos = strfind(filename,'.'); %find the dot in the filename
jsonfilename = [filename(1:dotpos) 'json']; %create a .json filename
ncid = netcdf.open(filename);  %open netcdf file
fileID = fopen(jsonfilename,'w');  %open json file

[ndims, nvars, natts, dimm] = netcdf.inq(ncid);  
    %get the parameters of the netcdf file

fprintf(fileID, '{'); %first curly brace of the json file
e_num = write_globals_json(fileID, ncid, natts);  
   %write the global variables to the json file

[dimname, e_numdim] = write_dimensions_json(fileID, ncid, ndims);
   %write dimensions to the json file

[e_numvars, varlist] = write_variables_json(fileID, ncid, nvars, dimname, filename,varnamelist, interpvalues);
%write the variable data to json files
fprintf(fileID, '}');  %close the json file
netcdf.close(ncid);  %close the netcdf file
err_out = 0;