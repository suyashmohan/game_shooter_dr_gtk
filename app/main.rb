DEBUG = true
SCALE = 4
SCREEN_WIDTH = 720
SCREEN_HEIGHT = 720
SCREEN_OFFSET = 280 # 720+280 = 1280

require 'app/enemy.rb'
require 'app/bullet.rb'
require 'app/player.rb'

class Game
    attr_gtk

    def tick
        default
        update
        input
        render
    end

    def default 
        state.bullets ||= []
        state.player ||= PlayerClass.new
        state.enemies ||= []
        state.score ||= 0
        state.lives ||= 3
    end
    
    def update
        # Update Player
        state.player.ticks(args)
    
        # Update Bullets
        state.bullets.each do |bullet|
            bullet.ticks(args)
        end
    
        # Update Enemies
        state.enemies.each do |enemy|
            enemy.ticks(args)

            state.bullets.each do |bullet|
                if bullet.intersect_rect? enemy
                    bullet.die = true
                    enemy.die = true
                    state.score += 1
                end
            end
    
            if enemy.intersect_rect? state.player
                enemy.die = true
                state.lives -= 1
            end
        end
        
        # Remove unwanted bullets and enemies
        state.bullets = state.bullets.reject do |b|
            b.y < 0 || b.y > SCREEN_HEIGHT - 8 * SCALE || b.die == true
        end
        state.enemies = state.enemies.reject do |e|
            e.y < 0 || e.y > SCREEN_HEIGHT - 8 * SCALE || e.die == true
        end
    
        # Add new Enemies
        if state.tick_count.mod(30) == 0
            state.enemies << EnemyClass.new
        end
    end

    def input
        if inputs.keyboard.space and state.tick_count.mod(10) == 0
            state.bullets << BulletClass.new(state.player.x, state.player.y)
        end
    end
    
    def render
        outputs.background_color = [0, 0, 0] # black background
        outputs.solids << [0, 0, SCREEN_OFFSET, SCREEN_HEIGHT, 0, 0, 255]
        outputs.solids << [SCREEN_WIDTH+SCREEN_OFFSET, 0, SCREEN_OFFSET, SCREEN_HEIGHT, 0, 0, 255]
    
        outputs.sprites <<  state.bullets.map do |bullet|
            bullet.sprite
        end
        outputs.sprites <<  state.enemies.map do |enemy|
            enemy.sprite
        end
        outputs.sprites << state.player.sprite
    
        outputs.labels << [10, SCREEN_HEIGHT-10, "Score : #{state.score}", 255, 0, 255]
        outputs.labels << [10, SCREEN_HEIGHT-30, "Lives : #{state.lives}", 255, 0, 255]
    
        if DEBUG
            outputs.labels << [10, SCREEN_HEIGHT-50, "FPS : #{gtk.current_framerate.to_s.to_i} Ticks : #{state.tick_count}", 0, 255, 0]
            outputs.labels << [10, SCREEN_HEIGHT-70, "Sprites : #{outputs.sprites.size}", 0, 255, 0]
        end
    end
end

$game = Game.new

def tick args
    $game.args = args
    $game.tick
end