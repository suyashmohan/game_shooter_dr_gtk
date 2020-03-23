class EnemyClass
    attr_sprite
    attr_accessor :dy, :die
    def initialize
        @x = SCREEN_OFFSET + rand(SCREEN_WIDTH.idiv(8*SCALE)) * 8 * SCALE
        @y = SCREEN_HEIGHT-8*SCALE
        @w = 8*SCALE
        @h = 8*SCALE
        @path = "sprites/pico8_invaders_sprites_LARGE.png"
        @tile_x =  24
        @tile_y =  0
        @tile_w = 8
        @tile_h = 8
        @dy = -2
        @die = false
    end
end