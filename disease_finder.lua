local diseases = require("diseases") --[[@as DiseaseLookup]]

---@class DiseaseFinder
local DiseaseFinder = {}

-- The disease a symptom points to for the given body part, or nil if the body part is unknown
-- or the symptom doesn't identify a disease.
---@param body_part string? "head", "eyes", "legs" or "stomach"
---@param symptom string
---@return string?
function DiseaseFinder.diagnose(body_part, symptom)
  if type(body_part) ~= "string" or type(symptom) ~= "string" then return nil end
  local possible_symptoms = diseases[body_part]
  if not possible_symptoms then return nil end

  symptom = symptom:match("^%s*(.-)%s*$")
  return possible_symptoms[symptom]
end

return DiseaseFinder
