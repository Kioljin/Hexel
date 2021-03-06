local fileWidth = 768
local fileHeight = 333

local entityHeight = 111
local entityWidth = 128

local norm_asset_width = entityWidth/fileWidth
local norm_asset_height = entityHeight/fileHeight

local sprites_per_line = 6

local tower_names = 
    {"yellow_tower.png", "red_tower.png", "green_tower.png", "blue_tower.png", "black_space.png", "brown_space.png", 
    "basic1_tower.png", "basic2_tower.png", "basic3_tower.png", "slow1_tower.png", "slow2_tower.png", "slow3_tower.png", 
    "poison1_tower.png", "poison2_tower.png", "fire1_tower.png", "fire2_tower.png"}
local tower_size = 39

local map_names = {"map_2.png", "map_1.png"}
local map_size = 128

local images = {}

local numImages = 0
function temp(names, size)
    for i=1, #names, 1 do
        u0 = (((i+numImages)-1)%sprites_per_line) * norm_asset_width -- X0
        v0 = math.floor(((i+numImages)-1)/sprites_per_line) * norm_asset_height -- Y0
        u1 = ((i+numImages)%sprites_per_line) * norm_asset_width -- X1
        v1 = (math.floor(((i+numImages)-1)/sprites_per_line) + 1) * norm_asset_height -- X2
        
        if (i+numImages) % sprites_per_line == 0 then
            u1 = 1
        end
            
        table.insert(images, {
            name = names[i],
            spriteColorRect = {x = 0, y = 0, width = size, height = size }, -- This is the height and width of the object
            uvRect = { u0 = u0, v0 = v0, u1 = u1, v1 = v1},
            spriteSourceSize = { width = size, height = size },
            spriteTrimmed = true,
            textureRotated = false
        })
    end
    numImages = numImages + #names
end

temp(tower_names, tower_size)
temp(map_names, map_size)

return {
	texture = 'tp_image.png',
    frames = images
	}
