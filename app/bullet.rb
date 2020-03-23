class BulletClass
    attr_sprite
    attr_accessor :dy, :die
    
    def initialize (pos_x, pos_y)
        @x = pos_x
        @y = pos_y
        @w = 8*SCALE
        @h = 8*SCALE
        @path = "sprites/pico8_invaders_sprites_LARGE.png"
        @tile_x =  0
        @tile_y =  8
        @tile_w = 8
        @tile_h = 8
        @dy = 10
        @die = false
    end

    def ticks args
        frame = args.state.tick_count.idiv(4).mod(3)
        @y += @dy
        @tile_x = frame * 8
        sprite.x = @x
        sprite.y = @y
    end
end