shoot = {}

Shoots = {}

function shoot.new(x, y, speed)
    Shoot = {
        x = x,
        y = y,
        speed = speed
    }
    Shoot.texture = love.graphics.newImage("resources/images/objects/projectile.png")
    Shoot.w = Shoot.texture:getWidth()
    Shoot.h = Shoot.texture:getHeight()
    table.insert(Shoots, Shoot)
end

function shoot.render()
    for k, shoot in pairs(Shoots) do
        love.graphics.draw(shoot.texture, shoot.x, shoot.y, 0, 0.5, 0.5)
    end
end

function shoot.update(elapsed)
    for k, shoot in pairs(Shoots) do
        love.graphics.draw(shoot.texture, shoot.x, shoot.y, 0, 0.5, 0.5)
    end
end

return shoot