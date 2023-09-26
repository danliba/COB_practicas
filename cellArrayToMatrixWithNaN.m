function myMatrix = cellArrayToMatrixWithNaN(cellArray)
    % Determine the maximum number of rows and columns among the non-empty arrays
    maxRows = max(cellfun(@(x) size(x, 1), cellArray(~cellfun('isempty', cellArray))));
    maxCols = max(cellfun(@(x) size(x, 2), cellArray(~cellfun('isempty', cellArray))));

    % Initialize a matrix filled with NaN
    myMatrix = NaN(maxRows, maxCols, numel(cellArray));

    % Convert non-empty arrays to the matrix
    for i = 1:numel(cellArray)
        if ~isempty(cellArray{i})
            [rows, cols] = size(cellArray{i});
            myMatrix(1:rows, 1:cols, i) = cellArray{i};
        end
    end
end
