return {
  black = 0xffffffff,
  white = 0xffffffff,
  transparent = 0x00000000,

  cpu = {
    idle = 0xff0dff00,         -- #0dff00
    light = 0xff00ffbf,        -- #00ffff
    moderate = 0xffffd300,     -- #ffd300
    heavy  = 0xffff8000,       -- #ff8000
    critical  = 0xffe90064,    -- #E90064
  },
  space = {
    text = {
      inactive  = 0xffffffff, -- #ffffff # active
      active = 0xffB499FF, -- #a203ff # inactive
    },
    background = {
      inactive  = 0x00B499FF, -- #ffB499FF
      active = 0x00ffffff, -- #00ffffff
    }
  }
}
