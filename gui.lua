--[[============================================================================
gui.lua
============================================================================]] --

--------------------------------------------------------------------------------
-- UI Elements
--------------------------------------------------------------------------------

local function create_sample_selector(vb)
    local song = renoise.song()
    local instrument = song.selected_instrument

    if not instrument then
        return vb:row {
            vb:text {
                text = "No instrument selected"
            }
        }
    end

    -- Create sample names for dropdown
    local sample_names = {}
    for i, sample in ipairs(instrument.samples) do
        local name = sample.name
        if name == "" then
            name = "Sample " .. i - 1
        end
        table.insert(sample_names, name)
    end

    if #sample_names == 0 then
        return vb:row {
            vb:text {
                text = "No samples in instrument"
            }
        }
    end

    -- Create dropdown with sample names
    local sample_selector = vb:popup {
        id = "sample_selector",
        items = sample_names,
        value = 1
    }

    return vb:row {
        vb:text {
            text = "Select Sample:"
        },
        sample_selector
    }
end

local function create_buttons(vb)
    return vb:row {
        vb:button {
            text = "Save Volume State",
            id = "save_button",
            width = 120,
            notifier = function()
                local song = renoise.song()
                local instrument = song.selected_instrument
                if instrument then
                    save_current_volume_state()
                end
            end
        },
        vb:button {
            text = "Mute",
            id = "mute_button",
            width = 80,
            notifier = function()
                local song = renoise.song()
                local instrument = song.selected_instrument
                if instrument then
                    local sample_index = vb.views.sample_selector.value
                    mute_selected_sample(sample_index)
                end
            end
        },
        vb:button {
            text = "Unmute",
            id = "unmute_button",
            width = 80,
            notifier = function()
                local song = renoise.song()
                local instrument = song.selected_instrument
                if instrument then
                    local sample_index = vb.views.sample_selector.value
                    unmute_selected_sample(sample_index)
                end
            end
        }
    }
end

--------------------------------------------------------------------------------
-- Dialog
--------------------------------------------------------------------------------

function show_sample_mute_dialog()
    -- Create a new ViewBuilder instance for each dialog
    local vb = renoise.ViewBuilder()

    local dialog_content = vb:column {
        margin = 10,
        spacing = 10,
        create_sample_selector(vb),
        create_buttons(vb)
    }

    renoise.app():show_custom_dialog(
        "Sample Mute/Unmute",
        dialog_content
    )
end

-- Return the module
return {
    show_sample_mute_dialog = show_sample_mute_dialog
}
