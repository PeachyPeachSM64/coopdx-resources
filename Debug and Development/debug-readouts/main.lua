-- name: Debug Readouts v0.8
-- description: Really this tool is just for me (holc) and is undercooked, so this is not a formal release. If you somehow get your hands on it, you're better off checking mod releases for a full furnished public version of this that is optimized and feature complete. Until then, do not share this with anyone else. Thanks! -IncredibleHolc

local x = 3
local y = 90
local page = 1
local red = 255
local green = 255
local blue = 255
local function lerp(a, b, t) return a * (1 - t) + b * t end

local function position(m, key)
	local positionChange = key
	if positionChange then
		x = 360  -- X position from top
		y = 90  -- Y position from top
	else
		x = 3  -- X position from top
		y = 90  -- Y position from top
	end
end
hook_mod_menu_checkbox("Move to right side of screen", false, position)

local function rgb_slider_r(m, key)
	red = key
end
hook_mod_menu_slider("Red", 255, 0, 255, rgb_slider_r)

local function rgb_slider_g(m, key)
	green = key
end
hook_mod_menu_slider("Green", 255, 0, 255, rgb_slider_g)
	
local function rgb_slider_b(m, key)
	blue = key
end
hook_mod_menu_slider("Blue", 255, 0, 255, rgb_slider_b)

local tex_Dpad_Empty = get_texture_info("Dpad_Empty")
local tex_Dpad_L = get_texture_info("Dpad_L")
local tex_Dpad_U = get_texture_info("Dpad_U")
local tex_Dpad_R = get_texture_info("Dpad_R")
local tex_Dpad_D = get_texture_info("Dpad_D")
local tex_A_Button = get_texture_info("A")
local tex_B_Button = get_texture_info("B")
local tex_X_Button = get_texture_info("X")
local tex_Y_Button = get_texture_info("Y")
local tex_L_Stick = get_texture_info("L_Stick")
local tex_R_Stick = get_texture_info("R_Stick")
local tex_Stick_Point = get_texture_info("Stick_Point")
local tex_Z_Trig = get_texture_info("Z")
local tex_R_Trig = get_texture_info("R_Trig")
local tex_L_Trig = get_texture_info("L_Trig")

local dPad = {
    [L_JPAD] = tex_Dpad_L,
    [R_JPAD] = tex_Dpad_R,
    [U_JPAD] = tex_Dpad_U,
    [D_JPAD] = tex_Dpad_D,

}

local indexToAction = {}
for k, v in pairs(_G) do
    if k:find("ACT_") == 1 then
        indexToAction[v] = k
    end
end

local indexToLevel = {}
for k, v in pairs(_G) do
    if k:find("LEVEL_") == 1 then
        indexToLevel[v] = k
    end
end

local indexToAnim = {}
for k, v in pairs(_G) do
    if k:find("MARIO_ANIM_") == 1 and not k:find("MARIO_ANIM_PART") then
        indexToAnim[v] = k
    end
end

local indexToBGM = {}
for k, v in pairs(_G) do
    if k:find("SEQ_LEVEL_") == 1 then
        indexToBGM[v] = k
    end
end

local indexToCameraMode = {}
for k, v in pairs(_G) do
    if k:find("CAMERA_MODE_") == 1 then
        indexToCameraMode[v] = k
    end
end

---------------------------------------------------------------------------------------------------

function live_readout()
	local m = gMarioStates[0]
	local np = gNetworkPlayers[0]
	djui_hud_set_resolution(RESOLUTION_N64)
	djui_hud_set_font(FONT_NORMAL)
	djui_hud_set_color(255, 255, 255, 255)
	local playerHeightFromGround = m.pos.y - m.floorHeight
	local level = indexToLevel[np.currLevelNum]
	local sound = indexToBGM[get_current_background_music()]
	local camera = indexToCameraMode[gLakituState.mode]
	local xMessage = "mPosX: "..string.format("%.1f", tostring(m.pos.x))
	local yMessage = "mPosY: "..string.format("%.1f",tostring(m.pos.y))
	local zMessage = "mPosZ: "..string.format("%.1f",tostring(m.pos.z))
	local wallX, wallY, wallZ, wallNormal
	local gLakituX = "gLakituState.pos.x: "..string.format("%.1f",tostring(gLakituState.pos.x))
	local gLakituY = "gLakituState.pos.y: "..string.format("%.1f",tostring(gLakituState.pos.y))
	local gLakituZ = "gLakituState.pos.z: "..string.format("%.1f",tostring(gLakituState.pos.z))
	local mVelX = string.format("%.1f", tostring(m.vel.x))
	local mVelY = string.format("%.1f", tostring(m.vel.y))
	local mVelZ = string.format("%.1f", tostring(m.vel.z))
	local actionName = indexToAction[m.action]
	local prevActionName = indexToAction[m.prevAction]
	local currAnim = indexToAnim[m.marioObj.header.gfx.animInfo.animID]
	local camera_frozen = camera_is_frozen()
	local lakitu_dist_info = dist_between_object_and_point(m.marioObj, gLakituState.pos.x, gLakituState.pos.y, gLakituState.pos.z)
	local lakitu_dist = string.format("%.1f", tostring(lakitu_dist_info))
	if m.controller.buttonDown & L_TRIG ~= 0 then
		if m.controller.buttonPressed & L_JPAD ~= 0 then
			page = math.max(1, page - 1)
			play_sound(SOUND_MENU_CHANGE_SELECT, m.pos)
		elseif m.controller.buttonPressed & R_JPAD ~= 0 then
			page = math.min(3, page + 1)
			play_sound(SOUND_MENU_CHANGE_SELECT, m.pos)
		end
	end
	if m.wall then
		if m.wall.normal.x then wallX = tostring(m.wall.normal.x) else wallX = "nil" end
		if m.wall.normal.y then wallY = tostring(m.wall.normal.y) else wallY = "nil" end
		if m.wall.normal.z then wallZ = tostring(m.wall.normal.z) else wallZ = "nil" end
		if m.wallNormal then wallNormal = tostring(m.wallNormal) else wallNormal = "nil" end
	else
		wallX, wallY, wallZ, wallNormal = "nil", "nil", "nil", "nil"
	end


	djui_hud_set_color(0, 0, 0, 100)
	djui_hud_render_rect(x - 20, y - 25, 100, 100)

------------------------------------------------------------------------------------------------------------------------
	if page == 1 then --LOCAL PLAYER READOUTS

		djui_hud_set_color(red, green, blue, 255)
		djui_hud_print_text("----Player Stats----", x, y - 25, 0.2)
		djui_hud_print_text("mHealth: "..tostring(m.health), x, y - 20, 0.2)
		--djui_hud_print_text("HeightFromGround: "..tostring(playerHeightFromGround), x, y - 20, 0.2)
		djui_hud_print_text(xMessage, x, y - 15, 0.2)
		djui_hud_print_text(yMessage.." | DistFromGround:"..string.format("%.0f", tostring(playerHeightFromGround)), x, y - 10, 0.2)
		djui_hud_print_text(zMessage, x, y - 5, 0.2)
		djui_hud_print_text("mForwardVel = "..string.format("%.1f", tostring(m.forwardVel)), x, y + 0, 0.2)
		djui_hud_print_text("mVelX: "..mVelX, x, y + 5, 0.2)
		djui_hud_print_text("mVelY: "..mVelY, x, y + 10, 0.2)
		djui_hud_print_text("mVelZ: "..mVelZ, x, y + 15, 0.2)
		djui_hud_print_text("mFaceAngleY: "..tostring(m.faceAngle.y), x, y + 20, 0.2)
		djui_hud_print_text("mFloorHeight: "..string.format("%.1f", tostring(m.floorHeight)), x, y + 25, 0.2)
		if actionName ~= nil then
			djui_hud_print_text("mAction: "..actionName, x, y + 30, 0.2)
			djui_hud_print_text("mActionTimer: "..tostring(m.actionTimer), x, y + 35, 0.2)
			djui_hud_print_text("mActionArg: "..string.format("0x%04X", (m.action & 0x1FF)), x, y + 40, 0.2)
		else
			djui_hud_print_text("mAction: CUSTOM_ACTION", x, y + 30, 0.2)
			djui_hud_print_text("mActionTimer: "..tostring(m.actionTimer), x, y + 35, 0.2)
			djui_hud_print_text("mActionArg: CUSTOM_ARG", x, y + 40, 0.2)
		end
		if prevActionName ~= nil then
			djui_hud_print_text("mPrevAction: "..prevActionName, x, y + 45, 0.2)
		else
			djui_hud_print_text("mPrevAction: CUSTOM_ACTION", x, y + 45, 0.2)
		end
		if currAnim ~= nil then
			djui_hud_print_text("mCurrAnim: "..currAnim, x, y + 50, 0.2)
		else
			djui_hud_print_text("mCurrAnim: CUSTOM_ANIM", x, y + 50, 0.2)
		end
		djui_hud_print_text("AnimFrame: "..tostring(m.marioObj.header.gfx.animInfo.animFrame).." | oTimer:"..tostring(m.marioObj.oTimer), x, y + 55, 0.2)
	end
------------------------------------------------------------------------------------------------------------------------

	if page == 2 then --LakituState
		djui_hud_set_color(red, green, blue, 255)
		djui_hud_print_text("----Camera Stats----", x, y - 20, 0.2)
		djui_hud_print_text("LakituState: "..tostring(camera), x, y - 15, 0.2)
		djui_hud_print_text(gLakituX, x, y - 10, 0.2)
		djui_hud_print_text(gLakituY, x, y - 5, 0.2)
		djui_hud_print_text(gLakituZ, x, y, 0.2)
		djui_hud_print_text("Lakitu Yaw: "..tostring(gLakituState.yaw), x, y + 5, 0.2)
		if m.area.camera then
			djui_hud_print_text("mAreaCamera Yaw: "..tostring(m.area.camera.yaw), x, y + 10, 0.2)
		else
			djui_hud_print_text("mAreaCamera Yaw: Nil", x, y + 10, 0.2)
		end
		djui_hud_print_text("Dist Lakitu->Mario: "..tostring(lakitu_dist), x, y + 15, 0.2)
		djui_hud_print_text("Camera frozen: "..tostring(camera_frozen), x, y + 20, 0.2)

	end
------------------------------------------------------------------------------------------------------------------------
	if page == 3 then --Level Information
		djui_hud_set_color(red, green, blue, 255)
		djui_hud_print_text("----Level Stats----", x, y - 20, 0.2)
		if level then
			djui_hud_print_text("Level: "..level, x, y - 15, 0.2)
		else
			djui_hud_print_text("Level: LEVEL_CUSTOM", x, y - 15, 0.2)
		end
		djui_hud_print_text("Course Num: "..tostring(np.currCourseNum), x, y - 10, 0.2)
		djui_hud_print_text("Area Index: "..tostring(np.currAreaIndex), x, y - 5, 0.2)
		djui_hud_print_text("Level BGM: "..tostring(sound), x, y, 0.2)
		djui_hud_print_text("Fix Collision Bugs: ".. tostring(gLevelValues.fixCollisionBugs), x, y + 5, 0.2 )
		djui_hud_print_text("m.wallNormal: "..wallNormal, x, y + 10, 0.2 )
		djui_hud_print_text("m.wall.normal.x: "..wallX, x, y + 15, 0.2 )
		djui_hud_print_text("m.wall.normal.y: "..wallY, x, y + 20, 0.2 )
		djui_hud_print_text("m.wall.normal.z: "..wallZ, x, y + 25, 0.2 )

		

	end
------------------------------------------------------------------------------------------------------------------------



	djui_hud_set_color(255, 255, 255, 100)
	djui_hud_render_texture(tex_Dpad_Empty, x, y + 66, 0.5, 0.5) --Was y+66 but moving
	djui_hud_set_color(255, 255, 255, 255)

	local buttons = m.controller.buttonDown
	for flag, texture in pairs(dPad) do
		if (buttons & flag) ~= 0 then
			djui_hud_render_texture(texture, x, y + 66, 0.5, 0.5)
		end
	end

if m.controller.stickX ~= 0 or m.controller.stickY ~= 0 then
	local t = m.controller.stickMag / 64
	local alpha = lerp(100, 255, t)
	djui_hud_set_color(255, 255, 255, alpha)
    djui_hud_render_texture(tex_L_Stick, x, y + 60, 0.5, 0.5)
	local angleRad = math.atan(m.controller.stickY, m.controller.stickX)
    local stick = angleRad * (180 / math.pi)
	local stickDirection = degrees_to_sm64(stick)
    djui_hud_set_rotation(stickDirection, 0.5, 0.5)
    djui_hud_render_texture(tex_Stick_Point, x, y + 60, 0.5, 0.5)
    djui_hud_set_rotation(0, 0.5, 0.5)
else
	djui_hud_set_color(255, 255, 255, 100)
    djui_hud_render_texture(tex_L_Stick, x, y + 60, 0.5, 0.5)
	djui_hud_set_color(255, 255, 255, 255)
end

if m.controller.extStickX ~= 0 or m.controller.extStickY ~= 0 then
	local extStickMag = math.sqrt(m.controller.extStickX^2 + m.controller.extStickY^2)
	local t = extStickMag / 128
	local alpha = lerp(100, 255, t)
	djui_hud_set_color(255, 255, 255, math.min(alpha, 255))
    djui_hud_render_texture(tex_R_Stick, x + 8, y + 60, 0.5, 0.5)
	local angleRad = math.atan(m.controller.extStickY, m.controller.extStickX)
    local stick = angleRad * (180 / math.pi)
	local stickDirection = degrees_to_sm64(stick)
    djui_hud_set_rotation(stickDirection, 0.5, 0.5)
    djui_hud_render_texture(tex_Stick_Point, x + 8, y + 60, 0.5, 0.5)
    djui_hud_set_rotation(0, 0.5, 0.5)
else
	djui_hud_set_color(255, 255, 255, 100)
    djui_hud_render_texture(tex_R_Stick, x + 8, y + 60, 0.5, 0.5)
	djui_hud_set_color(255, 255, 255, 255)
end

if m.controller.buttonDown & Z_TRIG ~= 0 then
    djui_hud_render_texture(tex_Z_Trig, x + 15, y + 60, 0.5, 0.5)
else
	djui_hud_set_color(255, 255, 255, 100)
    djui_hud_render_texture(tex_Z_Trig, x + 15, y + 60, 0.5, 0.5)
	djui_hud_set_color(255, 255, 255, 255)
end

if m.controller.buttonDown & R_TRIG ~= 0 then
    djui_hud_render_texture(tex_R_Trig, x + 22, y + 60, 0.5, 0.5)
else
	djui_hud_set_color(255, 255, 255, 100)
    djui_hud_render_texture(tex_R_Trig, x + 22, y + 60, 0.5, 0.5)
	djui_hud_set_color(255, 255, 255, 255)
end

if m.controller.buttonDown & L_TRIG ~= 0 then
    djui_hud_render_texture(tex_L_Trig, x + 29, y + 60, 0.5, 0.5)
else
	djui_hud_set_color(255, 255, 255, 100)
    djui_hud_render_texture(tex_L_Trig, x + 29, y + 60, 0.5, 0.5)
	djui_hud_set_color(255, 255, 255, 255)
end

if m.controller.buttonDown & A_BUTTON ~= 0 then
    djui_hud_render_texture(tex_A_Button, x + 8, y + 66, 0.5, 0.5)
else
	djui_hud_set_color(255, 255, 255, 100)
    djui_hud_render_texture(tex_A_Button, x + 8, y + 66, 0.5, 0.5)
	djui_hud_set_color(255, 255, 255, 255)
end

if m.controller.buttonDown & B_BUTTON ~= 0 then
    djui_hud_render_texture(tex_B_Button, x + 14, y + 66, 0.5, 0.5)
else
	djui_hud_set_color(255, 255, 255, 100)
    djui_hud_render_texture(tex_B_Button, x + 14, y + 66, 0.5, 0.5)
	djui_hud_set_color(255, 255, 255, 255)
end

if m.controller.buttonDown & X_BUTTON ~= 0 then
    djui_hud_render_texture(tex_X_Button, x + 20, y + 66, 0.5, 0.5)
else
	djui_hud_set_color(255, 255, 255, 100)
    djui_hud_render_texture(tex_X_Button, x + 20, y + 66, 0.5, 0.5)
	djui_hud_set_color(255, 255, 255, 255)
end

if m.controller.buttonDown & Y_BUTTON ~= 0 then
    djui_hud_render_texture(tex_Y_Button, x + 26, y + 66, 0.5, 0.5)
else
	djui_hud_set_color(255, 255, 255, 100)
    djui_hud_render_texture(tex_Y_Button, x + 26, y + 66, 0.5, 0.5)
	djui_hud_set_color(255, 255, 255, 255)
end


end
hook_event(HOOK_ON_HUD_RENDER, live_readout)

