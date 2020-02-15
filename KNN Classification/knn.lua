-----------------------------------------------------------------------------------------
--
-- knn.lua
--
-----------------------------------------------------------------------------------------
-- Require corona widget libraries.
local composer = require( "composer" )

-- Get file name and if file file exists.
file_name = composer.getVariable("file_name")
--print ("@knn.lua [file name: ] "..file_name)

-- Declare a table to hold the knn data from the csv file.
training_dataset = {}

-- Declare a table to store return values.
return_data = {}

-- Declare a table to store distance values.
euclideanDistance = {}
manhattanDistance = {}
cosineDistance = {}
chebyshevDistance = {}

distance_with_labels = {}
knn = {}
local pointCategory



-- Reading data from file.

-- Path for the file to read the knn data.
local path = system.pathForFile( file_name, system.ResourceDirectory)

if (path == nil) then

	fileFound = false
	return_data[0] = fileFound
	return return_data
else

	-- Open the file.
	local file, errorString = io.open(path, "r")

	-- Check if the file exists, if file not found, print an error message. Else, read the data in the file.
	if not file then

		print ("The specified file is not found! "..errorString)
		fileFound = false
		return_data[0] = fileFound
		return return_data
		
	else
		-- Store the csv data into a table as X,Y and the group that it belongs to.
		i = 1
		for line in file:lines() do

			local x_value, y_value, data_group = string.match(line, "(%d+),(%d+),(%a+)")

			-- Add values x, y and category respectively to the table.
			training_dataset[i] = { x_axis = x_value, y_axis = y_value, data_class = data_group}
			i = i + 1
			-- print ( line )
		end

		fileFound = true
		io.close( file )
	end

end

-- Function to calculate distances for the user selected option of calculation.
function calculateDistances(x, y, selectedOption)

    if (selectedOption == 1) then
        calculateEuclideanDistances(x, y)

    elseif (selectedOption == 2) then
        calculateManhattanDistance(x, y)

    elseif (selectedOption == 3) then
        calculateCosineSimilarity(x, y)

    elseif (selectedOption == 4) then
        calculateChebyshevDistance(x, y)

    end
end

-- Calculate Euclidean Distance.
function euclideanDistanceResolver(targetX, targetY, pointX, pointY)
	return math.sqrt(( math.pow((pointX - targetX),2) ) + (math.pow((pointY - targetY),2)))
end


function calculateEuclideanDistances(targetX, targetY)

	print ( "--- Euclidean Distance ---" )
	for i = 1, #training_dataset do

		euclideanDistance[i] = euclideanDistanceResolver(targetX, targetY, training_dataset[i].x_axis, training_dataset[i].y_axis) 
		distance_with_labels[i] = {index = i, distance = euclideanDistance[i], group = training_dataset[i].data_class, euclidean = euclideanDistance[i]}
	end

end

-- Calculate Manhattan Distance.
function manhattanDistanceResolver(targetX, targetY, pointX, pointY)
	return math.abs(pointX - targetX) + math.abs(pointY - targetY)
end

function calculateManhattanDistance(targetX, targetY)

    print ( "--- Manhattan Distance ---")
	for i = 1, #training_dataset do

		manhattanDistance[i] = manhattanDistanceResolver(targetX, targetY, training_dataset[i].x_axis, training_dataset[i].y_axis)
		print("Manhattan Distance:"..manhattanDistance[i])
		distance_with_labels[i] = {index = i, distance = manhattanDistance[i], group = training_dataset[i].data_class, euclidean = euclideanDistanceResolver( targetX, targetY, training_dataset[i].x_axis, training_dataset[i].y_axis) }
	end
end

-- Calculate Cosine Similarity.
function cosineSimilarityResolver(targetX, targetY, pointX, pointY)
	local numerator = ((pointX * pointY) + (targetX * targetY))
	local denominator = (math.sqrt(math.pow(pointX,2) + math.pow(targetX,2)) * (math.sqrt(math.pow(pointY,2) + math.pow(targetY,2))))
	local cosineSimilarity = numerator / denominator
	return cosineSimilarity
end


function calculateCosineSimilarity(targetX, targetY)

	print ("--- Cosine Distance ---")
	for i = 1, #training_dataset do

		cosineDistance[i] = cosineSimilarityResolver(targetX, targetY, training_dataset[i].x_axis, training_dataset[i].y_axis)
		distance_with_labels[i] = {index = i, distance = cosineDistance[i], group = training_dataset[i].data_class, euclidean = euclideanDistanceResolver( targetX, targetY, training_dataset[i].x_axis, training_dataset[i].y_axis) }
	end
end

-- Calculate Chebyshev Distance.
function chebyshevDistanceResolver(targetX, targetY, pointX, pointY)
	return math.max(math.abs(pointX - targetX), math.abs(pointY - targetY))
end


function calculateChebyshevDistance(targetX, targetY)

	print ("--- Chebyshev Distance ---")
	for i = 1, #training_dataset do

		chebyshevDistance[i] = chebyshevDistanceResolver(targetX, targetY, training_dataset[i].x_axis, training_dataset[i].y_axis)
		distance_with_labels[i] = {index = i, distance = chebyshevDistance[i], group = training_dataset[i].data_class, euclidean = euclideanDistanceResolver( targetX, targetY, training_dataset[i].x_axis, training_dataset[i].y_axis) }
	end
end

-- Function to compare.
function orderByAscending(distance1, distance2)
	return distance1.distance < distance2.distance
end 

-- Function to get nearest n number of neighbours.
function getNeighbours(kValue)
	print("K Value: "..kValue)
	table.sort(distance_with_labels, orderByAscending)
	for j = 1, kValue do
		knn[j] = {distance = distance_with_labels[j].distance, category = distance_with_labels[j].group, euclidean = distance_with_labels[j].euclidean }
		print("Distance:"..knn[j].distance.." Category: "..knn[j].category.." Euclid: " .. knn[j].euclidean)
	end
	return knn
end
     
-- Function to get category of neighbours.
function getCategory()
	local categoryA = 0
	local categoryB = 0
	for i = 1, #knn do
		if (distance_with_labels[i].group == "a") then
			categoryA = categoryA + 1
		else
			categoryB = categoryB + 1
		end
	end
	if categoryA > categoryB then
		return "a"		-- returns a if it has the highest count. ( input point then belongs to this category )
	else
		return "b"		-- returns b if it has the highest count. ( input point then belongs to this category )
	end
end

-- Function to get weighted nearest neighbours.
function weightedNearestNeighours()
	local prec = 1
	local current = prec + 1
	local weight
	local categoryA = 0
	local categoryB = 0
	for i = 1, #knn do
		weight = 1 / prec
		local distance = knn[i].distance
		local category = knn[i].category
		-- if (i > 1) then
		-- 	if (knn[i].distance == knn[i-1].distance) then
		-- 		prec = prec - 1
		-- 		weight = 1 / prec
		-- 		current = current - 1
		-- 	end
		-- end

		if (category == "a") then
			categoryA = categoryA + weight
		else
			categoryB = categoryB + weight
		end

		prec = prec + 1
		current = current + 1
		print("Category A:"..categoryA)
		print("Category B:"..categoryB)
	end

	if categoryA > categoryB then	-- ( return a or b according to highest count. input point belongs to this category)
		return "a"
	else
		return "b"
	end
end


-- Pass into a table.

return_data[0] = fileFound
return_data[1] = training_dataset
return_data[2] = distance_with_labels
return_data[3] = knn

--return_data = { Training_dataset = training_dataset, Distance_with_Labels = distance_with_labels, KNN = knn }

-- Return the table.

return return_data

--
-- (For Testing Purposes)
--
-- for i = 1, #distance_with_labels do
-- 	print("Index: "..distance_with_labels[i].index.." Distance: "..distance_with_labels[i].distance.." Group: "..distance_with_labels[i].group)
-- end
