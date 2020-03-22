class PlayerClass
    attr_sprite
    attr_accessor :vel_x, :vel_y, :accel, :max_vel 
    def initialize
        @x = (SCREEN_WIDTH-8*SCALE)/2
        @y = 48
        @w = 8*SCALE
        @h = 8*SCALE
        @path = "sprites/pico8_invaders_sprites_LARGE.png"
        @tile_x =  0
        @tile_y =  0
        @tile_w = 8
        @tile_h = 8
        @vel_x = 0
        @vel_y = 0
        @accel = 0.1
        @max_vel = 6
    end
end