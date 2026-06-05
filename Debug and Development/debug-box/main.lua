-- name: Hitbox display
-- description: Show object hitboxes.\n\nGo to the mod menu to enable hitboxes (\\#4cf\\blue\\#\\), hurtboxes (\\#f44\\red\\#\\) or wallboxes (\\#4c4\\green\\#\\).\n\nBy PeachyPeach.

local sShowHitboxes = false
local sShowHurtboxes = false
local sShowWallboxes = false

local E_MODEL_DEBUGBOX = smlua_model_util_get_id("debugbox_geo")

local OBJECT_LISTS = {
    OBJ_LIST_PLAYER,
    OBJ_LIST_EXT,
    OBJ_LIST_DESTRUCTIVE,
    OBJ_LIST_GENACTOR,
    OBJ_LIST_PUSHABLE,
    OBJ_LIST_LEVEL,
    OBJ_LIST_DEFAULT,
    OBJ_LIST_SURFACE,
    OBJ_LIST_POLELIKE,
    OBJ_LIST_SPAWNER,
}

local function obj_id(obj)
    return obj._pointer & 0xFFFFFFF0
end

local function bhv_debugbox_init(o)
    o.oFlags = o.oFlags | OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.header.gfx.skipInViewCheck = true
    o.activeFlags = o.activeFlags | ACTIVE_FLAG_INITIATED_TIME_STOP
end

local function bhv_debugbox_loop(o)
    local parent = o.parentObj
    if not parent or parent.activeFlags == ACTIVE_FLAG_DEACTIVATED or parent.oIntangibleTimer ~= 0 then
        obj_mark_for_deletion(o)
        return
    end
    obj_set_angle(o, 0, 0, 0)
    obj_copy_pos(o, parent)
    o.oPosY = o.oPosY - parent.hitboxDownOffset
    if o.oAnimState == 0 then
        if not sShowHitboxes then obj_mark_for_deletion(o) return end
        obj_set_gfx_scale(o,
            parent.hitboxRadius / 100.0,
            parent.hitboxHeight / 100.0,
            parent.hitboxRadius / 100.0
        )
    elseif o.oAnimState == 1 then
        if not sShowHurtboxes then obj_mark_for_deletion(o) return end
        obj_set_gfx_scale(o,
            parent.hurtboxRadius / 100.0,
            parent.hurtboxHeight / 100.0,
            parent.hurtboxRadius / 100.0
        )
    elseif o.oAnimState == 2 then
        if not sShowWallboxes then obj_mark_for_deletion(o) return end
        obj_set_gfx_scale(o,
            parent.oWallHitboxRadius / 100.0,
            parent.hitboxHeight      / 100.0,
            parent.oWallHitboxRadius / 100.0
        )
    end
end

local id_bhvDebugbox = hook_behavior(nil, OBJ_LIST_UNIMPORTANT, true, bhv_debugbox_init, bhv_debugbox_loop, "") -- empty name to avoid polluting  "Behaviors on screen"

local function spawn_hitbox(obj, type)
    local hitbox = spawn_non_sync_object(id_bhvDebugbox, E_MODEL_DEBUGBOX, obj.oPosX, obj.oPosY, obj.oPosZ, nil)
    if hitbox then
        hitbox.oAnimState = type
        hitbox.oBehParams = obj_id(obj) + type
        hitbox.parentObj = obj
    end
end

local function on_update()
    for _, objList in ipairs(OBJECT_LISTS) do
        local obj = obj_get_first(objList)
        while obj do
            if obj.oIntangibleTimer == 0 then
                local objId = obj_id(obj)
                if sShowHitboxes and not obj_get_first_with_behavior_id_and_field_s32(id_bhvDebugbox, 0x40, objId + 0) then
                    spawn_hitbox(obj, 0)
                end
                if sShowHurtboxes and not obj_get_first_with_behavior_id_and_field_s32(id_bhvDebugbox, 0x40, objId + 1) then
                    spawn_hitbox(obj, 1)
                end
                if sShowWallboxes and not obj_get_first_with_behavior_id_and_field_s32(id_bhvDebugbox, 0x40, objId + 2) then
                    spawn_hitbox(obj, 2)
                end
            end
            obj = obj_get_next(obj)
        end
    end
end

-- Make sure to hook everything after all other mods
hook_event(HOOK_ON_MODS_LOADED, function ()

hook_event(HOOK_UPDATE, on_update)

hook_mod_menu_checkbox("Show hitboxes (\\#4cf\\blue\\#\\)", false, function (_, value) sShowHitboxes = value end)
hook_mod_menu_checkbox("Show hurtboxes (\\#f44\\red\\#\\)", false, function (_, value) sShowHurtboxes = value end)
hook_mod_menu_checkbox("Show wallboxes (\\#4c4\\green\\#\\)", false, function (_, value) sShowWallboxes = value end)

end)
