debug = true
player = { x = 200, y = 710, speed = 250, img = nil }
isAlive = true
score = 0

canShoot = true
canShootTimerMax = 0.5 
canShootTimer = canShootTimerMax


bullets = {}

createEnemyTimerMax = 0.9
createEnemyTimer = createEnemyTimerMax
  
enemyImgs = {love.graphics.newImage("assets/enemy-ballmer.png"), love.graphics.newImage("assets/enemy-erdogan.png"),
  love.graphics.newImage("assets/enemy-jong-un.png"), love.graphics.newImage("assets/enemy-khomeni.png"),
  love.graphics.newImage("assets/enemy-zucker.png")}

bulletImgs = {love.graphics.newImage("assets/bullet-asm.png"), love.graphics.newImage("assets/bullet-fork.png"),
  love.graphics.newImage("assets/bullet-java.png")}

enemies = {} 

math.randomseed(os.time()) -- seed randomiser for images

background = nil
function love.load(arg)
    player.img = love.graphics.newImage('assets/aircraft.png')
    --bulletImg = love.graphics.newImage('assets/bullet-asm.png')
    --enemyImg = love.graphics.newImage('assets/enemy-khomeni.png')
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

    -- Get input from player to shoot
    if love.keyboard.isDown('space', 'rctrl', 'lctrl') and canShoot then
		randImg = bulletImgs[math.random(#bulletImgs)]
        newBullet = { x = player.x + (player.img:getWidth()/2), y = player.y, img = randImg }
        table.insert(bullets, newBullet)
        canShoot = false
        canShootTimer = canShootTimerMax
    end

    -- Update bullet position
    for i, bullet in ipairs(bullets) do
        bullet.y = bullet.y - (250 * dt)
    
          if bullet.y < 0 then -- remove bullets when they pass off the screen
            table.remove(bullets, i)
        end
    end

    createEnemyTimer = createEnemyTimer - (1 * dt)
    if createEnemyTimer < 0 and isAlive then
	    createEnemyTimer = createEnemyTimerMax

	    -- Create an enemy
		randImg = enemyImgs[math.random(#enemyImgs)]
	    randomNumber = math.random(10, love.graphics.getWidth() - randImg:getWidth())
	    newEnemy = { x = randomNumber, y = -10, img = randImg }
	    table.insert(enemies, newEnemy)
    end

    -- Update enemy position
    for i, enemy in ipairs(enemies) do
        enemy.y = enemy.y + (110 * dt)
    
        if enemy.y > 850 then -- remove enemies when they pass off the screen
            table.remove(enemies, i)
        end
    end

    for i, enemy in ipairs(enemies) do
        for j, bullet in ipairs(bullets) do
            if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight()) then
                table.remove(bullets, j)
                table.remove(enemies, i)
                score = score + 1
            end
        end
    
        if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), player.x, player.y, player.img:getWidth(), player.img:getHeight()) 
        and isAlive then
            table.remove(enemies, i)
            isAlive = false
        end
    end
    
    if not isAlive and love.keyboard.isDown('r') then
        -- remove all our bullets and enemies from screen
        bullets = {}
        enemies = {}
    
        -- reset timers
        canShootTimer = canShootTimerMax
        createEnemyTimer = createEnemyTimerMax
    
        -- move player back to default position
        player.x = 50
        player.y = 710
    
        -- reset our game state
        score = 0
        isAlive = true
    end

end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
    return x1 < x2+w2 and
           x2 < x1+w1 and
           y1 < y2+h2 and
           y2 < y1+h1
end

function love.draw(dt)
    love.graphics.draw(background,0,0)
    love.graphics.print("Score:",0,love.graphics.getHeight()-50)
    love.graphics.print(score,50,love.graphics.getHeight()-50)
    -- Draw Player
    if isAlive then
        love.graphics.draw(player.img, player.x, player.y)
    else
        love.graphics.print("Press 'R' to restart", love.graphics:getWidth()/2-50, love.graphics:getHeight()/2-10)
    end
    -- Draw Bullets
    for i, bullet in ipairs(bullets) do
        love.graphics.draw(bullet.img, bullet.x, bullet.y)
    end
    -- Draw Enemy
    for i, enemy in ipairs(enemies) do
        love.graphics.draw(enemy.img, enemy.x, enemy.y)
    end
    
end
