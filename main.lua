io.stdout:setvbuf("no")
local start = love.timer.getTime()


function love.load()

    stage = {}
    stage.elapsedTime = 0


    function genBullet(arg)
        local bullet = {}
        bullet.size = arg.size or 15
        bullet.angle = arg.angle or 0
        bullet.curveAngle = arg.curveAngle or 0
        bullet.speed = arg.speed or 10
    end

    function genEnemy(arg)
        local enemy = {}
        enemy.health = arg.health or 500

        
        if arg.type == 'boss' then
            --boss thing
        elseif arg.type == 'mobA'
            --easy enemy 1
        elseif arg.type == 'mobB'
            --easy enemy 2
        end


        --enemy movement behavior needs to be defined
        enemy.moveBehavior = arg.moveBehavior

    end

    function moveObject(object)
        --[[
            enemy.centerX = (-1/(1+math.e**(-5+enemy.moveTime/enemy.moveTimeMax*10))+1) * (enemy.toX-enemy.initialX) + enemy.initialX
            enemy.centerY = (-1/(1+math.e**(-5+enemy.moveTime/enemy.moveTimeMax*10))+1) * (enemy.toY-enemy.initialY) + enemy.initialY
        --]]


    end

    function objCenter(object) return (object.xPos+object.width/2), (object.yPos+object.height/2) end
    --spits out 2 things, midX and midY as the 2 return arguments
end

function love.draw()



end