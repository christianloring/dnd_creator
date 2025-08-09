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
    ui.ac.textContent   = pc.ac;
    ui.hp.textContent   = pc.hp;
    ui.maxHp.textContent = pc.maxHp;
    ui.ehp.textContent  = enemy.hp;
    ui.exp.textContent  = pc.exp;
    ui.gold.textContent = pc.gold;
  }

  function getBestMod(stat1, stat2, stat3 = null) {
    const mod1 = mod(stat1);
    const mod2 = mod(stat2);
    const mod3 = stat3 ? mod(stat3) : -Infinity;
    return Math.max(mod1, mod2, mod3);
  }



  function log(msg){
    const p = document.createElement("div");
    p.textContent = msg;
    ui.log.appendChild(p);
    ui.log.scrollTop = ui.log.scrollHeight;
  }

  function startEncounter(){
    const pcInit = roll() + mod(pc.dex);
    const enInit = roll() + mod(enemy.dex);
    turn = pcInit >= enInit ? "pc" : "enemy";
    log(`Initiative. You ${pcInit} vs ${enemy.name} ${enInit}. ${turn === "pc" ? "You go first." : enemy.name + " goes first."}`);
    updateUI();
    if (turn === "enemy") enemyTurn();
  }

  function toHit(attackBonus, targetAC){
    const d = roll();
    const isCrit = d === 20;
    const hit = isCrit || (d + attackBonus) >= targetAC;
    return { d, hit, isCrit };
  }

  function pcAttack(kind){
    if (enemy.hp <= 0 || pc.hp <= 0) return;
    
    // Use best modifier for attack bonus
    const attackBonus = 2 + getBestMod(pc.str, pc.dex);
    const r = toHit(attackBonus, enemy.ac);
    if (!r.hit){
      log(`You roll ${r.d} and miss.`);
      return enemyTurn();
    }
    
    // Use best modifier for damage
    let dmg = kind === "spell"
      ? rollExpr(pc.spellDie) + getBestMod(pc.int, pc.wis, pc.cha)
      : rollExpr(pc.wepDie)   + getBestMod(pc.str, pc.dex);

    if (r.isCrit) dmg += kind === "spell" ? rollExpr(pc.spellDie) : rollExpr(pc.wepDie);
    dmg = Math.max(1, dmg);

    enemy.hp = Math.max(0, enemy.hp - dmg);
    log(`${r.isCrit ? "Critical. " : ""}You deal ${dmg}. Enemy HP ${enemy.hp}.`);
    updateUI();

    if (enemy.hp <= 0){
      const expGain = stage * 10;
      const goldGain = stage * 5;
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
    if (pc.hp <= 0 || enemy.hp <= 0) return;
    const h = 4 + roll(1, 8) + Math.max(0, getBestMod(pc.wis, pc.cha));
    pc.hp = Math.min(pc.hp + h, pc.maxHp);
    log(`You heal ${h}. Your HP ${pc.hp}.`);
    updateUI();
    saveGameProfile();
    enemyTurn();
  }

  function enemyTurn(){
    if (pc.hp <= 0) return;
    setTimeout(() => {
      const r = toHit(enemy.atkBonus, pc.ac);
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
    setTimeout(() => {
      enemy = makeEnemy(stage);
      log(`A new enemy appears: ${enemy.name}. AC ${enemy.ac}. HP ${enemy.hp}.`);
      startEncounter();
    }, 600);
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

  document.getElementById("btn-attack")?.addEventListener("click", () => pcAttack("weapon"));
  document.getElementById("btn-spell") ?.addEventListener("click", () => pcAttack("spell"));
  document.getElementById("btn-heal")  ?.addEventListener("click", heal);
  document.getElementById("btn-reset") ?.addEventListener("click", resetProgress);

  startEncounter();
}

