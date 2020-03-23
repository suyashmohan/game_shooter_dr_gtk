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

    def ticks args
        frame = args.state.tick_count.idiv(10).mod(2)
        @y += @dy
        @tile_y = frame * 8
        sprite.x = @x
        sprite.y = @y
    end
end