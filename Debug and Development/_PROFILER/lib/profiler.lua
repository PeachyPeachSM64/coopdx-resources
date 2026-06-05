--[[
This file is a part of the "profile.lua" library.

MIT License

Copyright (c) 2015 2dengine LLC

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

-- The above license is for the original version of this file,
-- which was obtained from https://github.com/2dengine/profile.lua/blob/main/profile.lua
-- Extensive changes were made

local clock = os.clock

--- The "profile" module controls when to start or stop collecting data and can be used to generate reports.
-- @module profile
-- @alias profile
local profile = {}

-- function labels
local _labeled = {}
-- function definitions
local _defined = {}
-- time of last call
local _tcalled = {}
-- total execution time (inclusive: includes children)
local _telapsed = {}
-- self time (exclusive: excludes children)
local _tself = {}
-- number of calls
local _ncalls = {}
-- list of internal profiler functions
local _internal = {}
-- call stack for self-time tracking
local _callstack = {}
local _stackdepth = 0

--- This is an internal function.
-- @tparam string event Event type
-- @tparam number line Line number
-- @tparam[opt] table info Debug info table
function profile.hooker(event, line, info)
    info = info or debug.getinfo(2, 'fnS')
    local f = info.func
    -- ignore the profiler itself
    if _internal[f] or info.what ~= "Lua" then
        return
    end
    -- get the function name if available
    if info.name then
        _labeled[f] = info.name
    end
    -- find the line definition
    if not _defined[f] then
        _defined[f] = (info.source or info.short_src)..":"..info.linedefined
        _ncalls[f] = 0
        _telapsed[f] = 0
        _tself[f] = 0
    end

    local now = clock()

    if event == "tail call" then
        local prev = debug.getinfo(3, 'fnS')
        profile.hooker("return", line, prev)
        profile.hooker("call", line, info)
    elseif event == 'call' then
        -- pause self-time of the caller (top of stack)
        if _stackdepth > 0 then
            local caller = _callstack[_stackdepth]
            if caller and _tcalled[caller] then
                _tself[caller] = _tself[caller] + (now - _tcalled[caller])
            end
        end
        -- push onto call stack and start timing
        _stackdepth = _stackdepth + 1
        _callstack[_stackdepth] = f
        _tcalled[f] = now
    else
        -- return
        if _tcalled[f] then
            local dt = now - _tcalled[f]
            _telapsed[f] = _telapsed[f] + dt
            _tself[f] = _tself[f] + dt
            _tcalled[f] = nil
        end
        _ncalls[f] = _ncalls[f] + 1
        -- pop call stack
        if _stackdepth > 0 then
            _callstack[_stackdepth] = nil
            _stackdepth = _stackdepth - 1
        end
        -- resume self-time of the caller (now top of stack again)
        if _stackdepth > 0 then
            local caller = _callstack[_stackdepth]
            if caller then
                _tcalled[caller] = now
            end
        end
    end
end

--- Sets a clock function to be used by the profiler.
-- @tparam function func Clock function that returns a number
function profile.setclock(f)
    assert(type(f) == "function", "clock must be a function")
    clock = f
end

--- Starts collecting data.
function profile.start()
    _stackdepth = 0
    if rawget(_G, 'jit') then
        jit = jit or nil
        if jit then
            jit.off()
            jit.flush()
        end
    end
    debug.sethook(profile.hooker, "cr")
end

--- Stops collecting data.
function profile.stop()
    debug.sethook()
    local now = clock()
    for f in pairs(_tcalled) do
        local dt = now - _tcalled[f]
        _telapsed[f] = _telapsed[f] + dt
        _tself[f] = _tself[f] + dt
        _tcalled[f] = nil
    end
    _stackdepth = 0
    -- merge closures
    local lookup = {}
    for f, d in pairs(_defined) do
        local id = (_labeled[f] or '?')..d
        local f2 = lookup[id]
        if f2 then
            _ncalls[f2] = _ncalls[f2] + (_ncalls[f] or 0)
            _telapsed[f2] = _telapsed[f2] + (_telapsed[f] or 0)
            _tself[f2] = _tself[f2] + (_tself[f] or 0)
            _defined[f], _labeled[f] = nil, nil
            _ncalls[f], _telapsed[f], _tself[f] = nil, nil, nil
        else
            lookup[id] = f
        end
    end
    if collectgarbage then
        collectgarbage('collect')
    end
end

--- Resets all collected data.
function profile.reset()
    for f in pairs(_ncalls) do
        _ncalls[f] = 0
    end
    for f in pairs(_telapsed) do
        _telapsed[f] = 0
    end
    for f in pairs(_tself) do
        _tself[f] = 0
    end
    for f in pairs(_tcalled) do
        _tcalled[f] = nil
    end
    _stackdepth = 0
    if collectgarbage then
        collectgarbage('collect')
    end
end

--- This is an internal function.
-- @tparam function a First function
-- @tparam function b Second function
-- @treturn boolean True if "a" should rank higher than "b"
function profile.comp(a, b)
    local dt = _tself[b] - _tself[a]
    if dt == 0 then
        return _ncalls[b] < _ncalls[a]
    end
    return dt < 0
end

--- Strips common path prefix to show only the meaningful file:line portion
local function short_source(src)
    -- split off the :linenum suffix
    local path, linenum = src:match('^(.+):(%d+)$')
    if not path then return src end

    -- strip [string "..."] wrapper
    local inner = path:match('^%[string "(.+)"%]$')
    if inner then path = inner end

    -- strip leading @ (used by Lua for file-based chunks)
    if path:sub(1,1) == '@' then path = path:sub(2) end

    -- extract filename from path (after last / or \)
    local file = path:match('[/\\]([^/\\]+)$') or path
    return file .. ":" .. linenum
end

--- Format a number of seconds into a compact string
local function fmt_time(t)
    if t < 0.001 then
        return string.format("%.1fus", t * 1000000)
    elseif t < 1 then
        return string.format("%.2fms", t * 1000)
    else
        return string.format("%.3fs", t)
    end
end

--- Generates a report of functions that have been called since the profile was started.
-- Returns the report as a numeric table of rows containing the rank, function label,
-- number of calls, self time, inclusive time, avg time per call, percentage, and source.
-- @tparam[opt] number limit Maximum number of rows
-- @treturn table Table of rows
function profile.query(limit)
    local t = {}
    local total_time = 0
    for f, n in pairs(_ncalls) do
        if n > 0 then
            t[#t + 1] = f
            total_time = total_time + (_tself[f] or 0)
        end
    end
    table.sort(t, profile.comp)
    if limit then
        while #t > limit do
            table.remove(t)
        end
    end
    for i, f in ipairs(t) do
        local dt = 0
        local ds = 0
        if _tcalled[f] then
            dt = clock() - _tcalled[f]
            ds = dt
        end
        local self_time = (_tself[f] or 0) + ds
        local incl_time = (_telapsed[f] or 0) + dt
        local calls = _ncalls[f]
        local avg = calls > 0 and (self_time / calls) or 0
        local pct = total_time > 0 and (self_time / total_time * 100) or 0
        local src = short_source(_defined[f] or '?')
        t[i] = { i, _labeled[f] or '?', calls, fmt_time(self_time), fmt_time(incl_time), fmt_time(avg), string.format("%.1f%%", pct), src }
    end
    return t
end

--                 #        Function                    Calls         Self             Incl             Avg/call     %                Source
local cols = { 3,     29,                        11,             11,                11,                11,                6,             32 }

--- Generates a text report of functions that have been called since the profile was started.
-- Returns the report as a string that can be printed to the console.
-- @tparam[opt] number limit Maximum number of rows
-- @treturn string Text-based profiling report
function profile.report(limit)
    local out = {}
    local report = profile.query(limit)
    for i, row in ipairs(report) do
        for j = 1, #cols do
            local s = row[j]
            local l2 = cols[j]
            s = tostring(s)
            local l1 = s:len()
            if l1 < l2 then
                s = s..(' '):rep(l2-l1)
            elseif l1 > l2 then
                s = s:sub(l1 - l2 + 1, l1)
            end
            row[j] = s
        end
        out[i] = table.concat(row, ' | ')
    end

    local headers = { '#', 'Function', 'Calls', 'Self', 'Inclusive', 'Avg/call', '%', 'Source' }
    local header_cells = {}
    for j = 1, #cols do
        local s = headers[j]
        local w = cols[j]
        local l = s:len()
        if l < w then
            s = s .. (' '):rep(w - l)
        elseif l > w then
            s = s:sub(l - w + 1, l)
        end
        header_cells[j] = s
    end
    local row = " +-----+-------------------------------+-------------+-------------+-------------+-------------+--------+----------------------------------+ \n"
    local col = ' | ' .. table.concat(header_cells, ' | ') .. ' | \n'
    local sz = row..col..row
    if #out > 0 then
        sz = sz..' | '..table.concat(out, ' | \n | ')..' | \n'
    end
    return '\n'..sz..row
end

-- store all internal profiler functions
for _, v in pairs(profile) do
    if type(v) == "function" then
        _internal[v] = true
    end
end

return profile