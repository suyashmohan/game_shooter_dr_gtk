DEBUG = true
SCALE = 4

def tick args
    default args
    input args
    update args
    render args
end

def default args 
    
    args.state.bullets ||= []
    args.state.player ||= {
        x: (1280-8*SCALE)/2,
        y: 48,
        w: 8*SCALE,
        h: 8*SCALE,
        path: "sprites/pico8_invaders_sprites_LARGE.png",
        tile_x:  0,
        tile_y:  0,
        tile_w: 8,
        tile_h: 8,
        vel_x: 0,
        vel_y: 0,
        accel: 0.1,
        max_vel: 6
    }
    args.state.enemies ||= [
        {
            x: rand(1280-8*SCALE),
            y: 720-8*SCALE,
            w: 8*SCALE,
            h: 8*SCALE,
            path: "sprites/pico8_invaders_sprites_LARGE.png",
            tile_x:  24,
            tile_y:  0,
            tile_w: 8,
            tile_h: 8,
            dy: -2
        }   
    ]
end

def input args
    if args.inputs.keyboard.left
        args.state.player[:vel_x] -= args.state.player[:accel]
        args.state.player[:vel_x] = args.state.player[:vel_x].greater(-args.state.player[:max_vel])
    elsif args.inputs.keyboard.right
        args.state.player[:vel_x] += args.state.player[:accel]
        args.state.player[:vel_x] = args.state.player[:vel_x].lesser(args.state.player[:max_vel])
    else
        if args.state.player[:vel_x] < 0
            args.state.player[:vel_x] += args.state.player[:accel]
            args.state.player[:vel_x] = args.state.player[:vel_x].lesser(0)
        else
            args.state.player[:vel_x] -= args.state.player[:accel]
            args.state.player[:vel_x] = args.state.player[:vel_x].greater(0)
        end
    end

    if args.inputs.keyboard.space and args.state.tick_count.mod(10) == 0
        args.state.bullets << {
            x: args.state.player[:x],
            y: args.state.player[:y],
            w: 8*SCALE,
            h: 8*SCALE,
            path: "sprites/pico8_invaders_sprites_LARGE.png",
            tile_x:  0,
            tile_y:  8,
            tile_w: 8,
            tile_h: 8,
            dy: 10
        }
    end
end

def update args
    update_player args
    update_bullets_enemies args
    boundry_check args
end

def render args
    args.outputs.solids << [0,0, 1280, 720, 0,0,0]

    if DEBUG
        args.outputs.labels << [10, 720-10, args.state.tick_count, 0, 255, 0]
    end

    args.outputs.sprites << args.state.bullets
    args.outputs.sprites << args.state.enemies
    args.outputs.sprites << {
        x: args.state.player[:x],
        y: args.state.player[:y],
        w: 8*SCALE,
        h: 8*SCALE,
        path: "sprites/pico8_invaders_sprites_LARGE.png",
        tile_x:  0,
        tile_y:  0,
        tile_w: 8,
        tile_h: 8,
    }

    puts "Total Sprites : #{args.outputs.sprites.size}"
end

def update_player args
    args.state.player[:x] += args.state.player[:vel_x]
end

def update_bullets_enemies args
    args.state.bullets.each do |b|
        b[:y] += b[:dy]
    end

    args.state.enemies.each do |e|
        e[:y] += e[:dy]
    end
end

def boundry_check args
    x = args.state.player[:x]
    args.state.player[:x] = x.greater(0).lesser(1280 - 8 * SCALE)

    args.state.bullets = args.state.bullets.reject do |b|
        b[:y] < 0 || b[:y] > 720 - 8 * SCALE
    end
    
    args.state.enemies.each do |e|
        if e[:y] < 0
            e[:y] = 720-8*SCALE
            e[:x] = rand(1280-8*SCALE)
        end
    end
end