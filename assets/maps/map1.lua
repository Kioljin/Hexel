local map = {}

map.default_tile = TOWER_TYPES.EMPTY
map.width = 8
map.height = 35

local tiles = {}
tiles[TOWER_TYPES.YELLOW] = {}
tiles[TOWER_TYPES.RED] = {}
tiles[TOWER_TYPES.GREEN] = {}
tiles[TOWER_TYPES.BLUE] = {}
tiles[TOWER_TYPES.EMPTY] = {}
tiles[TOWER_TYPES.ENEMY] = {
    {2,1},{2,3},{2,5},{2,7},{2,9},{2,11},{2,13},{2,15},{2,17},{2,19},{2,21},{2,23},{2,25},{2,27},{2,28},
    {3,8},{3,9},{3,11},{3,13},{3,15},{3,17},{3,18},{3,20},{3,21},{3,23},{3,25},{3,26},{3,29},{3,30},
    {4,6},{4,7},{4,10},{4,11},{4,13},{4,15},{4,16},{4,18},{4,19},{4,20},{4,26},{4,27},{4,30},{4,31},
    {5,5},{5,6},{5,9},{5,10},{5,16},{5,17},{5,18},{5,21},{5,23},{5,25},{5,28},{5,29},
    {6,7},{6,8},{6,11},{6,13},{6,15},{6,19},{6,21},{6,23},{6,25},{6,27},
    {7,9},{7,11},{7,13},{7,15},{7,17},{7,19},{7,21},{7,23},{7,25},{7,27},{7,29},{7,31},{7,33},{7,35}
}
tiles[TOWER_TYPES.VOID] = {
    {1,1},{1,31},{1,32},{1,33},{1,34},{1,35},
    {2,33},{2,34},{2,35},
    {3,1},{3,2},{3,35},
    {4,1},
    {5,34},{5,35},
    {6,1},{6,2},{6,35},
    {7,1},{7,2},{7,3},{7,4},
    {8,1},{8,2},{8,3},{8,4},{8,5},{8,6},{8,8},{8,10},{8,12},{8,14},{8,16},{8,18},{8,20},{8,22},{8,24},{8,26},{8,28},{8,30},{8,32},{8,34},
}

map.tiles = tiles

local paths = {
    {
        {2,1},{2,27},{4,31},{6,27},{6,19},{4,15},{4,11},{5,9},{6,11},{6,15},{3,21},{3,25},{4,27},{5,25},{5,21},{3,17},{3,9},{5,5},{7,9},{7,35},
    },
}

map.paths = paths
map.startPosition = {2, 1}
map.targetPosition = {7, 35}

-- Wave details
map.waves = {
    
    {enemies = {{type = "NORMAL", weight = 1}},
                spawnRate = 0.5, length = 5},
    
    {enemies = {{type = "NORMAL", weight = 10},
                {type = "FAST",   weight = 50}},
                spawnRate = 0.4, length = 100},
        
    {enemies = {{type = "NORMAL", weight = 20},
                {type = "FAST", weight = 40},
                {type = "HEAVY", weight = 80}},
                spawnRate = 0.3, length = 200},
        
    {enemies = {{type = "SUPER", weight = 1}},
                spawnRate = 5, length = 5},
}

return map

