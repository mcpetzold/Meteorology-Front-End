function [e_num, varlist] = write_variables_json(fileID, ncid, nvars, dimname, filename, varnamelist, interpvalues)
%E_NUM = WRITE_VARIABLES_JSON(FILEID, NCID, NVARS, DIMNAME, FILENAME)
%Writes the variable information to a json file.  Creates separate files
%for the data contained in the variables.

%Dr. Mark Petzold
%St. Cloud State University
%Visualization Lab
%July 28, 2016
listinc = 1;
%disp(dimname)
interpamount = 0;
varlist = cell(nvars,1);
fprintf(fileID, '"Variables":{\n'); %write Variables keyword to file
for k = 0:nvars-1  %loop through the number of variables
    [varname, xtype, dimids, numatts] = netcdf.inqVar(ncid,k);
    %get variable information
    varlist{k+1} = varname;
    fprintf(fileID, '     "%s":{\n',varname);
    %write variable name to file
    switch xtype  %switch to select the actual data type from a number
        case 1
            xtypeString = 'NC_BYTE';
        case 2
            xtypeString = 'NC_CHAR';
        case 3
            xtypeString = 'NC_SHORT';
        case 4
            xtypeString = 'NC_INT';
        case 5
            xtypeString = 'NC_FLOAT';
        case 6
            xtypeString = 'NC_DOUBLE';
        otherwise
            xtypeString = num2str(xtype);
    end
    
    fprintf(fileID, '          "Datatype":"%s",\n',xtypeString);
    %write Datatype to file
    vardata = netcdf.getVar(ncid, k);
    %disp(interpvalues)
    %disp('write_variables_json')
    %interpolation routine
    dimstring = '';
    for m = 1:length(dimids)
        if m == 1
            dimstring = [dimname{dimids(m)+1}];
        else
            dimstring = [dimstring ', ' dimname{dimids(m)+1}];
        end
        
    end
    
    
   % disp(varnamelist)
    
    
    %uncomment this to write data files
    %disp(varname)
    switch varname
        case 'ztop'
            [e_data, datafilename] = write_json_data(varname, vardata, filename);
            fprintf(fileID, '          "Datafile":"%s",\n', datafilename);
        case 'time'
            [e_data, datafilename] = write_json_data(varname, vardata, filename);
            fprintf(fileID, '          "Datafile":"%s",\n', datafilename);
        case 'xh'
            
            if interpvalues(1) > 1
                vardata = onedinterp(vardata,interpvalues(1));
            end
            [e_data, datafilename] = write_json_data(varname, vardata, filename);
            fprintf(fileID, '          "Datafile":"%s",\n', datafilename);
        case 'xf'
            if interpvalues(2) > 1
                vardata = onedinterp(vardata,interpvalues(1));
            end
            vardata = onedinterp(vardata,interpamount);
            [e_data, datafilename] = write_json_data(varname, vardata, filename);
            fprintf(fileID, '          "Datafile":"%s",\n', datafilename);
        case 'yh'
            if interpvalues(1) > 1
                vardata = onedinterp(vardata,interpvalues(1));
            end
            vardata = onedinterp(vardata,interpamount);
            [e_data, datafilename] = write_json_data(varname, vardata, filename);
            fprintf(fileID, '          "Datafile":"%s",\n', datafilename);
        case 'yf'
            if interpvalues(2) > 1
                vardata = onedinterp(vardata,interpvalues(1));
            end
            vardata = onedinterp(vardata,interpamount);
            [e_data, datafilename] = write_json_data(varname, vardata, filename);
            fprintf(fileID, '          "Datafile":"%s",\n', datafilename);
        case 'z'
            if interpvalues(1) > 1
                vardata = onedinterp(vardata,interpvalues(1));
            end
            vardata = onedinterp(vardata,interpamount);
            [e_data, datafilename] = write_json_data(varname, vardata, filename);
            fprintf(fileID, '          "Datafile":"%s",\n', datafilename);
        case 'zf'
            if interpvalues(2) > 1
                vardata = onedinterp(vardata,interpvalues(1));
            end
            vardata = onedinterp(vardata,interpamount);
            [e_data, datafilename] = write_json_data(varname, vardata, filename);
            fprintf(fileID, '          "Datafile":"%s",\n', datafilename);
        otherwise
            for m = 1:size(varnamelist,1)
                if strcmp(varnamelist{m,1},varname)
                    %disp(varnamelist{m,1})
                    %disp(varname)
                    %disp(dimstring)
                    %strfind(dimstring,'ni, ')
                    
                    if varnamelist{m,2}
                        disp(dimstring)
                        strfind(dimstring(1),'ni,')
                        if ~isempty(strfind(dimstring,'ni,'))
                            disp(varname)
                            vardata = variableinterp(vardata, interpvalues(1)-1);
                        elseif ~isempty(strfind(dimstring,'nip1,'))
                            vardata = variableinterp(vardata, interpvalues(1)-1);
                        end
                        [e_data, datafilename] = write_json_data(varname, vardata, filename);
                        fprintf(fileID, '          "Datafile":"%s",\n', datafilename);
                    end
                end
            end
    end
    %get variable data from file
    fprintf(fileID, '          "Attributes":{\n');
    for m = 0:numatts-1
        varatt = netcdf.inqAttName(ncid, k, m);
        %disp(varatt)
        varattval = netcdf.getAtt(ncid, k, varatt);
        %disp(varattval)
        if m < numatts-1
            fprintf(fileID, '               "%s":"%s",\n',varatt, varattval);
        else
            fprintf(fileID, '               "%s":"%s"\n',varatt, varattval);
        end
    end
    fprintf(fileID, '                       },\n');
    %     disp(varname)
    %     disp(num2str(size(vardata)))
    
%     dimstring = '';
%     for m = 1:length(dimids)
%         if m == 1
%             dimstring = [dimname{dimids(m)+1}];
%         else
%             dimstring = [dimstring ', ' dimname{dimids(m)+1}];
%         end
%         
%     end
    fprintf(fileID, '          "Dimensions":["%s"]\n',dimstring);
    if k < nvars-1
        fprintf(fileID, '          },\n');
    else
        fprintf(fileID, '          }\n');
    end
    %fprintf(fileID, '     }\n');
    %     disp(string)
    %     disp(['     ' xtypeString])
    % end
end
fprintf(fileID, '     }\n');
e_num = 0;