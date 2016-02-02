% name: readsb
% author: Chris Proctor, SSAI / NASA GSFC OBPG
% syntax: [data, sbHeader, headerArray] = readsb(fileName, <optional argument pairings>)
% 
% readsb is designed to open and read data files that are in a SeaBASS 
% format (http://seabass.gsfc.nasa.gov/). Data outputs can be returned as either
% a cell array or as a structure, where the names of the data field headers 
% from the SeaBASS file are array field names (e.g. dataStruc.depth,
% dataStruc.chl, dataStruc.lw412). Additional (optional) outputs include a
% structure of the header, and cell arrays of the header and/or data
% matrix.
%
% Inputs Arguments:
%   
%   (required inputs)
%   FILENAME  
%       Syntax: readsb(FILENAME)
%       FILENAME must be the first argument. It is the name of the single
%       SeaBASS-formatted file you wish to load.
%   
%   (optional input arguments with their paired value indicated between < >)
%   SetMissingValue  <false (to disable) OR another number>
%       Example: readsb(FILENAME, 'SetMissingValue', false)
%             or readsb(FILENAME, 'SetMissingValue', -99999);
%       By default, readsb converts missing values (as specified in the metadata
%       header, e.g., /missing=-999) to NaN. Set this to false to preserve the
%       original number used for missing values, or set to a number of your
%       choice to replace all missing values in the data with your new number.
%   
%   SetBDLValue  <number or NaN>
%       Example: readsb(FILENAME, 'SetBDLValue', NaN)
%             or readsb(FILENAME, 'SetBDLValue', -777);
%       SetBDLValue is an optional parameter that can be set to a numeric 
%       value (including NaN). The chosen value will replace all "below_detection_limit" 
%       values ("BDL" values for short) in the data. This setting only has
%       an effect if the SeaBASS file contains the BDL header (many do not need it). 
%       BDL values are used as replacement values when a parameter was measured 
%       for but not found (i.e., concentrations were lower than could be detected 
%       by the instrument used.) BDL values are distinct from "missing" 
%       values as missing indicates that something wasn't measured or reported.
%
%   MakeStructure <true> (otherwise false by default)
%       Example: readsb(FILENAME, 'MakeStructure', true)
%       By default readsb outputs all values in a cell array. Set 
%       MakeStructure to true if you instead want data output as a structure. 
%       The structure will contain a field named for each data field 
%       (e.g. data.chl, data.phaeo, data.LU410, etc.)
%
%   NewTextFields <single dimensional cell array of strings>
%       Example: myNewFields = {'shipName', 'example2', 'example3'};
%                readsb(FILENAME, 'NewTextFields', myNewFields);
%             or readsb(FILENAME, 'NewTextFields', {'all'});
%
%       NewTextFields is an optional argument. If used, its value must be set 
%       to a single dimensional cell array of characters listing additional 
%       field names (not case sensitive) whose columns contain text data. 
%
%       Most data columns in SeaBASS files are numeric, however common 
%       examples of text data include "station", "cruise" or "type" and a 
%       few others listed below in defaultTextFieldNames. NewTextFields
%       MAY be used to identify the names of fields not already in that
%       list; it is not necessary to do so, though doing so may make readsb
%       read the file faster.
%
%       Entering just {'all'} as the input for NewTextFields will
%       cause the entire data block to be read as text. An example of why
%       you might use this option: if you just wanted to rearrange
%       or make minor edits to the file (doing little or no math), having all 
%       the columns as text simplifies the code needed to re-write it.
%   
%   DatenumTime <false> (otherwise true by default)
%       Example: readsb(FILENAME, 'DatenumTime', false);
%       DatenumTime is an optional argument. By default, "time"
%       (in the data block, if present) is converted from HH:MM:SS to MATLAB's 
%       datenum format. Additionally, a new column (or structure field) will be
%       added to the "data" output containing MATLAB's datenum time for every
%       measurement row in the original file (if necessary, that
%       information will be obtained from the header). Set to false to
%       disable these features.
%
%   FillAncillaryData <true> (false by default if this argument isn't used)
%       Example: readsb(FILENAME, 'FillAncillaryData', true);
%       FillAncillaryData is an optional argument. Set to true to force
%       readsb to create fields for lat, lon, depth, datenum in the data
%       output, based on the metadata header values (i.e., SeaBASS files 
%       leave such info in the metadata header if it is the same for the
%       entire file, but this duplicates the header info on every row, to
%       simplify your other scripts).
%
% Outputs:
%
%   A variable number of outputs (1-4) are supported. Sequentially they are:
%
%   [data, sbHeader, headerArray, dataArray] = readsb(FILENAME)
%
%   data (1st output) is by default a cell matrix, but will be a structure if the
%       'MakeStructure' argument is used.
%
%   sbHeader (2nd output) is a structure of the SeaBASS file's header where the fields
%       are based on metadata header names (e.g. sbHeader.missing)
%
%   headerArray (3rd output) is a cell array containing the verbatim contents of the SeaBASS
%       header. It can be useful if you are plan to re-write a file.
%
%   dataArray (the 4th output) is a cell array containing the data block.
%       Useful if you plan to minimally change the data and re-write
%       a SeaBASS file.
%
% Examples:
%   
%   [data, header] = readsb('myfile.csv');
%   [data, header, headerArray, dataArray] = readsb('myfile.txt', 'MakeStructure', true, 'FillAncillaryData', true, 'SetBDLValue', NaN);
%
% Notes:
%
% * This function is designed to work with files that have been properly
% formatted according to SeaBASS guidelines (i.e. Files that passed FCHECK).
% Some error checking is performed, but improperly formatted input files
% could cause this script to error or behave unexpectedly. Files
% downloaded from the SeaBASS database should already be properly formatted, 
% however, please email seabass@seabass.gsfc.nasa.gov and/or the contact listed
% in the metadata header if you identify problems with specific files.
%
% * It is always HIGHLY recommended that you check for and read any metadata
%   header comments and/or documentation accompanying data files. Information 
%   from those sources could impact your analysis.
%
% * MATLAB compatibility: readsb was developed primarily with R2011b & R2012b.
%
% /*=====================================================================*/
%                  NASA Goddard Space Flight Center (GSFC) 
%          Software distribution policy for Public Domain Software
% 
% The readsb code is in the public domain, available without fee for 
% educational, research, non-commercial and commercial purposes. Users may 
% distribute this code to third parties provided that this statement appears
% on all copies and that no charge is made for such copies.
%
% NASA GSFC MAKES NO REPRESENTATION ABOUT THE SUITABILITY OF THE SOFTWARE
% FOR ANY PURPOSE. IT IS PROVIDED "AS IS" WITHOUT EXPRESS OR IMPLIED
% WARRANTY. NEITHER NASA GSFC NOR THE U.S. GOVERNMENT SHALL BE LIABLE FOR
% ANY DAMAGE SUFFERED BY THE USER OF THIS SOFTWARE.
% /*=====================================================================*/

% Changelog:
% 2013-03-19: Initial Release
% 2013-04-08: Fixed problem caused when reading certain files with columns of text data.
% 2013-06-10: Major revisions were made to this function to enable it to automatically read files containing non-standard fields of text data without requiring additional user input.
% 2014-06-04: Added support for files with 'below_detection_limit header and a new error for files that have no rows of data.
% 2015-11-17: Added "all" option for newTextFields to read all data as text.
% 2015-12-02: Added 'fillancillarydata' option. Set various useful options enabled by default. Refined input syntax to accept logicals.

function varargout = readsb(fileName,varargin)

% Optional user argument/input validation and parsing
p = inputParser;
p.addRequired('fileName',@(x) ischar(x));

% These optional user input values must be true or false
validationFcn = @(x) isscalar(x) && (islogical(x) || x == 1 || x == 0);
p.addParameter('MakeStructure', false, validationFcn);
p.addParameter('DatenumTime', true, validationFcn);
p.addParameter('FillAncillaryData', false, validationFcn)

% SetMissingValue user input value must be numeric. Zero will be
% interpretted as false, disabling the functionality
validationFcn = @(x) (isnumeric(x) && isscalar(x)) || x == false;
p.addParameter('SetMissingValue', NaN, validationFcn);

% SetBDLValue user input must be numeric (including NaN)
validationFcn = @(x) isnumeric(x) && isscalar(x);
p.addParameter('SetBDLValue', false, validationFcn);

% NewTextFields must be entered as a single dimensional cell array of characters
validationFcn = @(x) iscell(x) && all(cellfun(@ischar, x)) && min(size(x)) == 1;
p.addParameter('NewTextFields', false, validationFcn)

p.parse(fileName,varargin{:});
optionalArgs = p.Results;

% Following is a list of standardized field names whose data columns should 
% include text. If you want to read data files that have other columns
% which include text, you may wish to speed up this function by adding their
% names to this list or list them in the 'NewTextFields' optional argument.
% Readsb will automatically detect text, so identifying fields ahead of
% time is usually unnecessary, though in some cases it can reduce run time.
knownTextFieldNames = {
     'cruise',...
     'chors_id',...
     'date_time',...
     'file',...
     'hpl_id',...
     'hplc_gsfc_id',...
     'instrument',...
     'sample',...
     'station',...
     'time',...
     'type',...   
     };
 
%% Read data

disp(['Reading ', fileName,'...']);
if ~exist(fileName, 'file')
   
    error('readsb:FileNotFound', 'Could not find or open file %s', fileName);
    
end

% Read in the entire data block as text
fileID = fopen(fileName, 'rt');
    allDataLines = textscan(fileID, '%s', 'Delimiter', '\n');
fclose(fileID);

% Read meta-data headers
[header, headerArray, nHeaderLines] = readsbheader(allDataLines);
allDataLines = allDataLines{1}(nHeaderLines + 1:end);
nDataRows = length(allDataLines);

if nDataRows == 0
   error('readsb:NoData', 'No data rows found in the file %s', fileName); 
end

fields = regexp(header.fields, ',', 'split');
% Error if any fields (names) are empty
if any( cellfun('isempty', fields) )
    error('readsb:EmptyDataFieldName', ['Empty name found when reading "fields" ',...
          'metadata header: %s'], fileName);
end

% Obtain the missing value from the header. There should be only 1 missing
% value in normal files, but error checking is performed just in case there 
% are unusual files with multiple values.
missing = header.missing;

if ischar(missing)

    splitMissing = regexp(missing, ',', 'split');

    for ix = 1:length(splitMissing)
    
        if ~isempty( str2num(splitMissing{ix}) ) %#ok<ST2NM>
            multipleMissing{ix} = str2num(splitMissing{ix}); %#ok<AGROW,ST2NM>
        end
        
    end
    
    missing = splitMissing{1};
    
elseif size(missing,2) > 1

    % Create a "multipleMissing" cell array
    for ix = 1:length(missing)
        multipleMissing{ix} = missing(ix); %#ok<AGROW>
    end

    missing = missing(1);
    
end
    
if exist('multipleMissing', 'var')
    
    warning('MATLAB:readsb:MultipleMissingValues',['Multiple missing values found ',...
            'in the meta-data header. SeaBASS headers normally have only a ',...
            'single missing value.']);
    
end

% Interpret delimiter from header delimiter field (space, comma or tab)
whitespace = [' ' '\b' '\t'];
switch lower(strtrim(header.delimiter))
    case 'comma',
        delimiter = ',';
    case 'space',
        delimiter = whitespace;
    case 'tab',
        delimiter = whitespace;
    otherwise
        error('readsb:InvalidDelimiter','File delimiter not recognized (acceptable delimiters are: space, comma or tab');
end

% add any user-defined text fields to the standard list
if iscell(optionalArgs.NewTextFields)
    
    % check for 'all' newTextFields option in which case the all data
    % fields will be interpreted as text
    if (numel(optionalArgs.NewTextFields) == 1) && (strcmpi(optionalArgs.NewTextFields,'all'))
        knownTextFieldNames = fields;
    else
        knownTextFieldNames(end+1:end+numel(optionalArgs.NewTextFields)) = optionalArgs.NewTextFields;% = [knownTextFieldNames, optionalArgs.NewTextFields];
    end
    
end

% find the column index of any known text fields in preparation for textscan
textColIndexes = getindex(fields, knownTextFieldNames);


% This loop exists so that if issues occur during textscan, each line can 
% be parsed to find the problematic (i.e. non-numeric) fields
warning('ON', 'MATLAB:readsb:TextDataDetected');
nLine = 1;
while nLine > 0 && nLine <= nDataRows

    [dataMatrix, textColIndexes, nLine] = readdata(fileName, nLine, fields, textColIndexes, nHeaderLines, delimiter, missing, allDataLines);

end

%%
% Replacement (i.e., "missing") values are automatically replaced with NaN 
% (unless the user disables or specifies some other replacement number). 
% The SetBDLValue may be used to replace below detection limit values with 
% NaNs or other user specified values.
setMissing = true;
if optionalArgs.SetMissingValue == 0
    setMissing = false;
end

setBDL = false;
if isfield(header, 'below_detection_limit') && ~islogical(optionalArgs.SetBDLValue) && optionalArgs.SetBDLValue ~= header.below_detection_limit
   setBDL = true;
end

if (setMissing || setBDL)
    
    for nField = 1:length(dataMatrix)

        if iscell(dataMatrix{nField})
           isText = true;
        else 
           isText = false;
        end       
        
        if setMissing
            
            % Replace all missing values (there should be only 1 missing value
            % but this loop deals with multiple missing... just in case.)
            numMissingValues = 1;
            if exist('multipleMissing', 'var')
                numMissingValues = length(multipleMissing);
            else
                multipleMissing{1} = missing;
            end

            for numMissing = 1:numMissingValues;

                dataMatrix{nField} = replacemissingvalues(dataMatrix{nField}, isText, multipleMissing{numMissing}, optionalArgs.SetMissingValue);

            end
            
        end
        
        if setBDL
            
            dataMatrix{nField} = replacemissingvalues(dataMatrix{nField}, isText, header.below_detection_limit, optionalArgs.SetBDLValue);
        
        end
        
    end
    
    missing = optionalArgs.SetMissingValue;
    
end

 
% If 'DatenumTime' set: if the time field exists, reformat "time" (HH:MM:SS)
%  with MATLAB datenums. Additionally, create new field called datenum.
if logical(optionalArgs.DatenumTime) == true
    
    % find time index and update that field
    if  ~isempty(getindex(fields, 'time'))
        dataMatrix(getindex(fields, 'time')) = { sbtime2datenum( dataMatrix{getindex(fields, 'time')}, missing ) }; 
    end
    
    % create new datenum data
    dataMatrix(end+1) = {makedatenum( dataMatrix, header, lower(fields) )};
    header.fields = [header.fields,',datenum'];
    fields{end+1} = 'datenum';

end


% FillAncillaryData
if logical(optionalArgs.FillAncillaryData) == true
    
    [newData, newFields] = fillancillarydata(dataMatrix,header);
    if ~isempty(newFields)
        
        dataMatrix = [dataMatrix,newData];
        header.fields = [header.fields,sprintf(',%s',newFields{:})];
        fields(end+1:end+numel(newFields)) = newFields;
        
    end
    
    % make datenum if not already created
    if ~ismember(fields,'datenum')
        
        dataMatrix(end+1) = {makedatenum( dataMatrix, header, lower(fields) )};
        header.fields = [header.fields,',datenum'];
        fields{end+1} = 'datenum';

    end
    
end


% Output data as a structure, only if optArg was set
if logical(optionalArgs.MakeStructure) == false

    data = dataMatrix;
    
else
    
    data = makestructure(dataMatrix,fields);

end


% readsb allows 1-4 outputs.
varargout = cell(1,nargout);

if nargout == 1
    varargout{1} = data;
elseif nargout == 2
    varargout{1} = data;
    varargout{2} = header;
elseif nargout == 3
    varargout{1} = data;
    varargout{2} = header;
    varargout{3} = headerArray;
elseif nargout == 4
    varargout{1} = data;
    varargout{2} = header;
    varargout{3} = headerArray;
    varargout{4} = allDataLines;
else
    error('readsb:TooManyOrFewOutputVars','Function was called with an improper amount of output variables. Please specify between 1 and 4 output variables.');
end


disp(['Finished reading ', fileName]);

end


%% -----------------------------------------------
% readsbheader
% Gather data from a SeaBASS meta-data header into a structure (and array)
% SeaBASS headers vary in length but always consist of the format:
% /begin_header
% /headera=XYZ
% /headerb=XYZ
% /...
% ! optional comments (anywhere in header)
% /end_header
function [sbHeader, headerArray, nHeaderLine] = readsbheader(allData)

    % Initialize SeaBASS header structure
    sbHeader = struct('investigators', NaN,...
    'affiliations', NaN,...
    'contact', NaN,...
    'experiment', NaN,...
    'cruise', NaN,...
    'station', NaN,...
    'documents', NaN,...
    'calibration_files', NaN,...
    'data_type', NaN,...
    'data_status', NaN,...
    'start_date', NaN,...
    'end_date', NaN,...
    'start_time', NaN,...
    'end_time', NaN,...
    'north_latitude', NaN,...
    'south_latitude', NaN,...
    'east_longitude', NaN,...
    'west_longitude', NaN,...
    'cloud_percent', NaN,...
    'wind_speed', NaN,...
    'wave_height', NaN,...
    'water_depth', NaN,...
    'measurement_depth', NaN,...
    'secchi_depth', NaN,...
    'delimiter', NaN,...
    'missing', -999.0,...
    'fields', NaN,...
    'units',NaN,...
    'comments','');
    
    maxBadLines = 5;
    badHeaderLines = 0;
    
    nHeaderLine = 1;
    headerLine = allData{1}{1};
    
    if strncmpi(headerLine, '/begin_header', 13)
           
        while nHeaderLine <= length(allData{1})
        
            if badHeaderLines > maxBadLines
                error('readsb:MoreThanMaxBadlines',...
                    ['More than maximum allowed failures (%d) due to ',...
                    'improperly formatted header lines.\nDouble check ',...
                    'that file is properly formatted for SeaBASS.'], maxBadLines);
            end

            headerArray(nHeaderLine) = {headerLine};
           
            % Record the header lines in a structure:    
            % Record comments ( i.e. beginning with "!" )
            if strncmp(headerLine, '!', 1)

                % Only record if a comment if text follows the "!"
                if length(headerLine) > 1

                    if isempty(sbHeader.comments)
                        sbHeader.comments = char(sbHeader.comments, headerLine);
                    else
                        sbHeader.comments = char(headerLine);
                    end

                end

            % Record header lines ( i.e. those beginning with "/" )
            elseif strncmp(headerLine, '/', 1)

                % Split the header line using '=' as the delimiter
                tokens = regexp(headerLine, '=', 'split', 'once');

                if strncmpi(tokens(1), '/end_header', 11)

                    break;

                elseif(size(tokens,2) == 2) 

                    name = makestructurename( lower(char(tokens(1))) );
                    % Remove any trailing brackets (e.g. 12:00:01[GMT] --> 12:00:01)
                    value = regexprep(strtrim( tokens{2} ), '(.+)\[.+\]$', '$1');
                    
                    % It is unnecessary to warn the user if a header
                    % VALUE is long (but still short enough it isn't truncated).  
                    % The warning is then turned back on in case the header 
                    % NAME is too long, because that can cause truncation)
                    identifier = 'MATLAB:namelengthmaxexceeded';
                    warning('off', identifier);
                    numValue = str2double(value);
                    warning('on', identifier);
                    
                    if isnan( numValue )
                        if strncmpi(value,'NA',2)
                            sbHeader.(name) = NaN;
                        else
                            sbHeader.(name) = value;
                        end
                    else % convert value to a number if it isn't text
                        sbHeader.(name) = numValue;
                    end
                    
                end

            % Warn user if the header line begins with some other character 
            else

                warning(['Unexpected character at beginning of header line # %2d.',...
                         '\nFound "%s",\n but was expecting line to begin with "/" or "!".\n'],...
                         nHeaderLine, headerLine );
                badHeaderLines = badHeaderLines + 1;

            end
            
            % Read next header line
            nHeaderLine = nHeaderLine + 1;
            headerLine = allData{1}{nHeaderLine};
      
        end    
        
    else
        error('File does not start with "/begin_header"');
    end

end


%% -----------------------------------------------
% readdata
% This function uses textscan to read the data block of a SeaBASS file.
% It returns the data matrix, as well as textColIndexes which is updated
% if any (unexpected) text data were encountered.
function [dataBlock, textColIndexes, nLine] = readdata(fileName, nLine, fields, textColIndexes, nHeaderLines, delimiter, missing, allDataLines)
fileID = fopen(fileName, 'rt');

% specify formats used to read data
formatSpec = repmat({'%f'}, 1, length(fields));
formatSpec = sprintf('%s', formatSpec{:});

for columnPosition = 1:length(textColIndexes)
    formatSpec( textColIndexes(columnPosition) * 2-1:textColIndexes(columnPosition) * 2 ) = '%s';
end

if ~isempty(strfind(delimiter, ' '))
    regexpDelimiter = '\s+';
else
    regexpDelimiter = delimiter;
end

try
    % If "/missing=" value is a number, run textscan without TreatAsEmpty
    if ~ischar(missing)
        
        dataBlock = textscan(fileID, formatSpec, 'HeaderLines', nHeaderLines,...
        'Delimiter', delimiter, 'MultipleDelimsAsOne', 1, 'ReturnOnError', 0);
        
    else

        dataBlock = textscan(fileID, formatSpec, 'HeaderLines', nHeaderLines,...
        'Delimiter', delimiter, 'MultipleDelimsAsOne', 1, 'ReturnOnError', 0,...
        'TreatAsEmpty', missing);

    end
    
    % This section double checks the length of the data block. If textscan
    % expected a column of numbers but finds certain text symbols,
    % (e.g. "123-456") it will misinterpret/overestimate the number of rows
    % the file contains without reporting an error. To address those cases
    % it is necessary to parse through the file a row at a time using regular
    % expressions to detect the problem. This process could theoretically 
    % be slow if the file is large (e.g. hyperspectral measurements).
    if length(dataBlock{1}) > length(allDataLines)

        warning('MATLAB:readsb:TextDataDetected','Non-standard field containing text data found while trying to read the file. Reading could be slow if the file is large.');
        % Disable this warning for the rest of the run; it is enabled earlier in
        % the run in case it was disabled during the last run.
        warning('OFF', 'MATLAB:readsb:TextDataDetected'); 
        
        problemColumnLocated = false;

        while (problemColumnLocated == false) && (nLine <= length(allDataLines))
            
            dataLine = regexp(allDataLines{nLine}, regexpDelimiter, 'split');
            [problemColumnLocated, textColIndexes] = parserow(dataLine, nLine, missing, textColIndexes, fields);
            nLine = nLine + 1;        
            
        end

    % if lengths are equal, and no other errors, the file was read successfully. Hooray!
    else
        nLine = -1;
    end

% Text data in the data matrix is typically the cause of the following errors
catch errorMsg 
     
    % check if the error was caused by text data
    if ~isempty( strfind(errorMsg.message, 'Trouble reading floating point number from file (row') );
        badRow = str2double( regexp(errorMsg.message, '(?<=row )\d+', 'match') );
    else
        % report other types of errors
        error(errorMsg.message);
    end
    
    % First check if badRow is in bounds. If it is, proceed and check if
    % textscan's error message correctly identified the row number
    % where the problem is (i.e. saving us the trouble of parsing for it)
    if badRow <= length(allDataLines)
    
        dataLine = regexp(allDataLines{badRow}, regexpDelimiter, 'split');
        [problemColumnLocated, textColIndexes] = parserow(dataLine, badRow, missing, textColIndexes, fields);    
        
        % However, if "badRow" had no problems (i.e. no unexpected text data), then
        % textscan was unsuccessful at pinpointing the row with bad data so it is necessary to go 
        % through the file line-by-line starting from the beginning (progress tracked by nLine).
        if problemColumnLocated == false
            
            while (problemColumnLocated == false) && (nLine <= length(allDataLines))
                
                dataLine = regexp(allDataLines{nLine}, regexpDelimiter, 'split');
                [problemColumnLocated, textColIndexes] = parserow(dataLine, nLine, missing, textColIndexes, fields);
                nLine = nLine + 1;
                
            end
            
        end
    
    % If the badRow index was greater than the length of allDataLines then
    % that indicates the file contains text data AND there is a delimiting problem 
    % (in textscan) due to text characters like "-" or ":". The file must be parsed
    % line-by-line.
    else
  
        warning('MATLAB:readsb:TextDataDetected','Non-standard field containing text data found while trying to read the file. Reading could be slow if the file is large.');
        % Disable this warning for the rest of the run; it is enabled earlier in
        % this function in case it was disabled during the last run.
        warning('OFF', 'MATLAB:readsb:TextDataDetected'); 
        
        problemColumnLocated = false;

        while (problemColumnLocated == false) && (nLine <= length(allDataLines))
            
            dataLine = regexp(allDataLines{nLine}, regexpDelimiter, 'split');
            [problemColumnLocated, textColIndexes] = parserow(dataLine, nLine, missing, textColIndexes, fields);
            nLine = nLine + 1;

        end
        
    end
    
    dataBlock = -1;
    
end

fclose(fileID);

end


%% -----------------------------------------------
% getindex
% Pass in a list of the fields and the names of target fields and their
% indexes (i.e. numbered column positions) within the fields list are returned
function indexes = getindex(allFields, targetFields)

    indexes = find( ismember(lower(allFields), lower(targetFields)) );

end


%% -----------------------------------------------
% parserow
% This function will search a data row for any text data. It requires a row 
% of data, the index of that row (nLine), indexes of text columns and fields 
function [problemColumnLocated, textColIndexes] = parserow(dataLine, nLine, missing, textColIndexes, fields)

    problemColumnLocated = false;

    for nColumn = 1:length(dataLine)

        % check each value to see if it is 1) non-numeric, 2) not the missing value, and 3) not already a column that is recognized as text
        if isnan(str2double(dataLine(nColumn))) && ~strcmp(dataLine(nColumn), num2str(missing)) && ~ismember(nColumn, textColIndexes)

            badFieldError = sprintf('Non-numeric value (%s) detected at row %d column %d (%s). Column loaded as text.',dataLine{nColumn}, nLine, nColumn, fields{nColumn});
            disp(badFieldError);
            % Add the detected column to the fields list.
            textColIndexes = [textColIndexes nColumn]; %#ok<AGROW>
            problemColumnLocated = true;

        end

    end

end


%%  -----------------------------------------------
% sbtime2datenum
% convert the "time" column into a MATLAB datenum
function formattedTime = sbtime2datenum(time, missing)
    
    formattedTime = NaN(numel(time), 1);
    valid = not( strcmp(time,num2str(missing)) );
    formattedTime(valid,1) = datenum(time(valid,1),'HH:MM:SS');
    formattedTime(valid,1) = formattedTime(valid,1) - floor(formattedTime(valid,1));
    formattedTime(~valid,1) = missing;
    
end


%%  -----------------------------------------------
% makedatenum
% create new data columns containing the datetime converted to MATLAB datenum format
function newDatenum = makedatenum( dataMatrix, header, fields )
    
    numRows = numel(dataMatrix{1});
    dates = NaN(numRows, 1);
    times = NaN(numRows, 1);
    newDatenum = NaN(numRows, 1);
    
    % determine how to construct the datenum from the different fields that
    % can be included in a SeaBASS file. In fields, it consists of some combo of:
    % date time year hour day minute (second) headerstartdate headerstartime
    
    % date
    if any(strcmpi(fields, 'date'))  %(from data)
        
        try
            if iscell(dataMatrix{getindex(fields, 'date')})
                dformat = repmat({'yyyymmdd'},numRows,1);
                dindex = dataMatrix{getindex(fields, 'date')};
                dates(:,1) = cellfun(@datenum, dindex, dformat );
            else %this is most common
                dates(:,1) = datenum(num2str(dataMatrix{getindex(fields, 'date')}), 'yyyymmdd'); 
            end
            
        catch errorMsg
        end
        
    elseif sum(ismember(fields,{'year','month','day'})) == 3 % year&month&day (from data)
        
        try           
            if iscell(dataMatrix{getindex(fields, 'year')})
                iyear = getindex(fields, 'year');
                imonth = getindex(fields, 'month');
                iday = getindex(fields, 'day');
                for k = 1:numRows
                    dates(k,1) = datenum(sprintf('%4s%02s%02s', dataMatrix{iyear}{k},dataMatrix{imonth}{k},dataMatrix{iday}{k}),'yyyymmdd');
                end
            else
                dates(:,1) = datenum( dataMatrix{getindex(fields, 'year')}, dataMatrix{getindex(fields, 'month')}, dataMatrix{getindex(fields, 'day')} );
            end
        catch errorMsg
        end
        
    else % get date from header
        
    	dates(:,1) = datenum( num2str(header.start_date), 'yyyymmdd');  

    end
    
    
    % time
    if any(strcmpi(fields, 'time'))

    	times(:,1) = dataMatrix{getindex(fields, 'time')};

    elseif sum(ismember(fields,{'hour','minute','second'})) >= 2  % hour&minute&(second) (from data fields)
        
        nzeros = zeros(numRows, 1);
        
        if any(ismember(fields,'second'))
            if ~iscell(dataMatrix{getindex(fields, 'second')})
                seconds = dataMatrix{getindex(fields, 'second')};
            else
                seconds = sprintf('%02d\n',dataMatrix{getindex(fields, 'seconds')}{:});
            end
        else %sometimes seconds-precision wasn't measured
            if ~iscell(dataMatrix{getindex(fields, 'hour')}) %see if hour was cell format and match/assume same format for seconds
                seconds = nzeros;
            else
                seconds = repmat({'00'},numRows,1);
            end
        end
        
        try
            if iscell(dataMatrix{getindex(fields, 'hour')}) && iscell(dataMatrix{getindex(fields, 'minute')})
                ihour = getindex(fields, 'hour');
                iminute = getindex(fields, 'minute');
                for k = 1:numRows
                    times(k,1) = rem( datenum(sprintf('%02s%02s%02s', dataMatrix{ihour}{k},dataMatrix{iminute}{k},seconds{k}),'HHMMSS'), 1);
                end
            else
                times(:,1) = datenum(nzeros, nzeros, nzeros, dataMatrix{getindex(fields, 'hour')}, dataMatrix{getindex(fields, 'minute')}, seconds);
            end
        catch errorMsg
        end
    
    else % get time from header
        
        if isnan(header.start_time)
            warning('MATLAB:readsb:DatenumTime:MissingTimeInfo','Measurement time not found in data block nor start_time header. Datenum data may be affected, check those values for accuracy before using');
            times(:,1) = 0;
        else
            times(:,1) = rem( datenum( header.start_time, 'HH:MM:SS'), 1 ); 
        end
    end
    
    if ~exist('errorMsg','var')
        newDatenum = dates + times;
    else
        warning('Errors occurred when trying to create a "datenum" column (i.e., serial date numbers for every data row):\n%s',errorMsg.message);
    end  
    
end


%%  -----------------------------------------------
% fillancillarydata
% Adds additional fields to the data block by finding values in the headers
% and duplicating them into their own columns (if not already present)
function [newData, newFields] = fillancillarydata(dataMatrix, header)
    
    % pairs of ("/fields" names : equivalent metadata-header-name)
    ancillaryFields = [{'lat','north_latitude'};...
                       {'lon','east_longitude'};...
                       {'depth','measurement_depth'}];

    fields = lower(regexp(header.fields, ',', 'split'));
    ancFieldIndexes = ~ismember((ancillaryFields(:,1)),fields);
    numFields = sum(ancFieldIndexes);
    newFields = ancillaryFields(ancFieldIndexes,1);
    newData = repmat( {NaN(numel(dataMatrix{1}),1)},1,numFields );
    
    % create any needed new fields
    for ix = 1:numel(newFields)
        
        newData{ix}(:,1) = header.(ancillaryFields{ancFieldIndexes(1),2});
        
    end

end


%% -----------------------------------------------
% makestructurename
% Turns mixed text into a string appropriate for a structure's field name.
% Any non-word or non-numeric characters are replaced with an underscore
% and leading and trailing underscores are removed. 
% (e.g. _Custom-Field.Name+ becomes Custom_Field_Name)
function fieldName = makestructurename(value)

    pattern = '[^\w]';
    fieldName = regexprep(lower(value), pattern, '_');
    fieldName = regexprep(fieldName, '_+$', '');
    fieldName = regexprep(fieldName, '^_+', '');
    % the prefix 'n' is added any field names beginning with a digit
    fieldName = regexprep(fieldName, '^(\d)', 'n$1');

end


%% -----------------------------------------------
% makestructure
% Converts a cell array into a structure using the field names from the
% metadata header as the names of the structure's fields
function newStructure = makestructure(cells, fields)
newStructure = struct;
fields = makestructurename(fields);

numCols = length(fields);
if length(unique(fields)) < numCols
    warning('MATLAB:readsbheaders:duplicateFieldNames',['This file contains ',...
        'duplicate field names.\nConsequently, its structure field names will ',...
        'be renamed with incrementing numbers (using a suffix of _n#) ',...
        'to avoid overwriting the duplicated field names']);
end

% Assign data into named structure fields. A few SeaBASS files might
% contain duplicate field names, so additional instances of the same name
% are given an incrementing numerical suffix (e.g. chl, chl_n1, chl_n2). If
% the program detects more than maxTries duplicates of a name, it will end
% in an error (that situation is unexpected to ever occur in a normal
% SeaBASS file.)
for col = 1:numCols
    
    if ~isfield(newStructure, fields{col})
        
        newStructure.(fields{col}) = cells{col};
        
    else
        
        suffix = 2;
        maxTries = 10;
        while isfield(newStructure, [fields{col}, '_n', num2str(suffix)])
            
            suffix = suffix + 1;
            if suffix > maxTries
                  
                 error('readSB:MakeStructure:tooManyNameDuplicates',...
                     ['A field name is duplicated more than %d times in this file. ',...
                     'Please verify the /fields line in the file is correct'], maxTries);
                 
            end
            
        end
        
        newStructure.([fields{col}, '_n', num2str(suffix)]) = cells{col};

    end
    
end

end


%% ---------------------------------------------
% replacemissingvalues
% SeaBASS files contain a header field called /missing with a single value 
% that represents missing values in the file. A number like -999 is often 
% used. The following function is provided to replace whatever the missing 
% values are with a numeric value of the users choice (NaN included).
% This function can also be used to make replacements for /below_detection_limit
function newCells = replacemissingvalues(cells, isText, oldMissingVal, newMissingVal)

if isText % If the data column is made up of text
    
    pattern = num2str(oldMissingVal);
    pattern = regexprep(pattern,'([-+]?\d+)(\.0*)?','$1(\.0*)?');
    cells = regexprep(cells,pattern,num2str(newMissingVal));
    
else % if the data column is numeric
    
    if ischar(oldMissingVal)
        
        cells(strcmpi(cells, oldMissingVal)) = newMissingVal;
        
        % textscan's TreatAsEmpty turns any text values into NaN, so this
        % next if statement replaces any of those newly created NaNs with 
        % the newMissingVal (Unless newMissingVal is NaN; then it can skip)
        if ~isnan(newMissingVal)
            cells(isnan(cells)) = newMissingVal;
        end
        
    else % missing value is numeric
        
        cells(cells == oldMissingVal) = newMissingVal;
        
    end

end

newCells = cells;

end
