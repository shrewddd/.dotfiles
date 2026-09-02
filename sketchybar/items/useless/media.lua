local icons = {
	nerdfont = {
		plus = "",
		loading = "",
		apple = "",
		gear = "",
		cpu = "",
		clipboard = "󰅇",
		switch = {
			on = "󱨥",
			off = "󱨦",
		},
		clock = {
			_1 = "󱐿",
			_2 = "󱑀",
			_3 = "󱑁",
			_4 = "󱑂",
			_5 = "󱑃",
			_6 = "󱑄",
			_7 = "󱑅",
			_8 = "󱑆",
			_9 = "󱑇",
			_10 = "󱑈",
			_11 = "󱑉",
			_12 = "󱑊",
		},
		volume = {
			headphones = "",
			_100 = "",
			_66 = "",
			_33 = "",
			_10 = "",
			_0 = "",
		},
		battery = {
			_100 = "",
			_75 = "",
			_50 = "",
			_25 = "",
			_0 = "",
			charging = "",
		},
		wifi = {
			upload = "",
			download = "",
			connected = "󰖩",
			disconnected = "󰖪",
			router = "󰑩",
		},
		media = {
			play = "",
			back = "",
			forward = "",
			pause = "",
		},
    spaces = {
      active = "",
      inactive = "",
    },
		slider = {
			knob = "",
		},
	},
}

local MAX_TEXT_LENGTH = 40

local current_playing = false
local current_media_text = ""

local function truncate_text(text)
  if #text <= MAX_TEXT_LENGTH then
    return text
  end
  return string.sub(text, 1, MAX_TEXT_LENGTH - 3) .. "..."
end

local media = sbar.add("item", "media_ctrl.anchor", {
  position = "right",
  update_freq = 2,
  label = {
    string = "No Media",
    color = 0xffffffff,
    padding_left = 8,
    padding_right = 8,
  },
  icon = {
    string = "",
    color = 0xffffffff,
    padding_left = 8,
  },
  drawing = true,
})

media:subscribe("routine", function()
  sbar.exec(
    'media-control get 2>/dev/null | jq -r \'if . == null then "||false" else .title + "|" + (.artist // "") + "|" + (if .playing then "true" else "false" end) end\'',
    function(result, exit_code)
      local has_valid_media = false

      if exit_code == 0 and result and result ~= "" and result ~= "null|null|null" and result ~= "||false" then
        local parts = {}
        for part in result:gmatch("([^|]*)") do
          table.insert(parts, part)
        end

        local track = parts[1] or ""
        local artist = parts[2] or ""
        print(track, artist)
        local playing_str = parts[3] or "false"
        local playing = string.lower(string.gsub(playing_str or "", "%s+", "")) == "true"

        if track ~= "" and track ~= "null" and track ~= "nil" then
          has_valid_media = true

          local media_text = track
          if artist ~= "" and artist ~= "null" and artist ~= "nil" then
            media_text = track .. " - " .. artist
          end

          local display_text = truncate_text(media_text)

          current_playing = playing
          current_media_text = display_text

          local play_icon = playing and "" or ""

          media:set({
            icon = { string = play_icon },
            label = { string = display_text },
          })
        end
      end

      -- Show empty content if no valid media (but keep widget visible in order to keep polling)
      if not has_valid_media then
        current_playing = false
        current_media_text = ""
        media:set({
          icon = { string = "" },
          label = { string = "" },
        })
      end
    end
  )
end)

media:subscribe("mouse.clicked", function()
  if current_media_text ~= "" then
    -- Immediately toggle the visual state for instant feedback
    current_playing = not current_playing
    local immediate_icon = current_playing and "" or ""

    media:set({
      icon = { string = immediate_icon },
      label = { string = current_media_text },
      drawing = true,
    })

    sbar.exec("media-control toggle-play-pause")
  end
end)
