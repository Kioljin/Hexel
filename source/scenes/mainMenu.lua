module(..., package.seeall)

--------------------------------------------------------------------------------
-- Imports
--------------------------------------------------------------------------------

local flower = flower
local widget = widget

--------------------------------------------------------------------------------
-- Constraints
--------------------------------------------------------------------------------

local MENU_ITEMS = require "scenes/sceneList"
local ITEM_WIDTH = flower.viewWidth / 2
local ITEM_HEIGHT = 60

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------

local selectedData = nil
local backButton = nil
local view = nil

--------------------------------------------------------------------------------
-- Functions
--------------------------------------------------------------------------------

function createBackButton(childScene)
    
    -- Create view for this child state
    -- TODO: this view should be created elsewhere
    local childView = widget.UIView {
        scene = childScene,
        layout = widget.BoxLayout {
            align = {"right", "top"},
        },
        children = {{
            widget.Button {
                size = {100, 50},
                text = "Back",
                onClick = function()
                    flower.closeScene({animation = selectedData.closeAnime})
                    selectedData = nil
                end,
            },
        }},
    }
end

-- Populates the main menu with buttons for their corresponding state.
function createMenuList()
    
    local function onClickCallback(item)
        if item.scene then
            local childScene = flower.openScene(item.scene, {animation = item.openAnime, params = item.params})
            if childScene then
                selectedData = item
                createBackButton(childScene)
            end
        end
    end
    
    for i, item in ipairs(MENU_ITEMS) do
        local menuItem = widget.Button {
            size = {ITEM_WIDTH, ITEM_HEIGHT},
            text = item.title,
            onClick = function()
                onClickCallback(item)
            end,
            enabled = item.scene ~= nil,
        }
        
        view:addChild(menuItem)
    end
end

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    layer = flower.Layer()
    layer:setTouchEnabled(true)
    scene:addChild(layer)
    
    view = widget.UIView {
        scene = scene,
        layout = widget.BoxLayout {
            gap = {5, 5},
            align = {"center", "center"},
        },
    }
    
    createMenuList()
    
    -- TODO: have the quit button actually quit the game.
    local quitButton = widget.Button {
        size = {ITEM_WIDTH, ITEM_HEIGHT},
        text = "Quit",
        onClick = nil,
        onDown = nil,
        onUp = nil,
        enabled = false,
    }
    
    view:addChild(quitButton)
end

function onStart(e)
end