local icons = require("icons")

local cal = sbar.add("item", {
  background = {
    border_width = 2,
    border_color = 0xffffffff,
    corner_radius = 5,
    height = 30,
  },
  icon = {
    padding_right = 0,
    font = {
      style = "Black",
      size = 18.0,
    },
  },
  label = {
    align = "right",
  },
  position = "right",
  update_freq = 15,
})

local function update()
  local date = os.date("%a %d %H:%M")
  cal:set({ icon = icons.calendar, label = date })
end

cal:subscribe({ "routine", "forced" }, update)
