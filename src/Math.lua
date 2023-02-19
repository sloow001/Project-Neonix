Math = {}

function Math.lerp(value1, value2, t) 
    return value1 + t * (value2 - value1)
end

return Math