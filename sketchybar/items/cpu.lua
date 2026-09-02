local colors = require("colors")

sbar.exec("killall cpu_load >/dev/null; ~/.config/sketchybar/cpu/bin/cpu_load cpu_update 1.0")

local cpu = sbar.add("graph", "widgets.cpu" , 40, {
  position = "right",
  width = 80,
  graph = { color = colors.cpu.idle, line_width = 2 },
  background = {
    height = 30,
    -- color = 0xff2e2e2e,
    -- color = { alpha = 0 },
    border_color = 0xffffffff,
    corner_radius = 4,
    drawing = true,
  },
  icon = { string = "􀫥", width = 30 },
  label = {
    string = "CPU ??%",
    font = {
      size = 10.0,
    },
    drawing = true,
    align = "right",
    padding_right = 0,
    width = 0,
    y_offset = 4,
  },
})

cpu:subscribe("cpu_update", function(env)
  local load = tonumber(env.total_load)
  cpu:push({ load / 100 })

  local color

  if load > 100 then
    load = 100
  end

  if load < 20 then
    color = colors.cpu.idle
  elseif load < 40 then
    color = colors.cpu.light
  elseif load < 65 then
    color = colors.cpu.moderate
  elseif load < 85 then
    color = colors.cpu.heavy
  else
    color = colors.cpu.critical
  end

  cpu:set({
    graph = { color = color },
    label = "CPU " .. env.total_load .. "%",
  })
end)

cpu:subscribe("mouse.clicked", function(env)
  sbar.exec("open -a 'Activity Monitor'")
end)

sbar.add("bracket", "widgets.cpu.bracket", { cpu.name }, {
  background = { color = colors.cpu.critical }
})

sbar.add("item", "widgets.cpu.padding", {
  position = "right",
  width = 400
})
