-- diseases.<part>[symptom] = disease name
-- Symptoms shared by more than one disease are left out, since they can't identify one.

---@class DiseaseLookup
---@field head table<string, string>
---@field eyes table<string, string>
---@field legs table<string, string>
---@field stomach table<string, string>

---@type DiseaseLookup
local diseases = {
  head = {
    ["The animal keeps making noises at embarrassing moments, making it difficult to investigate."] = "Foot-in-mouth",
    ["The animal's breath smells oddly like socks."] = "Foot-in-mouth",
    ["The gums appear to be a little sore."] = "Foot-in-mouth",
    ["There are some nasty looking marks along the gum line."] = "Foot-in-mouth",

    ["The animal appears to be suffering from a small fever."] = "Flu",
    ["The animal coughs in your face."] = "Flu",
    ["The animal sneezes in your face."] = "Flu",
    ["The animal's breath smells deeply unpleasant."] = "Flu",

    ["The animal occasionally mumbles something in a language it can't possibly speak."] = "Curse",
    ["The animal's breath smells faintly of sulphur."] = "Curse",
    ["The animal's nose is lumpy, like it's grown warts."] = "Curse",
    ["There is a faint light deep within the animal's throat."] = "Curse",

    ["The animal's nose is very dry."] = "Dry nose",
    ["The animal refuses to let you see its nose, it seems like the nose is quite sore."] = "Dry nose",

    ["The animal's breath smells normal, which is to say horrible."] = "Bone rattle",
    ["The animal's teeth click in a sinister manner."] = "Bone rattle",
    ["The gums appear to be healthy."] = "Bone rattle",

    ["The animal coughs as you try and examine it."] = "Wooting cough",
    ["The animal coughs loudly in a 'hu hu huuu' style."] = "Wooting cough",
    ["The animal's breath smells normal."] = "Wooting cough",
  },

  eyes = {
    ["The animal's eyes seem normal."] = "Foot-in-mouth",

    ["The eyes are a little bloodshot."] = "Flu",

    ["The animal's eyes are faintly glowing."] = "Curse",
    ["The animal's eyes are filled with uncharacteristic malice."] = "Curse",
    ["The animal's eyes seem a little glazed over."] = "Curse",

    ["The animal's eyes are filled with mirth, more mirth than normal."] = "Wooting cough",
    ["The animal's eyes keep darting around the place with a sense of wonder."] = "Wooting cough",
  },

  legs = {
    ["The animal's feet are a little soggy for some reason."] = "Foot-in-mouth",

    ["The animal's feet are clammy."] = "Flu",
    ["The animal's feet are very sweaty."] = "Flu",
    ["The animal's feet are very warm to the touch."] = "Flu",

    ["The animal's feet are tapping to a strange rhythm. It's unsettling."] = "Curse",

    ["The animal's legs click as it walks."] = "Bone rattle",
    ["The animal's legs seem a little stiff."] = "Bone rattle",

    ["The animal is a little unsteady on its feet."] = "Wooting cough",
    ["The animal's legs seem fine."] = "Wooting cough",
  },

  stomach = {
    ["The animal's emissions smell strangely of shoes."] = "Foot-in-mouth",
    ["The animal's stomach appears to be a little bloated."] = "Foot-in-mouth",

    ["The animal appears to be suffering from nausea."] = "Flu",

    ["The animal's stomach is making strange noises, like there's something singing inside there."] = "Curse",

    ["The animal appears to be shivering, but has no temperature."] = "Bone rattle",
    ["The animal's body is making a weird clicking noise."] = "Bone rattle",

    ["The animal coughs regularly."] = "Wooting cough",
    ["The animal's body is slightly swollen."] = "Wooting cough",
  },
}

return diseases
