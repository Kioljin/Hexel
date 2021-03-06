module(..., package.seeall)

require "source/utilities/extensions/io"
require "source/gui/guiUtilities"

MAP_LIST = require "assets/maps/mapList"
ITEM_HEIGHT = 32

local selectedData = nil
local view = nil

function createMenuList()
    
    local function onClickCallback(item)
        if flower.SceneMgr.transitioning then
            return
        end
        
        if item.path then
            local childView = createChildView(item.closeAnime, selectedData)
            local childScene = flower.openScene("source/scenes/singlePlayer", {animation = "fade", mapFile = item.path, view = childView})
            if childScene then
                childView:setScene(childScene)
                selectedData = item
            end
        end
    end
    
    newView = widget.UIView {
        scene = scene,
        layout = widget.BoxLayout {
            align = {"center", "top"},
        },
        children = {{
            widget.Button {
                size = {0, flower.viewHeight/6},
            },
        }}
    }
    
    mapGroup = widget.UIGroup {
        layout = widget.BoxLayout {
            gap = {100, 100},
            direction = "horizotal",
        },
        parent = newView,
    }
    
    for i, item in ipairs(MAP_LIST) do
        local map = widget.SheetButton{
            size = {128, 128},
            text = item.title,
            textColor = {0.8, 0.8, 0.8, 1},
            normalTexture = item.image,
            onClick = function()
                onClickCallback(item)
            end,
            parent = mapGroup,
        } 
    end
    
end

function resizeMenuList()
    _resizeComponents(view)
    _resizeComponents(newView)
end

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    layer = flower.Layer()
    layer:setTouchEnabled(true)
    scene:addChild(layer)
    view = e.data.view
    createMenuList()
    
    flower.Runtime:addEventListener("resize", onResize)
end

function onStart(e)
    -- debug
    MOAISim.forceGarbageCollection()
    MOAISim.reportHistogram()

end

function onResize(e)
    resizeMenuList()
end
