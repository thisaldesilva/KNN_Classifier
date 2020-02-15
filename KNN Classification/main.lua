-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- show default status bar (iOS)
display.setStatusBar( display.DefaultStatusBar )


-- include Corona's "widget" library
local widget = require("widget")
local composer = require("composer")


-- event listener for start screen:
local function onStartUpScreen ( event )
	composer.gotoScene( "Loading" )
end


-- invoke first view of the app onPress event manually
onStartUpScreen()