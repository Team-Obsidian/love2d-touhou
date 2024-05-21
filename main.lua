io.stdout:setvbuf("no")




function love.load()

    start = love.timer.getTime()

    winX = 1280
    winY = 960
    hasEnded = false
    love.window.setMode(winX,winY)

    pHitTex = love.graphics.newImage('img/playerHitbox.png')
    heartTex = love.graphics.newImage('img/heart.png')

    stage = {}
    stage.elapsedTime = 0


    function genPlayer(arg)
        local player = {}
        player.xPos = arg.xPos or 640
        player.lives = arg.lives or 3
        player.speed = arg.speed or 400
        player.xPos = arg.xPos or winX/2
        player.yPos = arg.yPos or winY*0.8
        player.radius = arg.radius or 8
        player.rotate = arg.rotate or 0
        player.skewX = arg.skewX or 0
        player.skewY = arg.skewY or 0
        player.opacity = arg.opacity or 1
        player.hitable = true
        player.bulletCooldownMax = arg.bulletCooldownMax or 0.15
        player.bulletCooldown = arg.bulletCooldown or player.bulletCooldownMax 
        player.hitTimerMax = 5
        player.hitTimer = arg.hitTimer or player.hitTimerMax
        return player
    end

    player = genPlayer{}
    bullets = {}


    function genBullet(arg)
        local bullet = {}
        bullet.xPos = arg.xPos or winX/2
        bullet.yPos = arg.yPos or winY/5*2
        bullet.radius = arg.radius or 16
        bullet.angle = arg.angle or math.pi/2
        bullet.curveAngle = arg.curveAngle or 0
        bullet.speed = arg.speed or 500
        bullet.accelerateMin = arg.accelerateMin or 0
        bullet.accelerateMax = arg.accelerateMax or 0
        bullet.accelerate = arg.accelerate or 0
        bullet.owner = arg.owner or 'enemy'
        bullet.damage = arg.damage or 5

        bullet.timeoutMax = arg.timeoutMax or 0.5
        bullet.timeout = arg.timeout or bullet.timeoutMax
        table.insert(bullets, bullet)
    end

    function aimBullet(arg)
        local aimAngle = math.pi + math.atan2((arg.yPos-player.yPos),(arg.xPos-player.xPos))
        local bullet = {}
        bullet.xPos = arg.xPos or winX/2
        bullet.yPos = arg.yPos or winY/5*2
        bullet.radius = arg.radius or 16
        bullet.angle = arg.angle or aimAngle
        bullet.curveAngle = arg.curveAngle or 0
        bullet.speed = arg.speed or 500
        bullet.accelerateMin = arg.accelerateMin or 0
        bullet.accelerateMax = arg.accelerateMax or 0
        bullet.accelerate = arg.accelerate or 0
        genBullet(bullet)
    end


    enemies = {}
    function genEnemy(arg)
        local enemy = {}
        enemy.xPos = arg.xPos or winX/2
        enemy.yPos = arg.yPos or winY/5
        enemy.radius = arg.radius or 24

        enemy.health = arg.health or 500

        
        if arg.type == 'boss' then
            --boss thing
        elseif arg.type == 'mobA' then
            --easy enemy 1
        elseif arg.type == 'mobB' then
            --easy enemy 2
        end


        --enemy movement behavior needs to be defined
        enemy.moveBehavior = arg.moveBehavior or ''
        table.insert(enemies, enemy)
    end
    genEnemy{}

    function moveObject(object)
        --[[
            enemy.centerX = (-1/(1+math.e**(-5+enemy.moveTime/enemy.moveTimeMax*10))+1) * (enemy.toX-enemy.initialX) + enemy.initialX
            enemy.centerY = (-1/(1+math.e**(-5+enemy.moveTime/enemy.moveTimeMax*10))+1) * (enemy.toY-enemy.initialY) + enemy.initialY
        --]]


    end

    function objCenter(object) return (object.xPos+object.width/2), (object.yPos+object.height/2) end
    function objNum(object) local num = 0 for i, value in pairs(object) do num = num + 1 end return num end
    function objDistance(object1, object2) 
        local something = (object2.xPos - object1.xPos)^2 + (object2.yPos - object1.yPos)^2
        --print(math.sqrt(something))
        return math.sqrt(something)
    end
    --spits out 2 things, midX and midY as the 2 return arguments
end

function love.draw()
    if hasEnded == false then
        --adjust the scaling factor
        if player.lives >= 1 then
            for i=1, player.lives do
                love.graphics.draw(heartTex, winX*0.8+40*i, 200)
            end
        end
        --[[
        love.graphics.draw(
            pHitTex, player.xPos, player.yPos
            )

        love.graphics.circle('fill', player.xPos, player.yPos, player.radius)
        --]]
        love.graphics.setColor(0.2, 0.2, 0.8, player.opacity)
        love.graphics.circle('fill', player.xPos, player.yPos, player.radius)

        for i, enemy in pairs(enemies) do
            love.graphics.setColor(0.8, 0.2, 0.2, 1)
            love.graphics.circle('fill', enemy.xPos, enemy.yPos, enemy.radius)
        end

        for i, bullet in pairs(bullets) do
            love.graphics.setColor(0.9, 0.9, 0.9, 0.8)
            love.graphics.circle('fill', bullet.xPos, bullet.yPos, bullet.radius)

            if bullet.owner == 'enemy' then love.graphics.setColor(0.5, 0.2, 0.2, 1)
            elseif bullet.owner == 'player' then love.graphics.setColor(0.2, 0.2, 0.5, 1)
            end

            love.graphics.circle('fill', bullet.xPos, bullet.yPos, bullet.radius*0.8)

        end

    elseif hasEnded == true then
        love.graphics.setColor(1, 1, 1, 1)
        if player.lives >= 1 then

            love.graphics.print('You win!',winX/2,winY/2,0,3,3)
        else
            love.graphics.print('You died...',winX/2,winY/2,0,3,3)
        end
    end

end

function love.update(dTime)
    if hasEnded == false then
        stage.elapsedTime = stage.elapsedTime + dTime
        if player.hitable == false then
            player.hitTimer = player.hitTimer - dTime
            if player.hitTimer <= 0 then
                player.hitable = true
                player.opacity = 1
                player.hitTimer = player.hitTimerMax
            end
        end

        if love.keyboard.isDown('left') then
            player.xPos = player.xPos - player.speed*dTime
        end

        if love.keyboard.isDown('right') then
            player.xPos = player.xPos + player.speed*dTime
        end

        if love.keyboard.isDown('up') then
            player.yPos = player.yPos - player.speed*dTime
        end

        if love.keyboard.isDown('down') then
            player.yPos = player.yPos + player.speed*dTime
        end

        if love.keyboard.isDown('z') then
            player.bulletCooldown = player.bulletCooldown - dTime
            if player.bulletCooldown <= 0 then
                player.bulletCooldown = player.bulletCooldownMax
                genBullet{owner='player',xPos=player.xPos,yPos=player.yPos,angle=-math.pi/2,speed=800,radius=12}
            end
        end

        --if enemy is dead

        for i, enemy in pairs(enemies) do
            local enemyNum = i
            if enemy.health <= 0 then
                table.remove(enemies, enemyNum)
                hasEnded = true
            end
        end

        for i, bullet in pairs(bullets) do
            local bulletNum = i
            local willRemove = false

            bullet.xPos = bullet.xPos + math.cos(bullet.angle) * bullet.speed*dTime
            bullet.yPos = bullet.yPos + math.sin(bullet.angle) * bullet.speed*dTime

            --if bullet outside window
            if bullet.xPos >= winX + bullet.radius or bullet.xPos <= -bullet.radius or bullet.yPos >= winY + bullet.radius or bullet.yPos <= -bullet.radius  then
                if bullet.timeout <= 0 then
                    willRemove = true
                else
                    bullet.timeout = bullet.timeout - dTime
                end
            end

            --if bullet makes contact
            if bullet.owner == 'player' then
                for i, enemy in pairs(enemies) do
                    if objDistance(enemy, bullet) < bullet.radius + enemy.radius then
                        willRemove = true
                        enemy.health = enemy.health - bullet.damage
                        print('enemyHit')

                    end
                end
            elseif bullet.owner == 'enemy' then
                for i, enemy in pairs(enemies) do
                    if objDistance(player, bullet) < bullet.radius + player.radius and player.hitable then
                        --willRemove = true
                        player.lives = player.lives - 1
                        if player.lives == 0 then
                            hasEnded = true
                        end
                        player.opacity = 0.8
                        player.hitable = false
                        print('playerHit')
                    end
                end
            end

            if willRemove == true then
                table.remove(bullets, bulletNum)
            end
        end

        if stage.elapsedTime%2.5 < dTime then
            for i, enemy in pairs(enemies) do
                aimBullet{speed=300,radius=45,xPos=enemy.xPos,yPos=enemy.yPos}
            end
        end
        if (stage.elapsedTime+8)%2.5 < dTime then
            for i, enemy in pairs(enemies) do
                for i=1, 24 do
                    genBullet{speed=350,xPos=enemy.xPos,yPos=enemy.yPos,angle=2*math.pi/24*i}
                end
            end
        end



    elseif hasEnded == true then
        --something somethibng
    end


end

function love.keypressed(key)






end