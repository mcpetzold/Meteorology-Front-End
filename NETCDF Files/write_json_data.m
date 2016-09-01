function [e_data, datafilename] = write_json_data(varname, vardata, filename)



%Dr. Mark Petzold
%St Cloud State University
%Visualization Lab
%July 28, 2016

dotpos = strfind(filename,'.'); %find the dot in the filename
datafilename = [filename(1:dotpos-1) '_' varname '.json']; 
%create a .json filename
datadim = length(size(vardata));  %get number of dimensions

fileID = fopen(datafilename,'w');  %open json file
fprintf(fileID, '{"%s":{', varname);  %start of json file, variable name
fprintf(fileID, '\n   "ArraySize": [ ');  %put array size in the file
datasize = size(vardata);  %get size of variable data
for k = 1:length(datasize)
    if k < length(datasize)
        fprintf(fileID, '%3i, ', datasize(k));  %write data size, comma
    else
        fprintf(fileID, '%3i ', datasize(k));   %write data size, no comma
    end
end
fprintf(fileID, '],\n   "Data":');  %write data descriptor
switch datadim  %switch statement for number of data dimensions
    case 2
        fprintf(fileID, '[');  %opening square brace
        for k = 1:size(vardata,1)  %for loop for rows
            for m = 1:size(vardata,2)  %for loop for columns
                if k < size(vardata,1) | m < size(vardata,2)  
                    %if statement for commas
                    fprintf(fileID,' %9.4f,',vardata(k,m));
                else
                    fprintf(fileID, ' %9.4f',vardata(k,m));
                end
            end
        end
        fprintf(fileID, ']\n     }\n');  %ending brackets
    case 3  %3 dimensional data
        fprintf(fileID, '[');  %opening square brace
        for g = 1:size(vardata,3)  %depth
            for k = 1:size(vardata,1)  %rows
                for m = 1:size(vardata,2) %columns
                    if m < size(vardata,2) | k < size(vardata,1) | g < size(vardata,3)
                        fprintf(fileID,' %9.4f,',vardata(k,m,g)); %commas
                    else
                        fprintf(fileID,' %9.4f',vardata(k,m,g));  %no comma
                    end
                end
            end
        end
        fprintf(fileID, ']\n     }\n');
    case 4  %4 dimensional data
        fprintf(fileID, '[');  %opening square brace
        for g = 1:size(vardata,4)  %time
            for h = 1:size(vardata,3) %depth
                for k = 1:size(vardata,1)  %rows
                    fprintf(fileID, ' %9.4f, ', vardata(k, :, h, g));
                end
            end
        end
        fprintf(fileID, '\b\b]\n     }\n');
    otherwise
        disp('Hello World')
end
fprintf(fileID,'}');
e_data = 0;
fclose(fileID);

