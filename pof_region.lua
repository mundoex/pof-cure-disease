local POF_REGION = CoordGrid.new(0, 41, 52, 0, 0)
local RANCH_REGION = CoordGrid.new(0, 81, 37, 0, 0)
local POF_REGION_EVENT = "pof-region-event"

local PofRegion = {}
local already_in_pof_region = false

---@param target CoordGrid
---@return boolean
local function is_player_in_map_square(player, target)
  return player.coordGrid.mapSquareX == target.mapSquareX and player.coordGrid.mapSquareZ == target.mapSquareZ
end

---@return boolean
local function is_player_in_animal_farms_region(player)
  return is_player_in_map_square(player, POF_REGION) or is_player_in_map_square(player, RANCH_REGION)
end

-- Calls start_fn if player is in the pof region and the player wasnt there yet
-- If not in region call stop_fn and reset
---@param start_fn fun() Called while the player is inside the animal farms region
---@param stop_fn fun() Called while the player is outside it
function PofRegion.start_checking_for_pof(start_fn, stop_fn)
  Event.ServerLogic.Subscribe(POF_REGION_EVENT, function()
    local player = PlayerList.Self()
    if is_player_in_animal_farms_region(player) then
      -- print("IN REGION")
      if not already_in_pof_region then start_fn() end
      already_in_pof_region = true
    else
      stop_fn()
      already_in_pof_region = false
    end
  end)
end

function PofRegion.stop_checking_for_pof() Event.ServerLogic.Unsubscribe(POF_REGION_EVENT) end

return PofRegion
