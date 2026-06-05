-- name: Behaviors on screen
-- description: This mod shows any object's \\#00FFFF\\behavior\\#FFFFFF\\ on the screen attached to the object itself!\n\nUse the \\#FFFF00\\Mod Menu\\#FFFFFF\\ to activate/deactivate, choose a \\#00FF00\\Preset\\#FFFFFF\\ or decide colors!\n\nYou can also make your own \\#00FF00\\Presets\\#FFFFFF\\ by looking in the lua file.\n\nby \\#FF4A4E\\Davimari\\#FFFFFF\\ <3
-- cheat, debug, cheats
--           #####  ##    ##   ######  ########  ########  ###  ###      ########   ########   ########   ######  ########  ########   ######
--          ##      ##    ##  ###         ##     ##    ##  ########      ##    ###  ##    ###  ##        ###      ##           ##     ###    
--          ##      ##    ##   ######     ##     ##    ##  ## ## ##      ########   ########   ######     ######  ######       ##      ######
--          ##      ##    ##      ###     ##     ##    ##  ##    ##      ##         ##  ####   ##            ###  ##           ##         ###
--           #####  ########  ######      ##     ########  ##    ##      ##         ##   ####  ########  ######   ########     ##     ###### 

--                                              ########   ########  ##        ########  ## ## ##  ##
--                                              ##    ###  ##        ##        ##    ##  ## ## ##  ##
--                                              ########   ######    ##        ##    ##  ## ## ##  ##
--                                              ##    ###  ##        ##        ##    ##   ######   
--                                              ########   ########  ########  ########   ## ##    ##



-- localize functions to optimiz performance :)
local get_behavior_from_id, get_behavior_name_from_id, get_id_from_behavior, get_id_from_vanilla_behavior, obj_get_first, obj_get_next, djui_hud_get_fov_coeff, djui_hud_measure_text, djui_hud_print_text, djui_hud_set_color, djui_hud_set_font, djui_hud_set_resolution, djui_hud_world_pos_to_screen_pos = get_behavior_from_id, get_behavior_name_from_id, get_id_from_behavior, get_id_from_vanilla_behavior, obj_get_first, obj_get_next, djui_hud_get_fov_coeff, djui_hud_measure_text, djui_hud_print_text, djui_hud_set_color, djui_hud_set_font, djui_hud_set_resolution, djui_hud_world_pos_to_screen_pos


-------------------------------------------------------- Vanilla Behaviors

local Presets = {
    [0] = {name = "All Behaviors",
        [0] = {nil, {140, 230, 90}}, -- "1Up" is ID 0, so it needs to be indexed at 0 in the table (lua tables start from 1 normally).
        {nil,   {140, 230, 90}},
        {nil,   {140, 230, 90}},
        {nil,   {140, 230, 90}},
        {nil,   {140, 230, 90}},
        {nil,   {200, 220, 50}},
        {nil,   {128, 128, 128}},
        {nil,   {128, 128, 128}},
        {nil,   {40, 40, 40},            0.75},
        {nil,   {255, 255, 128},         0.75},
        {nil,                            [3] = 0.75},
        {nil,   {180, 180, 180}},
        {nil,   {180, 180, 180},         0.75},
        {},
        {},
        {nil,   {200, 220, 50}},
        {nil,   {200, 220, 50}},
        {nil,   {128, 20, 60}},
        {nil,   {200, 220, 255}},
        {nil,   {100, 20, 0}},
        {nil,   {180, 180, 180},         0.3},
        {nil,   {255, 230, 0}},
        {nil,   {255, 220, 200}},
        {nil,   {180, 180, 180}},
        {},
        {nil,   {40, 40, 0}},
        {nil,   {40, 40, 0}},
        {},
        {},
        {nil,   {255, 30, 0}},
        {nil,   {255, 30, 0}},
        {},
        {},
        {nil,   {180, 200, 140}},
        {nil,   {180, 200, 140},         0.75},
        {nil,   {50, 50, 50}},
        {nil,   {50, 50, 50}},
        {nil,   {140, 255, 255}},
        {nil,   {220, 220, 220}},
        {nil,   {50, 160, 200}},
        {nil,   {50, 160, 200},          0.75},
        {nil,   {100, 100, 100}},
        {nil,   {190, 220, 255}},
        {nil,   {230, 255, 200}},
        {nil,   {100, 100, 100},         0.15},
        {nil,   {100, 100, 100},         0.15},
        {nil,   {100, 100, 100},         0.15},
        {nil,   {109, 100, 255}},
        {nil,   {109, 100, 255},         0.2},
        {nil,   {109, 100, 255},         0.2},
        {nil,   {109, 100, 180},         0.2},
        {nil,   {60, 0, 255},            0.4},
        {nil,   {109, 100, 255}},
        {nil,   {30, 30, 30}},
        {nil,   {50, 50, 50}},
        {nil,   {100, 100, 100}},
        {nil,   {255, 80, 220}},
        {nil,   {255, 80, 220}},
        {nil,   {100, 100, 100},         0.3},
        {nil,   {100, 100, 100},         0.2},
        {nil,   {100, 100, 100},         0.2},
        {nil,   {100, 100, 100},         0.2},
        {nil,   {200, 220, 255}},
        {nil,   {180, 180, 180}},
        {nil,   {90, 90, 90}},
        {nil,   {200, 220, 255}},
        {nil,   {0, 100, 80}},
        {nil,   {0, 180, 80}},
        {nil,   {200, 220, 255}},
        {nil,   {255, 50, 0}},
        {nil,   {255, 50, 0}},
        {nil,   {100, 100, 100}},
        {nil,   {50, 100, 10}},
        {nil,   {50, 100, 10}},
        {nil,   {60, 100, 160}},
        {nil,   {100, 100, 100}},
        {nil,   {100, 100, 100}},
        {nil,   {255, 255, 0}},
        {nil,   {255, 50, 0, 164}},
        {nil,   {255, 255, 0}},
        {nil,   {255, 255, 0}},
        {nil,   {255, 255, 0}},
        {nil,   {255, 255, 255}},
        {nil,   {60, 10, 160}},
        {nil,   {60, 10, 160}},
        {nil,   {50, 100, 10}},
        {nil,   {220, 130, 0}},
        {nil,   {220, 130, 0}},
        {nil,   {220, 220, 0},           0.15},
        {nil,                            [3] = 0.2},
        {},
        {nil,   {255, 164, 0}},
        {nil,   {200, 250, 255},         0.1},
        {nil,   {200, 250, 255},         0.2},
        {nil,   {200, 250, 255},         0.1},
        {nil,   {200, 250, 255},         0.1},
        {nil,   {20, 0, 100}},
        {nil,   {128, 128, 128}},
        {nil,   {220, 0, 220},           0.2},
        {nil,   {255, 230, 0},           0.75},
        {nil,   {40, 0, 180}},
        {nil,   {40, 0, 180}},
        {nil,   {200, 250, 255}},
        {nil,   {40, 0, 180}},
        {nil,   {70, 0, 30}},
        {},
        {},
        {},
        {},
        {},
        {},
        {},
        {},
        {nil,   {255, 0, 0},             0.9},
        {nil,   {164, 20, 20}},
        {nil,   {255, 255, 0}},
        {nil,   {255, 255, 0}},
        {nil,   {255, 255, 0},           0.2},
        {nil,   {100, 100, 100}},
        {nil,   {180, 180, 180},         0.2},
        {nil,   {180, 180, 180}},
        {nil,   {200, 220, 50}},
        {nil,   {200, 220, 50}},
        {nil,   {255, 80, 0}},
        {nil,   {255, 80, 0}},
        {nil,   {160, 30, 180}},
        {nil,   {160, 30, 180}},
        {nil,   {80, 80, 80}},
        {nil,   {200, 30, 200}},
        {nil,   {128, 128, 0}},
        {nil,   {128, 128, 0}},
        {nil,   {220, 220, 220},         0.3},
        {nil,   {220, 220, 220},         0.2},
        {nil,   {80, 40, 0}},
        {nil,   {120, 60, 0}},
        {nil,   {220, 220, 60}},
        {nil,   {220, 220, 60}},
        {nil,   {220, 220, 60},          0.2},
        {nil,   {255, 255, 0},           0.15},
        {nil,   {120, 20, 50}},
        {nil,   {120, 20, 50}},
        {nil,   {255, 255, 255}},
        {nil,   {255, 255, 255}},
        {nil,   {200, 200, 60}},
        {nil,   {200, 200, 60}},
        {nil,   {200, 140, 255},         0.75},
        {nil,   {40, 40, 40},            0.75},
        {nil,   {180, 180, 20}},
        {nil,                            [3] = 0.2},
        {nil,   {210, 164, 80}},
        {nil,   {210, 164, 80}},
        {nil,   {225, 170, 70}},
        {nil,   {225, 170, 70}},
        {nil,   {180, 140, 220}},
        {nil,   {50, 160, 200}},
        {nil,   {50, 160, 200}},
        {nil,   {255, 220, 200}},
        {nil,   {255, 0, 0}},
        {nil,   {255, 230, 0}},
        {nil},
        {nil,                            [3] = 0.75},
        {nil,   {220, 220, 0},           0.2},
        {nil,   {200, 150, 0}},
        {nil,   {200, 150, 0}},
        {nil,   {255, 255, 255},         0.75},
        {nil,   {50, 80, 60}},
        {nil,   {120, 120, 120}},
        {nil,   {120, 120, 120},         0.35},
        {},
        {nil,   {200, 220, 50}},
        {nil,   {0, 60, 255}},
        {nil,   {255, 30, 0},            0.2},
        {nil,   {60, 128, 50}},
        {nil,   {60, 60, 60}},
        {nil,   {60, 0, 255},            0.2},
        {nil,   {60, 0, 255},            0.2},
        {nil,   {60, 0, 255}},
        {nil,   {255, 30, 0}},
        {nil,   {255, 30, 0}},
        {nil,   {255, 30, 0}},
        {nil,   {255, 30, 0}},
        {nil,   {255, 30, 0}},
        {nil,   {255, 30, 0}},
        {nil,   {255, 30, 0}},
        {nil,   {255, 30, 0},            0.2},
        {nil,   {120, 30, 100}},
        {nil,   {120, 30, 100}},
        {nil,   {120, 30, 100}},
        {nil,   {120, 30, 100}},
        {nil,   {160, 30, 30}},
        {nil,   {255, 50, 50}},
        {nil,   {255, 30, 0}},
        {nil,   {0, 100, 80}},
        {nil,                            [3] = 0.75},
        {nil,   {100, 100, 100}},
        {nil,   {200, 220, 255}},
        {nil,   {200, 220, 255}},
        {nil,   {140, 140, 140}},
        {nil,   {255, 255, 0},           0.15},
        {nil,   {130, 50, 50}},
        {nil,   {130, 50, 50}},
        {nil,   {255, 255, 0},           1.0},
        {},
        {nil,                            [3] = 0.75},
        {nil,   {30, 80, 80}},
        {nil,   {30, 80, 80}},
        {nil,   {120, 40, 60}},
        {nil,   {150, 0, 30}},
        {nil,   {150, 0, 30}},
        {nil,   {140, 230, 90}},
        {nil,   {140, 230, 90}},
        {nil,   {140, 230, 90}},
        {nil,   {140, 230, 90}},
        {nil,   {140, 230, 90}},
        {},
        {nil,   {109, 100, 255}},
        {nil,                            [3] = 0.27},
        {nil,   {255, 255, 0}},
        {nil,   {140, 140, 140}},
        {nil,   {255, 255, 0}},
        {nil,   {255, 255, 0}},
        {nil,   {200, 220, 50}},
        {nil,   {100, 100, 100}},
        {nil,   {100, 30, 50}},
        {},
        {nil,   {255, 255, 0},           0.2},
        {nil,   {80, 100, 230},          0.15},
        {nil,   {220, 220, 220}},
        {},
        {},
        {nil,                            [3] = 0.75},
        {nil,   {50, 100, 150}},
        {nil,   {50, 100, 150}},
        {nil,   {50, 100, 150}},
        {},
        {},
        {nil,   {100, 150, 210}},
        {nil,   {100, 150, 210}},
        {nil,   {100, 150, 210}},
        {nil,   {100, 50, 30}},
        {nil,   {100, 50, 30}},
        {nil,   {100, 50, 30}},
        {nil,   {200, 150, 40}},
        {nil,   {170, 80, 50}},
        {nil,   {100, 100, 100}},
        {nil,   {110, 50, 20}},
        {nil,   {80, 180, 20}},
        {nil,   {230, 180, 20}},
        {},
        {nil,   {80, 180, 20}},
        {nil,   {255, 30, 0},            0.2},
        {nil,   {80, 180, 20}},
        {},
        {nil,   {40, 40, 40},            0.75},
        {nil,   {255, 255, 128},         0.75},
        {nil,   {60, 150, 70},           0.2},
        {nil,   {210, 130, 70}},
        {nil,   {210, 30, 70}},
        {nil,   {60, 128, 220}},
        {nil,   {60, 128, 220}},
        {nil,   {80, 60, 0}},
        {nil,   {60, 128, 220}},
        {nil,   {60, 128, 220}},
        {nil,   {100, 50, 40}},
        {nil,   {200, 180, 170}},
        {nil,   {200, 180, 170}},
        {nil,   {200, 180, 170}},
        {nil,   {255, 30, 0}},
        {nil,   {60, 128, 220}},
        {nil,   {60, 128, 220}},
        {nil,   {60, 128, 220}},
        {nil,   {60, 128, 220}},
        {nil,   {60, 128, 220},           0.3},
        {nil,   {128, 30, 30}},
        {nil,   {80, 60, 0}},
        {nil,   {164, 90, 10}},
        {nil,   {100, 100, 100}},
        {nil,   {100, 150, 210}},
        {nil,   {100, 150, 210}},
        {nil,   {100, 150, 210}},
        {nil,   {80, 50, 255}},
        {nil,   {255, 255, 255}},
        {nil,   {255, 255, 255}},
        {nil,   {255, 255, 255}},
        {nil,   {120, 80, 50}},
        {nil,   {200, 220, 255}},
        {nil,   {200, 220, 255}},
        {nil,   {200, 220, 255}},
        {nil,   {255, 200, 30}},
        {nil,   {210, 150, 30}},
        {nil,   {80, 60, 100}},
        {nil,   {230, 180, 20}},
        {nil,                            [3] = 0.2},
        {nil,                            [3] = 0.2},
        {},
        {nil,   {40, 110, 20}},
        {nil,   {255, 255, 0}},
        {nil,   {200, 140, 50}},
        {nil,   {200, 140, 50}},
        {nil,   {160, 160, 160}},
        {nil,   {109, 100, 255},         0.3},
        {nil,   {220, 220, 60},          0.3},
        {nil,   {200, 230, 230}},
        {nil,   {200, 230, 230}},
        {nil,   {50, 50, 255}},
        {nil,   {50, 50, 255},           0.3},
        {nil,   {50, 50, 255}},
        {nil,   {50, 50, 255},           0.2},
        {nil,   {255, 0, 0}},
        {nil,   {200, 250, 255},         0.15},
        {nil,   {200, 250, 255},         0.15},
        {nil,   {200, 250, 255},         0.15},
        {nil,   {200, 250, 255},         0.15},
        {nil,   {200, 220, 50}},
        {nil,   {220, 220, 60},          0.3},
        {nil,   {180, 180, 180}},
        {nil,   {200, 50, 50}},
        {nil,   {255, 110, 40}},
        {nil,   {40, 40, 40},            0.75},
        {nil,   {255, 255, 128},         0.75},
        {nil,   {40, 80, 255}},
        {nil,   {40, 80, 255}},
        {nil,   {40, 80, 255}},
        {},
        {nil,   {64, 170, 30}},
        {nil,   {200, 250, 255},         0.2},
        {nil,   {200, 250, 255},         0.3},
        {nil,   {100, 100, 100}},
        {nil,   {200, 220, 50}},
        {nil,                            [3] = 0.75},
        {nil,   {200, 250, 255},         0.2},
        {nil,   {255, 200, 70}},
        {nil,   {255, 200, 70}},
        {nil,   {140, 140, 140}},
        {nil,   {255, 255, 0},           0.15},
        {nil,   {255, 255, 0},           0.15},
        {nil,   {128, 0, 128},           0.15},
        {nil,   {220, 130, 0},           0.27},
        {nil,   {120, 0, 70}},
        {nil,   {200, 140, 60}},
        {nil,   {100, 100, 100}},
        {nil,   {200, 140, 60}},
        {nil,   {200, 140, 60}},
        {nil,   {200, 140, 60},          0.2},
        {nil,   {40, 80, 255}},
        {},
        {nil,   {160, 10, 40}},
        {nil,   {255, 0, 0},             0.4},
        {nil,   {90, 90, 140}},
        {},
        {nil,   {128, 128, 128}},
        {},
        {},
        {nil,   {200, 220, 50}},
        {nil,   {255, 255, 255}},
        {nil,   {200, 220, 50}},
        {nil,   {200, 220, 50}},
        {nil,   {230, 180, 100}},
        {nil,   {230, 80, 30}},
        {nil,   {230, 80, 30}},
        {nil,   {40, 140, 30},           0.2},
        {nil,   {40, 140, 30}},               
        {nil,   {100, 220, 250}},
        {nil,   {200, 250, 255},         0.15},
        {nil,   {200, 250, 255},         0.15},
        {nil,   {50, 100, 150}},
        {nil,   {210, 150, 30}},
        {nil,   {220, 220, 60},          0.3},
        {nil,   {60, 170, 200}},
        {nil,   {60, 170, 200},          0.2},
        {nil,   {200, 220, 50}},
        {nil,   {200, 200, 200}},
        {nil,   {200, 200, 200}},
        {nil,   {40, 80, 255}},
        {},
        {nil,   {50, 50, 50}},
        {nil,   {140, 255, 255}},
        {nil,   {255, 255, 255},         0.15},
        {nil,   {200, 250, 255},         0.15},
        {nil,   {220, 220, 220},         0.15},
        {nil,   {40, 80, 255}},                
        {nil,   {255, 50, 0},            0.15},
        {nil,   {200, 250, 255},         0.15},
        {nil,   {200, 250, 255},         0.15},
        {nil,   {140, 140, 140}},              
        {nil,   {100, 100, 100},         0.15},
        {nil,   {220, 220, 220}},
        {nil,   {220, 220, 220}},
        {nil,   {220, 220, 220}},
        {nil,   {220, 220, 220}},
        {nil,   {220, 220, 220}},
        {nil,   {220, 220, 220},         0.2},
        {nil,   {255, 50, 50}},
        {nil,   {80, 80, 80}},
        {nil,                            [3] = 0.75},
        {nil,   {255, 255, 0},           0.15},
        {nil,   {255, 255, 0},           0.15},
        {nil,   {255, 255, 0},           0.15},
        {nil,   {255, 255, 0}},
        {nil,   {255, 255, 0}},
        {nil,                            [3] = 0.75},
        {nil,                            [3] = 0.75},
        {},
        {nil,   {255, 255, 200}},
        {nil,   {255, 50, 10}},
        {},
        {},
        {nil,   {200, 220, 50}},
        {nil,   {200, 140, 60}},
        {nil,   {255, 255, 0}},
        {nil,   {110, 20, 20}},
        {nil,   {255, 255, 200},         0.2},
        {nil,   {255, 255, 0}},
        {nil,   {200, 220, 50}},
        {},
        {nil,   {220, 220, 220},         0.2},
        {},
        {},
        {},
        {nil,   {50, 100, 150}},
        {nil,   {50, 100, 150}},
        {nil,   {50, 100, 150}},
        {nil,   {80, 140, 150}},
        {nil,   {80, 140, 150}},
        {nil,   {0, 90, 220},            0.75},
        {nil,   {200, 220, 50}},
        {nil,   {0, 0, 255}},
        {nil,   {50, 60, 220},           0.3},
        {nil,   {220, 220, 60},          0.3},
        {nil,   {220, 220, 60}},
        {nil,   {30, 30, 30}},
        {},
        {},
        {nil,   {220, 220, 60}},
        {nil,   {50, 90, 255}},
        {nil,   {50, 90, 255}},
        {nil,   {180, 0, 50}},
        {nil,   {220, 220, 220},         0.15},
        {nil,   {255, 0, 0}},
        {},
        {},
        {nil,   {100, 200, 50}},
        {},
        {},
        {nil,   {80, 40, 0}},
        {nil,   {80, 40, 0}},
        {nil,   {80, 40, 0}},
        {nil,   {80, 40, 0}},
        {nil,   {80, 40, 0}},
        {nil,   {100, 200, 50}},
        {nil,   {100, 200, 50},          0.15},
        {nil,   {110, 200, 255},         0.15},
        {nil,   {255, 255, 0},           0.2},
        {nil,   {220, 0, 220},           0.2},
        {nil,   {230, 190, 30}},
        {nil,   {230, 190, 30}},
        {nil,   {230, 190, 30}},
        {nil,   {230, 190, 30}},
        {nil,   {230, 190, 30}},
        {nil,   {230, 190, 30}},
        {nil,   {230, 190, 30}},
        {nil,   {230, 190, 30}},
        {nil,   {230, 190, 30}},
        {nil,   {120, 120, 120}},
        {nil,   {100, 70, 0}},
        {nil,   {200, 220, 50}},
        {nil,   {40, 80, 255}},
        {nil,   {220, 220, 110}},
        {nil,   {220, 220, 110},         0.15},
        {nil,   {164, 90, 10}},
        {nil,   {164, 90, 10}},
        {nil,   {164, 90, 10}},
        {nil,   {255, 255, 0}},
        {nil,   {110, 20, 100}},
        {nil,   {110, 20, 100}},
        {nil,   {255, 255, 0}},
        {},
        {},
        {},
        {},
        {},
        {},
        {},
        {nil,   {255, 255, 0}},
        {nil,                            [3] = 0.2},
        {nil,   {200, 220, 50}},
        {nil,   {120, 200, 200}},
        {nil,   {255, 255, 0},           0.2},
        {nil,   {255, 30, 0},            0.3},
        {nil,   {255, 30, 0},            0.75},
        {nil,   {255, 255, 0},           0.15},
        {nil,   {255, 255, 255},         0.75},
        {nil,   {60, 255, 10},           0.75},
        {nil,   {200, 250, 255},         0.15},
        {nil,   {200, 250, 255}},
        {nil,   {40, 0, 180}},
        {nil,   {80, 80, 80}},
        {nil,   {200, 250, 255}},
        {nil,   {200, 250, 255},         0.15},
        {nil,   {200, 250, 255},         0.15},
        {nil,   {200, 250, 255},         0.75},
        {},
        {nil,   {200, 200, 200}},
        {nil,   {200, 250, 255},         0.15},
        {nil,   {200, 250, 255},         0.15},
        {nil,   {200, 250, 255},         0.15},
        {nil,   {200, 250, 255},         0.15},
        {},
        {},
        {},
        {},
        {},
        {},
        {},
        {nil,   {180, 120, 60}},
        {},
        {},
        {},
        {nil,   {180, 120, 60}},
        {nil,   {200, 250, 255}},
        {nil,   {255, 255, 255},         0.15},
        {nil,   {255, 255, 255},         0.15},
        {nil,   {255, 255, 255},         0.15},
        {nil,   {128, 128, 128},         0.15},
        {nil,   {128, 128, 128},         0.15},
        {nil,   {128, 128, 128}},
        {nil,   {255, 220, 30}},
        {nil,   {255, 220, 30}},
        {nil,   {255, 255, 255}},
        {nil,   {210, 210, 210}},
        {nil,   {220, 180, 0}},
        {nil,   {180, 140, 0}},
        {nil,   {220, 220, 60}},
        {nil,   {255, 255, 0},           0.3},
        {nil,   {80, 230, 30},           1.0},
        {},
        {},
        {nil,   {109, 100, 255}},
        {nil,   {255, 110, 40}},
        
        {"[Unrecognized Behavior]", {0, 0, 0}},
    }
}
local referenceTable = Presets[0]


------------------------------------------------------------ Start Message
local startMsg = true

hook_event(HOOK_ON_LEVEL_INIT, function()
    if startMsg then
        djui_chat_message_create("\\#BBBBBB\\You're using '\\#FFFFFF\\Behaviors on Screen\\#BBBBBB\\'! Check out the \\#FFFF00\\Mod Options\\#FFFFFF\\.")
        startMsg = nil
    end
end)


------------------------------------------------------------ Options & Saves

-- Menu Options --
local Options = {}
Options.modActive = true
Options.presetIdx = mod_storage_load_number("presetIdx") or 0
Options.textcolor = mod_storage_load_bool("textcolor")
Options.autocolor = mod_storage_load_bool("autocolor")


-- Info Button --
hook_mod_menu_button("\\#FFFF00\\Options & Commands Info", function (index)
    djui_chat_message_create("\\#FFFF00\\Text Color: \\#FFFFFF\\Toggles the text color on/off.")
    djui_chat_message_create("\\#FFFF00\\Autocolor: \\#FFFFFF\\Behaviors with unspecified colors will be given a random color. When off, they will be white.")
    djui_chat_message_create("\\#FFFF00\\Previous/Next Preset: \\#FFFFFF\\Switches the Preset for the behaviors currently on screen.")
    djui_chat_message_create("\\#00FF00\\/behaviors: \\#FFFFFF\\Returns a list of \\#00FFFF\\behaviors \\#FFFFFF\\for all the objects currently loaded.")
    djui_chat_message_create("\\#00FF00\\/behaviors hooked: \\#FFFFFF\\Returns a list of all \\#33FF66\\hooked behaviors\\#FFFFFF\\.")
    djui_chat_message_create("\\#AAAAAA\\Note: Behaviors with a * next to them have been overwritten by a mod. For example, there's \\#FFFFFF\\bhvGoomba\\#AAAAAA\\ in a Preset but a mod overwrites it to \\#FFFFFF\\bhvCustomGoomba\\#AAAAAA\\.")
end)


-- Activate/Deactivate Mod --
hook_mod_menu_checkbox("Activate/Deactivate Mod", true, function (index, bool)
    Options.modActive = bool
    if bool then
        djui_popup_create("\\#FFFF00\\Mod Activated.", 1)
    else
        djui_popup_create("\\#FF4444\\Mod Deactivated.", 1)
    end
end)


-- Checkboxes --
hook_mod_menu_checkbox("Text Color (On/Off)", Options.textcolor, function (index, bool)
    Options.textcolor = bool
end)
hook_mod_menu_checkbox("Autocolor (On/Off)", Options.autocolor, function (index, bool)
    Options.autocolor = bool
end)


-- Option Saving --
hook_event(HOOK_ON_EXIT, function ()
    mod_storage_save_number("presetIdx", Options.presetIdx)
    mod_storage_save_bool("textcolor", Options.textcolor)
    mod_storage_save_bool("autocolor", Options.autocolor)
end)


------------------------------------------------------- Chat Scan Command

local function get_curr_preset_name()    
    return Presets[Options.presetIdx].name or "Preset " .. tostring(Options.presetIdx)
end

hook_chat_command("behaviors", ": Returns a list of \\#00FFFF\\behaviors \\#FFFFFF\\for all the objects currently loaded.\n/behaviors hooked : Returns a list of all \\#33FF66\\hooked behaviors\\#FFFFFF\\.",
function (msg)
    if not Options.modActive then djui_chat_message_create("\\#FFFF00\\Mod isn't active. Use the Mod Options to activate it.") return true end

    if msg == "help" then
        djui_chat_message_create("\\#00FF00\\/behaviors: \\#FFFFFF\\Returns a list of \\#00FFFF\\behaviors \\#FFFFFF\\for all the objects currently loaded.")
        djui_chat_message_create("\\#00FF00\\/behaviors hooked: \\#FFFFFF\\Returns a list of all \\#33FF66\\hooked behaviors\\#FFFFFF\\.")
        djui_chat_message_create("\\#AAAAAA\\Note: Behaviors with a * next to them have been overwritten by a mod. For example, there's \\#FFFFFF\\bhvGoomba\\#AAAAAA\\ in a Preset but a mod overwrites it to \\#FFFFFF\\bhvCustomGoomba\\#AAAAAA\\.")
        return true
    end

    if msg == "hooked" or msg == "hooks" then
        local bhv = 0x8000
        while Presets[0][bhv] do
            local origId = get_id_from_behavior(get_behavior_from_id(bhv))
            if origId ~= bhv then
                djui_chat_message_create("Hooked:\\#33FF66\\ " .. tostring(bhv) .. "  " .. Presets[0][bhv][1] .. "\n\\#FFFFFF\\Original: \\#00FFFF\\" .. tostring(origId) .. "  " .. get_behavior_name_from_id(origId))
            else
                djui_chat_message_create("Hooked:\\#33FF66\\ " .. tostring(bhv) .. "  " .. Presets[0][bhv][1] .. "\n\\#FFFFFF\\Original: \\#A0A0A0\\ None")
            end
            bhv = bhv + 1
        end

        if bhv == 0x8000 then djui_chat_message_create("\\#AAAAAA\\No hooked behaviors.") end

        return true
    end

    if msg ~= "" then return false end
    
    local obj
    local totCount = 0
    for OBJ_LIST = 0, 12 do
        obj = obj_get_first(OBJ_LIST)
        local objCount = {}

        while obj do
            local bhv = get_id_from_vanilla_behavior(obj.behavior)
            if bhv == id_bhv_max_count then bhv = get_id_from_behavior(obj.behavior) end

            if referenceTable[bhv] then
                if not objCount[bhv] then objCount[bhv] = 1 else objCount[bhv] = objCount[bhv] + 1 end
            end

            obj = obj_get_next(obj)
        end

        for i in pairs(objCount) do
            local name = Presets[0][i][1]
            if not name then name = get_behavior_name_from_id(i) end

            if i >= 0x8000 then
                djui_chat_message_create(name .. " \\#33FF66\\(ID " .. tostring(i) .. ")\\#FFFFFF\\: \\#AAAAAA\\" .. objCount[i] .. " objs found.")
            else
                djui_chat_message_create(name .. " \\#00FFFF\\(ID " .. tostring(i) .. ")\\#FFFFFF\\: \\#AAAAAA\\" .. objCount[i] .. " objs found.")
            end

            totCount = totCount + objCount[i]
        end
    end
    djui_chat_message_create("\\#AAAAAA\\" .. tostring(totCount) .. " total objs with behaviors from \\#FFFF00\\" .. get_curr_preset_name())

    return true
end)


------------------------------------------------------------ Table Operations

--- Autocolor ---
local lastAutoColor
local randomStartColor = {
    {255, 0, 0},
    {255, 128, 0},
    {255, 255, 0},
    {128, 255, 0},
    {0, 255, 0},
    {0, 255, 128},
    {0, 255, 255},
    {0, 128, 255},
    {0, 0, 255},
    {128, 0, 255},
    {255, 0, 255},
    {255, 0, 128},
}
local function autocolor(i)
    if not lastAutoColor then referenceTable[i][2] = randomStartColor[math.random(1, 12)] return end

    referenceTable[i][2] = {referenceTable[lastAutoColor][2][1], referenceTable[lastAutoColor][2][2], referenceTable[lastAutoColor][2][3]}
    local wraptable = {referenceTable[i][2][3], referenceTable[i][2][1], referenceTable[i][2][2], referenceTable[i][2][3], referenceTable[i][2][1]}
    local k1,k2,d

    for k in pairs(referenceTable[i][2]) do
        if referenceTable[i][2][k] == 255 then
            if wraptable[k+2] == 255 then -- wraptable always works applying +1, so "k0 = k" == "k0 = k+1",
                k2 = k + 1                --                                        "k0 = k + 1" == "k0 = k + 2",
                k1 = k + 2                --                                        "k0 = k - 1" == "k0 = k".
                d = k
            elseif wraptable[k] ~= 0 then
                k2 = k
                k1 = k + 1
                if k == 1 then d = 3 else d = k - 1 end
            else
                k2 = k + 2
                k1 = k + 1
                if k == 3 then d = 1 else d = k + 1 end
            end
            break
        end
    end

    if k2 > k1 then
        referenceTable[i][2][d] = wraptable[k2] + 16
        if referenceTable[i][2][d] > 255 then referenceTable[i][2][d] = 255 end
    else
        referenceTable[i][2][d] = wraptable[k2] - 16
        if referenceTable[i][2][d] < 0 then referenceTable[i][2][d] = 0 end
    end
end


--- Initialize Behavior Entries ---
local function update_reference_table(i)
    referenceTable[i] = referenceTable[i] or {}

    referenceTable[i][1] = referenceTable[i][1] or get_behavior_name_from_id(i)

    if not referenceTable[i][2] then
        autocolor(i)
        referenceTable[i][4] = true
        lastAutoColor = i
    end

    referenceTable[i][3] = referenceTable[i][3] or 0.5
end



------------------------------------------------------------ Object Scanning

local objsFound = {}

local function register_found_object(bhv, obj)
    if not objsFound[bhv] then
        objsFound[bhv] = {}
        update_reference_table(bhv)
    end

    local idx = #objsFound[bhv] + 1

    for i,v in ipairs(objsFound[bhv]) do
        if not v then
            idx = i
            break
        end
    end

    objsFound[bhv][idx] = obj
end

local function check_object_for_insertion(obj)
    local bhv = get_id_from_vanilla_behavior(obj.behavior)
    if bhv == id_bhv_max_count then bhv = get_id_from_behavior(obj.behavior) end -- if id_bhv_max_count was returned, it's a custom behavior. (Need to do it like this cause using get_id_from_behavior for vanilla objects was buggy).

    if not referenceTable[bhv] then return end

    register_found_object(bhv, obj)
end

local function check_all_objects_for_insertion()
    local obj
    for OBJ_LIST = 0, 12 do
        obj = obj_get_first(OBJ_LIST)

        while obj do
            check_object_for_insertion(obj)
            obj = obj_get_next(obj)
        end
    end
end

local function clear_found_objects()
    objsFound = {}
    lastAutoColor = false
end


------------------------------------------------------------ External Mods Compatibiliy and Presets

hook_event(HOOK_ON_MODS_LOADED, function ()
    -- Fetch Hooked Behaviors --
    local hookedBhvs = {}
    local name = get_behavior_name_from_id(0x8000)

    if name then 
        local bhvId = 0x8000
        while name do
            local origId = get_id_from_behavior(get_behavior_from_id(bhvId))
            if bhvId ~= origId then hookedBhvs[bhvId] = {name, origId}
            else hookedBhvs[bhvId] = {name} end

            bhvId = bhvId + 1
            name = get_behavior_name_from_id(bhvId)
        end
    end

    local function get_hooked_behavior_id_from_outside_mod(bhvName)
        local bhvId = 0x8000
        while hookedBhvs[bhvId] do
            if bhvName == hookedBhvs[bhvId][1] then return bhvId end
            bhvId = bhvId + 1
        end
        return id_bhv_max_count
    end
        
-----------------------------------------------------------------------------------------------------------------------------------------------
--                                    ########   ########   ########   ######  ########  ########   ######
--                                    ##    ###  ##    ###  ##        ###      ##           ##     ###    
--                                    ########   ########   ######     ######  ######       ##      ######
--                                    ##         ##  ####   ##            ###  ##           ##         ###
--                                    ##         ##   ####  ########  ######   ########     ##     ###### 


-- To add a hooked (custom) Behavior ID from an outside mod, you must register it first:

    local id_bhvGoreTree = get_hooked_behavior_id_from_outside_mod("bhvGoreTree") -- from Gore / Hardmode

    local id_bhvWPet = get_hooked_behavior_id_from_outside_mod("bhvWPet") -- from WiddlePets 

    local id_bhvSMSRHiddenAt120Stars = get_hooked_behavior_id_from_outside_mod("bvhSMSRHiddenAt120Stars") -- from Star Road

    local id_bhvExampleCustomGoomba = get_hooked_behavior_id_from_outside_mod("bhvExampleCustomGoomba") -- random example...

    --etc... (Add your own here!)

-- All these will work when the respective mod is active!
-- Note: The argument in 'get_hooked_behavior_id_from_outside_mod' must be the behavior's name.
--       Sometimes, the hooked behavior's name is automatically generated, so make sure you know
--       the name of the behavior you're adding.
--       You can use "/behaviors hooked" in chat to get a list of all hooked behaviors.




--                                         --- Use the table below to create your own presets. ---

-- To create a Preset, simply add a table inside 'Presets' (please don't skip numeric indexes). The table should have:
  -- A name (otherwise it will be generated) and a list of Behaviors. The Behaviors can have Text to attach to them, a Color and a Priority.
  -- Prority is how far the text can be seen from the camera. 0.5 is Regular distance; 1.0 and above means always visible from any distance.

    Presets[1] = {name = "Particles",
     -- |      -- Behavior Id --         |  |  -- Text on screen --   |  |      -- Color --      |  | -- Priority -- |
     -- |________________________________|  |_________________________|  |_______________________|  |________________|
     --                                     | nil = raw behavior name |  | nil = White/Autocolor |  |   nil = 0.5    |
        [id_bhvBlackSmokeBowser]            = {nil,                       {100, 100, 100},           0.15},
        [id_bhvBlackSmokeMario]             = {nil,                       {100, 100, 100},           0.15},
        [id_bhvBlackSmokeUpward]            = {nil,                       {100, 100, 100},           0.15},
        [id_bhvBobombBullyDeathSmoke]       = {nil,                       {100, 100, 100},           0.3},
        [id_bhvBobombExplosionBubble]       = {nil,                       {100, 100, 100},           0.2},
        [id_bhvBobombExplosionBubble3600]   = {nil,                       {100, 100, 100},           0.2},
        [id_bhvBobombFuseSmoke]             = {nil,                       {100, 100, 100},           0.2},
        [id_bhvBowserBombExplosion]         = {nil,                       {100, 100, 100}},
        [id_bhvBowserBombSmoke]             = {nil,                       {100, 100, 100}},
        [id_bhvBreakBoxTriangle]            = {nil,                       {220, 220, 0},             0.15},
        [id_bhvBubbleMaybe]                 = {nil,                       {200, 250, 255},           0.1},
        [id_bhvBubblePlayer]                = {nil,                       {200, 250, 255},           0.1},
        [id_bhvBubbleSplash]                = {nil,                       {200, 250, 255},           0.1},
        [id_bhvCelebrationStarSparkle]      = {nil,                       {255, 255, 0},             0.2},
        [id_bhvCoinSparkles]                = {nil,                       {255, 255, 0},             0.15},
        [id_bhvGoldenCoinSparkles]          = {nil,                       {255, 255, 0},             0.15},
        [id_bhvIdleWaterWave]               = {nil,                       {80, 100, 230},            0.15},
        [id_bhvKoopaShellFlame]             = {nil,                       {255, 30, 0},              0.2},
        [id_bhvMrIParticle]                 = {nil,                       {50, 50, 255},             0.2},
        [id_bhvObjectBubble]                = {nil,                       {200, 250, 255},           0.15},
        [id_bhvObjectWaterSplash]	        = {nil,                       {200, 250, 255},           0.15},
        [id_bhvObjectWaterWave]             = {nil,                       {200, 250, 255},           0.15},
        [id_bhvObjectWaveTrail]             = {nil,                       {200, 250, 255},           0.15},
        [id_bhvOrangeNumber]                = {nil,                       {255, 110, 40}},
        [id_bhvPiranhaPlantBubble]          = {nil,                       {200, 250, 255}},
        [id_bhvPlungeBubble]                = {nil,                       {200, 250, 255},           0.2},
        [id_bhvPoundTinyStarParticle]       = {nil,                       {255, 255, 0},             0.15},
        [id_bhvPunchTinyTriangle]           = {nil,                       {255, 255, 0},             0.15},
        [id_bhvPurpleParticle]              = {nil,                       {128, 0, 128},             0.15},
        [id_bhvShallowWaterWave]            = {nil,                       {200, 250, 255},           0.15},
        [id_bhvShallowWaterSplash]          = {nil,                       {200, 250, 255},           0.15},
        [id_bhvSkeeterWave]                 = {nil,                       {60, 170, 200},            0.2},
        [id_bhvSLSnowmanWind]               = {nil,                       {200, 200, 200}},
        [id_bhvSmallParticle]               = {nil,                       {255, 255, 255},           0.15},
        [id_bhvSmallParticleBubbles]        = {nil,                       {200, 250, 255},           0.15},
        [id_bhvSmallParticleSnow]           = {nil,                       {220, 220, 220},           0.15},
        [id_bhvSmallWaterWave]              = {nil,                       {200, 250, 255},           0.15},
        [id_bhvSmallWaterWave398]           = {nil,                       {200, 250, 255},           0.15},
        [id_bhvSmoke]                       = {nil,                       {100, 100, 100},           0.15},
        [id_bhvSparkle]                     = {nil,                       {255, 255, 0},             0.15},
        [id_bhvSparkleSpawn]                = {nil,                       {255, 255, 0},             0.15},
        [id_bhvStrongWindParticle]          = {nil,                       {220, 220, 220},           0.2},
        [id_bhvTinyStrongWindParticle]      = {nil,                       {220, 220, 220},           0.15},
        [id_bhvTreeLeaf]	                = {nil,                       {100, 200, 50},            0.15},
        [id_bhvTreeSnow]	                = {nil,                       {110, 200, 255},           0.15},
        [id_bhvTriangleParticleSpawner]     = {nil,                       {255, 255, 0},             0.2},
        [id_bhvTweesterSandParticle]        = {nil,                       {220, 220, 110},           0.15},
        [id_bhvVolcanoFlames]               = {nil,                       {255, 30, 0},              0.3},
        [id_bhvWallTinyStarParticle]        = {nil,                       {255, 255, 0},             0.15},
        [id_bhvWaterAirBubble]              = {nil,                       {200, 250, 255},           0.15},
        [id_bhvWaterDroplet]                = {nil,                       {200, 250, 255},           0.15},
        [id_bhvWaterDropletSplash]          = {nil,                       {200, 250, 255},           0.15},
        [id_bhvWaterMist]                   = {nil,                       {200, 250, 255},           0.15},
        [id_bhvWaterMist2]                  = {nil,                       {200, 250, 255},           0.15},
        [id_bhvWaterSplash]                 = {nil,                       {200, 250, 255},           0.15},
        [id_bhvWaveTrail]                   = {nil,                       {200, 250, 255},           0.15},
        [id_bhvWhitePuff1]                  = {nil,                       {255, 255, 255},           0.12},
        [id_bhvWhitePuff2]                  = {nil,                       {255, 255, 255},           0.12},
        [id_bhvWhitePuffExplosion]          = {nil,                       {255, 255, 255},           0.15},
        [id_bhvWhitePuffSmoke]              = {nil,                       {255, 255, 255},           0.15},
        [id_bhvWhitePuffSmoke2]             = {nil,                       {255, 255, 255},           0.15},
        
        [id_bhvBird]                        = {nil,   {50, 160, 200}},
        [id_bhvButterfly]                   = {nil,   {220, 0, 220},      0.2},
        [id_bhvEndBirds1]                   = {nil,   {50, 160, 200}},
        [id_bhvEndBirds2]                   = {nil,   {50, 160, 200}},
        [id_bhvTripletButterfly]            = {nil,   {220, 0, 220},      0.2},
    }

    Presets[2] = {name = "Enemies",
        [id_bhvMario]                   =   {"Player",  {255, 255, 255}},

        [id_bhvGoomba]                  =  {},
        [id_bhvBalconyBigBoo]           =  {},
        [id_bhvBigBully]                =  {},
        [id_bhvBigBullyWithMinions]     =  {},
        [id_bhvBigChillBully]           =  {},
        [id_bhvBobomb]                  =  {},
        [id_bhvBobombBuddy]             =  {},
        [id_bhvBobombBuddyOpensCannon]  =  {},
        [id_bhvBoo]                     =  {},
        [id_bhvBooInCastle]             =  {},
        [id_bhvBooWithCage]             =  {},
        [id_bhvBowser]                  =  {},
        [id_bhvBubba]                   =  {},
        [id_bhvBulletBill]              =  {},
        [id_bhvChainChomp]              =  {},
        [id_bhvChirpChirp]              =  {},
        [id_bhvChuckya]                 =  {},
        [id_bhvChuckyaAnchorMario]      =  {},
        [id_bhvCirclingAmp]             =  {},
        [id_bhvCloud]                   =  {},
        [id_bhvCourtyardBooTriplet]     =  {},
        [id_bhvDorrie]                  =  {"bhvDorrie >:3"},
        [id_bhvEnemyLakitu]             =  {},
        [id_bhvEyerokBoss]              =  {},
        [id_bhvEyerokHand]              =  {},
        [id_bhvFlyGuy]                  =  {},
        [id_bhvFlyingBookend]           =  {},
        [id_bhvFreeBowlingBall]         =  {},
        [id_bhvGhostHuntBigBoo]         =  {},
        [id_bhvGhostHuntBoo]            =  {},
        [id_bhvGoomba]                  =  {},
        [id_bhvHauntedBookshelf]        =  {},
        [id_bhvHauntedChair]            =  {},
        [id_bhvHeaveHo]                 =  {},
        [id_bhvHeaveHoThrowMario]       =  {},
        [id_bhvHomingAmp]               =  {},
        [id_bhvKingBobomb]              =  {},
        [id_bhvKlepto]                  =  {},
        [id_bhvKoopa]                   =  {},
        [id_bhvMacroUkiki]              =  {},
        [id_bhvMadPiano]                =  {},
        [id_bhvMantaRay]                =  {},
        [id_bhvMerryGoRoundBigBoo]      =  {},
        [id_bhvMerryGoRoundBoo]         =  {},
        [id_bhvMips]                    =  {"bnuy"},
        [id_bhvMoneybag]                =  {},
        [id_bhvMoneybagHidden]          =  {nil, nil, 0.1},
        [id_bhvMontyMole]               =  {},
        [id_bhvMontyMoleRock]           =  {},
        [id_bhvMrBlizzard]              =  {},
        [id_bhvMrBlizzardSnowball]      =  {},
        [id_bhvMrI]                     =  {},
        [id_bhvPenguinBaby]             =  {"The Evilest Of Them All; Lord Penguin the Baby."},
        [id_bhvPiranhaPlant]            =  {},
        [id_bhvPitBowlingBall]          =  {},
        [id_bhvPokey]                   =  {},
        [id_bhvRacingPenguin]           =  {},
        [id_bhvScuttlebug]              =  {},
        [id_bhvSkeeter]                 =  {},
        [id_bhvSLWalkingPenguin]        =  {},
        [id_bhvSmallBully]              =  {},
        [id_bhvSmallChillBully]         =  {},
        [id_bhvSmallPenguin]            =  {"The Evilest Of Them All; Lord Penguin the Baby."},
        [id_bhvSmallWhomp]              =  {},
        [id_bhvSnufit]                  =  {},
        [id_bhvSnufitBalls]             =  {},
        [id_bhvSpindel]                 =  {},
        [id_bhvSpindrift]               =  {},
        [id_bhvSpiny]                   =  {},
        [id_bhvSushiShark]              =  {},
        [id_bhvSwoop]                   =  {},
        [id_bhvThwomp]                  =  {},
        [id_bhvThwomp2]                 =  {},
        [id_bhvToadMessage]             =  {"bhvEnemyToad"},
        [id_bhvTuxiesMother]            =  {"B*tch stupid mother penguin why do you even lose your child like that like you're down here and they're all the way to the top how did you even manage this you're a bad parent"},
        [id_bhvUkiki]                   =  {},
        [id_bhvUnagi]                   =  {"Horrorboros"},
        [id_bhvWaterBomb]               =  {},
        [id_bhvWhompKingBoss]           =  {},
        [id_bhvWigglerBody]             =  {},
        [id_bhvWigglerHead]             =  {},
        [id_bhvYoshi]                   =  {[3] = 10.0}
    }

    Presets[3] = {name = "Warps",
        [id_bhvAirborneDeathWarp]          =   {"AirborneDeathWarp",                     nil,                    1.0},
        [id_bhvAirborneStarCollectWarp]    =   {"AirborneStarCollectWarp",               nil,                    1.0},
        [id_bhvAirborneWarp]               =   {"AirborneWarp",                          nil,                    1.0},
        [id_bhvDddWarp]                    =   {"DddWarp",                               nil,                    1.0},
        [id_bhvDeathWarp]                  =   {"DeathWarp",                             nil,                    1.0},
        [id_bhvDoorWarp]                   =   {"DoorWarp",                              nil,                    1.0},
        [id_bhvExitPodiumWarp]             =   {"ExitPodiumWarp",                        nil,                    1.0},
        [id_bhvFadingWarp]                 =   {"FadingWarp",                            nil,                    1.0},
        [id_bhvFlyingWarp]                 =   {"FlyingWarp",                            nil,                    1.0},
        [id_bhvHardAirKnockBackWarp]       =   {"HardAirKnockBackWarp",                  nil,                    1.0},
        [id_bhvInstantActiveWarp]          =   {"InstantActiveWarp",                     nil,                    1.0},
        [id_bhvLaunchDeathWarp]            =   {"LaunchDeathWarp",                       nil,                    1.0},
        [id_bhvLaunchStarCollectWarp]      =   {"LaunchStarCollectWarp",                 nil,                    1.0},
        [id_bhvPaintingDeathWarp]          =   {"PaintingDeathWarp",                     nil,                    1.0},
        [id_bhvPaintingStarCollectWarp]    =   {"PaintingStarCollectWarp",               nil,                    1.0},
        [id_bhvSpinAirborneCircleWarp]     =   {"SpinAirborneCircleWarp",                nil,                    1.0},
        [id_bhvSpinAirborneWarp]           =   {"SpinAirborneWarp",                      nil,                    1.0},
        [id_bhvSwimmingWarp]               =   {"SwimmingWarp",                          nil,                    1.0},
        [id_bhvWarp]                       =   {"Warp",                                  nil,                    1.0},
        [id_bhvWarpPipe]                   =   {"WarpPipe",                              {60, 255, 10},          1.0},
    }
        
    -- Change whatever you want to this!
    Presets[4] = {name = "My Custom Preset",
        [id_bhvMario]                   = {"Custom Text :)"},
        [id_bhvExampleCustomGoomba]     = {nil, {160, 60, 60}, 0.65},
        [id_bhvWPet]                    = {"Hi Mario!", nil, 0.65},
        [id_bhvGoreTree]                = {"funny Tree"},
        [id_bhvSMSRHiddenAt120Stars]    = {"idk what this is lmao"}
    }

    -- Updating hooked behaviors in Presets --
    for bhv in pairs(hookedBhvs) do
        local bhvName = hookedBhvs[bhv][1]
        local origId = hookedBhvs[bhv][2]

        -- Insert hooked behavior to 'AllBehaviorIDs'
        Presets[0][bhv] = {bhvName}

        -- update non-hooked behaviors in Presets to hooked -- 
        if origId then
            for P in pairs(Presets) do
                if Presets[P][origId] then
                    local origEntry = Presets[P][origId]
                    Presets[P][origId] = nil

                    Presets[P][bhv] = {"*"..bhvName, origEntry[2], origEntry[3]}
                end
            end
        end
    end


    -- If the saved index is invalid set it to 0
    if not Presets[Options.presetIdx] then referenceTable = Presets[0] else referenceTable = Presets[Options.presetIdx] end


    -- Preset Buttons --
    hook_mod_menu_button("\\#FFFF00\\Current Preset", function(index)
        djui_chat_message_create("\\#FFFF00\\Current Preset: \\#FFFFFF\\" .. get_curr_preset_name())
    end)


    hook_mod_menu_button("Previous Preset", function (index)
        Options.presetIdx = Options.presetIdx - 1
        if not Presets[Options.presetIdx] then Options.presetIdx = #Presets end
            
        referenceTable = Presets[Options.presetIdx]

        djui_popup_create("\\#FFFF00\\Switched Preset.\n\\#FFFFFF\\" .. get_curr_preset_name(), 2)

        clear_found_objects()
        check_all_objects_for_insertion()
    end)

    hook_mod_menu_button("Next Preset", function (index)
        Options.presetIdx = Options.presetIdx + 1
        if not Presets[Options.presetIdx] then Options.presetIdx = 0 end
            
        referenceTable = Presets[Options.presetIdx]
        
        djui_popup_create("\\#FFFF00\\Switched Preset.\n\\#FFFFFF\\" .. get_curr_preset_name(), 2)

        clear_found_objects()
        check_all_objects_for_insertion()
    end)
end)


------------------------------------------------------- Object Scan Hooks

hook_event(HOOK_ON_SYNC_VALID, function ()
    objsFound = {}
    check_all_objects_for_insertion()
end)

hook_event(HOOK_ON_WARP, function ()
    objsFound = {}
    check_all_objects_for_insertion()
end)

-- check objects whenever they load
hook_event(HOOK_ON_OBJECT_LOAD, function (obj)
    if not gNetworkPlayers[0].currAreaSyncValid or not gNetworkPlayers[0].currLevelSyncValid then return end

    check_object_for_insertion(obj)
end)



------------------------------------------------------- On Screen Rendering
local oPos = {x = 0, y = 0, z = 0}
local screenPos = {x = 0, y = 0, z = 0}

hook_event(HOOK_ON_HUD_RENDER, function ()
    if not Options.modActive then return end

    djui_hud_set_resolution(RESOLUTION_N64)
    djui_hud_set_font(FONT_NORMAL)


    for bhv in pairs(objsFound) do
        for k,obj in ipairs(objsFound[bhv]) do
            if obj then
                if (obj.activeFlags & ACTIVE_FLAG_ACTIVE) == ACTIVE_FLAG_ACTIVE then
                    local priority = referenceTable[bhv][3]
                    local size = (priority*1825)/-obj.header.gfx.cameraToObject.z  --  1460 is 365*5. I don't know why I need 365, ask the sm64 decomp people.

                    if size > 0.15 or priority >= 1.0 then
                        oPos = {x = obj.oPosX, y = obj.oPosY, z = obj.oPosZ}

                        if djui_hud_world_pos_to_screen_pos(oPos, screenPos) then
                            local text = referenceTable[bhv][1]
                            local R,G,B

                            if not Options.textcolor then
                                R,G,B = 255, 255, 255
                            elseif Options.autocolor then
                                R,G,B = referenceTable[bhv][2][1], referenceTable[bhv][2][2], referenceTable[bhv][2][3]
                            else
                                if referenceTable[bhv][4] then
                                    R,G,B = 255, 255, 255
                                else
                                    R,G,B = referenceTable[bhv][2][1], referenceTable[bhv][2][2], referenceTable[bhv][2][3]
                                end
                            end

                            local alpha
                            if size > 0.3 then
                                size = 0.3
                                alpha = 255
                            else
                                if priority >= 1.0 then
                                    alpha = math.ceil((size*3.33)*(size*3.33)*195 + 30)

                                    if size < 0.15 then
                                        size = 0.15
                                    end
                                else
                                    alpha = math.ceil((size*3.33)*(size*3.33)*255 - 60)
                                end
                            end

                            screenPos.x = screenPos.x - (djui_hud_measure_text(text)*size*0.5*djui_hud_get_fov_coeff())

                            djui_hud_set_color(30, 30, 30, alpha)
                            djui_hud_print_text(text, screenPos.x + 0.3, screenPos.y + 0.3, size)
                            djui_hud_set_color(R, G, B, alpha)
                            djui_hud_print_text(text, screenPos.x, screenPos.y, size)
                            --djui_hud_print_text(tostring(bhv), screenPos.x, screenPos.y - 10, size)
                            djui_hud_set_color(255, 255, 255, alpha)
                            --djui_hud_print_text("0." .. tostring(math.ceil(size*100)), screenPos.x - 26, screenPos.y - 30, size)
                            --djui_hud_print_text(tostring(djui_hud_measure_text(text)), screenPos.x - 26, screenPos.y - 25, size)
                        end
                    end
                else
                    objsFound[bhv][k] = false
                end
            end
        end
    end
end)