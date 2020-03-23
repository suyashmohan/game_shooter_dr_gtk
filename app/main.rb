DEBUG = true
SCALE = 6
SCREEN_WIDTH = 720
SCREEN_HEIGHT = 720
SCREEN_OFFSET = 280

SCORE = 0
LIVES = 3

require 'app/enemy.rb'
require 'app/bullet.rb'
require 'app/player.rb'

def tick args
    default args
    input args
    update args
    render args
end

def default args 
    args.state.bullets ||= []
    args.state.player ||= PlayerClass.new
    args.state.enemies ||= []
end

def input args
    args.state.player.dx = 0
    args.state.player.dy = 0
    args.state.player.tile_x = 0 * 8

    if args.inputs.keyboard.left
        args.state.player.dx = -1
        args.state.player.tile_x = 1 * 8
    elsif args.inputs.keyboard.right
        args.state.player.dx = 1
        args.state.player.tile_x = 2 * 8
    end

    if args.inputs.keyboard.up
        args.state.player.dy = 1
        args.state.player.tile_x = 0 * 8
    elsif args.inputs.keyboard.down
        args.state.player.dy = -1
        args.state.player.tile_x = 0 * 8
    end

    if args.inputs.keyboard.space and args.state.tick_count.mod(10) == 0
        args.state.bullets << BulletClass.new(args.state.player.x, args.state.player.y)
    end
end

def update args
    update_player args
    update_bullets_enemies args
    boundry_check args
end

def render args
    args.outputs.background_color = [0, 0, 0] # black background
    args.outputs.solids << [0, 0, SCREEN_OFFSET, SCREEN_HEIGHT, 0, 0, 255]
    args.outputs.solids << [SCREEN_WIDTH+SCREEN_OFFSET, 0, SCREEN_OFFSET, SCREEN_HEIGHT, 0, 0, 255]

    args.outputs.sprites <<  args.state.bullets.map do |bullet|
        bullet.sprite
    end
    args.outputs.sprites <<  args.state.enemies.map do |enemy|
        enemy.sprite
    end
    args.outputs.sprites << args.state.player.sprite

    args.outputs.labels << [10, SCREEN_HEIGHT-10, "Score : #{SCORE}", 255, 0, 255]
    args.outputs.labels << [10, SCREEN_HEIGHT-30, "Lives : #{LIVES}", 255, 0, 255]

    if DEBUG
        args.outputs.labels << [10, SCREEN_HEIGHT-50, "FPS : #{args.gtk.current_framerate.to_s.to_i} Ticks : #{args.state.tick_count}", 0, 255, 0]
        args.outputs.labels << [10, SCREEN_HEIGHT-70, "Sprites : #{args.outputs.sprites.size}", 0, 255, 0]
    end
end

def update_player args
    args.state.player.x += args.state.player.dx * args.state.player.speed
    args.state.player.y += args.state.player.dy * args.state.player.speed
    args.state.player.sprite.x = args.state.player.x
    args.state.player.sprite.y = args.state.player.y
end

def update_bullets_enemies args
    args.state.bullets.each do |bullet|
        frame = args.state.tick_count.idiv(4).mod(3)
        bullet.y += bullet.dy
        bullet.tile_x = frame * 8
        bullet.sprite.x = bullet.x
        bullet.sprite.y = bullet.y
    end

    args.state.enemies.each do |enemy|
        frame = args.state.tick_count.idiv(10).mod(2)
        enemy.y += enemy.dy
        enemy.tile_y = frame * 8
        enemy.sprite.x = enemy.x
        enemy.sprite.y = enemy.y

        args.state.bullets.each do |bullet|
            if bullet.intersect_rect? enemy
                bullet.die = true
                enemy.die = true
                SCORE += 1
            end
        end

        if enemy.intersect_rect? args.state.player
            enemy.die = true
            LIVES -= 1
        end
    end
    
    if args.state.tick_count.mod(30) == 0
        args.state.enemies << EnemyClass.new
    end
end

def boundry_check args
    args.state.player.x = args.state.player.x.greater(SCREEN_OFFSET).lesser((SCREEN_OFFSET + SCREEN_WIDTH) - 8 * SCALE)
    args.state.player.y = args.state.player.y.greater(0).lesser(SCREEN_HEIGHT - 8 * SCALE)

    args.state.bullets = args.state.bullets.reject do |b|
        b.y < 0 || b.y > SCREEN_HEIGHT - 8 * SCALE || b.die == true
    end

    args.state.enemies = args.state.enemies.reject do |e|
        e.y < 0 || e.y > SCREEN_HEIGHT - 8 * SCALE || e.die == true
    end
end