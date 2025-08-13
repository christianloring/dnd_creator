document.addEventListener("DOMContentLoaded", () => {
  const classSelect = document.getElementById("character_class_select");
  const subclassSelect = document.getElementById("subclass_select");

  const subclassOptions = {
    "Warrior": ["Path of the Berserker", "Path of the Guardian", "Path of the Champion"],
    "Mage": ["College of Lore", "College of Battle", "College of Elements"],
    "Guardian": ["Life Domain", "Protection Domain", "Justice Domain"],
    "Mystic": ["Circle of Nature", "Circle of Spirits", "Circle of Elements"],
    "Scout": ["Pathfinder", "Beast Master", "Shadow Walker"],
    "Rogue": ["Thief", "Assassin", "Trickster"],
    "Sage": ["School of Knowledge", "School of Divination", "School of Illusion"],
    "Ranger": ["Hunter", "Beast Companion", "Wilderness Guide"],
    "Warlock": ["Pact of the Fey", "Pact of the Void", "Pact of the Elements"],
    "Wizard": ["School of Evocation", "School of Abjuration", "School of Conjuration"],
    "Artificer": ["Alchemist", "Engineer", "Enchanter"]
  };

  if (!classSelect || !subclassSelect) return;

  classSelect.addEventListener("change", () => {
    const selectedClass = classSelect.value;
    const subclasses = subclassOptions[selectedClass] || [];

    // Clear old options
    subclassSelect.innerHTML = "";

    if (subclasses.length > 0) {
      subclassSelect.disabled = false;
      const promptOption = document.createElement("option");
      promptOption.text = "Choose a subclass";
      promptOption.value = "";
      subclassSelect.add(promptOption);

      subclasses.forEach(subclass => {
        const option = document.createElement("option");
        option.text = subclass;
        option.value = subclass;
        subclassSelect.add(option);
      });
    } else {
      subclassSelect.disabled = true;
    }
  });
});
