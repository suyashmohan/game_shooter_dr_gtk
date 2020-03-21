SCALE = 3

def tick args
    default args
    input args
    update args
    render args
end

def default args 
    args.state.player.x ||= 100
    args.state.player.y ||= 100
    args.state.player.vel.x ||= 0
    args.state.player.vel.y ||= 0
    args.state.player.accel ||= 0.1
    args.state.player.max_vel ||= 6
end

def input args
    if args.inputs.keyboard.left
        args.state.player.vel.x -= args.state.player.accel
        args.state.player.vel.x = args.state.player.vel.x.greater(-args.state.player.max_vel)
    elsif args.inputs.keyboard.right
        args.state.player.vel.x += args.state.player.accel
        args.state.player.vel.x = args.state.player.vel.x.lesser(args.state.player.max_vel)
    else
        if args.state.player.vel.x < 0
            args.state.player.vel.x += args.state.player.accel
            args.state.player.vel.x = args.state.player.vel.x.lesser(0)
        else
            args.state.player.vel.x -= args.state.player.accel
            args.state.player.vel.x = args.state.player.vel.x.greater(0)
        end
    end
end

def update args
    args.state.player.x += args.state.player.vel.x
    boundry_check args
end

def render args
    args.outputs.solids << [0,0, 1280, 720, 0,0,0]
    args.outputs.sprites << {
        x: args.state.player.x,
        y: args.state.player.y,
        w: 8*SCALE,
        h: 8*SCALE,
        path: "sprites/pico8_invaders_sprites_LARGE.png",
        tile_x:  0,
        tile_y:  0,
        tile_w: 8,
        tile_h: 8,
    }
end

def boundry_check args
    x = args.state.player.x
    args.state.player.x = x.greater(0).lesser(1280 - 8 * SCALE)
end