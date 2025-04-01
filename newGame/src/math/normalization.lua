local normalize = {}

-- Mathmatical functions should be handled here for the sake of organization
-- Normalizes a vector so diagonal movement isn't faster than horizontal/vertical movement
function normalize.NormalizedVector(dx, dy)
    local length = math.sqrt(dx * dx + dy * dy)
    if length == 0 then
        return 0, 0
    else
        return dx / length, dy / length

    end 
end

return normalize
