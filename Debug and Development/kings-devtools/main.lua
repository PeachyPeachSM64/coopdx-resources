-- description: some tools i thought were useful for\ntesting king related shit\n\nheres what you can do with it:\n - fly anywhere easily\n - show useful statistics on mario\n - quickly access any star of any\n   vanilla level (including stars 0\n   and 99)\n - toggle powerups at any time\n - send your hat to that flying\n   fuck klepto and back\n\nMod by King
-- name: King's Devtools

ACT_DEVTOOLS_DEBUG_MOVE = allocate_mario_action(ACT_GROUP_CUTSCENE | ACT_FLAG_MOVING | ACT_FLAG_INTANGIBLE | ACT_FLAG_PAUSE_EXIT)
ACT_DEVTOOLS_LOCKED =     allocate_mario_action(ACT_GROUP_CUTSCENE | ACT_FLAG_STATIONARY | ACT_FLAG_INTANGIBLE | ACT_FLAG_PAUSE_EXIT)

g64kMode = false
for i in pairs(gActiveMods) do
    if gActiveMods[i].relativePath == "64-king-the-memer" then
        g64kMode = true
    end
end

gDevtools = {}
for i = 0, (MAX_PLAYERS - 1) do
    gDevtools[i] = {
        ["showStats"] = 0,
        ["lMode"] = false,
        ["lTrig"] = 0,
        ["levelSelect"] = {
            ["enabled"] = 0,
            ["level"] = 0,
            ["star"] = 1,
            ["test"] = 0
        },
        ["capSelect"] = {
            ["enabled"] = 0,
            ["cap"] = 0,
        }
    }
end

if mod_storage_load_bool("devtools_lmode") ~= nil then
    gDevtools[0].lMode = mod_storage_load_bool("devtools_lmode")
else
    mod_storage_save_bool("devtools_lmode", gDevtools[0].lMode)
end

local levelTable = {
    [LEVEL_BBH] = {
        ["course"] = COURSE_BBH,
        ["name"] = "BOO APPARITION"
    },
    [LEVEL_CCM] = {
        ["course"] = COURSE_CCM,
        ["name"] = "SNOW SLIDER"
    },
    [LEVEL_CASTLE] = {
        ["course"] = COURSE_NONE,
        ["name"] = "SELECT ROOM"
    },
    [LEVEL_HMC] = {
        ["course"] = COURSE_HMC,
        ["name"] = "HORROR DUNGEON"
    },
    [LEVEL_SSL] = {
        ["course"] = COURSE_SSL,
        ["name"] = "DESERT & PYRAMID"
    },
    [LEVEL_BOB] = {
        ["course"] = COURSE_BOB,
        ["name"] = "BATTLE FIELD"
    },
    [LEVEL_SL] = {
        ["course"] = COURSE_SL,
        ["name"] = "SNOW MOUNTAIN"
    },
    [LEVEL_WDW] = {
        ["course"] = COURSE_WDW,
        ["name"] = "POOL STAGE"
    },
    [LEVEL_JRB] = {
        ["course"] = COURSE_JRB,
        ["name"] = "SUNKEN SHIP"
    },
    [LEVEL_THI] = {
        ["course"] = COURSE_THI,
        ["name"] = "BIG WORLD"
    },
    [LEVEL_TTC] = {
        ["course"] = COURSE_TTC,
        ["name"] = "CLOCK TOWER"
    },
    [LEVEL_RR] = {
        ["course"] = COURSE_RR,
        ["name"] = "RAINBOW CRUISE"
    },
    [LEVEL_CASTLE_GROUNDS] = {
        ["course"] = COURSE_NONE,
        ["name"] = "MAIN MAP"
    },
    [LEVEL_BITDW] = {
        ["course"] = COURSE_BITDW,
        ["name"] = "SIDE SCROLLER"
    },
    [LEVEL_VCUTM] = {
        ["course"] = COURSE_VCUTM,
        ["name"] = "MOAT MINI"
    },
    [LEVEL_BITFS] = {
        ["course"] = COURSE_BITFS,
        ["name"] = "BASEMENT LAVA"
    },
    [LEVEL_SA] = {
        ["course"] = COURSE_SA,
        ["name"] = "FISH TANK"
    },
    [LEVEL_BITS] = {
        ["course"] = COURSE_BITS,
        ["name"] = "HEAVEN"
    },
    [LEVEL_LLL] = {
        ["course"] = COURSE_LLL,
        ["name"] = "FIRE BUBBLE"
    },
    [LEVEL_DDD] = {
        ["course"] = COURSE_DDD,
        ["name"] = "WATER LAND"
    },
    [LEVEL_WF] = {
        ["course"] = COURSE_WF,
        ["name"] = "MOUNTAIN"
    },
    [LEVEL_ENDING] = {
        ["course"] = COURSE_CAKE_END,
        ["name"] = "ENDING"
    },
    [LEVEL_CASTLE_COURTYARD] = {
        ["course"] = COURSE_NONE,
        ["name"] = "BACK GARDEN"
    },
    [LEVEL_PSS] = {
        ["course"] = COURSE_PSS,
        ["name"] = "MINI SLIDER"
    },
    [LEVEL_COTMC] = {
        ["course"] = COURSE_COTMC,
        ["name"] = "IN THE FALL"
    },
    [LEVEL_TOTWC] = {
        ["course"] = COURSE_TOTWC,
        ["name"] = "MARIO FLY"
    },
    [LEVEL_BOWSER_1] = {
        ["course"] = COURSE_BITDW,
        ["name"] = "KOOPA 1"
    },
    [LEVEL_WMOTR] = {
        ["course"] = COURSE_WMOTR,
        ["name"] = "BLUE SKY"
    },
    [LEVEL_BOWSER_2] = {
        ["course"] = COURSE_BITFS,
        ["name"] = "KOOPA 2"
    },
    [LEVEL_BOWSER_3] = {
        ["course"] = COURSE_BITS,
        ["name"] = "KOOPA 3"
    },
    [LEVEL_TTM] = {
        ["course"] = COURSE_TTM,
        ["name"] = "MONKEY & SLIDER"
    },
}

local actNames = {}
actNames[ACT_DEVTOOLS_DEBUG_MOVE] = "ACT_DEVTOOLS_DEBUG_MOVE"
actNames[ACT_DEVTOOLS_LOCKED] = "ACT_DEVTOOLS_LOCKED"

if gKingExists then
    actNames[ACT_KING_WALKING] = "ACT_KING_WALKING"
    actNames[ACT_KING_BALL_AIR] = "ACT_KING_BALL_AIR"
    actNames[ACT_KING_BALL_LAND] = "ACT_KING_BALL_LAND"
    actNames[ACT_KING_BOUNCE] = "ACT_KING_BOUNCE"
    actNames[ACT_KING_BOUNCE_LAND] = "ACT_KING_BOUNCE_LAND"
    actNames[ACT_KING_ROLLING] = "ACT_KING_ROLLING"
    actNames[ACT_KING_ROLLDASH] = "ACT_KING_ROLLDASH"
    actNames[ACT_KING_FLOAT] = "ACT_KING_FLOAT"
    actNames[ACT_KING_SPECIAL_BALL] = "ACT_KING_SPECIAL_BALL"
    actNames[ACT_KING_POLE_SPIN] = "ACT_KING_POLE_SPIN"
    actNames[ACT_KING_POLE_JUMP] = "ACT_KING_POLE_JUMP"
    actNames[ACT_KING_TRIP_FLAIL] = "ACT_KING_TRIP_FLAIL"
end

function action_value_to_string(action)
    if actNames[action] then
        return actNames[action]
    end
    for k, v in pairs(_G) do
        if v == action then
            actNames[action] = k
            return k
        end
    end
    return tostring(action)
end

function wrap_value(value, minimum, maximum)
    if minimum ~= nil and value < minimum then
        value = maximum
    end
    if maximum ~= nil and value > maximum then
        value = minimum
    end
    return value
end

function select_value(m, value, INC_BUTTON, DEC_BUTTON, minimum, maximum)
    if (m.controller.buttonPressed & INC_BUTTON) ~= 0 then
        value = value + 1
        play_sound(SOUND_MENU_CHANGE_SELECT, m.marioObj.header.gfx.cameraToObject)
    end
    if (m.controller.buttonPressed & DEC_BUTTON) ~= 0 then
        value = value - 1
        play_sound(SOUND_MENU_CHANGE_SELECT, m.marioObj.header.gfx.cameraToObject)
    end

    value = wrap_value(value, minimum, maximum)
    return value
end

function handle_devtools(m, devtools)
    if devtools.levelSelect.enabled == 1
    or devtools.capSelect.enabled == 1 then
        set_mario_action(m, ACT_DEVTOOLS_LOCKED, 0)
    else
        if m.action == ACT_DEVTOOLS_LOCKED then
            set_mario_action(m, ACT_FREEFALL, 0)
        end
    end

    if devtools.levelSelect.enabled ~= 0 then
        devtools.levelSelect.level = select_value(m, devtools.levelSelect.level, U_JPAD, D_JPAD, 1, LEVEL_COUNT - 1)
        devtools.levelSelect.star = select_value(m, devtools.levelSelect.star, R_JPAD, L_JPAD, 1, 8)

        if (m.controller.buttonPressed & A_BUTTON) ~= 0 then
            local warp = false

            if devtools.levelSelect.level ~= LEVEL_ENDING then
                local starNum = devtools.levelSelect.star

                if devtools.levelSelect.star == 7 then
                    starNum = 0
                end

                if devtools.levelSelect.star == 8 then
                    starNum = 99
                end

                warp = warp_to_level(devtools.levelSelect.level, 1, starNum)

                if warp == true then
                    devtools.levelSelect.enabled = 0
                else
                    play_sound(SOUND_MENU_CAMERA_BUZZ, m.marioObj.header.gfx.cameraToObject)
                end
            else
                lvl_set_current_level(0, LEVEL_ENDING)
                fade_into_special_warp(SPECIAL_WARP_CAKE, 0x000000)
                devtools.levelSelect.enabled = 0
            end
        end

        if (m.controller.buttonPressed & B_BUTTON) ~= 0 then
            devtools.levelSelect.enabled = 0
        end
    else
        devtools.levelSelect.level = gNetworkPlayers[0].currLevelNum
        devtools.levelSelect.star = gNetworkPlayers[0].currActNum

        if devtools.levelSelect.star == 0 then
            devtools.levelSelect.star = 7
        end

        if devtools.levelSelect.star == 99 then
            devtools.levelSelect.star = 8
        end
    end

    if devtools.capSelect.enabled ~= 0 then
        if g64kMode then
            devtools.capSelect.cap = select_value(m, devtools.capSelect.cap, R_JPAD, L_JPAD, 0, 4)
        else
            devtools.capSelect.cap = select_value(m, devtools.capSelect.cap, R_JPAD, L_JPAD, 0, 3)
        end

        if (m.controller.buttonPressed & A_BUTTON) ~= 0 then
            if devtools.capSelect.cap < 3 then
                if devtools.capSelect.cap == 0 then
                    if (m.flags & MARIO_WING_CAP) == 0 then
                        interact_cap(m, 0, spawn_non_sync_object(id_bhvWingCap, E_MODEL_MARIOS_WING_CAP, m.pos.x, m.pos.y, m.pos.z, nil))
                    else
                        if (m.flags & MARIO_VANISH_CAP) ~= 0 or (m.flags & MARIO_METAL_CAP) ~= 0 then
                            m.flags = m.flags & ~MARIO_WING_CAP
                        else
                            m.capTimer = 1
                        end
                    end
                end

                if devtools.capSelect.cap == 1 then
                    if (m.flags & MARIO_VANISH_CAP) == 0 then
                        interact_cap(m, 0, spawn_non_sync_object(id_bhvVanishCap, E_MODEL_MARIOS_CAP, m.pos.x, m.pos.y, m.pos.z, nil))
                    else
                        if (m.flags & MARIO_WING_CAP) ~= 0 or (m.flags & MARIO_METAL_CAP) ~= 0 then
                            m.flags = m.flags & ~MARIO_VANISH_CAP
                        else
                            m.capTimer = 1
                        end
                    end
                end

                if devtools.capSelect.cap == 2 then
                    if (m.flags & MARIO_METAL_CAP) == 0 then
                        interact_cap(m, 0, spawn_non_sync_object(id_bhvMetalCap, E_MODEL_MARIOS_METAL_CAP, m.pos.x, m.pos.y, m.pos.z, nil))
                    else
                        if (m.flags & MARIO_WING_CAP) ~= 0 or (m.flags & MARIO_VANISH_CAP) ~= 0 then
                            m.flags = m.flags & ~MARIO_METAL_CAP
                        else
                            m.capTimer = 1
                        end
                    end
                end
            else
                if g64kMode then
                    if devtools.capSelect.cap == 3 and gMarioIsKing then
                        if star_king_is_enabled(m) == 0 then
                            star_king_enable(m)
                        else
                            star_king_disable(m)
                        end
                    end

                    if devtools.capSelect.cap == 4 then
                        if (m.flags & MARIO_CAP_ON_HEAD) == 0 or m.cap ~= 0 then
                            m.flags = m.flags | MARIO_CAP_ON_HEAD
                            m.cap = 0
                        else
                            m.flags = m.flags & ~MARIO_CAP_ON_HEAD
                            m.cap = SAVE_FLAG_CAP_ON_KLEPTO
                        end
                    end
                else
                    if devtools.capSelect.cap == 3 then
                        if (m.flags & MARIO_CAP_ON_HEAD) == 0 or m.cap ~= 0 then
                            m.flags = m.flags | MARIO_CAP_ON_HEAD
                            m.cap = 0
                        else
                            m.flags = m.flags & ~MARIO_CAP_ON_HEAD
                            m.cap = SAVE_FLAG_CAP_ON_KLEPTO
                        end
                    end
                end
            end

            devtools.capSelect.enabled = 0
        end

        if (m.controller.buttonPressed & B_BUTTON) ~= 0 then
            devtools.capSelect.enabled = 0
        end
    end

    if (m.controller.buttonDown & L_TRIG) ~= 0 or devtools.lMode == false then
        devtools.lTrig = 1

        if m.action ~= ACT_DEVTOOLS_LOCKED then
            if (m.controller.buttonPressed & U_JPAD) ~= 0 then
                if m.action == ACT_DEVTOOLS_DEBUG_MOVE then
                    set_mario_action(m, ACT_FREEFALL, 0)
                else
                    set_mario_action(m, ACT_DEVTOOLS_DEBUG_MOVE, 0)
                end
            end

            if (m.controller.buttonPressed & D_JPAD) ~= 0 then
                if devtools.showStats == 0 then
                    devtools.showStats = 1
                else
                    devtools.showStats = 0
                end
            end

            if (m.controller.buttonPressed & L_JPAD) ~= 0 then
                devtools.levelSelect.enabled = 1
            end

            if (m.controller.buttonPressed & R_JPAD) ~= 0 then
                devtools.capSelect.enabled = 1
            end
        end
    else
        devtools.lTrig = 0
    end
end

function door_stuff(m)
    local dist = 150
    local doorwarp = obj_get_nearest_object_with_behavior_id(m.marioObj, id_bhvDoorWarp)
    local door = obj_get_nearest_object_with_behavior_id(m.marioObj, id_bhvDoor)
    local stardoor = obj_get_nearest_object_with_behavior_id(m.marioObj, id_bhvStarDoor)

    if doorwarp ~= nil and dist_between_objects(m.marioObj, doorwarp) < dist then
        local actionArg = should_push_or_pull_door(m, doorwarp) + 4

        if doorwarp.oAction == 0 then
            if (actionArg & 1) ~= 0 then
                doorAction = ACT_PULLING_DOOR
            else
                doorAction = ACT_PUSHING_DOOR
            end

            m.interactObj = doorwarp
            m.usedObj = doorwarp
            return set_mario_action(m, doorAction, actionArg)
        end
    elseif door ~= nil and dist_between_objects(m.marioObj, door) < dist then
        if door.oAction == 0 then
            if (should_push_or_pull_door(m, door) & 1) ~= 0 then
                door.oInteractStatus = 0x00010000
            else
                door.oInteractStatus = 0x00020000
            end
        end
    elseif stardoor ~= nil and dist_between_objects(m.marioObj, stardoor) < dist then
        if stardoor.oAction == 0 then
            stardoor.oInteractStatus = 0x00010000
        end
    end
end

function act_devtools_debug_move(m)
    local speed = 48

    if (m.controller.buttonDown & B_BUTTON) ~= 0 then
        speed = 96
    end

    set_mario_animation(m, MARIO_ANIM_A_POSE)

    local upDown = 0
    if (m.controller.buttonDown & A_BUTTON) ~= 0 then
        upDown = upDown + 1
    end
    if (m.controller.buttonDown & Z_TRIG) ~= 0 then
        upDown = upDown - 1
    end

    m.vel.y = upDown * speed/2
    m.forwardVel = m.intendedMag/32 * speed

    if m.pos.y == m.floorHeight and m.vel.y <= 0 then
        perform_ground_step(m)
    else
        perform_air_step(m, 0)
    end

    m.faceAngle.y = m.intendedYaw
    m.vel.x = m.forwardVel * sins(m.faceAngle.y)
    m.vel.z = m.forwardVel * coss(m.faceAngle.y)

    door_stuff(m)
end

function act_devtools_locked(m)
    set_mario_animation(m, MARIO_ANIM_A_POSE)

    m.forwardVel = 0
    perform_air_step(m, 0)

    m.vel.x = 0
    m.vel.y = 0
    m.vel.z = 0
end

function djui_hud_print_text_shadowed(message, x, y, scale)
    local color = djui_hud_get_color()

    djui_hud_set_color(0, 0, 0, color.a)
    djui_hud_print_text(message, x + 2*scale, y + 2*scale, scale)

    djui_hud_set_color(color.r, color.b, color.g, color.a)
    djui_hud_print_text(message, x, y, scale)
end

function draw_debug_hud()
    local m = gMarioStates[0]
    local devtools = gDevtools[0]

    if hud_get_value(HUD_DISPLAY_FLAGS) == HUD_DISPLAY_NONE or hud_is_hidden() then
        return
    end

    local x = 22
    local y = djui_hud_get_screen_height() - 31
    local y2 = y - 20
    local y3 = y2 - 20
    local y4 = y3 - 20

    if not is_game_paused() then
        handle_devtools(m, devtools)
    end

    if devtools.showStats == 1 then
        local newY = 24
        local SPD = string.format("SPD %.0f", m.forwardVel):gsub("-", "M")

        djui_hud_set_font(FONT_CUSTOM_HUD)
        djui_hud_print_text(SPD, x, newY + 10, 1)

        djui_hud_set_font(FONT_CUSTOM_HUD)
        djui_hud_print_text("VEL", x, newY*2 + 8, 0.75)

        local VELX = string.format("X: %.0f", m.vel.x)
        local VELY = string.format("Y: %.0f", m.vel.y)
        local VELZ = string.format("Z: %.0f", m.vel.z)

        djui_hud_set_font(FONT_NORMAL)
        djui_hud_print_text_shadowed(VELX, x, newY*2.875, 0.375)
        djui_hud_print_text_shadowed(VELY, x, newY*3.375, 0.375)
        djui_hud_print_text_shadowed(VELZ, x, newY*3.875, 0.375)

        djui_hud_set_font(FONT_CUSTOM_HUD)
        djui_hud_print_text("POS", x*3, newY*2 + 8, 0.75)

        local POSX = string.format("X: %.0f", m.pos.x)
        local POSY = string.format("Y: %.0f", m.pos.y)
        local POSZ = string.format("Z: %.0f", m.pos.z)

        djui_hud_set_font(FONT_NORMAL)
        djui_hud_print_text_shadowed(POSX, x*3, newY*2.875, 0.375)
        djui_hud_print_text_shadowed(POSY, x*3, newY*3.375, 0.375)
        djui_hud_print_text_shadowed(POSZ, x*3, newY*3.875, 0.375)

        djui_hud_set_font(FONT_CUSTOM_HUD)
        djui_hud_print_text("ANG", x*5, newY*2 + 8, 0.75)

        local ANGX = string.format("X: %.0f", m.faceAngle.x)
        local ANGY = string.format("Y: %.0f", m.faceAngle.y)
        local ANGZ = string.format("Z: %.0f", m.faceAngle.z)

        djui_hud_set_font(FONT_NORMAL)
        djui_hud_print_text_shadowed(ANGX, x*5, newY*2.875, 0.375)
        djui_hud_print_text_shadowed(ANGY, x*5, newY*3.375, 0.375)
        djui_hud_print_text_shadowed(ANGZ, x*5, newY*3.875, 0.375)

        local ACT = string.upper(string.format("ACT 0*%x", (m.action & ACT_ID_MASK)))

        djui_hud_set_font(FONT_CUSTOM_HUD)
        djui_hud_print_text(string.upper(ACT), x, newY*4.125 + 10, 1)

        local ACT2 = action_value_to_string(m.action)

        djui_hud_set_font(FONT_NORMAL)
        djui_hud_print_text_shadowed(ACT2, x + 1, newY*5.25, 0.5)
        djui_hud_set_font(FONT_CUSTOM_HUD)
    end

    if devtools.levelSelect.enabled == 0
    and devtools.capSelect.enabled == 0 then
        if devtools.lTrig == 1 or devtools.lMode == false then
            local dpad = {
                ["up"] = get_texture_info("devtools_dpad_up"),
                ["down"] = get_texture_info("devtools_dpad_down"),
                ["left"] = get_texture_info("devtools_dpad_left"),
                ["right"] = get_texture_info("devtools_dpad_right")
            }

            local TEX_DEBUG = get_texture_info("devtools_menu_debug")
            local TEX_POWER = get_texture_info("devtools_menu_cap")

            if g64kMode then
                TEX_DEBUG = get_texture_info("devtools_menu_debug_king")
            end

            if g64kMode then
                TEX_POWER = get_texture_info("devtools_menu_power")
            end

            -- debug move
            djui_hud_render_texture(dpad.up, x, y4, 1, 1)
            djui_hud_render_texture(TEX_DEBUG, x*2, y4, 1, 1)

            -- stats display
            djui_hud_render_texture(dpad.down, x, y3, 1, 1)
            djui_hud_render_texture(get_texture_info("devtools_menu_stats"), x*2, y3, 1, 1)

            -- level select
            djui_hud_render_texture(dpad.left, x, y2, 1, 1)
            djui_hud_render_texture(get_texture_info("devtools_menu_select"), x*2, y2, 1, 1)

            -- cap select
            djui_hud_render_texture(dpad.right, x, y, 1, 1)
            djui_hud_render_texture(TEX_POWER, x*2, y, 1, 1)
        end
    else
        -- confirm
        djui_hud_render_texture(get_texture_info("devtools_button_a"), x, y2, 1, 1)
        djui_hud_render_texture(get_texture_info("devtools_tick"), x*2, y2, 1, 1)

        -- exit
        djui_hud_render_texture(get_texture_info("devtools_button_b"), x, y, 1, 1)
        djui_hud_render_texture(gTextures.no_camera, x*2, y, 1, 1)

        if devtools.levelSelect.enabled == 1 then
            local baseX = djui_hud_get_screen_width()/2
            local levelNum = tostring(devtools.levelSelect.level)
            djui_hud_print_text("LVL "..levelNum, baseX - djui_hud_measure_text("LVL 00")/4, y4 + 8, 0.5)

            local starX = djui_hud_get_screen_width()/2 - 78
            local star = {
                [1] = gTextures.star,
                [2] = gTextures.star,
                [3] = gTextures.star,
                [4] = gTextures.star,
                [5] = gTextures.star,
                [6] = gTextures.star,
                [7] = get_texture_info("texture_hud_char_0"),
                [8] = get_texture_info("devtools_hud_char_99")
            }

            djui_hud_set_color(0, 0, 255, 127)
            djui_hud_render_texture(star[1], starX, y2, 1, 1)
            djui_hud_render_texture(star[2], starX + 20, y2, 1, 1)
            djui_hud_render_texture(star[3], starX + 40, y2, 1, 1)
            djui_hud_render_texture(star[4], starX + 60, y2, 1, 1)
            djui_hud_render_texture(star[5], starX + 80, y2, 1, 1)
            djui_hud_render_texture(star[6], starX + 100, y2, 1, 1)
            djui_hud_set_color(85, 85, 85, 127)
            djui_hud_render_texture(star[7], starX + 120, y2, 1, 1)
            djui_hud_render_texture(star[8], starX + 140, y2, 1, 1)
            djui_hud_set_color(255, 255, 255, 255)

            djui_hud_render_texture(star[devtools.levelSelect.star], starX - 20 + 20*devtools.levelSelect.star - 1.6, y2 - 1.6, 1.2, 1.2)

            local name1 = "UNKNOWN"
            local name2 = "UNKNOWN LEVEL"

            if levelTable[devtools.levelSelect.level] ~= nil then
                name1 = levelTable[devtools.levelSelect.level].name
                name2 = string.upper(get_level_name(levelTable[devtools.levelSelect.level].course, devtools.levelSelect.level, 1))
            end

            djui_hud_print_text(name1, baseX - djui_hud_measure_text(name1)/2, y3, 1)
            djui_hud_print_text(name2, baseX - djui_hud_measure_text(name2)/4, y, 0.5)
        end

        if devtools.capSelect.enabled == 1 then
            local baseX = djui_hud_get_screen_width()/2
            local power = {
                [0] = get_texture_info("devtools_cap_wing"),
                [1] = get_texture_info("devtools_cap_vanish"),
                [2] = get_texture_info("devtools_cap_metal")
            }

            if g64kMode then
                power = {
                    [0] = get_texture_info("devtools_power_super_wing"),
                    [1] = get_texture_info("devtools_power_vanish_flower"),
                    [2] = get_texture_info("devtools_power_metal_crystal")
                }
            end

            if g64kMode then
                baseX = baseX - 10
            end

            djui_hud_set_color(85, 85, 85, 127)
            djui_hud_render_texture(power[0], baseX - 46, y - 8, 1, 1)
            djui_hud_render_texture(power[1], baseX - 26, y - 8, 1, 1)
            djui_hud_render_texture(power[2], baseX - 6, y - 8, 1, 1)
            djui_hud_set_color(255, 255, 255, 255)

            if devtools.capSelect.cap < 3 then
                djui_hud_render_texture(power[devtools.capSelect.cap], baseX - 46 + 20*devtools.capSelect.cap - 3.2, y - 8 - 3.2, 1.2, 1.2)
            end

            if g64kMode then
                djui_hud_set_color(0, 0, 255, 127)
                djui_hud_render_texture(gTextures.star, baseX + 22, y, 1, 1)
                djui_hud_set_color(85, 85, 85, 127)
                djui_hud_render_texture(get_texture_info("devtools_klepto"), baseX + 39, y - 8, 1, 1)
                djui_hud_set_color(255, 255, 255, 255)

                if devtools.capSelect.cap == 3 then
                    djui_hud_render_texture(gTextures.star, baseX + 22 - 1.6, y - 1.6, 1.2, 1.2)
                end

                if devtools.capSelect.cap == 4 then
                    djui_hud_render_texture(get_texture_info("devtools_klepto"), baseX + 39 - 3.2, y - 8 - 3.2, 1.2, 1.2)
                end
            else
                djui_hud_set_color(85, 85, 85, 127)
                djui_hud_render_texture(get_texture_info("devtools_klepto"), baseX + 19, y - 8, 1, 1)
                djui_hud_set_color(255, 255, 255, 255)

                if devtools.capSelect.cap == 3 then
                    djui_hud_render_texture(get_texture_info("devtools_klepto"), baseX + 19 - 3.2, y - 8 - 3.2, 1.2, 1.2)
                end
            end
        end
    end
end

hook_mod_menu_checkbox("L Mode", mod_storage_load_bool("devtools_lmode"), function(index, value)
    gDevtools[0].lMode = value
    mod_storage_save_bool("devtools_lmode", value)
end)

hook_mario_action(ACT_DEVTOOLS_DEBUG_MOVE, act_devtools_debug_move)
hook_mario_action(ACT_DEVTOOLS_LOCKED, act_devtools_locked)

hook_event(HOOK_ON_HUD_RENDER_BEHIND, function()
    djui_hud_set_resolution(RESOLUTION_N64)
    djui_hud_set_color(255, 255, 255, 255)
    djui_hud_set_font(FONT_CUSTOM_HUD)

    draw_debug_hud()
end)