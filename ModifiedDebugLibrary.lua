-- https://forum.robloxscripts.com/showthread.php?tid=4794
local is_table_writeable = iswriteable or is_writeable or function(t) return not isreadonly(t) end
local make_writeable     = make_writeable or makewriteable or setwriteable or function(t) setreadonly(t, false) end
local make_readonly      = make_readonly  or makereadonly  or setreadonly  or function(t) setreadonly(t, true) end
assert(islclosure ~= nil, 'The environment is not supported.')

if not is_table_writeable(debug) then
    make_writeable(debug)
end

debug.getclosure = function(name, ...)
    local other_arguments  = {...}
    local script
    local upvalues
    if #other_arguments > 0 and type(other_arguments[1]) == 'userdata' then
        script = other_arguments[1]
    elseif #other_arguments > 0 and type(other_arguments[1]) == 'number' then
        upvalues = other_arguments[1]
    end
    local garbagecollector = (getgc and getgc()) or (getreg and getreg())
    for Index, Value in next, garbagecollector do
        if type(Value) == 'function' and islclosure(Value) then
            if debug.getinfo(Value).name == name then
                if upvalues ~= nil and #debug.getupvalues(Value) then
                    if script and (debug.getfenv or getfenv)(Value).script == script then
                        return Value
                    elseif not script then
                        return Value
                    end
                elseif upvalues == nil then 
                    if script and (debug.getfenv or getfenv)(Value).script == script then
                        return Value
                    elseif not script then
                        return Value
                    end
                end
            end
        end
    end
end

debug.getclosures = function(name, ...)
    local other_arguments  = {...}
    local script
    if #other_arguments > 0 and type(other_arguments[1]) == 'userdata' then
        script = other_arguments[1]
    elseif #other_arguments > 0 and type(other_arguments[1]) == 'number' then
        upvalues = other_arguments[1]
    end
    local closures         = {}
    local garbagecollector = (getgc and getgc()) or (getreg and getreg())
    for Index, Value in next, garbagecollector do
        if type(Value) == 'function' and islclosure(Value) then
            if debug.getinfo(Value).name == name then
                if upvalues ~= nil and #debug.getupvalues(Value) then
                    if script and (debug.getfenv or getfenv)(Value).script == script then
                        table.insert(closures, Value)
                    elseif not script then
                        table.insert(closures, Value)
                    end
                elseif upvalues == nil then 
                    if script and (debug.getfenv or getfenv)(Value).script == script then
                        table.insert(closures, Value)
                    elseif not script then
                        table.insert(closures, Value)
                    end
                end
            end
        end
    end
    return closures
end

make_readonly(debug)
