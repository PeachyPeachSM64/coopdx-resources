-- name: Surface display
-- description: Show level and object surfaces.\n\nGo to the mod menu to enable static surfaces, dynamic surfaces or SOC surfaces.\n\\#08f\\Blue\\#\\ surfaces are floors, \\#f00\\red\\#\\ are ceilings, \\#0a0\\green\\#\\ are X-oriented walls and \\#cc0\\yellow\\#\\ are Z-oriented walls.\n\nBy PeachyPeach.

local SURFACE_POOL_STATIC = SURFACE_POOL_STATIC
local SURFACE_POOL_DYNAMIC = SURFACE_POOL_DYNAMIC
local SURFACE_POOL_SOC = SURFACE_POOL_SOC

local sShowStaticSurfaces = false
local sShowDynamicSurfaces = false
local sShowSOCSurfaces = false
local sShowSurfacesCount = true

---------
-- GFX --
---------

-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! --
-- !! Be careful, this shit has a lot of micro-optimization, !! --
-- !! because the Gfx Lua API is reeeeally slow, and we need !! --
-- !! to construct a loooot of triangles                     !! --
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! --

local max = math.max
local abs = math.abs
local floor = math.floor
local strfmt = string.format
local tblpop = table.remove
local gfx_create = gfx_create
local gfx_resize = gfx_resize
local gfx_set_command = gfx_set_command
local gfx_get_command = gfx_get_command
local gfx_get_from_name = gfx_get_from_name
local vtx_create = vtx_create
local vtx_resize = vtx_resize
local vtx_get_from_name = vtx_get_from_name
local vtx_get_vertex = vtx_get_vertex
local vtx_get_next_vertex = vtx_get_next_vertex

-- not exposed lol
-- we need 6 vertices and 5 commands per surface
local MOD_DATA_DISPLAY_LIST_MAX_LENGTH = 0x800
local MOD_DATA_VERTEX_BUFFER_MAX_COUNT = 0x1000
local NUM_COMMANDS_PER_SURFACE = 5
local NUM_VERTICES_PER_SURFACE = 6
local MAX_SURFACES_PER_DISPLAY_LIST = floor((MOD_DATA_DISPLAY_LIST_MAX_LENGTH - 1) / NUM_COMMANDS_PER_SURFACE)

local sSurfacesGfxIndices  = {
    [SURFACE_POOL_STATIC]  = { count = 0, free = {} },
    [SURFACE_POOL_DYNAMIC] = { count = 0, free = {} },
    [SURFACE_POOL_SOC]     = { count = 0, free = {} },
}

local function gfx_set(gfx, offset, command, ...)
    gfx_set_command(gfx_get_command(gfx, offset), command, ...)
end

local function get_surface_gfx_from_index(index, poolType)
    local dlindex = floor(index / MAX_SURFACES_PER_DISPLAY_LIST)
    local subindex = index % MAX_SURFACES_PER_DISPLAY_LIST
    local gfx = gfx_get_from_name(strfmt("debug_surfaces_%d_gfx_%d", poolType, dlindex))
    return gfx_get_command(gfx, subindex * NUM_COMMANDS_PER_SURFACE)
end

local function get_surface_vtx_from_index(index, poolType)
    local dlindex = floor(index / MAX_SURFACES_PER_DISPLAY_LIST)
    local subindex = index % MAX_SURFACES_PER_DISPLAY_LIST
    local vtx = vtx_get_from_name(strfmt("debug_surfaces_%d_vtx_%d", poolType, dlindex))
    return vtx_get_vertex(vtx, subindex * NUM_VERTICES_PER_SURFACE)
end

local function get_surfaces_gfx(poolType)
    local name = strfmt("debug_surfaces_%d_gfx", poolType)
    local gfx = gfx_get_from_name(name)
    if not gfx then
        gfx = gfx_create(name, 4)
        gfx_set(gfx, 0, "gsSPClearGeometryMode(G_CULL_BOTH | G_LIGHTING)")
        gfx_set(gfx, 1, "gsSPSetGeometryMode(G_CULL_BACK)")
        gfx_set(gfx, 2, "gsDPSetCombineMode(G_CC_SHADE, G_CC_SHADE)")
        gfx_set(gfx, 3, "gsSPEndDisplayList()")
    end
    return gfx
end

local function allocate_surface_gfx(poolType)
    if #sSurfacesGfxIndices[poolType].free > 0 then
        return tblpop(sSurfacesGfxIndices[poolType].free)
    end

    local count = sSurfacesGfxIndices[poolType].count

    -- we need to allocate a new display list and vertex buffer
    if count % MAX_SURFACES_PER_DISPLAY_LIST == 0 then
        local dlcount = floor(count / MAX_SURFACES_PER_DISPLAY_LIST)
        local vtxName = strfmt("debug_surfaces_%d_vtx_%d", poolType, dlcount)
        local vtx = vtx_get_from_name(vtxName) or vtx_create(vtxName, 1)
        local dlName = strfmt("debug_surfaces_%d_gfx_%d", poolType, dlcount)
        local dl = gfx_get_from_name(dlName) or gfx_create(dlName, 1)
        gfx_set(dl, 0, "gsSPEndDisplayList()")

        -- resize main display list, branch new dl
        local gfx = get_surfaces_gfx(poolType)
        gfx_resize(gfx, 4 + dlcount + 1)
        gfx_set(gfx, 3 + dlcount, "gsSPDisplayList(%g)", dl)
        gfx_set(gfx, 3 + dlcount + 1, "gsSPEndDisplayList()")
    end

    local index0 = floor(count / MAX_SURFACES_PER_DISPLAY_LIST) * MAX_SURFACES_PER_DISPLAY_LIST
    local subindex = count % MAX_SURFACES_PER_DISPLAY_LIST

    -- resize vertex buffer
    local vtx = get_surface_vtx_from_index(index0, poolType)
    vtx_resize(vtx, NUM_VERTICES_PER_SURFACE * (subindex + 1))

    -- init vtx
    -- alpha value never changes
    vtx = get_surface_vtx_from_index(count, poolType)
    for _ = 1, NUM_VERTICES_PER_SURFACE do
        vtx.flag = 0
        vtx.a = 0xFF
        vtx = vtx_get_next_vertex(vtx)
    end

    -- resize display list
    local gfx = get_surface_gfx_from_index(index0, poolType)
    gfx_resize(gfx, NUM_COMMANDS_PER_SURFACE * (subindex + 1) + 1)

    -- init gfx
    -- the triangle commands are always the same
    gfx = get_surface_gfx_from_index(count, poolType)
    gfx_set(gfx, 1, "gsSP1Triangle(3, 4, 5, 0)")
    gfx_set(gfx, 2, "gsSP2Triangles(0, 1, 3, 0, 3, 1, 4, 0)")
    gfx_set(gfx, 3, "gsSP2Triangles(1, 2, 4, 0, 4, 2, 5, 0)")
    gfx_set(gfx, 4, "gsSP2Triangles(2, 0, 5, 0, 5, 0, 3, 0)")
    gfx_set(gfx, 5, "gsSPEndDisplayList()")

    sSurfacesGfxIndices[poolType].count = count + 1
    return count
end

-- preallocated tables
local v = {{ x = 0, y = 0, z = 0 },
           { x = 0, y = 0, z = 0 },
           { x = 0, y = 0, z = 0 }}
local c  = { x = 0, y = 0, z = 0 }
local dv = { x = 0, y = 0, z = 0 }

local function compute_surface_vtx(vtx, surf)
    local r, g, b, flag

    -- floor
    if surf.normal.y > gLevelValues.floorNormalMinY then
        r, g, b, flag = 0x00, 0x40, 0x7F, 1

    -- ceiling
    elseif surf.normal.y < gLevelValues.ceilNormalMaxY then
        r, g, b, flag = 0x7F, 0x00, 0x00, 2

    -- wall (x)
    elseif abs(surf.normal.x) > 0.707 then
        r, g, b, flag = 0x00, 0x50, 0x00, 3

    -- wall (z)
    else
        r, g, b, flag = 0x60, 0x60, 0x00, 4
    end

    v[1].x, v[1].y, v[1].z = surf.vertex1.x, surf.vertex1.y, surf.vertex1.z
    v[2].x, v[2].y, v[2].z = surf.vertex2.x, surf.vertex2.y, surf.vertex2.z
    v[3].x, v[3].y, v[3].z = surf.vertex3.x, surf.vertex3.y, surf.vertex3.z
    c.x = (v[1].x + v[2].x + v[3].x) / 3
    c.y = (v[1].y + v[2].y + v[3].y) / 3
    c.z = (v[1].z + v[2].z + v[3].z) / 3

    for i = 1, 6 do
        local vi = v[1 + (i - 1) % 3]
        if i > 3 then
            dv.x = vi.x - c.x
            dv.y = vi.y - c.y
            dv.z = vi.z - c.z
            local mult = max(0.5, 1.0 - (20.0 / vec3f_length(dv)))
            vi.x = c.x + mult * dv.x
            vi.y = c.y + mult * dv.y
            vi.z = c.z + mult * dv.z
        end
        vtx.x = vi.x
        vtx.y = vi.y
        vtx.z = vi.z
        if vtx.flag ~= flag then -- change color only when necessary
            vtx.r = r
            vtx.g = g
            vtx.b = b
            vtx.flag = flag
        end
        vtx = vtx_get_next_vertex(vtx)
        if i == 3 then
            r = r << 1
            g = g << 1
            b = b << 1
        end
    end
end

local function update_surface_gfx(index, poolType, surf)
    if index == -1 then
        index = allocate_surface_gfx(poolType)
    end

    local vtx = get_surface_vtx_from_index(index, poolType)
    compute_surface_vtx(vtx, surf)

    local gfx = get_surface_gfx_from_index(index, poolType)
    gfx_set(gfx, 0, "gsSPVertex(%v, 6, 0)", vtx)

    return index
end

local function remove_surface_gfx(index, poolType)
    local gfx = get_surface_gfx_from_index(index, poolType)
    -- "erase" vertices
    gfx_set(gfx, 0, "gsSPVertex(NULL, 0, 0)")
    sSurfacesGfxIndices[poolType].free[#sSurfacesGfxIndices[poolType].free+1] = index
end

local function clear_surfaces_gfx()
    for _, poolType in ipairs({ SURFACE_POOL_STATIC, SURFACE_POOL_DYNAMIC, SURFACE_POOL_SOC }) do
        local gfx = get_surfaces_gfx(poolType)
        gfx_set(gfx, 3, "gsSPEndDisplayList()")
        sSurfacesGfxIndices[poolType].count = 0
        sSurfacesGfxIndices[poolType].free = {}
    end
end

--------------
-- Surfaces --
--------------

local sStaticSurfaces = { count = 0, surfaces = {} }
local sDynamicSurfaces = { count = 0, surfaces = {} }
local sSOCSurfaces = { count = 0, tangible = 0, socs = {}, load = {} }

local sIsSmluaCollision = false
local sIsLoadAreaTerrain = false

local SURFACE_EVENT_toggle_static_object_collision  = 1
local SURFACE_EVENT_remove_static_object_collision  = 2
local SURFACE_EVENT_smlua_collision_move_surface    = 3
local SURFACE_EVENT_smlua_collision_delete_surface  = 4

local sSurfaceEvents = {}

-- Because Gfx and Vtx are local to mods, overridden globals cannot call
-- the surface gfx functions above (otherwise the Gfx and Vtx would be
-- created by the mod that call them, not this one)
-- This concerns the following functions:
-- - `toggle_static_object_collision`
-- - `remove_static_object_collision`
-- - `smlua_collision_move_surface`
-- - `smlua_collision_delete_surface`
local function add_surface_event(event, params)
    sSurfaceEvents[#sSurfaceEvents+1] = { event = event, params = params }
end

local _load_static_object_collision = load_static_object_collision
_G.load_static_object_collision = function ()
    local col = _load_static_object_collision()
    sSOCSurfaces.socs[col.index] = { tangible = true, surfaces = sSOCSurfaces.load }
    sSOCSurfaces.load = {}
    return col
end

local _toggle_static_object_collision = toggle_static_object_collision
_G.toggle_static_object_collision = function (col, tangible)
    _toggle_static_object_collision(col, tangible)
    add_surface_event(SURFACE_EVENT_toggle_static_object_collision, { col = col, tangible = tangible })
end

local _remove_static_object_collision = remove_static_object_collision
_G.remove_static_object_collision = function (col)
    add_surface_event(SURFACE_EVENT_remove_static_object_collision, { col = col })
end

local _smlua_collision_add_surface = smlua_collision_add_surface
_G.smlua_collision_add_surface = function (dynamic, surfaceType, vertex1, vertex2, vertex3)
    sIsSmluaCollision = true
    local surf = _smlua_collision_add_surface(dynamic, surfaceType, vertex1, vertex2, vertex3)
    sIsSmluaCollision = false
    return surf
end

local _smlua_collision_move_surface = smlua_collision_move_surface
_G.smlua_collision_move_surface = function (surf, vertex1, vertex2, vertex3)
    _smlua_collision_move_surface(surf, vertex1, vertex2, vertex3)
    add_surface_event(SURFACE_EVENT_smlua_collision_move_surface, { surf = surf })
end

local _smlua_collision_delete_surface = smlua_collision_delete_surface
_G.smlua_collision_delete_surface = function (surf)
    add_surface_event(SURFACE_EVENT_smlua_collision_delete_surface, { surf = surf })
end

local function clear_surfaces()
    sStaticSurfaces = { count = 0, surfaces = {} }
    sDynamicSurfaces = { count = 0, surfaces = {} }
    sSOCSurfaces = { count = 0, tangible = 0, socs = {}, load = {} }
    sSurfaceEvents = {}
    clear_surfaces_gfx()
end

local function on_add_surface(surf)

    -- Clear all surfaces if we enter load_area_terrain
    if not sIsSmluaCollision and not sIsLoadAreaTerrain and surf.poolType == SURFACE_POOL_STATIC then
        clear_surfaces()
        sIsLoadAreaTerrain = true
    end

    local uid = surf._pointer

    -- Static
    if surf.poolType == SURFACE_POOL_STATIC then
        local s = sStaticSurfaces.surfaces[uid]
        if not s then
            sStaticSurfaces.surfaces[uid] = { surface = surf, index = -1 }
            sStaticSurfaces.count = sStaticSurfaces.count + 1
            s = sStaticSurfaces.surfaces[uid]
        else
            s.surface = surf
        end
        s.index = update_surface_gfx(s.index, SURFACE_POOL_STATIC, s.surface)

    -- Dynamic
    -- Skip if sShowDynamicSurfaces is false, surfaces are going to be recreated next frame anyway
    elseif surf.poolType == SURFACE_POOL_DYNAMIC and sShowDynamicSurfaces then
        local s = sDynamicSurfaces.surfaces[uid]
        if not s then
            sDynamicSurfaces.surfaces[uid] = { surface = surf, index = -1 }
            sDynamicSurfaces.count = sDynamicSurfaces.count + 1
            s = sDynamicSurfaces.surfaces[uid]
        else
            s.surface = surf
        end
        s.index = update_surface_gfx(s.index, SURFACE_POOL_DYNAMIC, s.surface)
        register_surface_object(s.surface.object, SURFACE_POOL_DYNAMIC)

    -- SOC
    elseif surf.poolType == SURFACE_POOL_SOC then
        sSOCSurfaces.load[uid] = { surface = surf, index = -1 }
        sSOCSurfaces.count = sSOCSurfaces.count + 1
        sSOCSurfaces.tangible = sSOCSurfaces.tangible + 1
        local s = sSOCSurfaces.load[uid]
        s.index = update_surface_gfx(s.index, SURFACE_POOL_SOC, s.surface)
        register_surface_object(s.surface.object, SURFACE_POOL_SOC)
    end
end

local SURFACE_EVENTS = {

[SURFACE_EVENT_toggle_static_object_collision] = function (params)
    local soc = sSOCSurfaces.socs[params.col.index]
    for _, s in pairs(soc.surfaces) do

        -- Hide surfaces
        if soc.tangible and not params.tangible then
            remove_surface_gfx(s.index, SURFACE_POOL_SOC)
            unregister_surface_object(s.surface.object)
            sSOCSurfaces.tangible = sSOCSurfaces.tangible - 1
            s.index = -1

        -- Show surfaces
        elseif not soc.tangible and params.tangible then
            s.index = update_surface_gfx(s.index, SURFACE_POOL_SOC, s.surface)
            register_surface_object(s.surface.object, SURFACE_POOL_SOC)
            sSOCSurfaces.tangible = sSOCSurfaces.tangible + 1
        end
    end
    soc.tangible = params.tangible
end,

[SURFACE_EVENT_remove_static_object_collision] = function (params)
    local soc = sSOCSurfaces.socs[params.col.index]
    for _, s in pairs(soc.surfaces) do
        remove_surface_gfx(s.index, SURFACE_POOL_SOC)
        unregister_surface_object(s.surface.object)
        sSOCSurfaces.tangible = sSOCSurfaces.tangible - 1
        sSOCSurfaces.count = sSOCSurfaces.count - 1
    end
    sSOCSurfaces.socs[params.col.index] = nil
    _remove_static_object_collision(params.col)
end,

[SURFACE_EVENT_smlua_collision_move_surface] = function (params)
    local surf = params.surf

    -- Static
    if surf.poolType == SURFACE_POOL_STATIC then
        local s = sStaticSurfaces.surfaces[surf._pointer]
        s.index = update_surface_gfx(s.index, SURFACE_POOL_STATIC, s.surface)

    -- Dynamic
    -- Skip if sShowDynamicSurfaces is false, surfaces are going to be recreated next frame anyway
    elseif surf.poolType == SURFACE_POOL_DYNAMIC and sShowDynamicSurfaces then
        local s = sDynamicSurfaces.surfaces[surf._pointer]
        s.index = update_surface_gfx(s.index, SURFACE_POOL_DYNAMIC, s.surface)
        register_surface_object(s.surface.object, SURFACE_POOL_DYNAMIC)

    -- SOC
    elseif surf.poolType == SURFACE_POOL_SOC then
        local soc = sSOCSurfaces.socs[surf.socId]
        if soc.tangible then
            local s = soc.surfaces[surf._pointer]
            s.index = update_surface_gfx(s.index, SURFACE_POOL_SOC, s.surface)
            register_surface_object(s.surface.object, SURFACE_POOL_SOC)
        end
    end
end,

[SURFACE_EVENT_smlua_collision_delete_surface] = function (params)
    local surf = params.surf

    -- Static
    if surf.poolType == SURFACE_POOL_STATIC then
        local s = sStaticSurfaces.surfaces[surf._pointer]
        remove_surface_gfx(s.index, SURFACE_POOL_STATIC)
        sStaticSurfaces.surfaces[surf._pointer] = nil
        sStaticSurfaces.count = sStaticSurfaces.count - 1

    -- Dynamic
    -- Skip if sShowDynamicSurfaces is false, surfaces are going to be recreated next frame anyway
    elseif surf.poolType == SURFACE_POOL_DYNAMIC and sShowDynamicSurfaces then
        local s = sDynamicSurfaces.surfaces[surf._pointer]
        remove_surface_gfx(s.index, SURFACE_POOL_DYNAMIC)
        unregister_surface_object(s.surface.object)
        sDynamicSurfaces.surfaces[surf._pointer] = nil
        sDynamicSurfaces.count = sDynamicSurfaces.count - 1

    -- SOC
    elseif surf.poolType == SURFACE_POOL_SOC then
        local soc = sSOCSurfaces.socs[surf.socId]
        local s = soc.surfaces[surf._pointer]
        remove_surface_gfx(s.index, SURFACE_POOL_SOC)
        unregister_surface_object(s.surface.object)
        sSOCSurfaces.tangible = sSOCSurfaces.tangible - 1
        sSOCSurfaces.count = sSOCSurfaces.count - 1
        soc.surfaces[surf._pointer] = nil
    end

    _smlua_collision_delete_surface(surf)
end,
}

local function process_surface_events()
    for _, e in ipairs(sSurfaceEvents) do
        SURFACE_EVENTS[e.event](e.params)
    end
    sSurfaceEvents = {}
end

local function update_dynamic_surfaces()
    local invalidated = {}
    for uid, s in pairs(sDynamicSurfaces.surfaces) do
        if ~s.surface then
            invalidated[#invalidated+1] = uid
        end
    end
    for _, uid in ipairs(invalidated) do
        local s = sDynamicSurfaces.surfaces[uid]
        remove_surface_gfx(s.index, SURFACE_POOL_DYNAMIC)
        sDynamicSurfaces.count = sDynamicSurfaces.count - 1
        sDynamicSurfaces.surfaces[uid] = nil
    end
end

-------------
-- Objects --
-------------

local E_MODEL_DUMMY = smlua_model_util_get_id("dummy_geo")
local SURFACE_POOL_BHV_ID = 99

-- TODO: change it when better custom object fields
local OBJ_FIELD_SURFACE_POOL_TYPE = OBJECT_NUM_FIELDS - 1
local obj_get_field_s32 = obj_get_field_s32
local obj_set_field_s32 = obj_set_field_s32
local obj_get_surface_pool_type = function (obj) return obj_get_field_s32(obj, OBJ_FIELD_SURFACE_POOL_TYPE) - 1 end
local obj_set_surface_pool_type = function (obj, poolType) obj_set_field_s32(obj, OBJ_FIELD_SURFACE_POOL_TYPE, poolType + 1) end
local obj_get_prev_surface_pool_type = function (obj) return obj_get_field_s32(obj, OBJ_FIELD_SURFACE_POOL_TYPE - 1) - 1 end
local obj_set_prev_surface_pool_type = function (obj, poolType) obj_set_field_s32(obj, OBJ_FIELD_SURFACE_POOL_TYPE - 1, poolType + 1) end
local cast_graph_node = cast_graph_node

function register_surface_object(obj, poolType)
    if obj.header.gfx.sharedChild then
        obj.header.gfx.sharedChild.hookProcess = 1
    end
    obj_set_surface_pool_type(obj, poolType)
end

function unregister_surface_object(obj)
    if obj.header.gfx.sharedChild then
        obj.header.gfx.sharedChild.hookProcess = 1
    end
    obj_set_surface_pool_type(obj, -1)
end

local IGNORE_GRAPH_NODE_TYPES = {
    [GRAPH_NODE_TYPE_OBJECT_PARENT] = true,
    [GRAPH_NODE_TYPE_SWITCH_CASE] = true,
    [GRAPH_NODE_TYPE_GENERATED_LIST] = true,
}

-- Check if it's a GEO_ASM that renders moving surfaces
-- Works for vanilla, I guess?
local MOVTEX_SURFACE = {
    [0x0801] = true, -- MOVTEX_PYRAMID_SAND_PATHWAY_FRONT, MOVTEX_SSL_PYRAMID_SIDE, MOVTEX_SSL_SAND_PIT_OUTSIDE
    [0x0802] = true, -- MOVTEX_PYRAMID_SAND_PATHWAY_FLOOR, MOVTEX_SSL_PYRAMID_CORNER, MOVTEX_SSL_SAND_PIT_PYRAMID
    [0x0803] = true, -- MOVTEX_PYRAMID_SAND_PATHWAY_SIDE, MOVTEX_SSL_COURSE_EDGE
    [0x1901] = true, -- MOVTEX_BITFS_LAVA_FIRST
    [0x1902] = true, -- MOVTEX_BITFS_LAVA_SECOND
    [0x1903] = true, -- MOVTEX_BITFS_LAVA_FLOOR
    [0x2201] = true, -- MOVTEX_LLL_LAVA_FLOOR
    [0x2202] = true, -- MOVTEX_VOLCANO_LAVA_FALL
    [0x1400] = true, -- MOVTEX_TREADMILL_BIG
    [0x1401] = true, -- MOVTEX_TREADMILL_SMALL
}
local function is_geo_asm_movtex_surface(node)
    if node.type == GRAPH_NODE_TYPE_GENERATED_LIST then
        return MOVTEX_SURFACE[cast_graph_node(node).parameter] ~= nil
    end
    return false
end

local function hide_graph_node(node, isLevelGeo)
    if node and node.children then
        local head = node.children
        local curr = head
        repeat
            if isLevelGeo and IGNORE_GRAPH_NODE_TYPES[curr.type] and not is_geo_asm_movtex_surface(curr) then
                if curr.type & GRAPH_NODE_TYPE_FUNCTIONAL ~= 0 then
                    hide_graph_node(curr, true)
                end
            else
                curr.flags = curr.flags & ~GRAPH_RENDER_ACTIVE
            end
            curr = curr.next
        until curr == head
    end
end

local function unhide_graph_node(node, isLevelGeo)
    if node and node.children then
        local head = node.children
        local curr = head
        repeat
            if isLevelGeo and IGNORE_GRAPH_NODE_TYPES[curr.type] and curr.type & GRAPH_NODE_TYPE_FUNCTIONAL ~= 0 then
                unhide_graph_node(curr, true)
            end
            curr.flags = curr.flags | GRAPH_RENDER_ACTIVE
            curr = curr.next
        until curr == head
    end
end

local function hide_or_unhide(node, showSurfaces, isLevelGeo)
    if showSurfaces then
        hide_graph_node(node, isLevelGeo)
    else
        unhide_graph_node(node, isLevelGeo)
    end
end

local function before_geo_process(node)

    -- Level geometry
    if node.type == GRAPH_NODE_TYPE_CAMERA then
        hide_or_unhide(node, sShowStaticSurfaces, true)

    -- Surfaces
    else
        local obj = geo_get_current_object()
        if obj then
            local poolType = obj_get_surface_pool_type(obj)
            obj_set_prev_surface_pool_type(obj, poolType)
            if poolType == SURFACE_POOL_STATIC then
                hide_or_unhide(node, sShowStaticSurfaces, false)
            elseif poolType == SURFACE_POOL_DYNAMIC then
                hide_or_unhide(node, sShowDynamicSurfaces, false)
                obj_set_surface_pool_type(obj, -1)
            elseif poolType == SURFACE_POOL_SOC then
                hide_or_unhide(node, sShowSOCSurfaces, false)
            elseif poolType >= SURFACE_POOL_BHV_ID then
                local bhvId = poolType - SURFACE_POOL_BHV_ID
                local collisionObj = obj_get_first_with_behavior_id(bhvId)
                if collisionObj and obj_get_prev_surface_pool_type(collisionObj) == SURFACE_POOL_DYNAMIC then
                    hide_or_unhide(node, sShowDynamicSurfaces, false)
                else
                    unhide_graph_node(node, false)
                end
            else
                unhide_graph_node(node, false)
            end
        end
    end
end

local function after_geo_process(node)
    unhide_graph_node(node, node.type == GRAPH_NODE_TYPE_CAMERA)
end

local function on_object_render()
    local camera = geo_get_current_camera()
    if camera then
        camera.fnNode.node.hookProcess = 1
    end
end

local function debug_surfaces_update(o)
    if not (sShowStaticSurfaces or sShowDynamicSurfaces or sShowSOCSurfaces) then
        obj_mark_for_deletion(o)
        return
    end

    obj_set_pos(o, 0, 0, 0)
    obj_set_angle(o, 0, 0, 0)
    obj_scale(o, 1)
    obj_update_gfx_pos_and_angle(o)
    o.header.gfx.skipInViewCheck = true

    local staticSurfacesNode = cast_graph_node(o.header.gfx.sharedChild.children)
    local dynamicSurfacesNode = cast_graph_node(o.header.gfx.sharedChild.children.next)
    local SOCSurfacesNode = cast_graph_node(o.header.gfx.sharedChild.children.next.next)
    staticSurfacesNode.displayList = sShowStaticSurfaces and get_surfaces_gfx(SURFACE_POOL_STATIC) or nil
    dynamicSurfacesNode.displayList = sShowDynamicSurfaces and get_surfaces_gfx(SURFACE_POOL_DYNAMIC) or nil
    SOCSurfacesNode.displayList = sShowSOCSurfaces and get_surfaces_gfx(SURFACE_POOL_SOC) or nil
end

local id_bhvDebugSurfaces = hook_behavior(nil, OBJ_LIST_EXT, true, nil, debug_surfaces_update, "bhvDebugSurfaces") -- OBJ_LIST_EXT is updated last
local E_MODEL_DEBUG_SURFACES = smlua_model_util_get_id("debug_surfaces_geo")

local function spawn_debug_surfaces_object()
    if sShowStaticSurfaces or sShowDynamicSurfaces or sShowSOCSurfaces then
        local o = obj_get_first_with_behavior_id(id_bhvDebugSurfaces)
        if not o then
            spawn_non_sync_object(id_bhvDebugSurfaces, E_MODEL_DEBUG_SURFACES, 0, 0, 0, nil)
        end
    end
end

-- Hide these
hook_behavior(id_bhvStaticObject, OBJ_LIST_DEFAULT, false, function (o) register_surface_object(o, SURFACE_POOL_STATIC) end, nil, "bhvStaticObject")

-- Register with custom surface pool that points to collision objects
hook_behavior(id_bhvSunkenShipPart, OBJ_LIST_DEFAULT, false, function (o) register_surface_object(o, SURFACE_POOL_BHV_ID + id_bhvInSunkenShip) end, nil, "bhvSunkenShipPart")
hook_behavior(id_bhvSunkenShipPart2, OBJ_LIST_DEFAULT, false, function (o) register_surface_object(o, SURFACE_POOL_BHV_ID + id_bhvInSunkenShip2) end, nil, "bhvSunkenShipPart2")
hook_behavior(id_bhvShipPart3, OBJ_LIST_DEFAULT, false, function (o) register_surface_object(o, SURFACE_POOL_BHV_ID + id_bhvInSunkenShip3) end, nil, "bhvShipPart3")

-- Set a dummy model to trigger the geo process hooks
hook_behavior(id_bhvInSunkenShip, OBJ_LIST_SURFACE, false, function (o) obj_set_model_extended(o, E_MODEL_DUMMY) end, nil, "bhvInSunkenShip")
hook_behavior(id_bhvInSunkenShip2, OBJ_LIST_SURFACE, false, function (o) obj_set_model_extended(o, E_MODEL_DUMMY) end, nil, "bhvInSunkenShip2")
hook_behavior(id_bhvInSunkenShip3, OBJ_LIST_SURFACE, false, function (o) obj_set_model_extended(o, E_MODEL_DUMMY) end, nil, "bhvInSunkenShip3")

-----------------
-- HUD display --
-----------------

local function on_hud_render()
    local numLines = (sShowStaticSurfaces and 1 or 0) +
                     (sShowDynamicSurfaces and 1 or 0) +
                     (sShowSOCSurfaces and 1 or 0)
    if sShowSurfacesCount and numLines > 0 then
        djui_hud_set_resolution(RESOLUTION_N64)
        djui_hud_set_font(FONT_SPECIAL)
        local screenh = djui_hud_get_screen_height()
        local scale = 0.4

        local text = (
            (sShowStaticSurfaces and strfmt("\n\\#bbb\\Static surfaces: \\#\\%d", sStaticSurfaces.count) or "") ..
            (sShowDynamicSurfaces and strfmt("\n\\#bbb\\Dynamic surfaces: \\#\\%d", sDynamicSurfaces.count) or "") ..
            (sShowSOCSurfaces and strfmt("\n\\#bbb\\SOC surfaces: \\#\\%d / %d", sSOCSurfaces.tangible, sSOCSurfaces.count) or "")
        ):sub(2)
        local width, height = djui_hud_measure_text(text)
        width = width * scale
        height = height * scale

        djui_hud_set_color(0, 0, 0, 120)
        djui_hud_render_rect(12, screenh - 12 - (height + 4), width + 8, height + 4)
        djui_hud_set_color(255, 255, 255, 255)
        djui_hud_set_text_color(255, 255, 255, 255)
        djui_hud_set_text_alignment(TEXT_HALIGN_LEFT, TEXT_VALIGN_BOTTOM)
        djui_hud_print_text(text, 16, screenh - 16, scale, scale)
    end
end

-----------
-- Hooks --
-----------

-- Make sure to hook everything after all other mods
hook_event(HOOK_ON_MODS_LOADED, function ()

hook_event(HOOK_ON_ADD_SURFACE, on_add_surface)
hook_event(HOOK_ON_CLEAR_AREAS, clear_surfaces)
hook_event(HOOK_UPDATE, process_surface_events)
hook_event(HOOK_UPDATE, update_dynamic_surfaces)
hook_event(HOOK_UPDATE, function () sIsLoadAreaTerrain = false end)

hook_event(HOOK_BEFORE_GEO_PROCESS, before_geo_process)
hook_event(HOOK_ON_GEO_PROCESS, after_geo_process)
hook_event(HOOK_ON_OBJECT_RENDER, on_object_render)
hook_event(HOOK_UPDATE, spawn_debug_surfaces_object)
hook_event(HOOK_UPDATE, function () gMarioStates[0].marioObj.hookRender = 1 end)

hook_event(HOOK_ON_HUD_RENDER, on_hud_render)

hook_mod_menu_checkbox("Show static surfaces", sShowStaticSurfaces, function (_, value) sShowStaticSurfaces = value end)
hook_mod_menu_checkbox("Show dynamic surfaces", sShowDynamicSurfaces, function (_, value) sShowDynamicSurfaces = value end)
hook_mod_menu_checkbox("Show SOC surfaces", sShowSOCSurfaces, function (_, value) sShowSOCSurfaces = value end)
hook_mod_menu_checkbox("Show surfaces count", sShowSurfacesCount, function (_, value) sShowSurfacesCount = value end)

end)
