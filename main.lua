debug = true
player = { x = 200, y = 710, speed = 150, img = nil }

canShoot = true
canShootTimerMax = 0.2 
canShootTimer = canShootTimerMax

bulletImg = nil

bullets = {}

createEnemyTimerMax = 0.4
createEnemyTimer = createEnemyTimerMax
  
enemyImg = nil  

enemies = {} 

background = nil
function love.load(arg)
    player.img = love.graphics.newImage('assets/aircraft.png')
    bulletImg = love.graphics.newImage('assets/bullet-asm.png')
    enemyImg = love.graphics.newImage('assets/enemy-khomeni.png')
    background = love.graphics.newImage('assets/bg.png')
end

function love.update(dt)

	if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end

    if love.keyboard.isDown('left','a') then
        if player.x > 0 then -- binds us to the map
            player.x = player.x - (player.speed*dt)
        end
    elseif love.keyboard.isDown('right','d') then
        if player.x < (love.graphics.getWidth() - player.img:getWidth()) then
            player.x = player.x + (player.speed*dt)
        end
    end
    
    canShootTimer = canShootTimer - (1 * dt)
    if canShootTimer < 0 then
        canShoot = true
    end

    if love.keyboard.isDown('space', 'rctrl', 'lctrl', 'ctrl') and canShoot then
        newBullet = { x = player.x + (player.img:getWidth()/2), y = player.y, img = bulletImg }
        table.insert(bullets, newBullet)
        canShoot = false
        canShootTimer = canShootTimerMax
    end

    for i, bullet in ipairs(bullets) do
        bullet.y = bullet.y - (250 * dt)
    
          if bullet.y < 0 then -- remove bullets when they pass off the screen
            table.remove(bullets, i)
        end
    end

end

function love.draw(dt)
    love.graphics.draw(background,0,0)

    love.graphics.draw(player.img, player.x, player.y)

    for i, bullet in ipairs(bullets) do
        love.graphics.draw(bullet.img, bullet.x, bullet.y)
    end
end
