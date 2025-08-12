class Npc < ApplicationRecord
  belongs_to :user

  validates :name, presence: true

  before_validation :ensure_data_is_hash

  # NPC Categories and Options
  CATEGORIES = {
    body_types: [
      "Petite", "Short", "Average height", "Tall", "Towering",
      "Slender", "Lean", "Athletic", "Muscular", "Burly",
      "Plump", "Potbelly", "Broad shouldered", "Lanky", "Wiry",
      "Fragile", "Bony", "Stout", "Portly", "Rotund"
    ],
    build: [
      "Heavyset", "Lean", "Lanky", "Broad", "Narrow", "Bulky",
      "Fragile", "Wiry", "Stout", "Top-heavy", "Bottom-heavy"
    ],
    skintone: [
      "Fair", "Olive", "Tan", "Dark", "Pale", "Sunburned", "Ruddy",
      "Freckled", "Weathered", "Smooth", "Rough", "Scarred",
      "Sallow", "Flushed", "Dusky", "Bronzed", "Glowing"
    ],
    posture: [
      "Straight-backed", "Slouched", "Rigid", "Hunched", "Swaggering",
      "Relaxed", "Tense", "Awkward", "Graceful", "Stiff"
    ],
    face_shapes: [
      "Round", "Oval", "Square", "Heart-shaped", "Diamond", "Oblong",
      "Angular", "Long", "Broad", "Thin", "Sharp-jawed", "Narrow"
    ],
    nose: [
      "Straight", "Hooked", "Upturned", "Bulbous", "Aquiline", "Flat",
      "Wide", "Narrow", "Pointed", "Crooked", "Snub", "Button-like"
    ],
    eye_shape: [
      "Almond-shaped", "Round", "Hooded", "Narrow", "Wide-set", "Close-set",
      "Droopy", "Deep-set", "Sunken", "Protruding", "Sharp",
      "Slanted", "Large", "Small", "Squinty", "Bright", "Dull"
    ],
    eye_color: [
      "Blue", "Green", "Brown", "Hazel", "Gray", "Amber", "Violet",
      "Black", "Pale blue", "Icy gray", "Golden", "Mismatched", "Glowing"
    ],
    eyebrows: [
      "Thick", "Thin", "Bushy", "Arched", "Straight", "Sparse",
      "Sharp", "Angular", "Rounded", "Unkempt", "Perfectly groomed"
    ],
    mouth_lips: [
      "Thin", "Full", "Wide", "Narrow", "Pursed", "Cracked",
      "Crooked smile", "Toothy grin", "Tight-lipped", "Soft", "Frowning"
    ],
    teeth: [
      "Crooked", "Straight", "Sharp", "Chipped", "Missing", "Pearly white",
      "Yellowed", "Stained", "Jagged", "Uneven", "Fanged"
    ],
    misc: [
      "Pierced ears", "Pierced nose", "Pierced lip", "Missing an eye", "Eyepatch", "Glass eye",
      "Horns", "Tail", "Feathers", "Glowing tattoos", "Third eye", "Claws instead of nails"
    ],
    hair_length: [
      "Short", "Cropped", "Medium", "Shoulder-length", "Long", "Waist-length",
      "Buzzed", "Bald", "Pixie cut", "Chin-length", "Crew cut", "Shaggy"
    ],
    hair_texture: [
      "Straight", "Wavy", "Curly", "Coiled", "Frizzy", "Thick", "Thin",
      "Sleek", "Greasy", "Coarse", "Smooth", "Knotted", "Flowing", "Braided"
    ],
    hair_color: [
      "Blonde", "Brown", "Black", "Red", "White", "Silver", "Gray",
      "Auburn", "Chestnut", "Platinum", "Golden", "Raven", "Streaked"
    ],
    smell: [
      "Fresh", "Clean", "Perfumed", "Earthy", "Musky", "Foul",
      "Of dirt", "Of sweat", "Of flowers", "Of salt", "Of leather", "Of smoke",
      "Smells of herbs", "Smells of spices", "Smells of alcohol", "Smells of blood", "Smells of incense"
    ],
    voice: [
      "Deep", "High-pitched", "Raspy", "Nasal", "Melodious", "Gruff",
      "Soft-spoken", "Booming", "Gravelly", "Whispery", "Shrill", "Monotone"
    ],
    mannerisms: [
      "Fidgeting", "Pacing", "Stroking beard", "Biting nails",
      "Drumming fingers", "Narrowing eyes", "Crossing arms", "Tapping foot",
      "Constantly checking surroundings", "Cracking knuckles", "Adjusting clothes"
    ],
    speech_patterns: [
      "Talks quickly", "Slow drawl", "Pauses often", "Stumbles over words",
      "Speaks in riddles", "Constantly swearing", "Always whispering",
      "Singsong voice", "Loud and brash", "Very formal", "Overly polite"
    ],
    temperament: [
      "Calm and collected", "Hot-tempered", "Cheerful", "Morose", "Brooding",
      "Optimistic", "Pessimistic", "Excitable", "Shy", "Proud", "Arrogant"
    ],
    hands: [
      "Large", "Small", "Slender", "Calloused", "Delicate", "Rough",
      "Long-fingered", "Stubby", "Scarred", "Bony", "Graceful",
      "Covered in cuts", "Dirt under nails", "Trembling", "Steady"
    ],
    scars_markings: [
      "Large scar across the cheek", "Burn marks", "Jagged scar on the arm",
      "Tattoos covering the forearms", "Birthmark on the neck", "Freckles",
      "Scratches on the face", "Claw marks", "Magical runes engraved in skin"
    ],
    clothing: [
      "Pristine", "Tattered", "Dirty", "Bloodstained", "Soot-covered",
      "Wrinkled", "Clean", "Patched", "Threadbare", "Embroidered",
      "Simple", "Luxurious", "Frayed", "Torn", "Worn-out"
    ]
  }.freeze

  def self.randomize
    new(
      name: generate_random_name,
      data: generate_random_data
    )
  end

  def self.generate_random_name
    first_names = [ "Aldric", "Branwen", "Cedric", "Dara", "Eamon", "Faye", "Gareth", "Hilda", "Ivor", "Jenna", "Kael", "Luna", "Marek", "Nora", "Orin", "Poppy", "Quinn", "Raven", "Soren", "Tara", "Ulf", "Vera", "Wren", "Xander", "Yara", "Zane" ]
    last_names = [ "Blackwood", "Stormwind", "Ironheart", "Moonwhisper", "Fireforge", "Shadowbane", "Lightbringer", "Darkwater", "Silverleaf", "Goldcrest", "Bronzebeard", "Copperfield", "Steelheart", "Stonefist", "Thunderclap", "Windwalker", "Earthshaker", "Frostborn", "Flameweaver", "Voidwalker" ]

    "#{first_names.sample} #{last_names.sample}"
  end

  def self.generate_random_data
    data = {}
    CATEGORIES.each do |category, options|
      # 70% chance to have a trait, 30% chance to be "none"
      data[category.to_s] = rand < 0.7 ? options.sample : "None"
    end
    data
  end

  def display_traits
    traits = []
    data&.each do |category, value|
      next if value == "None" || value.blank?
      traits << "#{category.to_s.humanize}: #{value}"
    end
    traits
  end

  def description
    return "No description available" if data.blank?

    parts = []

    # Physical description
    physical = []
    physical << data["body_types"] if data["body_types"] && data["body_types"] != "None"
    physical << data["build"] if data["build"] && data["build"] != "None"
    physical << data["skintone"] if data["skintone"] && data["skintone"] != "None"

    if physical.any?
      parts << "A #{physical.join(', ')} individual"
    end

    # Face description
    face = []
    face << data["face_shapes"] if data["face_shapes"] && data["face_shapes"] != "None"
    face << data["eye_color"] if data["eye_color"] && data["eye_color"] != "None"
    face << data["eye_shape"] if data["eye_shape"] && data["eye_shape"] != "None"

    if face.any?
      parts << "with #{face.join(', ')} features"
    end

    # Hair description
    hair = []
    hair << data["hair_color"] if data["hair_color"] && data["hair_color"] != "None"
    hair << data["hair_texture"] if data["hair_texture"] && data["hair_texture"] != "None"
    hair << data["hair_length"] if data["hair_length"] && data["hair_length"] != "None"

    if hair.any?
      parts << "and #{hair.join(', ')} hair"
    end

    # Personality/behavior
    personality = []
    personality << data["temperament"] if data["temperament"] && data["temperament"] != "None"
    personality << data["speech_patterns"] if data["speech_patterns"] && data["speech_patterns"] != "None"
    personality << data["mannerisms"] if data["mannerisms"] && data["mannerisms"] != "None"

    if personality.any?
      parts << "They are #{personality.join(', ')}"
    end

    parts.join(". ")
  end

  private

  def ensure_data_is_hash
    self.data = {} if data.nil?
  end
end
