function [dimname, e_num] = write_dimensions_json(fileID, ncid, ndims)
%E_NUM = WRITE_DIMENSIONS_JSON(FILEID, NCID, NDIMS)
%Write the dimensions from a netcdf file to a json file
%fileID is the file id of the json file, ncid is the file id of the
%netcdf file, and ndims is the number of dimensions to read in.

%Dr. Mark Petzold
%St. Cloud State University
%Visualization Lab
%July 28, 2016

fprintf(fileID, '"Dimensions":{\n'); %print Dimensions keyword
for k = 0:ndims-1  %loop through dimensions
    [dname dimlen] = netcdf.inqDim(ncid,k);  
        %read dimension name and length from file
    dimname{k+1} = dname;
        %put dimension names in a vector
    if k < ndims-1  %if loop to print dimension name and value
        fprintf(fileID, '     "%s":%f,\n',dname, dimlen); %comma
    elseif k == ndims-1
        fprintf(fileID, '     "%s":%f\n',dname, dimlen); 
             %last value no comma
    end
end
fprintf(fileID, '},\n');  %closing }
e_num = 0;  %success