local DiseaseFinder = require("disease_finder")

-- Options 1-4 are body parts, option 5 is "administer treatment"
local BODY_PART_OPTION_COUNT = 4
local TREATMENT_OPTION_INDEX = 5

---@enum CuringState
local CuringState = {
  SELECTING_BODY_PART_OR_ADMINISTER_TREATMENT = "selecting_body_part_or_administer_treatment",
  SELECTING_TREATMENT = "selecting_treatment",
}

---@class CureOption
---@field component_id integer The option's text component (used for highlighting)
---@field component_option_id integer The option's row component (what a click lands on)
---@field body_part string? nil for the treatment option
---@field checked boolean

---@class CuringStateManager
---@field state CuringState
---@field disease string? Name of the diagnosed disease, nil until a symptom matches
---@field options CureOption[]
---@field selected_option_index integer Index into options of the last clicked option, -1 if none yet
local CuringStateManager = {}
CuringStateManager.__index = CuringStateManager

---@return CuringStateManager
function CuringStateManager.new()
  local self = setmetatable({}, CuringStateManager)
  self.state = CuringState.SELECTING_BODY_PART_OR_ADMINISTER_TREATMENT
  self.disease = nil
  self.options = {
    {
      component_id = id.Component.CHOICE_V2__OPTION_TEXT_1,
      component_option_id = id.Component.CHOICE_V2__OPTION_1,
      body_part = "head",
      checked = false,
    },
    {
      component_id = id.Component.CHOICE_V2__OPTION_TEXT_2,
      component_option_id = id.Component.CHOICE_V2__OPTION_2,
      body_part = "eyes",
      checked = false,
    },
    {
      component_id = id.Component.CHOICE_V2__OPTION_TEXT_3,
      component_option_id = id.Component.CHOICE_V2__OPTION_3,
      body_part = "legs",
      checked = false,
    }, -- legs and feet
    {
      component_id = id.Component.CHOICE_V2__OPTION_TEXT_4,
      component_option_id = id.Component.CHOICE_V2__OPTION_4,
      body_part = "stomach",
      checked = false,
    },
    { component_id = id.Component.CHOICE_V2__OPTION_TEXT_5, component_option_id = id.Component.CHOICE_V2__OPTION_5, checked = false }, -- treatment
  }
  self.selected_option_index = -1
  return self
end

---@param state CuringState
function CuringStateManager:set_state(state) self.state = state end

---@param state CuringState
---@return boolean
function CuringStateManager:is_state(state) return self.state == state end

function CuringStateManager:set_selecting_body_part() return self:set_state(CuringState.SELECTING_BODY_PART_OR_ADMINISTER_TREATMENT) end

---@return boolean
function CuringStateManager:is_selecting_body_part() return self:is_state(CuringState.SELECTING_BODY_PART_OR_ADMINISTER_TREATMENT) end

---@return boolean
function CuringStateManager:has_found_disease() return self.disease ~= nil end

-- used to keep track where the user is in the menu because its the same comp id
---@param component_option_id integer
function CuringStateManager:select_option(component_option_id)
  for i, option in ipairs(self.options) do
    if option.component_option_id == component_option_id then
      self.selected_option_index = i
      option.checked = true
      if not option.body_part then self:set_state(CuringState.SELECTING_TREATMENT) end
    end
  end
end

---@return string?
function CuringStateManager:get_selected_option_body_part() return self.options[self.selected_option_index].body_part end

-- checks if the passed symptom string matches a disease if so sets the disease string
---@param symptom string
function CuringStateManager:check_symptom(symptom)
  local body_part = self:get_selected_option_body_part()
  self.disease = DiseaseFinder.diagnose(body_part, symptom)
end

-- Only the body part options (1-4), without the treatment option
---@return CureOption[]
function CuringStateManager:body_parts_options() return { table.unpack(self.options, 1, BODY_PART_OPTION_COUNT) } end

---@return CureOption
function CuringStateManager:get_treatment_option() return self.options[TREATMENT_OPTION_INDEX] end

return CuringStateManager
