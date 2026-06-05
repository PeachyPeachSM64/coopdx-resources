-- name: \\#F00\\* \\#888\\Deep Lua Profiling \\#000\\[WIP]
-- description: Deep Lua Profiling

local function prof()
    local controller = gMarioStates[0].controller

    if (controller.buttonDown & L_TRIG) == 0 then
        return
    end

    local profile = require('/lib/profiler')
    if not profile then return end

    if (controller.buttonPressed & R_JPAD) == R_JPAD and not go then
        profile.start()
        go = true
        djui_chat_message_create("Profiling started")
    end

    if (controller.buttonDown & L_JPAD) == L_JPAD and go then
        profile.stop()
        go = false
        print(profile.report(40))
        djui_chat_message_create("Profiling stopped")
    end
end

hook_event(HOOK_UPDATE, function()
    if debug then prof() end
end)
