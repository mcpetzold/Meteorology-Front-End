function select_data
%SELECT_DATA  MATLAB GUI interface for selecting meteorological data for
%the VIZLAB classroom system.

%Dr. Mark Petzold
%St. Cloud State University
%Visualization Lab

global varnamelist;  %variable list from the netcdf file
varnamelist = cell(30,3);  %initialize the variable list
hinterpdrop = zeros(2,1);  %initialize the interpolation drop-down handles
width = 1000;  %width of the figure window
height = 700;  %height of the figure window
%  Create and then hide the UI as it is being constructed.
f = figure('Visible','off', 'MenuBar','none',...
    'Name','Select Data','NumberTitle','off',...
    'Position',[360,50,width,height]);  %figure window for selecting data

%text to describe file select text box
htext = uicontrol('Style','text','String','Select File',...
    'Position',[50,(height - 25),60,15]);  

D = dir('*.nc');  %find all files that are netcdf
listNames = cell(1, length(D) + 1);  %create cell array
listNames(1) = {'<select file>'};  
%put in a null selection to force a selection
for k = 2:length(D)+1   %put names in cell array for the popup list box
    listNames(k) = {D(k-1).name};
end
%dropdown menu for the file names

hpopup = uicontrol('Style','popupmenu',...
    'String',listNames,...
    'Position',[25,(height - 50),175,25],...
    'Callback', @popup_menu_Callback);

%big old start button, probably should turn green when everything is ready
hstartprog    = uicontrol('Visible','off','Style','pushbutton',...
    'String','Start','Position',[50,60,70,25],...
    'Callback',@startbutton_Callback);


filename = '';  %initialize file name
ha = axes('Units','pixels','Position',[10,10,1347/4,161/4]);  
%place for logo
%ha.Color = 'Black';
im = imread('U_PriExHorz_Rev_BlkDkBG.png');  %scsu logo
image(im)  %put logo on figure


f.Visible = 'on';  %make figure visible

    function popup_menu_Callback(source, ~)
        %embedded function once the file is selected
        str = get(source, 'String');
        val = get(source, 'Value');  %get the file name
        
        filename = str{val};  %set the file name
        interp_data_menu(filename);  %call menu for interpolation
        select_data_menu(filename);  %call data select function
        
        hstartprog.Visible = 'on';  %turn on start button
        
    end

    function startbutton_Callback(~, ~)
        %callback after start button is pressed
        %check for a proper filename (shouldn't be an issue as the button
        %appears only after the filename is selected
        if isempty(filename)
            errordlg('No File Specified');  %produce error dialog
        else
            
            interpvalues = zeros(2,1);  %initialize the interp values
            %flag to make sure one thing is selected
            selectflag = 0;
            %check the checkboxes here and send that data to the json
            %writer
            %loop through the variable names
            for k = 1:size(varnamelist,1)
                varnamelist{k,2} = get(varnamelist{k,3}, 'Value'); 
                %determine which variables are checked
                if varnamelist{k,2} == 1
                    selectflag = 1; %if one variable is selected, flag it
                end
            end
            %if no data selected, tell user
            if selectflag == 0
                errordlg('Select at least one set of data'); %error dialog
            else
                %otherwise go on and get the interpolation values
                for n =1:length(hinterpdrop)
                    interpvalues(n) = get( hinterpdrop(n), 'Value');
                end
                %and start producing the appropriate json files
                %probably need to create a directory for all json files
                netcdf_json(filename, varnamelist, interpvalues);
            end
        end
    end


    function interp_data_menu(filename)
        %interpolation menu population
        
        ncid = netcdf.open(filename);  %open netcdf file
        [ndims, nvars, natts, dimm] = netcdf.inq(ncid);
        %get information from the netcdf file
        
        for k = 0:nvars-1  %loop through the number of variables
            [varname, xtype, dimids, numatts] = netcdf.inqVar(ncid,k);
            %get the variable names from the netcdf file
            vardata = netcdf.getVar(ncid, k);  %get variable data
            %switch on variable name
            switch varname
                case 'ztop'
                    
                case 'time'
                    %display time increment
                    dtime = max(diff(vardata));
                    hdtime = uicontrol('Style','text',...
                        'String',['Time Increment: ' num2str(dtime)] ,...
                        'HorizontalAlignment','left',...
                        'Position',[30,height - 75,150,15]);

                case 'xh'
                    %display x grid increment
                    dxh = max(diff(vardata));
                    hdxh = uicontrol('Style','text',...
                        'String',['West-East Grid Increment: ' num2str(dxh)] ,...
                        'HorizontalAlignment','left',...
                        'Position',[30,(height - 125),250,15]);
                case 'yh'
                    %display y grid increment
                    dyh = max(diff(vardata));
                    hdyh = uicontrol('Style','text',...
                        'String',['North-South Grid Increment: ' num2str(dyh)] ,...
                        'HorizontalAlignment','left',...
                        'Position',[30,(height - 150),250,15]);
                    
                case 'xf'
                    %display offset x grid increment
                    dxf = max(diff(vardata));
                    hdxf = uicontrol('Style','text',...
                        'String',['West-East Staggered Grid Increment: ' num2str(dxf)] ,...
                        'HorizontalAlignment','left',...
                        'Position',[30,(height - 275),250,15]);
                    
                    
                case 'yf'
                    %display offset y grid increment
                    dyf = max(diff(vardata));
                    hdyf = uicontrol('Style','text',...
                        'String',['North-South Staggered Grid Increment: ' num2str(dyf)] ,...
                        'HorizontalAlignment','left',...
                        'Position',[30,(height - 300),250,15]);
                    
                case 'z'
                    %display z grid increment
                    dz = max(diff(vardata));
                    hdz = uicontrol('Style','text',...
                        'String',['Height of z Grid Increment: ' num2str(dz)] ,...
                        'HorizontalAlignment','left',...
                        'Position',[30,(height - 175),250,15]);
                    
                case 'zf'
                    %display offset z grid increment
                    dzf = max(diff(vardata));
                    hdzf = uicontrol('Style','text',...
                        'String',...
                        ['Height of Staggered z Grid Increment: ' num2str(dzf)] ,...
                        'HorizontalAlignment','left',...
                        'Position',[30,(height - 325),250,15]);

                otherwise
                    %no otherwise
            end
            
        end
        %text for interpolation increment description for grid
        hdxh2 = uicontrol('Style','text',...
            'String','Desired Interpolation Increment' ,...
            'HorizontalAlignment','left',...
            'Position',[30,(height - 200),150,15]);
        %interpolation dropdown menu
        hinterpdrop(1) = uicontrol('Style','popupmenu',...
            'String',{'none', sprintf('%4.2fx',2), sprintf('%4.2fx',4), sprintf('%4.2fx',8)},...
            'Position',[25,(height - 225),150,25]);
        %text for interpolation increment description for offset grid
        hdxf2 = uicontrol('Style','text',...
            'String','Desired Grid Increment' ,...
            'HorizontalAlignment','left',...
            'Position',[30,(height - 350),150,15]);
        %interpolation dropdown menu
        hinterpdrop(2) = uicontrol('Style','popupmenu',...
            'String',{'none', sprintf('%4.2fx',2), sprintf('%4.2fx',4), sprintf('%4.2fx',8)},...
            'Position',[25,(height - 375),150,25]);
        %close netcdif files
        netcdf.close(ncid);
    end


    function select_data_menu(filename)
        %put data checkboxes on menu
        ncid = netcdf.open(filename);  %open netcdf file
        %get values from the file
        [ndims, nvars, natts, dimm] = netcdf.inq(ncid);
        %get the parameters of the netcdf file
        %initialize variable list handles
        hvar = zeros(1,nvars);
        %Initialize variable list variable to 1.  This doesn't track with
        %the for loop
        varlist = 1;
        %Initialize position list to 1.  This puts the checkbox at the
        %appropiate place on the figure.
        poslist = 1;
        %initialize the last variable value to nothing.  checks for
        %repeated variables
        lastvarattval = '';
        %left position for the checkboxes
        checkleft = 250;
        %for loop to loop through the variables
        for k = 0:nvars-1
            %get variable information
            [varname, xtype, dimids, numatts] = netcdf.inqVar(ncid,k);
            %check variable names for specific actions  Specifically ignore
            %certain variables
            switch varname
                case 'ztop'
                case 'time'
                case 'xh'
                case 'xf'
                case 'yh'
                case 'yf'
                case 'z'
                case 'zf'
                otherwise
                    %get variable attributes
                    varatt = netcdf.inqAttName(ncid, k, 0);
                    %get attribute values
                    varattval = netcdf.getAtt(ncid, k, varatt);
                    %check to see if the variable attribute value is
                    %repeated
                    if ~strcmp(varattval,lastvarattval)
                        %put the variable name in the variable name list
                        varnamelist{varlist,1} = varname;
                        %set up the check box for the variable
                        hvar(varlist) = uicontrol('Style','checkbox',...
                            'String',varattval,...
                            'Position',...
                            [checkleft,(height - 25 - 25*poslist),350,25]);
                        %save the handle to the checkbox
                        varnamelist{varlist,3} = hvar(varlist);
                        %increment varlist and poslist
                        varlist = varlist + 1;
                        poslist = poslist + 1;
                    end
                    %update lastvarattval
                    lastvarattval = varattval;
                    %if at the bottom of the column, move checkleft over
                    %and put poslist back to the top
                    if (height - 25 - 25*poslist) < 75
                        checkleft = checkleft + 350;
                        poslist = 1;
                    end
                    
            end
        end
        %close the netcdf file
        netcdf.close(ncid);
    end
end