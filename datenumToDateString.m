function dateStrings = datenumToDateString(datenumArray)
    % Initialize a cell array to store date strings
    dateStrings = cell(size(datenumArray));

    % Loop through the numeric array and convert datenum values to date strings
    for i = 1:size(datenumArray, 1)
        for j = 1:size(datenumArray, 2)
            % Check if the value is not NaN
            if ~isnan(datenumArray(i, j))
                % Convert datenum to date string
                dateStrings{i, j} = datestr(datenumArray(i, j), 'yyyy-mm-dd');
            else
                % Set NaN as an empty string
                dateStrings{i, j} = '';
            end
        end
    end
end
