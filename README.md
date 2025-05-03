# Sample Mute/Unmute Tool for Renoise

A Renoise tool that allows you to mute and unmute samples while preserving their volume states. This is particularly useful when you want to temporarily silence samples during mixing or arrangement without losing their original volume settings.

## Features

- Save volume states for all samples in the current instrument
- Mute individual samples (sets volume to 0.0)
- Unmute samples by restoring their previously saved volume
- Simple and intuitive interface
- Preserves volume states in instrument comments

## Installation

1. Download the `com.renoise.SampleMuteUnmute.xrnx` folder
2. Place it in your Renoise Tools directory:
   - Windows: `%APPDATA%\Renoise\V3.4.4\Scripts\Tools\`
   - macOS: `~/Library/Preferences/Renoise/V3.4.4/Scripts/Tools/`
   - Linux: `~/.config/renoise/V3.4.4/Scripts/Tools/`
3. Restart Renoise or reload the tools

## Usage

1. Select an instrument in Renoise
2. Open the tool from the Tools menu or use its keyboard shortcut
3. Use the dropdown to select the sample you want to work with
4. Click "Save Volume State" to store the current volumes of all samples
5. Click "Mute" to silence the selected sample
6. Click "Unmute" to restore the saved volume of the selected sample

## How It Works

The tool stores volume information in the instrument's comments using a simple format:

- Each sample's volume is stored as `"index:volume"` (e.g., "1:1.0000")
- When you save volume states, it creates entries for all samples in the instrument
- The mute function sets the sample's volume to 0.0
- The unmute function reads the saved volume from the comments and restores it

## Tips

- Always save volume states before muting samples
- You can save volume states at any time to update them
- The tool works with any number of samples in an instrument
- Volume states persist with your song file since they're stored in instrument comments

## Requirements

- Renoise 3.4.4 or later

## Author

Charlie Abbott

## License

This tool is provided as-is under the same license as Renoise.
