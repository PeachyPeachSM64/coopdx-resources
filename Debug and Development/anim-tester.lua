-- name: Anim-Tester
-- description: tiny mod to test player animations \n\n \\#d0a0f0\\-wibblus

local init = false

hook_event(HOOK_ON_SYNC_VALID, function()
    if init then return end

    local syncTable = gPlayerSyncTable[0]
    syncTable.testAnim = syncTable.testAnim or 0x0E
    syncTable.testAnimFrame = syncTable.testAnimFrame or -1
    syncTable.testAnimHeight = syncTable.testAnimHeight or 0
    syncTable.testAnimHand = syncTable.testAnimHand or MARIO_HAND_FISTS
    syncTable.testAnimEye = syncTable.testAnimEye or MARIO_EYES_OPEN

    djui_chat_message_create("Anim Tester is enabled. Use either \\#ffff50\\/anim-test\\#ffffff\\ or \\#ffa0f0\\[Z] + [DPAD DOWN]\\#ffffff\\ to enter the test state.")

    init = true
end)

local ANIM_NAMES = {
    [0x00] = 'ANIM_SLOW_LEDGE_GRAB',
    [0x01] = 'ANIM_FALL_OVER_BACKWARDS',
    [0x02] = 'ANIM_BACKWARD_AIR_KB',
    [0x03] = 'ANIM_DYING_ON_BACK',
    [0x04] = 'ANIM_BACKFLIP',
    [0x05] = 'ANIM_CLIMB_UP_POLE',
    [0x06] = 'ANIM_GRAB_POLE_SHORT',
    [0x07] = 'ANIM_GRAB_POLE_SWING_PART1',
    [0x08] = 'ANIM_GRAB_POLE_SWING_PART2',
    [0x09] = 'ANIM_HANDSTAND_IDLE',
    [0x0A] = 'ANIM_HANDSTAND_JUMP',
    [0x0B] = 'ANIM_START_HANDSTAND',
    [0x0C] = 'ANIM_RETURN_FROM_HANDSTAND',
    [0x0D] = 'ANIM_IDLE_ON_POLE',
    [0x0E] = 'ANIM_A_POSE',
    [0x0F] = 'ANIM_SKID_ON_GROUND',
    [0x10] = 'ANIM_STOP_SKID',
    [0x11] = 'ANIM_CROUCH_FROM_FAST_LONGJUMP',
    [0x12] = 'ANIM_CROUCH_FROM_SLOW_LONGJUMP',
    [0x13] = 'ANIM_FAST_LONGJUMP',
    [0x14] = 'ANIM_SLOW_LONGJUMP',
    [0x15] = 'ANIM_AIRBORNE_ON_STOMACH',
    [0x16] = 'ANIM_WALK_WITH_LIGHT_OBJ',
    [0x17] = 'ANIM_RUN_WITH_LIGHT_OBJ',
    [0x18] = 'ANIM_SLOW_WALK_WITH_LIGHT_OBJ',
    [0x19] = 'ANIM_SHIVERING_WARMING_HAND',
    [0x1A] = 'ANIM_SHIVERING_RETURN_TO_IDLE',
    [0x1B] = 'ANIM_SHIVERING',
    [0x1C] = 'ANIM_CLIMB_DOWN_LEDGE',
    [0x1D] = 'ANIM_CREDITS_WAVING',
    [0x1E] = 'ANIM_CREDITS_LOOK_UP',
    [0x1F] = 'ANIM_CREDITS_RETURN_FROM_LOOK_UP',
    [0x20] = 'ANIM_CREDITS_RAISE_HAND',
    [0x21] = 'ANIM_CREDITS_LOWER_HAND',
    [0x22] = 'ANIM_CREDITS_TAKE_OFF_CAP',
    [0x23] = 'ANIM_CREDITS_START_WALK_LOOK_UP',
    [0x24] = 'ANIM_CREDITS_LOOK_BACK_THEN_RUN',
    [0x25] = 'ANIM_FINAL_BOWSER_RAISE_HAND_SPIN',
    [0x26] = 'ANIM_FINAL_BOWSER_WING_CAP_TAKE_OFF',
    [0x27] = 'ANIM_CREDITS_PEACE_SIGN',
    [0x28] = 'ANIM_STAND_UP_FROM_LAVA_BOOST',
    [0x29] = 'ANIM_FIRE_LAVA_BURN',
    [0x2A] = 'ANIM_WING_CAP_FLY',
    [0x2B] = 'ANIM_HANG_ON_OWL',
    [0x2C] = 'ANIM_LAND_ON_STOMACH',
    [0x2D] = 'ANIM_AIR_FORWARD_KB',
    [0x2E] = 'ANIM_DYING_ON_STOMACH',
    [0x2F] = 'ANIM_SUFFOCATING',
    [0x30] = 'ANIM_COUGHING',
    [0x31] = 'ANIM_THROW_CATCH_KEY',
    [0x32] = 'ANIM_DYING_FALL_OVER',
    [0x33] = 'ANIM_IDLE_ON_LEDGE',
    [0x34] = 'ANIM_FAST_LEDGE_GRAB',
    [0x35] = 'ANIM_HANG_ON_CEILING',
    [0x36] = 'ANIM_PUT_CAP_ON',
    [0x37] = 'ANIM_TAKE_CAP_OFF_THEN_ON',
    [0x38] = 'ANIM_QUICKLY_PUT_CAP_ON',
    [0x39] = 'ANIM_HEAD_STUCK_IN_GROUND',
    [0x3A] = 'ANIM_GROUND_POUND_LANDING',
    [0x3B] = 'ANIM_TRIPLE_JUMP_GROUND_POUND',
    [0x3C] = 'ANIM_START_GROUND_POUND',
    [0x3D] = 'ANIM_GROUND_POUND',
    [0x3E] = 'ANIM_BOTTOM_STUCK_IN_GROUND',
    [0x3F] = 'ANIM_IDLE_WITH_LIGHT_OBJ',
    [0x40] = 'ANIM_JUMP_LAND_WITH_LIGHT_OBJ',
    [0x41] = 'ANIM_JUMP_WITH_LIGHT_OBJ',
    [0x42] = 'ANIM_FALL_LAND_WITH_LIGHT_OBJ',
    [0x43] = 'ANIM_FALL_WITH_LIGHT_OBJ',
    [0x44] = 'ANIM_FALL_FROM_SLIDING_WITH_LIGHT_OBJ',
    [0x45] = 'ANIM_SLIDING_ON_BOTTOM_WITH_LIGHT_OBJ',
    [0x46] = 'ANIM_STAND_UP_FROM_SLIDING_WITH_LIGHT_OBJ',
    [0x47] = 'ANIM_RIDING_SHELL',
    [0x48] = 'ANIM_WALKING',
    [0x49] = 'ANIM_FORWARD_FLIP',
    [0x4A] = 'ANIM_JUMP_RIDING_SHELL',
    [0x4B] = 'ANIM_LAND_FROM_DOUBLE_JUMP',
    [0x4C] = 'ANIM_DOUBLE_JUMP_FALL',
    [0x4D] = 'ANIM_SINGLE_JUMP',
    [0x4E] = 'ANIM_LAND_FROM_SINGLE_JUMP',
    [0x4F] = 'ANIM_AIR_KICK',
    [0x50] = 'ANIM_DOUBLE_JUMP_RISE',
    [0x51] = 'ANIM_START_FORWARD_SPINNING',
    [0x52] = 'ANIM_THROW_LIGHT_OBJECT',
    [0x53] = 'ANIM_FALL_FROM_SLIDE_KICK',
    [0x54] = 'ANIM_BEND_KNESS_RIDING_SHELL',
    [0x55] = 'ANIM_LEGS_STUCK_IN_GROUND',
    [0x56] = 'ANIM_GENERAL_FALL',
    [0x57] = 'ANIM_GENERAL_LAND',
    [0x58] = 'ANIM_BEING_GRABBED',
    [0x59] = 'ANIM_GRAB_HEAVY_OBJECT',
    [0x5A] = 'ANIM_SLOW_LAND_FROM_DIVE',
    [0x5B] = 'ANIM_FLY_FROM_CANNON',
    [0x5C] = 'ANIM_MOVE_ON_WIRE_NET_RIGHT',
    [0x5D] = 'ANIM_MOVE_ON_WIRE_NET_LEFT',
    [0x5E] = 'ANIM_MISSING_CAP',
    [0x5F] = 'ANIM_PULL_DOOR_WALK_IN',
    [0x60] = 'ANIM_PUSH_DOOR_WALK_IN',
    [0x61] = 'ANIM_UNLOCK_DOOR',
    [0x62] = 'ANIM_START_REACH_POCKET',
    [0x63] = 'ANIM_REACH_POCKET',
    [0x64] = 'ANIM_STOP_REACH_POCKET',
    [0x65] = 'ANIM_GROUND_THROW',
    [0x66] = 'ANIM_GROUND_KICK',
    [0x67] = 'ANIM_FIRST_PUNCH',
    [0x68] = 'ANIM_SECOND_PUNCH',
    [0x69] = 'ANIM_FIRST_PUNCH_FAST',
    [0x6A] = 'ANIM_SECOND_PUNCH_FAST',
    [0x6B] = 'ANIM_PICK_UP_LIGHT_OBJ',
    [0x6C] = 'ANIM_PUSHING',
    [0x6D] = 'ANIM_START_RIDING_SHELL',
    [0x6E] = 'ANIM_PLACE_LIGHT_OBJ',
    [0x6F] = 'ANIM_FORWARD_SPINNING',
    [0x70] = 'ANIM_BACKWARD_SPINNING',
    [0x71] = 'ANIM_BREAKDANCE',
    [0x72] = 'ANIM_RUNNING',
    [0x73] = 'ANIM_RUNNING_UNUSED',
    [0x74] = 'ANIM_SOFT_BACK_KB',
    [0x75] = 'ANIM_SOFT_FRONT_KB',
    [0x76] = 'ANIM_DYING_IN_QUICKSAND',
    [0x77] = 'ANIM_IDLE_IN_QUICKSAND',
    [0x78] = 'ANIM_MOVE_IN_QUICKSAND',
    [0x79] = 'ANIM_ELECTROCUTION',
    [0x7A] = 'ANIM_SHOCKED',
    [0x7B] = 'ANIM_BACKWARD_KB',
    [0x7C] = 'ANIM_FORWARD_KB',
    [0x7D] = 'ANIM_IDLE_HEAVY_OBJ',
    [0x7E] = 'ANIM_STAND_AGAINST_WALL',
    [0x7F] = 'ANIM_SIDESTEP_LEFT',
    [0x80] = 'ANIM_SIDESTEP_RIGHT',
    [0x81] = 'ANIM_START_SLEEP_IDLE',
    [0x82] = 'ANIM_START_SLEEP_SCRATCH',
    [0x83] = 'ANIM_START_SLEEP_YAWN',
    [0x84] = 'ANIM_START_SLEEP_SITTING',
    [0x85] = 'ANIM_SLEEP_IDLE',
    [0x86] = 'ANIM_SLEEP_START_LYING',
    [0x87] = 'ANIM_SLEEP_LYING',
    [0x88] = 'ANIM_DIVE',
    [0x89] = 'ANIM_SLIDE_DIVE',
    [0x8A] = 'ANIM_GROUND_BONK',
    [0x8B] = 'ANIM_STOP_SLIDE_LIGHT_OBJ',
    [0x8C] = 'ANIM_SLIDE_KICK',
    [0x8D] = 'ANIM_CROUCH_FROM_SLIDE_KICK',
    [0x8E] = 'ANIM_SLIDE_MOTIONLESS',
    [0x8F] = 'ANIM_STOP_SLIDE',
    [0x90] = 'ANIM_FALL_FROM_SLIDE',
    [0x91] = 'ANIM_SLIDE',
    [0x92] = 'ANIM_TIPTOE',
    [0x93] = 'ANIM_TWIRL_LAND',
    [0x94] = 'ANIM_TWIRL',
    [0x95] = 'ANIM_START_TWIRL',
    [0x96] = 'ANIM_STOP_CROUCHING',
    [0x97] = 'ANIM_START_CROUCHING',
    [0x98] = 'ANIM_CROUCHING',
    [0x99] = 'ANIM_CRAWLING',
    [0x9A] = 'ANIM_STOP_CRAWLING',
    [0x9B] = 'ANIM_START_CRAWLING',
    [0x9C] = 'ANIM_SUMMON_STAR',
    [0x9D] = 'ANIM_RETURN_STAR_APPROACH_DOOR',
    [0x9E] = 'ANIM_BACKWARDS_WATER_KB',
    [0x9F] = 'ANIM_SWIM_WITH_OBJ_PART1',
    [0xA0] = 'ANIM_SWIM_WITH_OBJ_PART2',
    [0xA1] = 'ANIM_FLUTTERKICK_WITH_OBJ',
    [0xA2] = 'ANIM_WATER_ACTION_END_WITH_OBJ',
    [0xA3] = 'ANIM_STOP_GRAB_OBJ_WATER',
    [0xA4] = 'ANIM_WATER_IDLE_WITH_OBJ',
    [0xA5] = 'ANIM_DROWNING_PART1',
    [0xA6] = 'ANIM_DROWNING_PART2',
    [0xA7] = 'ANIM_WATER_DYING',
    [0xA8] = 'ANIM_WATER_FORWARD_KB',
    [0xA9] = 'ANIM_FALL_FROM_WATER',
    [0xAA] = 'ANIM_SWIM_PART1',
    [0xAB] = 'ANIM_SWIM_PART2',
    [0xAC] = 'ANIM_FLUTTERKICK',
    [0xAD] = 'ANIM_WATER_ACTION_END',
    [0xAE] = 'ANIM_WATER_PICK_UP_OBJ',
    [0xAF] = 'ANIM_WATER_GRAB_OBJ_PART2',
    [0xB0] = 'ANIM_WATER_GRAB_OBJ_PART1',
    [0xB1] = 'ANIM_WATER_THROW_OBJ',
    [0xB2] = 'ANIM_WATER_IDLE',
    [0xB3] = 'ANIM_WATER_STAR_DANCE',
    [0xB4] = 'ANIM_RETURN_FROM_WATER_STAR_DANCE',
    [0xB5] = 'ANIM_GRAB_BOWSER',
    [0xB6] = 'ANIM_SWINGING_BOWSER',
    [0xB7] = 'ANIM_RELEASE_BOWSER',
    [0xB8] = 'ANIM_HOLDING_BOWSER',
    [0xB9] = 'ANIM_HEAVY_THROW',
    [0xBA] = 'ANIM_WALK_PANTING',
    [0xBB] = 'ANIM_WALK_WITH_HEAVY_OBJ',
    [0xBC] = 'ANIM_TURNING_PART1',
    [0xBD] = 'ANIM_TURNING_PART2',
    [0xBE] = 'ANIM_SLIDEFLIP_LAND',
    [0XBF] = 'ANIM_SLIDEFLIP',
    [0xC0] = 'ANIM_TRIPLE_JUMP_LAND',
    [0xC1] = 'ANIM_TRIPLE_JUMP',
    [0xC2] = 'ANIM_FIRST_PERSON',
    [0xC3] = 'ANIM_IDLE_HEAD_LEFT',
    [0xC4] = 'ANIM_IDLE_HEAD_RIGHT',
    [0xC5] = 'ANIM_IDLE_HEAD_CENTER',
    [0xC6] = 'ANIM_HANDSTAND_LEFT',
    [0xC7] = 'ANIM_HANDSTAND_RIGHT',
    [0xC8] = 'ANIM_WAKE_FROM_SLEEP',
    [0xC9] = 'ANIM_WAKE_FROM_LYING',
    [0xCA] = 'ANIM_START_TIPTOE',
    [0xCB] = 'ANIM_SLIDEJUMP',
    [0xCC] = 'ANIM_START_WALLKICK',
    [0xCD] = 'ANIM_STAR_DANCE',
    [0xCE] = 'ANIM_RETURN_FROM_STAR_DANCE',
    [0xCF] = 'ANIM_FORWARD_SPINNING_FLIP',
    [0xD0] = 'ANIM_TRIPLE_JUMP_FLY',
}

local HAND_NAMES = {
    [MARIO_HAND_FISTS] = "FISTS",
    [MARIO_HAND_OPEN] = "OPEN",
    [MARIO_HAND_PEACE_SIGN] = "PEACE",
    [MARIO_HAND_HOLDING_CAP] = "CAP",
    [MARIO_HAND_HOLDING_WING_CAP] = "WING CAP",
    [MARIO_HAND_RIGHT_OPEN] = "RIGHT OPEN",
}

local EYE_NAMES = {
    [MARIO_EYES_OPEN] = "OPEN",
    [MARIO_EYES_HALF_CLOSED] = "HALF",
    [MARIO_EYES_CLOSED] = "CLOSED",
    [MARIO_EYES_LOOK_LEFT] = "LOOK LEFT",
    [MARIO_EYES_LOOK_RIGHT] = "LOOK RIGHT",
    [MARIO_EYES_LOOK_UP] = "LOOK UP",
    [MARIO_EYES_LOOK_DOWN] = "LOOK DOWN",
    [MARIO_EYES_DEAD] = "DEAD",
}

local function wrap(n, add, max, min)
    n = n + add
    if n > max then return min + (n - max - 1) end
    if n < min then return max + (n - min + 1) end
    return n
end
local HEX_DIGITS = "0123456789ABCDEF"
---@return string
local function dec_to_hex(num)
    if num == 0 then return "0" end
    local result = ""
    while num > 0 do
        local n = num % 16
        result = string.sub(HEX_DIGITS, n + 1, n + 1) .. result
        num = math.floor(num / 16)
    end
    return result
end

local VEC3F_ZERO = { x = 0, y = 0, z = 0 }

ACT_ANIM_TEST = allocate_mario_action(ACT_GROUP_CUTSCENE | ACT_FLAG_STATIONARY | ACT_FLAG_INTANGIBLE)

local function enter_anim_test(id)
    id = tonumber(id)

    gPlayerSyncTable[0].testAnim = id or 0x0E
    gPlayerSyncTable[0].testAnimFrame = -1
    gPlayerSyncTable[0].testAnimHeight = 0
    gPlayerSyncTable[0].testAnimHand = 0
    gPlayerSyncTable[0].testAnimEye = 1
    set_mario_action(gMarioStates[0], ACT_ANIM_TEST, 0)

    play_sound(SOUND_MENU_MESSAGE_APPEAR, VEC3F_ZERO)

    return true
end

---@param m MarioState
local function before_mario_update(m)
    if m.playerIndex ~= 0 then return end

    if m.action ~= ACT_ANIM_TEST then
        if m.controller.buttonDown & (D_JPAD | Z_TRIG) == (D_JPAD | Z_TRIG) then enter_anim_test() end
        return
    end

    local buttonPressed = m.controller.buttonPressed
    local animInfo = m.marioObj.header.gfx.animInfo
    local syncTable = gPlayerSyncTable[0]

    if buttonPressed & START_BUTTON ~= 0 then
        m.controller.buttonPressed = 0
        return set_mario_action(m, ACT_IDLE, 0)
    end
    if buttonPressed & B_BUTTON ~= 0 then
        if syncTable.testAnimFrame < 0 then
            syncTable.testAnimFrame = animInfo.animFrame
            play_sound(SOUND_MENU_HAND_DISAPPEAR, gLakituState.pos)
        else
            syncTable.testAnimFrame = -1
            play_sound(SOUND_MENU_HAND_APPEAR, VEC3F_ZERO)
        end
    end
    if buttonPressed & Z_TRIG ~= 0 then
        syncTable.testAnimHeight = wrap(syncTable.testAnimHeight, 50, 149, 0)
    end
    if buttonPressed & (L_TRIG | Y_BUTTON) ~= 0 then
        syncTable.testAnimHand = wrap(syncTable.testAnimHand, 1, MARIO_HAND_RIGHT_OPEN,
            MARIO_HAND_FISTS)
        play_sound(SOUND_MENU_CHANGE_SELECT, VEC3F_ZERO)
    end
    if buttonPressed & (R_TRIG | X_BUTTON) ~= 0 then
        syncTable.testAnimEye = wrap(syncTable.testAnimEye, 1, MARIO_EYES_DEAD, MARIO_EYES_OPEN)
        play_sound(SOUND_MENU_CHANGE_SELECT, VEC3F_ZERO)
    end
    if buttonPressed & (U_JPAD | D_JPAD | R_JPAD | L_JPAD) ~= 0 then
        local testAnim = syncTable.testAnim
        local frame = syncTable.testAnimFrame

        if frame >= 0 then
            -- while paused, frame advance
            if buttonPressed & R_JPAD ~= 0 then
                frame = wrap(frame, 1, animInfo.curAnim.loopEnd - 1, 0)
            elseif buttonPressed & L_JPAD ~= 0 then
                frame = wrap(frame, -1, animInfo.curAnim.loopEnd - 1, 0)
            end
        else
            -- while unpaused, change anims
            if buttonPressed & R_JPAD ~= 0 then
                testAnim = wrap(testAnim, 1, CHAR_ANIM_MAX - 1, 0)
            elseif buttonPressed & U_JPAD ~= 0 then
                testAnim = wrap(testAnim, 16, CHAR_ANIM_MAX - 1, 0)
            elseif buttonPressed & L_JPAD ~= 0 then
                testAnim = wrap(testAnim, -1, CHAR_ANIM_MAX - 1, 0)
            elseif buttonPressed & D_JPAD ~= 0 then
                testAnim = wrap(testAnim, -16, CHAR_ANIM_MAX - 1, 0)
            end
            -- reset to first frame if paused, keep at -1 if unpaused
            frame = min(frame, 0)
            play_sound(SOUND_MENU_CLICK_FILE_SELECT, VEC3F_ZERO)
        end
        syncTable.testAnim = testAnim
        syncTable.testAnimFrame = frame
    end
    m.controller.buttonPressed = buttonPressed & (A_BUTTON)
end

hook_event(HOOK_BEFORE_MARIO_UPDATE, before_mario_update)

---@param m MarioState
local function act_anim_test(m)
    local syncTable = gPlayerSyncTable[m.playerIndex]

    mario_set_forward_vel(m, 0)
    if m.controller.stickMag > 0.5 then
        m.faceAngle.y = m.intendedYaw
    end
    if m.controller.buttonPressed & A_BUTTON ~= 0 then
        set_anim_to_frame(m, m.marioObj.header.gfx.animInfo.curAnim.startFrame)
        syncTable.testAnimFrame = min(syncTable.testAnimFrame, 0)
    end
    m.marioObj.header.gfx.angle.y = m.faceAngle.y
    m.marioObj.header.gfx.angle.x = 0
    m.marioObj.header.gfx.angle.z = 0
    m.marioObj.header.gfx.pos.y = m.pos.y + syncTable.testAnimHeight

    m.marioBodyState.eyeState = syncTable.testAnimEye
    m.marioBodyState.handState = syncTable.testAnimHand

    set_character_animation(m, syncTable.testAnim)

    if syncTable.testAnimFrame >= 0 then
        set_anim_to_frame(m, syncTable.testAnimFrame)
    end
end

hook_mario_action(ACT_ANIM_TEST, act_anim_test)


hook_event(HOOK_ON_HUD_RENDER, function()
    if gMarioStates[0].action == ACT_ANIM_TEST then
        djui_hud_set_resolution(RESOLUTION_DJUI)
        djui_hud_set_font(FONT_ALIASED)

        local animInfo = gMarioStates[0].marioObj.header.gfx.animInfo

        local height = djui_hud_get_screen_height()
        local animName = ANIM_NAMES[gPlayerSyncTable[0].testAnim]
        local info = {
            "[DPAD L/R] - Change animation/frame.",
            "   ([DPAD U/D] to change faster)",
            "[A] - Restart animation.",
            "[B] - Pause/unpause animation playback.",
            "[Z] - Change model display height.",
            "[L/Y] - Change hand state.",
            "[R/X] - Change eye state.",
            "[L-STICK] - Rotate model.",
            "[START] - Exit anim testing."
        }
        local menuY = height - 170
        local infoY = menuY - #info * 32 - 16

        djui_hud_set_color(0, 0, 0, 160)
        djui_hud_render_rect(16, infoY - 8, 400, menuY - infoY)
        local width = djui_hud_measure_text(animName) * 2.0
        djui_hud_render_rect(16, menuY, 200 + max(width, 500), (height - 32) - menuY)

        local y = infoY
        djui_hud_set_color(225, 225, 225, 255)
        for i = 1, #info, 1 do
            djui_hud_print_text(info[i], 32, y, 1.0)
            y = y + 32
        end

        djui_hud_print_text("HANDS: " .. HAND_NAMES[gPlayerSyncTable[0].testAnimHand], 250, menuY + 16, 1.0)
        djui_hud_print_text("EYES: " .. EYE_NAMES[gPlayerSyncTable[0].testAnimEye], 500, menuY + 16, 1.0)

        djui_hud_print_text("/ " .. animInfo.curAnim.loopEnd - 1, 145, menuY + 16, 1.0)
        if gPlayerSyncTable[0].testAnimFrame >= 0 then djui_hud_set_color(255, 255, 255, 255) end
        djui_hud_print_text("FRAME: " .. animInfo.animFrame, 32, menuY + 16, 1.0)

        djui_hud_set_color(255, 255, 255, 255)
        djui_hud_print_text("0x" .. dec_to_hex(gPlayerSyncTable[0].testAnim), 32, menuY + 48, 2.0)
        djui_hud_print_text(": " .. animName, 150, height - 120, 2.0)
    end
end)

hook_chat_command('anim-test', "- enable animation testing", enter_anim_test)
