local PofRegion = require("pof_region")
local CuringStateManager = require("curing_state_manager")

local BODY_PARTS_DISEASE_INTERFACE_ID = 1188
local SYMPTOMS_INTERFACE_ID = 1186
local HIGHLIGHTED_COLOR = 0x00FFFFFF
local DEFAULT_COLOR = 0xFFFFFFFF
local POF_CURE_PLUGIN_EVENT = "pof-plugin-event"
local DISEASE_CURER_EVENT = "disease-curer-event"

local CHOICE_TEXT_IDS = {
  id.Component.CHOICE_V2__OPTION_TEXT_1,
  id.Component.CHOICE_V2__OPTION_TEXT_2,
  id.Component.CHOICE_V2__OPTION_TEXT_3,
  id.Component.CHOICE_V2__OPTION_TEXT_4,
  id.Component.CHOICE_V2__OPTION_TEXT_5,
}

---@type CuringStateManager?
local curing_state_manager = nil
local was_clicked = {}

---@param text string
---@return string
local function normalize_text(text)
  text = text:gsub("<br>", " ")
  text = text:gsub("<[^>]*>", "")
  text = text:gsub("%s+", " ")
  text = text:match("^%s*(.-)%s*$")
  return text
end

---@param component_id integer
---@return boolean
local function was_just_clicked(component_id)
  local comp = ui.Interfaces:GetComponent(component_id)
  local clicked = comp ~= nil and comp.isClicked
  local just_clicked = clicked and not was_clicked[component_id]
  was_clicked[component_id] = clicked
  return just_clicked
end

---@param component_id integer
---@param rgba integer
local function set_color(component_id, rgba)
  local comp = ui.Interfaces:GetComponent(component_id)
  if comp then comp.rgba = rgba end
end

-- check if component text matches the disease string
---@param component_id integer
---@param disease string
---@return boolean
local function choice_matches_disease(component_id, disease)
  local comp = ui.Interfaces:GetComponent(component_id) --[[@as ui.Text?]]
  if not comp or not comp.content then return false end
  return normalize_text(comp.content):lower():find(disease:lower(), 1, true) ~= nil
end

-- handles logic when player is in the treatment menu
---@param manager CuringStateManager
local function handle_treatment_menu(manager)
  local disease = manager.disease --[[@as string]]

  -- set default for wrong highlighted for correct disease
  for _, component_id in ipairs(CHOICE_TEXT_IDS) do
    local comp = ui.Interfaces:GetComponent(component_id) --[[@as ui.Text?]]
    if not comp or not comp.content then return false end
    if choice_matches_disease(component_id, disease) then
      set_color(component_id, HIGHLIGHTED_COLOR)
    else
      set_color(component_id, DEFAULT_COLOR)
    end
  end
end

-- handles logic when player is in the body part menu
---@param manager CuringStateManager
local function handle_body_part_menu(manager)
  -- option selection
  for _, option in ipairs(manager.options) do
    if was_just_clicked(option.component_option_id) then manager:select_option(option.component_option_id) end
  end

  -- color highlighting
  local found_disease = manager:has_found_disease()
  if found_disease then set_color(manager:get_treatment_option().component_id, HIGHLIGHTED_COLOR) end
  for _, option in ipairs(manager:body_parts_options()) do
    if found_disease or option.checked then
      set_color(option.component_id, DEFAULT_COLOR)
    else
      set_color(option.component_id, HIGHLIGHTED_COLOR)
    end
  end
end

-- handles logic when player is viewing the symptom chat box
-- grabs the text written parses it to just the symptom part of the string and normalizes it
---@param manager CuringStateManager
local function handle_symptom_box(manager)
  local symptom_text = ui.Interfaces:GetComponent(id.Component.MESBOX_V2__MESBOX_TEXT) --[[@as ui.Text?]]
  if not symptom_text or not symptom_text.content then return end
  local _, after_colon = symptom_text.content:match("^(.-): (.*)$")
  local symptom = normalize_text(after_colon or symptom_text.content)
  manager:check_symptom(symptom)
end

--handles logic when the player clicks the cure disease on a animal
local function start_disease_curer()
  Event.Draw.Subscribe(DISEASE_CURER_EVENT, function()
    -- Press Cure Disease on Animal
    if was_just_clicked(id.Component.POF_ANIMAL__CURE_CLICK) then curing_state_manager = CuringStateManager.new() end

    if not curing_state_manager then return end

    -- Body Parts or disease select interface opened
    if ui.Interfaces:GetInterface(BODY_PARTS_DISEASE_INTERFACE_ID) then
      if curing_state_manager:is_selecting_body_part() then
        -- body parts menu
        handle_body_part_menu(curing_state_manager)
      else
        -- disease menu
        handle_treatment_menu(curing_state_manager)
      end
    end
    -- if user missed the correct disease reset to selecing body part
    if was_just_clicked(id.Component.CHAT_V2_RIGHT__CLICK_CONTINUE) then curing_state_manager:set_selecting_body_part() end
    -- showing symptom_text
    local is_symptom_box_open = ui.Interfaces:GetInterface(SYMPTOMS_INTERFACE_ID) ~= nil
    if is_symptom_box_open then handle_symptom_box(curing_state_manager) end
  end)
end

local function stop_disease_curer()
  Event.Draw.Unsubscribe(DISEASE_CURER_EVENT)
  curing_state_manager = nil
end

PofRegion.start_checking_for_pof(start_disease_curer, stop_disease_curer)
Event.ServerLogic.Subscribe(POF_CURE_PLUGIN_EVENT, function()
  if Player.IsAvailable() then
    PofRegion.start_checking_for_pof(start_disease_curer, stop_disease_curer)
  else
    PofRegion.stop_checking_for_pof()
  end
end)
