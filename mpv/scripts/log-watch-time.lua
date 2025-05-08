local mp = require 'mp'

local last_time = nil
local seeking = false
local watch_time = nil
local this_time = nil
local video_filename = nil

local log_file_path = mp.command_native({"expand-path", "~/Documents/watch-log.txt"})

-- Utility function to write a line to the log file
local function log_to_file(line)
    local f = io.open(log_file_path, "a")  -- "a" for append mode
    if f then
        f:write(line .. "\n")
        f:close()
    else
        mp.msg.error("Failed to open log file: " .. log_file_path)
    end
end

-- Observe the "time-pos" property
mp.observe_property("time-pos", "number", function(name, value)
    if not value then return end

    if not seeking then
        last_time = value
    else
        update_watch_time(value)

        mp.msg.info(string.format("Seeked from %.2f to %.2f, watch time %.2f", last_time or 0, value, watch_time or 0))
        seeking = false
    end
end)

function update_watch_time(value)
    watch_time = (watch_time or 0) + (last_time or 0) - (this_time or 0)
    this_time = value
end


-- Listen for user-initiated seeks
mp.register_event("seek", function()
    seeking = true
end)

-- save filename for after the file is unloaded
mp.register_event("file-loaded", function()
    video_filename = mp.get_property("filename/no-ext")
end)

-- log watch time
mp.register_event("end-file", function()
    -- flush watch time update
    update_watch_time(0)

    -- log watch time
    mp.msg.info(string.format("End watch time: %s: %.2f", video_filename, watch_time or 0))

    log_to_file(string.format("%s,%.2f", video_filename, watch_time or 0))

    -- cleanup for next video
    last_time = nil
    watch_time = nil
    this_time = nil
    video_filename = nil
end)

function print_r ( t ) 
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    sub_print_r(t,"  ")
end

function seek_happened(event)
	mp.osd_message("seek happend")
    print_r(event)
end
--mp.register_event("seek", seek_happened)

