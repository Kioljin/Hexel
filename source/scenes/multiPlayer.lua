module(..., package.seeall)

require "source/networking/networkFrameworkEntity"
local JSON = require "source/libraries/JSON"

--require "source/game/versusGame"
require "source/game/server"
require "source/game/client"
require "source/gui/guiUtilities"

local mouseEvents = {
    "mouseClick",
    "mouseMove",
    "mouseRightClick",
}

local flower = flower

local multiPlayerGame = nil
local view = nil

function onCreate(e)
    layer = flower.Layer()
    layer:setTouchEnabled(true)
    scene:addChild(layer)
    
    local popupView = widget.UIView {
        scene = scene,
        layout = widget.BoxLayout {
            align = {"center", "center"},
        },
    }
    
    
    local my_nfe = NetworkFrameworkEntity{}
    local connected, networkError = my_nfe:isConnected()
    if not connected then
        return
    end
    
    if my_nfe:isServer() then
        multiPlayerGame =  Server {
            mapFile = "assets/maps/map1.lua",
            layer = layer,
            view = e.data.view,
            nfe = my_nfe,
        }
        view = e.data.view
    else
        multiPlayerGame = Client {
            layer = layer,
            view = e.data.view,
            nfe = my_nfe,
            popupView = popupView,
        }
        view = e.data.view
        buildUI("SinglePlayer", e.data.view, multiPlayerGame)
    
        for i, v in ipairs(mouseEvents) do
            flower.InputMgr:addEventListener(v, onMouseEvent)
        end
    end

    flower.Runtime:addEventListener("resize", onResize)
    
    --flower.InputMgr:addEventListener("mouseClick", item_onTouchDown)
end

function updateLayout()
    _resizeComponents(view)
end

function onResize(e)
    updateLayout()
end

function onStart(e)
    multiPlayerGame:stopped(false)
    multiPlayerGame:run()
end

function onStop(e)
    for i, v in ipairs(mouseEvents) do
        flower.InputMgr:removeEventListener(v, onMouseEvent)
    end
    multiPlayerGame:paused(false)
    multiPlayerGame:stopped(true)
    multiPlayerGame = nil
end

function item_onTouchDown(e)
    if not e.down then
        return
    end
    
    -- TODO: check this later. Is this needed?

    local x = e.x
    local y = e.y
    x, y = layer:wndToWorld(x, y)
    --x, y = prop:worldToModel(x, y)
    


end

function onMouseEvent(e)
    if multiPlayerGame.map then
        if e.type ~= "mouseMove" then
            if not e.down then
                return
            end
        end
        
        local pos = multiPlayerGame.map:screenToGridSpace(e.x, e.y, layer)
        
        if e.type == "mouseClick" or e.type == "mouseRightClick" then
            multiPlayerGame:onTouchDown(pos, e.type)
        elseif e.type == "mouseMove" then
            multiPlayerGame:onMouseMove(pos)
        else
            error("Unknown input event: " .. e.type)
        end
    end
end