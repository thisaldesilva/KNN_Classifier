-----------------------------------------------------------------------------------------
--
-- view2.lua
--
-----------------------------------------------------------------------------------------
-- Require data.
local processed_data = require( "knn" )
local widget = require( "widget" )
local composer = require( "composer" )
local scene = composer.newScene()

-- Declaring global variables.
local xCoordinateField
local yCoordinateField
local kValueField
local gap
local pointX
local pointY
local inputPointCategory = ""
local existingPoint

local training_dataset = return_data[1]
local knn = return_data[3]
local point
local existingPoint
local neighbourRange
local radius
local buttonPress

-- Declare variables to store user selected options from view1.
local selectedOption = composer.getVariable( "selectedOption" )
local selectedVoteOption = composer.getVariable( "selectedVoteOption" )
-----------------------------------------------------------------------------------------
--
-- Create event listeners for text fields.
--

local function textListenerXField( event )

	if ( event.phase == "ended" or event.phase == "submitted" or event.phase == "editing" ) then
		
		xCoordinateField = event.target.text
		local field = "X Coordinate"

		if(xCoordinateField == "" or xCoordinateField == nil) then
			field = ""
			
		elseif (( tonumber( event.target.text ) < 0 ) or ( tonumber( event.target.text ) > 10 )) then
			displayError(xCoordinateField, field)
			event.target.text = ""

		end
		print( "X Coordinate: "..event.target.text)
	end
end

local function textListenerYField( event )
 
	if ( event.phase == "ended" or event.phase == "submitted" or event.phase == "editing" ) then
		
		yCoordinateField = event.target.text
		local field = "Y Coordinate"

		if(yCoordinateField == "" or yCoordinateField == nil) then
			field = ""
			
		elseif ((tonumber(event.target.text) < 0) or (tonumber(event.target.text) > 10)) then
			displayError(yCoordinateField, field)
			event.target.text = ""
		end

		print( "Y Coordinate: "..event.target.text )
	end
end

local function textListenerKValue( event )

	if ( event.phase == "ended" or event.phase == "submitted" or event.phase == "editing" ) then

		kValueField = event.target.text
		local field = "K Value"
		
		if(kValueField == "" or kValueField == nil) then
			field = ""
			
		elseif ((tonumber(event.target.text) <= 0) or (tonumber(event.target.text) > 20)) then
			displayError(kValueField, field)
			event.target.text = ""
		end

		print( "K Value: "..event.target.text)
	end
end

-- Event to handle back button press (on device)
local function onKeyEvent( event )
	print("Key '" .. event.keyName .. "' was pressed " .. event.phase)

	if ( system.getInfo("platform") == "android" ) then	-- fire only for android devices.
		if (event.keyName == "back" ) then
			if (neighbourRange ~= nil and userInputPoint ~= nil) then
				display.remove(neighbourRange)
				display.remove(userInputPoint)
			end
			composer.gotoScene("view1")
		return true
		end
	end
	return false
end

-- Button event listeners.
function handleGenerateButtonEvent( event )

	if ( event.phase == "began" ) then
		audio.play ( buttonPress )
    end

	if (xCoordinateField == nil or yCoordinateField == nil or kValueField == nil ) then	-- validate empty fields.
		local field = ""
		local error = ""
		displayError(error, field)	-- call function to throw error message.
	end

	if (neighbourRange ~= nil and userInputPoint ~= nil) then
		display.remove(neighbourRange)
		display.remove(userInputPoint)
	end

	if ( (xCoordinateField ~= "" and yCoordinateField ~= "" and kValueField ~= "") and "ended" == event.phase ) then	-- if button is pressed and released
		
		local x = tonumber(xCoordinateField)
		local y = tonumber(yCoordinateField)
		local k = tonumber(kValueField)

		calculateDistances(x , y, selectedOption)	-- calculate the distance
		if (selectedVoteOption == 1) then

			getNeighbours(k)	-- get the nearest k number of neighbours.
			inputPointCategory = getCategory()		-- get the category of user entered point based knn algorithm.
			print("Category your point belongs to: "..inputPointCategory)

		elseif (selectedVoteOption == 2) then
			getNeighbours(k)		-- get the nearest k number of neighbours.
			inputPointCategory = weightedNearestNeighours()		-- get the category by applying harmonic series.
			print("Category your point belongs to (using harmonic series): "..inputPointCategory)
		end

		print ( "Button was pressed and released")
		inputPoint(x, y, k)		-- draw input point on graph.
		resultsText.text = "New point belongs to Category: "..tostring(inputPointCategory)

	end
end

function handleBackButtonEvent( event )		-- handle back button.
	
	if ( event.phase == "began" ) then
		audio.play ( buttonPress )	-- play sound effect on button press.
    end
	
	if ( "ended" == event.phase ) then

		local options = {
			effect = "slideRight",	
			time = 400,
		}
			composer.removeScene("view2")	
			composer.gotoScene("view1", options)		-- change the scene.	
	end
end

function displayError(errorText, field)
	-- Show pop up alerts.
	local message
	local alert 

	if ( errorText == nil ) then
		message = "The "..field.." Field cannot be empty! Please enter a value between 0 and 10."
		alert = native.showAlert( "K-Nearest Neighbour",message, { "OK" })
		timer.performWithDelay( 6000, alert )

	elseif ( errorText == "" and field == "" ) then
		message = "The fields cannot be empty!"
		alert = timer.performWithDelay( 2000, native.showAlert( "K-Nearest Neighbour",message, { "OK" }))

	elseif (errorText ~= nil ) then
		message = "Invalid value! Please enter a valid value."
		alert = timer.performWithDelay( 1000, native.showAlert( "K-Nearest Neighbour",message, { "OK" }))
	end
end

-----------------------------------------------------------------------------------------
--
-- Create scene
--
function scene:create( event )
	local sceneGroup = self.view
	
	-- Called when the scene's view does not exist.

	-- add the sound file for button click.
	buttonPress = audio.loadSound( "sound_effect_click.mp3")
	
	-- create a white background to fill screen
	local background = display.newRect( display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight )
	background:setFillColor( 1 )	-- white

	local header = display.newRect( display.contentCenterX, display.actualContentHeight - 740, display.actualContentWidth, 160 )
	header:setFillColor( 0.0196, 0.1843, 0.3098 )
	
	-- create title text
	local title = display.newText( "K- Nearest Neighbour", display.contentCenterX , 90, "Roboto-Black.ttf", 35)
	title:setFillColor( 1 )

	local subTitle = display.newText("Machine Learning Classifier", display.contentCenterX, 130, "Roboto-Bold.ttf", 18)
	subTitle:setFillColor( 1 )
	
	local textBoxBackground = display.newRect( header.x, header.y + 200, display.actualContentWidth, 240)
	textBoxBackground:setFillColor( 1 )

	local xValueText = { text = "X Coordinate: ", 
							x = display.contentCenterX - 100, 
							y = subTitle.y + 50, 
							width = 310, 
							height = 20, 
							font = "Roboto-Black.ttf", 
							fontSize = 16, 
							align = "center" }

	local xValue = display.newText( xValueText )
	xValue:setFillColor( 0 ) -- black

	inputXCoordinate = native.newTextField( display.contentCenterX + 50, xValue.y, 170, 30 )
	inputXCoordinate:addEventListener( "userInput", textListenerXField )
	inputXCoordinate.inputType = "decimal"
	inputXCoordinate.placeholder = "Enter a numeric value"
	inputXCoordinate.maxLen = 2

	local yValueText = { text = "Y Coordinate: ", 
							x = display.contentCenterX - 100, 
							y = xValueText.y + 40, 
							width = 310, 
							height = 30, 
							font = "Roboto-Black.ttf", 
							fontSize = 16, 
							align = "center" }

	local yValue = display.newText( yValueText )
	yValue:setFillColor( 0 ) -- black

	inputYCoordinate = native.newTextField( display.contentCenterX + 50, yValue.y - 2, 170, 30 )
	inputYCoordinate:addEventListener( "userInput", textListenerYField )
	inputYCoordinate.inputType = "decimal"
	inputYCoordinate.placeholder = "Enter a numeric value"

	local kValueText = { text = "K Value: ",
							x = display.contentCenterX - 80,
							y = yValueText.y + 40,
							width = 310,
							height = 30,
							font = "Roboto-Black.ttf",
							fontSize = 16,
							align = "center" }

	local kValue = display.newText( kValueText)
	kValue:setFillColor( 0 ) -- black

	inputKValue = native.newTextField(display.contentCenterX + 50, kValue.y - 3, 170, 30 )
	inputKValue:addEventListener( "userInput", textListenerKValue )
	inputKValue.inputType = "number"
	inputKValue.placeholder = "Enter a numeric value"

	local generate = widget.newButton(
		{
			label = "Generate",
			onEvent = handleGenerateButtonEvent,
			emboss = false,
			shape = "roundedRect",
			width = 100,
			height = 35,
			cornerRadius = 8,
			font = "Roboto-Bold.ttf",
			fontSize = 16,
			fillColor = { default = { 0.0196, 0.1843, 0.3098 }, over = { 1, 1, 1 } },
			labelColor = { default={ 1, 1, 1 }, over={ 0.0196, 0.1843, 0.3098 } },
			strokeColor = { default= {1, 1, 1}, over= {1,1,1}},
			strokeWidth = 4
		}
	)

	generate.x = display.contentCenterX
	generate.y = display.contentCenterY - 105

	local results = {
		text = " Enter a new value to determine its class",
		x = generate.x,
		y = generate.y + 40,
		width = 400,
		font = "Roboto-Bold.ttf",
		fontSize = 16,
		align = "center"

	}

	resultsText = display.newText ( results )
	resultsText:setFillColor ( 0 ) 

	-- create legend.

	local legendParamA = {
		text = "a - ",
		x = (display.actualContentWidth / 3) - 45,
		y = resultsText.y + 25,
		width = 400,
		font = "Roboto-Bold.ttf",
		fontSize = 16,
		align = "center"
	}

	local legendTextA = display.newText ( legendParamA )
	legendTextA:setFillColor ( 0 )

	legendPointA = display.newCircle( legendTextA.x + 20 , legendTextA.y  , 8)	
	legendPointA:setFillColor( 0.929, 0.462, 0.054 )	-- orange

	local legendParamB = {
		text = "b -",
		x = legendTextA.x + 80,
		y = legendTextA.y,
		width = 400,
		font = "Roboto-Bold.ttf",
		fontSize = 16,
		align = "center"
	}

	local legendTextB = display.newText ( legendParamB )
	legendTextB:setFillColor ( 0 )

	legendPointB = display.newCircle( legendTextB.x + 20, legendTextB.y  , 5)	
	legendPointB:setFillColor( 0.929, 0.054, 0.247 )	-- magenta

	local legendParamC = {
		text = "New point -",
		x = legendParamB.x + 100,
		y = legendParamB.y,
		width = 400,
		font = "Roboto-Bold.ttf",
		fontSize = 16,
		align = "center"
	}

	local legendTextC = display.newText ( legendParamC )
	legendTextC:setFillColor ( 0 )

	legendPointNew = display.newCircle( legendTextC.x + 50, legendTextC.y , 6)	
	legendPointNew:setFillColor( 0.0196, 0.1843, 0.3098 )	-- blue

	-- create graph to display the points.
	local graphImage = display.newImageRect("Graph.png", 366, 366)
	graphImage.stroke = paint
	graphImage.strokeWidth = 4
	graphImage.strokeColor = 0
	graphImage.x = display.contentCenterX
	graphImage.y = display.contentCenterY + 158

	-- create back button.
	local back = widget.newButton(
		{
			label = "Back",
			onEvent = handleBackButtonEvent,
			emboss = false,
			shape = "roundedRect",
			width = 60,
			height = 30,
			cornerRadius = 5,
			font = "Roboto-Bold.ttf",
			fontSize = 17,
			fillColor = { default = { 0.0196, 0.1843, 0.3098 }, over = { 1, 1, 1 } },
			labelColor = { default={ 1, 1, 1 }, over={ 0.0196, 0.1843, 0.3098 } },
			strokeColor = { default= {1, 1, 1}, over= {0.0196, 0.1843, 0.3098}},
		}
	)

	back.x = display.contentCenterX - 130
	back.y = display.contentCenterY + 375

	-- Get the coordinates (0,0) on the graph.
	pointX = graphImage.x - 154.5
	pointY = graphImage.y + 158

	-- Get difference between two points of an axis on the graph.
	gap = 31 --(graphImage.x - 122.5) - pointX
	print("Gap:"..gap)

	-- all objects must be added to groups (e.g. self.view)
	sceneGroup:insert( background )
	sceneGroup:insert( header )
	sceneGroup:insert( title )
	sceneGroup:insert( subTitle )
	sceneGroup:insert( graphImage )
	

	-- Function to insert a point on the graph to display the training data set values.
	local function insertPoint(pointX, pointY, x, y, gap, category)

		if (category == "a") then
			existingPoint = display.newCircle(pointX + (x * gap) , pointY - (y * gap) , 8)	
			existingPoint:setFillColor(0.929, 0.462, 0.054) 	-- orange
		else
			existingPoint = display.newCircle(pointX + (x * gap) , pointY - (y * gap) , 5)
			existingPoint:setFillColor(0.929, 0.054, 0.247) 	-- magenta
			
		end
	
		sceneGroup:insert( existingPoint )
		
	end
	
	-- function to display user input ( new point ) point on the graph wih the range of selected number of neighbours.
	function inputPoint( inputXCoordinate, inputYCoordinate, kValue )

		local userPointParams = {
			time = 3000,
			iterations = 2,
		}

		userInputPoint = display.newCircle(pointX + (inputXCoordinate * gap) , pointY - (inputYCoordinate * gap) , 6)
		userInputPoint:setFillColor(0.0196, 0.1843, 0.3098)	-- blue
		transition.blink ( userInputPoint, userPointParams )
	
		radius = knn[kValue].euclidean
		print( "Radius: "..radius )
	
		neighbourRange = display.newCircle(pointX + (inputXCoordinate * gap) , pointY - (inputYCoordinate * gap) , 5)--radius * gap)
		neighbourRange:setFillColor(0.0196, 0.1843, 0.3098)
		neighbourRange:setStrokeColor(0.0196, 0.1843, 0.3098)
		neighbourRange.alpha = 0.20
		neighbourRange.strokeWidth = 2

		transition.to ( neighbourRange.path, { time = 1500, delay = 100, radius = radius * gap})	-- play animation.

		timer.performWithDelay ( 3000, transition.cancel( userInputPoint ) )	-- cancel animation.

		sceneGroup:insert( userInputPoint )
		sceneGroup:insert( neighbourRange )
	end

	for i = 1, #training_dataset do
		local xCoordinate = training_dataset[i].x_axis
		local yCoordinate = training_dataset[i].y_axis
		local pointCategory = training_dataset[i].data_class
		local point = insertPoint(pointX, pointY, xCoordinate, yCoordinate, gap, pointCategory)
	end

	local footer = display.newRect(display.contentCenterX, display.actualContentHeight - 10, display.actualContentWidth, 100 )
	footer:setFillColor( 0.0196, 0.1843, 0.3098 )

	-- all objects must be added to groups (e.g. self.view)

	local inputSets = display.newGroup()
	inputSets:insert ( textBoxBackground )
	inputSets:insert( xValue )
	inputSets:insert( inputXCoordinate )
	inputSets:insert( yValue )
	inputSets:insert( inputYCoordinate )
	inputSets:insert( kValue )
	inputSets:insert( inputKValue )
	inputSets:insert( generate )
	inputSets:insert( resultsText )
	inputSets:insert ( legendTextA )
	inputSets:insert( legendPointA )
	inputSets:insert( legendTextB )
	inputSets:insert( legendPointB )
	inputSets:insert ( legendTextC )
	inputSets:insert( legendPointNew )
	
	sceneGroup:insert( inputSets )
	sceneGroup:insert( footer )
	sceneGroup:insert( back )
	
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then

		-- Called when the scene is now on screen

	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		
		
	elseif phase == "did" then
		sceneGroup:removeSelf()

		print("INSIDE HIDE ")
		

		-- Called when the scene is now off screen
	end
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 

	inputXCoordinate.isVisible = false
	inputYCoordinate.isVisible = false
	inputKValue.isVisible = false

	display.remove( background )
	display.remove( header )
	display.remove( title )
	display.remove( subTitle )
	display.remove( resultsText )
	display.remove( graphImage )
	display.remove( existingPoint )
	display.remove( userInputPoint )
	display.remove( neighbourRange )
	display.remove( back )
	display.remove( footer )
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
Runtime:addEventListener( "key", onKeyEvent)

-----------------------------------------------------------------------------------------

return scene
