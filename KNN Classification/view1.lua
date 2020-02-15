-----------------------------------------------------------------------------------------
--
-- view1.lua
--
-----------------------------------------------------------------------------------------
local widget = require( "widget")
local composer = require( "composer" )
local scene = composer.newScene()

local selectedOption = 0
local selectedVoteOption = 0
local switch1, switch2, switch3, switch4
local simpleVoteSwitch, harmonicVoteSwitch
local buttonPress
local file = "knn.csv"

composer.setVariable("file_name", file)

-- Event listener for reading the file.
local function textListenerfileField( event )

	if ( event.phase == "ended" or event.phase == "submitted" or event.phase == "editing" ) then

			file = string.lower(event.target.text)..".csv"
			composer.setVariable("file_name", file)
			print( "Filename: "..file)
	end
end
  
-- Event listener for button "Next"
local function handleButtonEvent( event )

	if ( event.phase == "began" ) then
		audio.play ( buttonPress )
	end

	if ( "ended" == event.phase or event.phase == "submitted" ) then

		local knn = require("knn")
		print ("Filename:".. file)
		local alert
		local fileFound = knn[0]

		if (file == "") then	-- If no data file.
			alert = native.showAlert( "K-Nearest Neighbour",errorMessage(), { "OK" } )

		elseif (selectedOption == 0 or selectedVoteOption == 0) then	-- If user has not selected a distance method or weighting method,
			alert = native.showAlert( "K-Nearest Neighbour",errorMessage(), { "OK" } )	-- Show alert.

		elseif ( fileFound == false ) then
			alert = native.showAlert( "K-Nearest Neighbour","Specified File Not Found.", { "OK" } )
			--fileFound = nil

		else
			local options = {
				effect = "slideLeft",
				time = 400,
			}
			composer.removeScene("view1")
			composer.gotoScene( "view2", options)	-- Go to next scene (view2)
			
		end

		print ( "[Next] button was pressed and released")
	end
end

-- Module to handle error messages displayed.
function errorMessage()

	if (file == "" or file == nil) then	-- If no file selected.
		return "Please enter a data file name!"

	elseif (selectedOption == 0 and selectedVoteOption ~= 0) then	-- If no Distance metric selected.
		return "Please choose a preferred Distance Metric."

	elseif (selectedOption ~= 0 and selectedVoteOption == 0) then	-- If no weighting option selected.
		return "Please choose a preferred Voting Algorithm."

	else
		return "Please select your preferences."	-- If both options not selected.
	end
end

-- Event listener for distance metric selection (radio buttons).
local function onDistanceRadioButtonPress( event )

	local switch = event.target

	if (switch1.isOn == true) then
		selectedOption = 1	-- Euclidean Distance
		print(switch.id.." is selected")

	elseif (switch2.isOn == true) then
		selectedOption = 2	-- Manhattan Distance
		print(switch.id.." is selected")

	elseif (switch3.isOn == true) then
		selectedOption = 3	-- Cosine Similarity
		print(switch.id.." is selected")

	elseif (switch4.isOn == true) then
		selectedOption = 4	-- Chebyshev Distance
		print(switch.id.." is selected")
	end

	composer.setVariable("selectedOption", selectedOption)	-- set variable to 'selectedOption'
end

-- Event listener for weight options selection. (radio buttons)
local function onVoteRadioButtonPress ( event )

	local voteSwitch = event.target

	if (simpleVoteSwitch.isOn == true) then
		selectedVoteOption = 1			-- unit weights (simple vote)
		print (voteSwitch.id.." is selected")

	elseif (harmonicVoteSwitch.isOn == true) then
		selectedVoteOption = 2			-- harmonic weights
		print (voteSwitch.id.." is selected")
	end

	composer.setVariable("selectedVoteOption", selectedVoteOption)
end

function scene:create( event )
	local sceneGroup = self.view

	-- add the sound file for button click.
	buttonPress = audio.loadSound( "sound_effect_click.mp3")

	-- Code to initialize the scene
	-- create a background to fill the screen
	local background = display.newRect( display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight )
	background:setFillColor( 1 )	-- white

	-- create a header.
	local header = display.newRect( display.contentCenterX, (display.actualContentHeight / 2) - 340, display.actualContentWidth, 150 )
	header:setFillColor( 0.0196, 0.1843, 0.3098 )
	
	-- create title text.
	local title = display.newText( "K- Nearest Neighbour", display.contentCenterX , header.y + 10, "Roboto-Black.ttf", 30)
	title:setFillColor( 1 )

	--create subtitle text.
	local subTitle = display.newText("Machine Learning Classifier", display.contentCenterX, title.y + 35, "Roboto-Bold.ttf", 17)
	subTitle:setFillColor( 1 )

	-- create text objects and text field for data input file (CSV file).
	local fileTextDesc = { text = "CSV file name: ",
							x = display.contentCenterX - 100,
							y = subTitle.y + 80,
							width = 310,
							height = 30,
							font = "Roboto-Bold.ttf",
							fontSize = 18,
							align = "center" }

	local fileText = display.newText( fileTextDesc)
	fileText:setFillColor( 0 ) -- color black

	fileField = native.newTextField(display.contentCenterX + 35, fileText.y - 3, 145, 30 )
	fileField:addEventListener( "userInput", textListenerfileField )
	fileField.inputType = "default"
	fileField.placeholder = "Enter file name"
	fileField.text = "knn"

	local fileTextDesc2 = { text = ".csv",
							x = display.contentCenterX + 130,
							y = subTitle.y + 80,
							width = 310,
							height = 30,
							font = "Roboto-Bold.ttf",
							fontSize = 18,
							align = "center" }

	local fileText2 = display.newText (fileTextDesc2)
	fileText2:setFillColor( 0 )

	-- create selection 1 text object.
	local newTextParams = { text = "Select preferred Distance Metric: ", 
						x = display.contentCenterX - 35, 
						y = fileField.y + 100, 
						width = 310, 
						height = 100, 
						font = "Roboto-Regular.ttf", 
						fontSize = 17, 
						align = "center" }

	local summary = display.newText( newTextParams )
	summary:setFillColor( 0 ) -- black

	-- create radio button options to select the distance metric preferred.
	local euclideanOption = {
		id = "euclidean_option",
		x = display.contentCenterX - 120,
		y = summary.y + 10,
		initialSwitchState = false,
		style = "radio",
		onPress = onDistanceRadioButtonPress,
		width = 25,
		height = 25
	}

	local manhattanOption = {
		id = "manhattan_option",
		x = display.contentCenterX - 120,
		y = euclideanOption.y + 40,
		initialSwitchState = false,
		style = "radio",
		onPress = onDistanceRadioButtonPress,
		width = 25,
		height = 25
	}

	local cosineOption = {
		id = "cosine_option",
		x = display.contentCenterX - 120,
		y = manhattanOption.y + 40,
		initialSwitchState = false,
		style = "radio",
		onPress = onDistanceRadioButtonPress,
		width = 25,
		height = 25
	}

	local chebyshevOption = {
		id = "chebyshev_option",
		x = display.contentCenterX - 120,
		y = cosineOption.y + 40,
		initialSwitchState = false,
		style = "radio",
		onPress = onDistanceRadioButtonPress,
		width = 25,
		height = 25
	}

	switch1 = widget.newSwitch( euclideanOption )
	local option1 = display.newText( "Euclidean Distance", euclideanOption.x + 115, euclideanOption.y, 180,0, "Roboto-Regular.ttf", 16 )
	option1:setFillColor(0)

	switch2 = widget.newSwitch( manhattanOption )
	local option2 = display.newText( "Manhattan Distance", manhattanOption.x + 115, manhattanOption.y, 180,0, "Roboto-Regular.ttf", 16 )
	option2:setFillColor(0)
	
	switch3 = widget.newSwitch( cosineOption )
	local option3 = display.newText( "Cosine Similarity", cosineOption.x + 115, cosineOption.y, 180,0, "Roboto-Regular.ttf", 16 )
	option3:setFillColor(0)

	switch4 = widget.newSwitch( chebyshevOption )
	local option4 = display.newText( "Chebyshev Distance", chebyshevOption.x + 115, chebyshevOption.y, 180,0, "Roboto-Regular.ttf", 16 )
	option4:setFillColor(0)

	-- add all selectors of distance metric to new group. (selector1)
	local selector1 = display.newGroup()
	selector1:insert( switch1 )
	selector1:insert( option1 )
	selector1:insert( switch2 )
	selector1:insert( option2 )
	selector1:insert( switch3 )
	selector1:insert( option3 )
	selector1:insert( switch4 )
	selector1:insert( option4 )

	-- create selection 2 text object.
	local newTextParams2 = { text = "Select preferred voting algorithm: ", 
						x = display.contentCenterX - 28, 
						y = chebyshevOption.y + 100, 
						width = 310, height = 100, 
						font = "Roboto-Regular.ttf", 
						fontSize = 17, 
						align = "center" }

	local summary2 = display.newText( newTextParams2 )
	summary2:setFillColor( 0 ) -- black
	
	-- create radio buttons for selection of weight method.
	local simpleVote = {
		id = "simpleVote_option",
		x = display.contentCenterX - 120,
		y = summary2.y + 10,
		initialSwitchState = false,
		style = "radio",
		onPress = onVoteRadioButtonPress,
		width = 25,
		height = 25
	}

	local harmonicVote = {
		id = "harmonicVote_option",
		x = display.contentCenterX - 120,
		y = simpleVote.y + 40,
		initialSwitchState = false,
		style = "radio",
		onPress = onVoteRadioButtonPress,
		width = 25,
		height = 25
	}

	simpleVoteSwitch = widget.newSwitch( simpleVote )
	local voteOption1 = display.newText( "Unit Weight", simpleVote.x + 130, simpleVote.y, 200,0, "Roboto-Regular.ttf", 16 )
	voteOption1:setFillColor(0)

	harmonicVoteSwitch = widget.newSwitch( harmonicVote )
	local voteOption2 = display.newText( "Harmonic Mean Weights", harmonicVote.x + 130, harmonicVote.y,200,0, "Roboto-Regular.ttf", 16)
	voteOption2:setFillColor(0)

	-- add the weight method selection radio buttons to new group (selector2).
	local selector2 = display.newGroup()
	selector2:insert( simpleVoteSwitch )
	selector2:insert( voteOption1 )
	selector2:insert( harmonicVoteSwitch )
	selector2:insert( voteOption2 )

	-- create button to proceed.
	local next = widget.newButton(
		{
			label = "Next >>",
			onEvent = handleButtonEvent,
			emboss = false,
			shape = "roundedRect",
			width = 100,
			height = 50,
			cornerRadius = 10,
			font = "Roboto-Bold.ttf",
			fontSize = 18,
			fillColor = { default = { 0.0196, 0.1843, 0.3098 }, over = { 1, 1, 1 } },
			labelColor = { default={ 1, 1, 1 }, over={ 0.0196, 0.1843, 0.3098 } },
			strokeColor = { default= {1, 1, 1}, over= {1,1,1}},
			strokeWidth = 4
			
		}
	)

	next.x = display.contentCenterX			-- button [next] x coordinate.
	next.y = display.contentCenterY + 250	-- button [next] y coordinate.

	-- create a footer object.
	local footer = display.newRect(display.contentCenterX, display.actualContentHeight - 10, display.actualContentWidth, 120 )
	footer:setFillColor( 0.0196, 0.1843, 0.3098 )
	
	-- add all objects to a group.
	sceneGroup:insert( background )
	sceneGroup:insert( header )
	sceneGroup:insert( title )
	sceneGroup:insert( subTitle )
	sceneGroup:insert( fileText )
	sceneGroup:insert( fileField )
	sceneGroup:insert( fileText2 )
	sceneGroup:insert( summary )
	sceneGroup:insert( selector1 )
	sceneGroup:insert( summary2 )
	sceneGroup:insert( selector2 )
	sceneGroup:insert( next )
	sceneGroup:insert( footer )
end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then	-- Called when the scene is still off screen and is about to move on screen

	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
		sceneGroup:removeSelf()
	end
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.


	display.remove( background )
	display.remove( header )
	display.remove( title )
	display.remove( subTitle )
	display.remove( fileText )
	display.remove( fileField )
	display.remove( fileText2 )
	display.remove( summary )
	display.remove( selector1 )
	display.remove( summary2 )
	display.remove( selector2 )
	--display.remove( next )
	display.remove( footer )
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene