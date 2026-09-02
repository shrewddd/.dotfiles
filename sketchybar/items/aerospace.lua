local colors = require("colors")
local icons = require("icon_map")

local function read_command(cmd)
  local handle = io.popen(cmd)
  if not handle then return "" end
  local output = handle:read("*a") or ""
  handle:close()
  return output
end

local function get_apps_in_workspace(ws)
  local output = read_command("aerospace list-windows --workspace " .. ws)
  local apps = {}

  for line in output:gmatch("[^\n]+") do
    local _, app_name = line:match("^(%d+)%s*|%s*([^|]+)")
    if app_name then
      app_name = app_name:gsub("^%s*(.-)%s*$", "%1")
      table.insert(apps, app_name)
    end
  end

  return apps
end

local function lines(str)
  local t = {}
  for line in str:gmatch("[^\n]+") do
    table.insert(t, line)
  end
  return t
end

local workspace_items = {}
local workspaces = lines(read_command("aerospace list-workspaces --all"))

local function update_spaces()
  local focused_ws = read_command("aerospace list-workspaces --focused"):gsub("%s+", "")

  for i, ws in ipairs(workspaces) do
    local space = workspace_items[i]
    if not space then goto continue end

    local apps = get_apps_in_workspace(ws)
    local is_focused = (focused_ws == ws)

    local icon_color = is_focused and colors.space.text.active or colors.space.text.inactive
    local background_color = is_focused and colors.space.background.active or colors.space.background.inactive

    -- 🧠 Build icon string for all apps
    local icon_strings = {}
    for _, app_name in ipairs(apps) do
      local icon = icons[app_name] or app_name
      table.insert(icon_strings, icon)
    end
    local label_string = table.concat(icon_strings, " ")

    local is_empty = (#apps == 0)

    space:set({
      icon = {
        color = icon_color,
        string = ws,
      },
      label = {
        string = label_string,
        drawing = not is_empty,
        color = icon_color,
      },
      background = {
        color = background_color,
      },
    })

    ::continue::
  end
end

for i, ws in ipairs(workspaces) do
  local space = sbar.add("item", "space." .. i, {
    icon = {
      string = ws,
      color = colors.space.text.inactive,
    },
    background = {
      drawing = false,
      height = 24,
      corner_radius = 5,
    },
    label = {
      string = icons["zen"],
      drawing = false,
      font = "Sketchybar-App-Font:Regular:18",
    },
    padding_left = 2,
    padding_right = 2,
  })

  workspace_items[i] = space

  space:subscribe("aerospace_workspace_change", function()
    update_spaces()
  end)
end

update_spaces()
