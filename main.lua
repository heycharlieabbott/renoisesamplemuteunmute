--[[============================================================================
main.lua
============================================================================]] --

--------------------------------------------------------------------------------
-- Functions
--------------------------------------------------------------------------------

-- Save the current volume state of all samples to the instrument comment
local function save_volume_state()
    local song = renoise.song()
    local instrument = song.selected_instrument

    if not instrument then
        renoise.app():show_warning("No instrument selected")
        return
    end

    -- Create new comments array
    local new_comments = {}

    -- Save volume state for each sample
    for i, sample in ipairs(instrument.samples) do
        local volume_state = string.format("%d:%.4f", i, sample.volume)
        table.insert(new_comments, volume_state)
    end

    -- Update the comments array
    instrument.comments = new_comments
end

-- Get the saved volume for a sample from the instrument comment
local function get_saved_volume(sample_index)
    local song = renoise.song()
    local instrument = song.selected_instrument

    if not instrument or not instrument.comments then
        return nil
    end

    -- Look for pattern "sample_index:volume" in comments
    local pattern = "^" .. sample_index .. ":([%d%.]+)$"
    for _, comment in ipairs(instrument.comments) do
        local volume_str = comment:match(pattern)
        if volume_str then
            return tonumber(volume_str)
        end
    end

    return nil
end

-- Mute a sample by setting its volume to -INF
local function mute_sample(sample_index)
    local song = renoise.song()
    local instrument = song.selected_instrument

    if not instrument then
        renoise.app():show_warning("No instrument selected")
        return
    end

    local sample = instrument.samples[sample_index]
    if not sample then
        renoise.app():show_warning("Invalid sample index")
        return
    end

    -- Save current volume state before muting
    save_volume_state()

    -- Set volume to -INF (0.0)
    sample.volume = 0.0
end

-- Unmute a sample by restoring its saved volume
local function unmute_sample(sample_index)
    local song = renoise.song()
    local instrument = song.selected_instrument

    if not instrument then
        renoise.app():show_warning("No instrument selected")
        return
    end

    local sample = instrument.samples[sample_index]
    if not sample then
        renoise.app():show_warning("Invalid sample index")
        return
    end

    local saved_volume = get_saved_volume(sample_index)
    if not saved_volume then
        renoise.app():show_warning("No saved volume state found for this sample")
        return
    end

    sample.volume = saved_volume
end

--------------------------------------------------------------------------------
-- Public Functions (used by gui.lua)
--------------------------------------------------------------------------------

function save_current_volume_state()
    save_volume_state()
end

function mute_selected_sample(sample_index)
    mute_sample(sample_index)
end

function unmute_selected_sample(sample_index)
    unmute_sample(sample_index)
end

--------------------------------------------------------------------------------
-- Menu & Key Binding Registration
--------------------------------------------------------------------------------

-- Load GUI module
local gui = require "gui"

-- Add menu entry
renoise.tool():add_menu_entry {
    name = "Main Menu:Tools:Sample Mute/Unmute...",
    invoke = gui.show_sample_mute_dialog
}

-- Add keybinding
renoise.tool():add_keybinding {
    name = "Global:Tools:Sample Mute/Unmute",
    invoke = gui.show_sample_mute_dialog
}
