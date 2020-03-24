class PlayerClass
    attr_sprite
    attr_accessor :dx, :dy, :speed 
    
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
        @dy = 0
        @speed = 5
    end

    def ticks args
        input(args)
        @x += @dx * @speed
        @y += @dy * @speed

        @x = @x.clamp(SCREEN_OFFSET, (SCREEN_OFFSET + SCREEN_WIDTH) - 8 * SCALE)
        @y = @y.clamp(0, SCREEN_HEIGHT - 8 * SCALE)
    end

    def input args
        @dx = 0
        @dy = 0
        @tile_x = 0 * 8
    
        if args.inputs.keyboard.left
            @dx = -1
            @tile_x = 1 * 8
        elsif args.inputs.keyboard.right
            @dx = 1
            @tile_x = 2 * 8
        end
    
        if args.inputs.keyboard.up
            @dy = 1
            @tile_x = 0 * 8
        elsif args.inputs.keyboard.down
            @dy = -1
            @tile_x = 0 * 8
        end
    end
end