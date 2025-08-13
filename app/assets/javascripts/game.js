function mod(score){ return Math.floor((Number(score) - 10) / 2); }
function roll(n = 1, d = 20){
  let t = 0; for(let i = 0; i < n; i++) t += Math.floor(Math.random()*d) + 1; return t;
}
function rollExpr(expr){
  const [n, d] = String(expr).split("d").map(Number);
  return roll(n, d);
}

const root = document.getElementById("game-root");
if (root){
  const pc = {
    id:  Number(root.dataset.characterId),
    name:  root.dataset.name,
    level: Number(root.dataset.level || 1),
    hp:    Number(root.dataset.hp || 10),
    maxHp: Number(root.dataset.maxHp || 10),
    ac:    Number(root.dataset.ac || 10),
    str:   Number(root.dataset.str || 10),
    dex:   Number(root.dataset.dex || 10),
    int:   Number(root.dataset.int || 10),
    wis:   Number(root.dataset.wis || 10),
    cha:   Number(root.dataset.cha || 10),
    exp:   Number(root.dataset.exp || 0),
    gold:  Number(root.dataset.gold || 0),
    gameData: JSON.parse(root.dataset.gameData || '{}'),
    wepDie:  root.dataset.wepDie || "1d8",
    spellDie: root.dataset.spellDie || "2d6",
  };

  let stage = 1;
  let enemy = makeEnemy(stage);
  let turn  = "pc";
  let enemiesDefeated = 0;

  const ui = {
    name: document.getElementById("ui-name"),
    lvl:  document.getElementById("ui-lvl"),
    ac:   document.getElementById("ui-ac"),
    hp:   document.getElementById("ui-hp"),
    maxHp: document.getElementById("ui-max-hp"),
    ehp:  document.getElementById("ui-ehp"),
    exp:  document.getElementById("ui-exp"),
    gold: document.getElementById("ui-gold"),
    log:  document.getElementById("combat-log"),
  };

  // Prices
  const PRICES = {
    armor: {1:100, 2:250, 3:500},
    weapon:{1:120, 2:300, 3:600},
    wand:  {1:120, 2:300, 3:600},
    potion: 50,
    gpotion: 100,
    meta: {
      battleTraining: 300,
      arcaneStudy: 300,
      blessedCharm: 250,
      greedyPouch: 250
    }
  };

  // Ensure gameData structure
  pc.gameData ||= {};
  pc.gameData.gear ||= { armor: 0, weapon: 0, wand: 0 };       // tier 0..3
  pc.gameData.meta ||= { battleTraining:false, arcaneStudy:false, blessedCharm:false, greedyPouch:false };
  pc.gameData.bag  ||= { potion: 0, gpotion: 0 };

  // Session-only bonuses that shouldn't be saved as max_hp in profile
  let sessionHpBonus = pc.gameData.meta.blessedCharm ? 10 : 0;

  function makeEnemy(stage){
    const ac = 10 + Math.floor(stage / 2);
    const hp = 12 + stage * 6;
    const atkBonus = 2 + Math.floor(stage / 3);
    const dmgDie = "1d6";
    const dex = 10 + Math.min(6, stage);
    return { name: `Enemy ${stage}`, hp, ac, atkBonus, dmgDie, dex };
  }

  function updateUI(){
    ui.name.textContent = pc.name;
    ui.lvl.textContent  = pc.level;
    ui.ac.textContent   = effectiveAC();
    ui.hp.textContent   = pc.hp;
    ui.maxHp.textContent = pc.maxHp;
    ui.ehp.textContent  = enemy.hp;
    ui.exp.textContent  = pc.exp;
    ui.gold.textContent = pc.gold;
    
    // Shop readouts (main UI)
    document.getElementById("ui-gear-armor")?.replaceChildren(String(pc.gameData.gear.armor||0));
    document.getElementById("ui-gear-weapon")?.replaceChildren(String(pc.gameData.gear.weapon||0));
    document.getElementById("ui-gear-wand")?.replaceChildren(String(pc.gameData.gear.wand||0));
    document.getElementById("ui-potion-count")?.replaceChildren(`x${pc.gameData.bag.potion}`);
    document.getElementById("ui-gpotion-count-modal")?.replaceChildren(`x${pc.gameData.bag.gpotion}`);
    
    // Shop readouts (modal)
    document.getElementById("ui-gold-modal")?.replaceChildren(String(pc.gold));
    document.getElementById("ui-gear-armor-modal")?.replaceChildren(String(pc.gameData.gear.armor||0));
    document.getElementById("ui-gear-weapon-modal")?.replaceChildren(String(pc.gameData.gear.weapon||0));
    document.getElementById("ui-gear-wand-modal")?.replaceChildren(String(pc.gameData.gear.wand||0));
    document.getElementById("ui-potion-count-modal")?.replaceChildren(`x${pc.gameData.bag.potion}`);
    document.getElementById("ui-gpotion-count-modal")?.replaceChildren(`x${pc.gameData.bag.gpotion}`);
    
    // Update shop button states
    updateShopButtonStates();
  }

  function getBestMod(stat1, stat2, stat3 = null) {
    const mod1 = mod(stat1);
    const mod2 = mod(stat2);
    const mod3 = stat3 ? mod(stat3) : -Infinity;
    return Math.max(mod1, mod2, mod3);
  }

  function effectiveAC(){ return pc.ac + (pc.gameData.gear.armor || 0); }
  function weaponAtkBonus(){
    return 2 + getBestMod(pc.str, pc.dex) + (pc.gameData.gear.weapon || 0) + (pc.gameData.meta.battleTraining ? 1 : 0);
  }
  function weaponDmgBonus(){
    return getBestMod(pc.str, pc.dex) + (pc.gameData.gear.weapon || 0);
  }
  function spellAtkBonus(){
    return 2 + getBestMod(pc.int, pc.wis, pc.cha) + (pc.gameData.gear.wand || 0) + (pc.gameData.meta.arcaneStudy ? 1 : 0);
  }
  function spellDmgBonus(){
    return getBestMod(pc.int, pc.wis, pc.cha) + (pc.gameData.gear.wand || 0) + (pc.gameData.meta.arcaneStudy ? 1 : 0);
  }



  function log(msg){
    const p = document.createElement("div");
    p.textContent = msg;
    ui.log.appendChild(p);
    ui.log.scrollTop = ui.log.scrollHeight;
  }

  function startEncounter(){
    disableShopButton();
    const nextBtn = document.getElementById("btn-next");
    if (nextBtn) {
      nextBtn.classList.add("hidden");
      nextBtn.disabled = true;
    }
    
    const pcInit = roll() + mod(pc.dex);
    const enInit = roll() + mod(enemy.dex);
    turn = pcInit >= enInit ? "pc" : "enemy";
    log(`Initiative. You ${pcInit} vs ${enemy.name} ${enInit}. ${turn === "pc" ? "You go first." : enemy.name + " goes first."}`);
    updateUI();
    if (turn === "enemy") enemyTurn();
  }

  function startNextBattle(){
    stage += 1;
    enemy = makeEnemy(stage);
    log(`A new enemy appears: ${enemy.name}. AC ${enemy.ac}. HP ${enemy.hp}.`);
    startEncounter();
  }

  function toHit(attackBonus, targetAC){
    const d = roll();
    const isCrit = d === 20;
    const hit = isCrit || (d + attackBonus) >= targetAC;
    return { d, hit, isCrit };
  }

    function pcAttack(kind){
    if (enemy.hp <= 0 || pc.hp <= 0 || isShopModalOpen()) return;
    
    const isSpell = (kind === "spell");
    const atkBonus = isSpell ? spellAtkBonus() : weaponAtkBonus();
    const r = toHit(atkBonus, enemy.ac);
    if (!r.hit){
      log(`You roll ${r.d} and miss.`);
      return enemyTurn();
    }
    
    let dmg = isSpell
      ? rollExpr(pc.spellDie) + spellDmgBonus()
      : rollExpr(pc.wepDie)   + weaponDmgBonus();

    if (r.isCrit) dmg += kind === "spell" ? rollExpr(pc.spellDie) : rollExpr(pc.wepDie);
    dmg = Math.max(1, dmg);

    enemy.hp = Math.max(0, enemy.hp - dmg);
    log(`${r.isCrit ? "Critical. " : ""}You deal ${dmg}. Enemy HP ${enemy.hp}.`);
    updateUI();

    if (enemy.hp <= 0){
      const expGain = stage * 10;
      const baseGold = stage * 5;
      const goldGain = pc.gameData.meta.greedyPouch ? Math.floor(baseGold * 1.25) : baseGold;
      pc.exp += expGain;
      pc.gold += goldGain;
      enemiesDefeated += 1;
      const progress = `${enemiesDefeated}/${pc.level}`;
      log(`You defeated ${enemy.name}! +${expGain} XP, +${goldGain} Gold (${progress} to level up)`);
      
      // Check if this should trigger a level up
      const enemiesNeeded = pc.level;
      if (enemiesDefeated >= enemiesNeeded) {
        enemiesDefeated = 0;
        // Let the server handle the level up logic
        const token = document.querySelector('meta[name="csrf-token"]')?.content;
        fetch(`/characters/${pc.id}/update_game_profile`, {
          method: "PATCH",
          headers: { 
            "Content-Type": "application/json", 
            "X-CSRF-Token": token 
          },
          body: JSON.stringify({ 
            game_profile: { 
              level: pc.level, 
              exp: pc.exp, // Send current total XP
              hp_current: pc.hp,
              max_hp: pc.maxHp,
              gold: pc.gold,
              data: pc.gameData
            } 
          })
        })
        .then(response => response.json())
        .then(data => {
          if (data.success) {
            // Update local state with server response
            pc.level = data.game_profile.level;
            pc.exp = data.game_profile.exp;
            pc.hp = data.game_profile.hp_current;
            pc.maxHp = data.game_profile.max_hp;
            
            if (data.leveled_up) {
              log(`🎉 LEVEL UP! You are now level ${pc.level}! +8 HP`);
            }
            updateUI();
            saveGameProfile();
            stage += 1;
            promptContinue();
          } else {
            log(`⚠️ Failed to level up: ${data.errors?.join(', ')}`);
            saveGameProfile();
            stage += 1;
            promptContinue();
          }
        })
        .catch(error => {
          log(`⚠️ Error during level up: ${error.message}`);
          saveGameProfile();
          stage += 1;
          promptContinue();
        });
      } else {
        saveGameProfile();
        stage += 1;
        promptContinue();
      }
      return;
    }
    enemyTurn();
  }

  function heal(){
    if (pc.hp <= 0 || enemy.hp <= 0 || isShopModalOpen()) return;
    const h = 4 + roll(1, 8) + Math.max(0, getBestMod(pc.wis, pc.cha));
    pc.hp = Math.min(pc.hp + h, pc.maxHp + sessionHpBonus);
    log(`You heal ${h}. Your HP ${pc.hp}.`);
    updateUI();
    saveGameProfile();
    enemyTurn();
  }

  function enemyTurn(){
    if (pc.hp <= 0) return;
    setTimeout(() => {
      const r = toHit(enemy.atkBonus, effectiveAC());
      if (!r.hit){
        log(`${enemy.name} rolls ${r.d} and misses.`);
        return;
      }
      let dmg = rollExpr(enemy.dmgDie) + Math.floor(enemy.atkBonus / 2);
      if (r.isCrit) dmg += rollExpr(enemy.dmgDie);
      dmg = Math.max(1, dmg);
      pc.hp = Math.max(0, pc.hp - dmg);
      log(`${enemy.name} hits for ${dmg}. Your HP ${pc.hp}.`);
      updateUI();
      saveGameProfile();
      if (pc.hp <= 0) {
        log("You fall. Game over.");
        saveRun("lose", stage);
      }
    }, 300);
  }

  function promptContinue(){
    enableShopButton();
    const nextBtn = document.getElementById("btn-next");
    if (nextBtn) {
      nextBtn.classList.remove("hidden");
      nextBtn.disabled = false;
    }
    log("Victory! Shop is now available. Click 'Next Battle' when ready.");
  }

  function saveGameProfile() {
    const token = document.querySelector('meta[name="csrf-token"]')?.content;
    fetch(`/characters/${pc.id}/update_game_profile`, {
      method: "PATCH",
      headers: { 
        "Content-Type": "application/json", 
        "X-CSRF-Token": token 
      },
      body: JSON.stringify({ 
        game_profile: { 
          level: pc.level, 
          exp: pc.exp,
          hp_current: pc.hp,
          max_hp: pc.maxHp,
          gold: pc.gold,
          data: pc.gameData
        } 
      })
    })
    .then(response => response.json())
    .then(data => {
      if (!data.success) {
        log(`⚠️ Failed to save progress: ${data.errors?.join(', ')}`);
      }
    })
    .catch(error => {
      log(`⚠️ Error saving progress: ${error.message}`);
    });
  }

  function saveRun(result, finalStage) {
    const token = document.querySelector('meta[name="csrf-token"]')?.content;
    const score = pc.level * 100 + pc.exp + pc.gold;
    
    fetch(`/characters/${pc.id}/runs`, {
      method: "POST",
      headers: { 
        "Content-Type": "application/json", 
        "X-CSRF-Token": token 
      },
      body: JSON.stringify({ 
        run: { 
          stage: finalStage,
          result: result,
          score: score
        } 
      })
    })
    .then(response => {
      if (!response.ok) {
        throw new Error(`HTTP ${response.status}`);
      }
      return response.json();
    })
    .then(data => {
      if (data.success) {
        log(`🏆 Run saved! Final score: ${score}`);
      } else {
        log(`⚠️ Failed to save run: ${data.errors?.join(', ')}`);
      }
    })
    .catch(error => {
      log(`⚠️ Error saving run: ${error.message}`);
    });
  }

  function resetProgress() {
    if (!confirm("Are you sure you want to reset your game progress? This cannot be undone.")) {
      return;
    }
    
    const token = document.querySelector('meta[name="csrf-token"]')?.content;
    fetch(`/characters/${pc.id}/reset_game_profile`, {
      method: "POST",
      headers: { 
        "Content-Type": "application/json", 
        "X-CSRF-Token": token 
      }
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        log(`🔄 Progress reset! Starting fresh...`);
        // Reload the page to reset everything
        window.location.reload();
      } else {
        log(`⚠️ Failed to reset progress: ${data.errors?.join(', ')}`);
      }
    })
    .catch(error => {
      log(`⚠️ Error resetting progress: ${error.message}`);
    });
  }

  // Shop functions
  function canAfford(cost){ return pc.gold >= cost; }
  function spend(cost){
    pc.gold -= cost;
    if (pc.gold < 0) pc.gold = 0;
  }

  function saveProgress(extraLogMsg){
    updateUI();
    saveGameProfile();
    if (extraLogMsg) log(extraLogMsg);
  }

  function enableShopButton() {
    const shopBtn = document.getElementById("btn-shop");
    if (shopBtn) shopBtn.disabled = false;
  }

  function disableShopButton() {
    const shopBtn = document.getElementById("btn-shop");
    if (shopBtn) shopBtn.disabled = true;
  }

  function isShopModalOpen() {
    const modal = document.getElementById("shop-modal");
    return modal && !modal.classList.contains("hidden");
  }

  function updateShopButtonStates() {
    // Update gear buttons based on current tier
    const armorTier = pc.gameData.gear.armor || 0;
    const weaponTier = pc.gameData.gear.weapon || 0;
    const wandTier = pc.gameData.gear.wand || 0;
    
    // Armor buttons
    document.querySelectorAll('[data-buy="armor"]').forEach(btn => {
      const tier = parseInt(btn.dataset.tier);
      if (tier <= armorTier) {
        btn.disabled = true;
        btn.classList.remove('bg-blue-600', 'hover:bg-blue-700');
        btn.classList.add('bg-gray-400', 'cursor-not-allowed');
      } else {
        btn.disabled = false;
        btn.classList.remove('bg-gray-400', 'cursor-not-allowed');
        btn.classList.add('bg-blue-600', 'hover:bg-blue-700');
      }
    });
    
    // Weapon buttons
    document.querySelectorAll('[data-buy="weapon"]').forEach(btn => {
      const tier = parseInt(btn.dataset.tier);
      if (tier <= weaponTier) {
        btn.disabled = true;
        btn.classList.remove('bg-red-600', 'hover:bg-red-700');
        btn.classList.add('bg-gray-400', 'cursor-not-allowed');
      } else {
        btn.disabled = false;
        btn.classList.remove('bg-gray-400', 'cursor-not-allowed');
        btn.classList.add('bg-red-600', 'hover:bg-red-700');
      }
    });
    
    // Wand buttons
    document.querySelectorAll('[data-buy="wand"]').forEach(btn => {
      const tier = parseInt(btn.dataset.tier);
      if (tier <= wandTier) {
        btn.disabled = true;
        btn.classList.remove('bg-purple-600', 'hover:bg-purple-700');
        btn.classList.add('bg-gray-400', 'cursor-not-allowed');
      } else {
        btn.disabled = false;
        btn.classList.remove('bg-gray-400', 'cursor-not-allowed');
        btn.classList.add('bg-purple-600', 'hover:bg-purple-700');
      }
    });
    
    // Meta upgrade buttons
    document.querySelectorAll('[data-buy^="meta-"]').forEach(btn => {
      const metaType = btn.dataset.buy.replace('meta-', '');
      if (pc.gameData.meta[metaType]) {
        btn.disabled = true;
        btn.classList.remove('bg-yellow-600', 'hover:bg-yellow-700');
        btn.classList.add('bg-gray-400', 'cursor-not-allowed');
      } else {
        btn.disabled = false;
        btn.classList.remove('bg-gray-400', 'cursor-not-allowed');
        btn.classList.add('bg-yellow-600', 'hover:bg-yellow-700');
      }
    });
  }

  function openShop() {
    const modal = document.getElementById("shop-modal");
    if (modal) {
      modal.classList.remove("hidden");
      document.body.classList.add("overflow-hidden");
      modal.querySelector("button, [href], input, select, textarea")?.focus();
      updateShopButtonStates();
    }
  }

  function closeShop() {
    const modal = document.getElementById("shop-modal");
    if (modal) {
      modal.classList.add("hidden");
      document.body.classList.remove("overflow-hidden");
    }
  }

  // Core gear purchase (tiered, replaces previous)
  function buyGear(kind, tier){
    const current = pc.gameData.gear[kind] || 0;
    if (tier <= current) return log(`You already have ${kind} +${tier}.`);
    if (tier > 3) return;
    const cost = PRICES[kind][tier];
    if (!canAfford(cost)) return log(`Not enough gold for ${kind} +${tier}.`);

    spend(cost);
    pc.gameData.gear[kind] = tier;
    saveProgress(`Purchased ${kind} +${tier}.`);
    updateShopButtonStates();
  }

  // Consumables
  function buyConsumable(key){
    const cost = (key === "potion") ? PRICES.potion : PRICES.gpotion;
    if (!canAfford(cost)) return log(`Not enough gold for ${key}.`);
    spend(cost);
    pc.gameData.bag[key] += 1;
    saveProgress(`Bought ${key}.`);
  }

  function usePotion(){
    if (pc.gameData.bag.potion <= 0) return log("No potions.");
    pc.gameData.bag.potion -= 1;
    const healAmt = Math.ceil((pc.maxHp + sessionHpBonus) * 0.5);
    pc.hp = Math.min(pc.hp + healAmt, pc.maxHp + sessionHpBonus);
    saveProgress(`You use a potion and heal ${healAmt}.`);
  }

  function useGPotion(){
    if (pc.gameData.bag.gpotion <= 0) return log("No greater potions.");
    pc.gameData.bag.gpotion -= 1;
    const healAmt = (pc.maxHp + sessionHpBonus) - pc.hp;
    pc.hp = pc.maxHp + sessionHpBonus;
    saveProgress(`You use a greater potion and heal ${healAmt}.`);
  }

  // Meta (one-time)
  function buyMeta(key){
    if (pc.gameData.meta[key]) return log("Already purchased.");
    const cost = PRICES.meta[key];
    if (!canAfford(cost)) return log(`Not enough gold for ${key}.`);

    spend(cost);
    pc.gameData.meta[key] = true;
    if (key === "blessedCharm") sessionHpBonus = 10; // affect current run too
    saveProgress(`Unlocked ${key}.`);
    updateShopButtonStates();
  }

  document.getElementById("btn-attack")?.addEventListener("click", () => pcAttack("weapon"));
  document.getElementById("btn-spell") ?.addEventListener("click", () => pcAttack("spell"));
  document.getElementById("btn-heal")  ?.addEventListener("click", heal);
  document.getElementById("btn-reset") ?.addEventListener("click", resetProgress);
  document.getElementById("btn-next")?.addEventListener("click", startNextBattle);
  document.getElementById("btn-shop")?.addEventListener("click", openShop);

  // Shop button event listeners
  function setupShopEventListeners() {
    // Core tiers
    document.querySelectorAll(".shop-btn[data-buy='armor']").forEach(b => b.addEventListener("click", e => buyGear("armor", Number(e.currentTarget.dataset.tier))));
    document.querySelectorAll(".shop-btn[data-buy='weapon']").forEach(b => b.addEventListener("click", e => buyGear("weapon", Number(e.currentTarget.dataset.tier))));
    document.querySelectorAll(".shop-btn[data-buy='wand']").forEach(b => b.addEventListener("click", e => buyGear("wand", Number(e.currentTarget.dataset.tier))));

    // Consumables
    document.querySelector(".shop-btn[data-buy='potion']")?.addEventListener("click", ()=>buyConsumable("potion"));
    document.querySelector(".shop-btn[data-buy='gpotion']")?.addEventListener("click", ()=>buyConsumable("gpotion"));
    document.getElementById("use-potion-modal")?.addEventListener("click", usePotion);
    document.getElementById("use-gpotion-modal")?.addEventListener("click", useGPotion);

    // Meta
    document.querySelector(".shop-btn[data-buy='meta-battleTraining']")?.addEventListener("click", ()=>buyMeta("battleTraining"));
    document.querySelector(".shop-btn[data-buy='meta-arcaneStudy']")?.addEventListener("click", ()=>buyMeta("arcaneStudy"));
    document.querySelector(".shop-btn[data-buy='meta-blessedCharm']")?.addEventListener("click", ()=>buyMeta("blessedCharm"));
    document.querySelector(".shop-btn[data-buy='meta-greedyPouch']")?.addEventListener("click", ()=>buyMeta("greedyPouch"));
  }

  // Set up shop event listeners immediately
  setupShopEventListeners();

  // Set up modal close handlers
  document.getElementById("shop-close")?.addEventListener("click", closeShop);
  document.getElementById("shop-backdrop")?.addEventListener("click", closeShop);
  
  // ESC key to close modal
  document.addEventListener("keydown", (e) => {
    if (e.key === "Escape" && isShopModalOpen()) {
      closeShop();
    }
  });

  // Apply Blessed Charm effect at start
  if (sessionHpBonus > 0) {
    pc.hp = Math.min(pc.hp + sessionHpBonus, pc.maxHp + sessionHpBonus);
  }

  // Start with shop available (no enemy yet)
  enableShopButton();
  startEncounter();
}

