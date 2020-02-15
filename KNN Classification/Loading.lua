local composer = require( "composer" )
local widget = require( "widget")
local scene = composer.newScene()

local buttonPress
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

print( "Actual Height: "..display.actualContentHeight)
print( "Actual Width: "..display.actualContentWidth)
 
 local function onProceed( event )

    if ( event.phase == "began" ) then
		audio.play ( buttonPress )
    end
    
    if ( "ended" == event.phase ) then
        composer.gotoScene ( "view1" )
    end
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    -- add the sound file for button click.
	buttonPress = audio.loadSound( "sound_effect_click.mp3")
 
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen

        -- create a white background to fill screen
        local background = display.newRect( display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight )
        background:setFillColor( 0.0196, 0.1843, 0.3098)	-- white

        -- create title text

        local titleK = display.newText( "K", (display.actualContentWidth / 2) - 122, (display.actualContentHeight / 2) + 50, "Roboto-Black.ttf" , 150)
        titleK:setFillColor( 1 )	-- white

        local titleNearest = display.newText("Nearest", titleK.x + 78, titleK.y + 90, "Roboto-Black.ttf" , 68)
        titleNearest:setFillColor( 1 )

        local titleNeighbour = display.newText("Neighbour", titleNearest.x + 40, titleNearest.y + 60, "Roboto-Black.ttf", 68)
        titleNeighbour:setFillColor( 1 )

        local titleText2 = display.newText("Machine Learning Classifier", titleNeighbour.x - 35, titleNeighbour.y + 55, "Roboto-Regular.ttf", 20)
        titleText2:setFillColor( 1 )

        local btnProceed = widget.newButton(
            {
                label = "Next >>",
                onEvent = onProceed,
                shape = "roundedRect",
                width = 100,
                height = 40,
                cornerRadius = 12,
                fontSize = 18,
                fillColor = { default = { 0.0196, 0.1843, 0.3098 }, over = { 1, 1, 1 } },
                labelColor = { default={ 1, 1, 1 }, over={ 0.0196, 0.1843, 0.3098 } },
                --strokeColor = { default= {1, 1, 1}, over= {1,1,1}},
                --strokeWidth = 4
            }
        )

        btnProceed.x = display.actualContentWidth - 90
        btnProceed.y = display.actualContentHeight - 50

        -- add all elements to the scene group.
        sceneGroup:insert( background )
        sceneGroup:insert( titleK )
        sceneGroup:insert( titleNearest )
        sceneGroup:insert( titleNeighbour )
        sceneGroup:insert( titleText2 )
        sceneGroup:insert( btnProceed )
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen

        display.remove( background )
        display.remove( titleK )
        display.remove( titleNearest )
        display.remove( titleNeighbour )
        display.remove( titleText2 )
        display.remove( btnProceed )
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene