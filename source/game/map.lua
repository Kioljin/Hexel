--------------------------------------------------------------------------------
-- map.lua - Defines a map which manages the construction of the hex grid and the path within
--------------------------------------------------------------------------------

require "source/pathfinder"
require "source/utilities/vector"

Map = flower.class()

function Map:init(t)
    
    -- Copy all data members of the table as member variables
    for k, d in pairs(t) do
        self[k] = d
    end
    
    -- Try to load the map
    if not self:load() then
        print("Cannot Load Map: " .. self.file)
    end
end

function Map:load(file)
    self.file = self.file or file
    if not (self.file and io.fileExists(self.file)) then
        return false
    end
    
    self.map = dofile(self.file)
    
    self.width = self.map.width or self.width
    self.height = self.map.height or self.height
    
    self.grid = flower.MapImage(self.texture, self.width,
                                self.height, self.tileWidth,
                                self.tileHeight, self.radius)                          
    self.grid:setShape(MOAIGridSpace.HEX_SHAPE)
    self.grid:setLayer(self.layer)
    
    self.selectedImage = flower.SheetImage(self.texture)
    self.selectedImage:setTileSize(self.tileWidth, self.tileHeight)
    self.selectedImage:setLayer(self.layer)
    
    -- TODO: Fix these numbers
    self.selectedImage:setScl(self.height / self.tileHeight / 1.3, self.height / self.tileHeight / 1.3)
    self.selectedImage:setPiv(self.radius / 2, self.radius / 2)
    self.selectedImage:setColor(0.2, 0.2, 0.2, 1)
    self.selectedImage:setVisible(false)
    
    if type(self.map.tiles) == "table" then
        for i = 1,self.width do
            for j = 1,self.height do
                self.grid.grid:setTile(i, j, self.map.default_tile)
            end
        end
        
        for i, data in ipairs(self.map.tiles) do
            for j, pos in ipairs(data) do
                self.grid.grid:setTile(pos[1], pos[2], i)
            end
        end
    elseif type(self.map.tiles) == "string" then
        
        -- Load file from stream
        local fileStream = MOAIFileStream.new()
        if not fileStream:open(self.map.tiles, MOAIFileStream.READ) then
            return false
        end
        
        self.grid.grid:streamTilesIn(fileStream)
        fileStream:close()
            
        self.spawnTiles = {}
        self.targetPosition = {}
        for i = 1,self.width do
            for j = 1,self.height do
                local tile = self.grid.grid:getTile(i, j)
                if tile == TOWER_TYPES.TARGET then
                    -- this tile is the desination
                    self.targetPosition[1], self.targetPosition[2] = i, j
                elseif tile == TOWER_TYPES.SPAWN then
                    table.insert(self.spawnTiles, {i, j})
                end
            end
        end
    else
        return false
    end
    
    -- TODO: make this a bit more dynamic
    local function validTileCallback(tile)
        return tile == TOWER_TYPES.ENEMY or tile == TOWER_TYPES.TARGET or tile == TOWER_TYPES.SPAWN
    end
    
    -- Find path in the map
    if self:isPathDynamic() then
        self.path = findPath(self:getMOAIGrid(), vector{self.targetPosition[1], self.targetPosition[2]}, validTileCallback)
    else
        self.path = self.map.paths[1]
        self.targetPosition = self.path[#self.path]
    end
    
    return true
end

-- TODO: need to center the selected tile
function Map:selectTile(pos)
    
    local worldPos = self:gridToWorldSpace(pos, MOAIGridSpace.TILE_LEFT_TOP)
    
    self.selectedImage:setVisible(true)
    self.selectedImage:setIndex(self.grid:getTile(pos[1], pos[2]))
    self.selectedImage:setPos(worldPos[1], worldPos[2])
end

function Map:randomStartingPosition()
    local startPosition = not self:isPathDynamic() and self.path[1]
    if not startPosition then
        local randomIndex = math.random(1, #self.spawnTiles)
        startPosition = self.spawnTiles[randomIndex]
    end
    
    return self:gridToWorldSpace(startPosition)
end

function Map:gridToWorldSpace(pos, alignment)
    return vector{self:getMOAIGrid():getTileLoc(pos[1], pos[2], alignment or MOAIGridSpace.TILE_CENTER)}
end

-- Returns true if the path was found using a pathfinder
function Map:isPathDynamic()
    if self.map.paths then
        return false
    end
    
    return true
end

function Map:getPath()
    return self.path
end

function Map:getGrid()
    return self.grid
end

function Map:getWaves()
    return self.map.waves
end

function Map:getMOAIGrid()
    return self:getGrid().grid
end
    