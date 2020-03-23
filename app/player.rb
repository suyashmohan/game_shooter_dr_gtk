class PlayerClass
    attr_sprite
    attr_accessor :dx, :speed 
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
        @dx = 0
        @speed = 5
    end
end