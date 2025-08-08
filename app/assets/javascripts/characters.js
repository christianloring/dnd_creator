document.addEventListener("DOMContentLoaded", () => {
  const classSelect = document.getElementById("character_class_select");
  const subclassSelect = document.getElementById("subclass_select");

  const subclassOptions = {
    "Barbarian": ["Path of the Berserker", "Path of the Wild Heart"],
    "Bard": ["College of Dance", "College of Lore", "College of Valor"],
    "Cleric": ["Life Domain", "Light Domain", "Trickery Domain"],
    "Druid": ["Circle of the Land", "Circle of the Moon", "Circle of the Sea"],
    "Fighter": ["Champion", "Battle Master", "Eldritch Knight"],
    "Monk": ["Warrior of the Hand", "Warrior of the Shadow", "Warrior of the Elements"],
    "Paladin": ["Oath of Devotion", "Oath of Vengeance", "Oath of the Ancients"],
    "Ranger": ["Hunter", "Beast Master", "Gloom Stalker"],
    "Rogue": ["Thief", "Assassin", "Arcane Trickster"],
    "Sorcerer": ["Draconic Bloodline", "Wild Magic", "Aberrant Mind"],
    "Warlock": ["The Archfey", "The Fiend", "The Great Old One"],
    "Wizard": ["Evocation", "Illusion", "Divination"],
    "Artificer": ["Alchemist", "Artillerist", "Battle Smith"]
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
