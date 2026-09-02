local icons = require("icons")

local battery = sbar.add("item", {
  position = "right",
  icon = {
    font = {
      style = "Regular",
      size = 18.0,
    }
  },
  label = { drawing = true },
  update_freq = 120,
})

local function battery_update()
  sbar.exec("pmset -g batt", function(batt_info)
    local icon = " "
    local charge = 0
    local found, _, percent = batt_info:find("(%d+)%%")

    if found then
      charge = tonumber(percent)
    end

    if batt_info:find("AC Power") then
      icon = icons.battery.plugged
    elseif charge > 80 then
      icon = icons.battery._80
    elseif charge > 60 then
      icon = icons.battery._60
    elseif charge > 40 then
      icon = icons.battery._40
    elseif charge > 20 then
      icon = icons.battery._20
    else
      icon = icons.battery._0
    end

    battery:set({ icon = icon, label = string.format("%d%%", charge) })
  end)
end

battery:subscribe({ "routine", "power_source_change", "system_woke" }, battery_update)
