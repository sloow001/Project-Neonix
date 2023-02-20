utilities = {}

function utilities.rgbToColor(r, g, b, a)
    R, G, B, A = love.math.colorFromBytes(r, g, b, a)
    return R, G, B, A
end

function utilities.collision(obj1, obj2)
    return     
    obj1.x < obj2.x + obj2.w and
    obj1.x + obj1.w > obj2.x and
    obj1.y < obj2.y + obj2.h and
    obj1.h + obj1.y > obj2.y
end

return utilities