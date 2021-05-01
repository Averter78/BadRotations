---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 15483.
--- DateTime: 4/22/2021 11:41 PM
---
local LibDraw = LibStub("LibDraw-BR")

local function createToggles()
    local DamagingModes = {
        [1] = { mode = "On", value = 1, overlay = "DAMAGE ON", tip = "Using DAMAGE", highlight = 1, icon = br.player.spell.tigerPalm },
        [2] = { mode = "Off", value = 2, overlay = "DAMAGE OFF", tip = "Not using DAMAGE", highlight = 0, icon = br.player.spell.tigerPalm }
    }
    br.ui:createToggle(DamagingModes, "Damaging", 1, 0)
    local HealingModes = {
        [1] = { mode = "On", value = 1, overlay = "HEAL ON", tip = "Using HEAL", highlight = 1, icon = br.player.spell.vivify },
        [2] = { mode = "Off", value = 2, overlay = "HEAL OFF", tip = "Not using HEAL", highlight = 0, icon = br.player.spell.vivify }
    };
    br.ui:createToggle(HealingModes, "Healing", 2, 0)
    local TeleportingModes = {
        [1] = { mode = "On", value = 1, overlay = "TELEPORT ON", tip = "Using TELEPORT", highlight = 1, icon = br.player.spell.transcendenceTransfer },
        [2] = { mode = "Off", value = 2, overlay = "TELEPORT OFF", tip = "Not using TELEPORT", highlight = 0, icon = br.player.spell.transcendenceTransfer }
    };
    br.ui:createToggle(TeleportingModes, "Teleporting", 3, 0)
end

local colors = {
    blue = "|cff4285F4",
    red = "|cffDB4437",
    yellow = "|cffF4B400",
    green = "|cff0F9D58",
    white = "|cffFFFFFF",
    purple = "|cff9B30FF",
    aqua = "|cff89E2C7",
    blue2 = "|cffb8d0ff",
    green2 = "|cff469a81",
    blue3 = "|cff6c84ef",
    orange = "|cffff8000"
}

local text = {
    keys = {
        damage = "DAMAGE Key",
        heal = "HEAL Key",
        teleport = "TELEPORT Key",
    },
    autoCDS = {
        text = "Auto CDS",
        fortifyingBrew = "Fortifying Brew",

    },
    draw = {
        text = "Draw settings",
        update = "Update rate"
    },
    extra = {
        text = "Extra settings"
    }
}

local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        section = br.ui:createSection(br.ui.window.profile, "Key Options")
        br.ui:createDropdown(section, text.keys.damage, br.dropOptions.Toggle, 6, "Keep pressing this key to use this rotation", "Select key")
        br.ui:createDropdown(section, text.keys.heal, br.dropOptions.Toggle, 6, "Keep pressing this key to use this rotation", "Select key")
        br.ui:createDropdown(section, text.keys.teleport, br.dropOptions.Toggle, 6, "Keep pressing this key to use this rotation", "Select key")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, text.autoCDS.text)
        --parent, text, number, min, max, step, tooltip, tooltipSpin, hideCheckbox
        br.ui:createSpinner(section, text.autoCDS.fortifyingBrew, 30, 0, 100, 1, "Hp <= to X to use it")

        --br.ui:createSpinnerWithout(section, text.input.gustOfMist, 0, 0, 50, 1, "How much healing your Gust of Mist does?")
        --br.ui:createSpinnerWithout(section, text.input.vivify, 0, 0, 50, 1, "How much healing your Vivify does?")
        --br.ui:createSpinnerWithout(section, text.input.envelopingMist, 0, 0, 50, 1, "How much healing your Enveloping Mist does?")
        --br.ui:createSpinnerWithout(section, text.input.expelHarm, 0, 0, 50, 1, "How much healing your Expel Harm does?")
        --br.ui:createSpinnerWithout(section, text.input.lifeCocoon, 0, 0, 50, 1, "How much absorb your Life Cocoon Harm does?")
        --br.ui:createSpinnerWithout(section, text.input.revival, 0, 0, 50, 1, "How much healing your Revival does?")
        --br.ui:createSpinnerWithout(section, text.input.soothingMist, 0, 0, 50, 1, "How much healing your Soothing Mist does?")
        --br.ui:createSpinnerWithout(section, text.input.essenceFont, 0, 0, 50, 1, "How much healing your Essence Font does?")
        --br.ui:createSpinnerWithout(section, text.input.tigerPalm, 0, 0, 50, 1, "How much damage your Tiger Palm does?")
        --br.ui:createSpinnerWithout(section, text.input.blackoutKick, 0, 0, 50, 1, "How much damage your Blackout Kick does?")
        --br.ui:createSpinnerWithout(section, text.input.risingSunKick, 0, 0, 50, 1, "How much damage your Rising Sun Kick does?")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, text.extra.text)
        br.player.module.BasicHealing(section)
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, text.draw.text)
        br.ui:createSpinner(section, text.draw.update, 0, 0, 1, 0.01, "Set update rate")
        br.ui:checkSectionState(section)

    end
    optionTable = { {
                        [1] = "Rotation Options",
                        [2] = rotationOptions,
                    } }
    return optionTable
end

local transcendence

local function runRotation()
    local buff = br.player.buff
    local cast = br.player.cast
    local cd = br.player.cd
    local charges = br.player.charges
    local debuff = br.player.debuff
    local runeforge = br.player.runeforge
    local enemies = br.player.enemies
    enemies.get(5)
    enemies.get(6)
    enemies.get(8)
    local mysticTouch = {
        lowest = debuff.mysticTouch.lowest(5, "remain"),
        count = debuff.mysticTouch.refreshCount(5),
        --range40 = br.player.units.get(40)
    }
    if not br.GetObjectExists(mysticTouch.lowest) then
        mysticTouch.lowest = enemies.yards5[1]
    end
    --local enemies = {
    --    range5 = br.player.enemies.get(5, "player", false, true),
    --    range6 = br.player.enemies.get(6, "player", false, true),
    --    range8 = br.player.enemies.get(8, "player", false, true),
    --    --range40 = br.player.enemies.get(40)
    --}

    local friends = {
        all = br.friend,
        lowest = br.friend[1]
    }
    --local friends.lowAllies = {
    --    essenceFont = br.getLowAlliesInTable(br.player.ui.value(text.heal.essenceFont .. "2"), friends.range30),
    --    essenceFontOoc = br.getLowAlliesInTable(br.player.ui.value(text.heal.outOfCombat.essenceFont .. "2"), friends.range30),
    --    revival = br.getLowAlliesInTable(br.player.ui.value(text.heal.revival .. "2"), friends.range40),
    --    refreshingJadeWind = br.getLowAlliesInTable(br.player.ui.value(text.heal.refreshingJadeWind .. "2"), friends.range10),
    --    invokeYulonTheJadeSerpent = br.getLowAlliesInTable(br.player.ui.value(text.heal.invokeYulonTheJadeSerpent .. "2"), friends.range40),
    --    invokeChiJiTheRedCrane = br.getLowAlliesInTable(br.player.ui.value(text.heal.invokeChiJiTheRedCrane .. "2"), friends.range40),
    --    weaponsOfOrder = br.getLowAlliesInTable(br.player.ui.value(text.heal.weaponsOfOrder .. "2"), friends.range40)
    --}
    local gcd = br.player.gcd
    local player = {
        hp = br.player.health,
        unit = "player",
        mana = br.player.power.mana.percent(),
        race = br.player.unit.race(),
        isFlying = IsFlying(),
        isMounted = IsMounted(),
        isMoving = br.isMoving("player"),
        isDrinking = br.getBuffRemain("player", 308433) > 0 or br.getBuffRemain("player", 167152) > 0,
        inCombat = br.player.inCombat,
        maxHealth = br._G.UnitHealthMax("player"),
    }
    local spell = br.player.spell
    local talent = br.player.talent
    --local tanks = br.getTanksTable()
    local totemInfo = {
        jadeSerpentStatueDuration = 0,
        yulonDuration = 0,
        chiJiDuration = 0
    }
    local ui = br.player.ui
    local unit = br.player.unit
    local has = br.player.has
    --local hasMouse = br.GetObjectExists("mouseover")
    --
    --local healingValues = {
    --    gustOfMist = ui.value(text.input.gustOfMist) * 1000,
    --    vivify = ui.value(text.input.vivify) * 1000,
    --    vivifyRenewingMistAmount = 104 * (ui.value(text.input.vivify) * 1000) / 141,
    --    envelopingMist = ui.value(text.input.envelopingMist) * 1000,
    --    expelHarm = ui.value(text.input.expelHarm) * 1000,
    --    lifeCocoon = ui.value(text.input.lifeCocoon) * 1000,
    --    revival = ui.value(text.input.revival) * 1000,
    --    soothingMist = ui.value(text.input.soothingMist) * 1000,
    --    essenceFont = ui.value(text.input.essenceFont) * 1000,
    --    tigerPalm = (ui.value(text.input.tigerPalm) * 1000) * 2.5,
    --    blackoutKick = (ui.value(text.input.blackoutKick) * 1000) * 2.5,
    --    risingSunKick = (ui.value(text.input.risingSunKick) * 1000) * 2.5,
    --}

    local mastery = select(1, GetMasteryEffect("player"))
    local spellPower = GetSpellBonusDamage(4)
    local versatility = 1 + ((GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE)) / 100)

    local healingMultiplier = 1
    if buff.envelopingMist.remains(friends.lowest.unit) > 2 then
        healingMultiplier = healingMultiplier + 0.3
        if talent.mistWrap then
            healingMultiplier = healingMultiplier + 0.1
        end
    end
    if buff.lifeCocoon.remains(friends.lowest.unit) > 2 then
        healingMultiplier = healingMultiplier + 0.5
    end
    local soothingMistUnit
    for i = 1, #friends.all do
        local tempUnit = friends.all[i]
        if buff.soothingMist.exists(tempUnit.unit) then
            soothingMistUnit = tempUnit.unit
            break
        end
    end

    local healingValues = {
        gustOfMist = ((0.1 / 100) + (mastery / 100)) * spellPower * versatility * 1.09 * healingMultiplier,
        vivify = (141 / 100) * spellPower * versatility * 1.09 * healingMultiplier,
        vivifyRenewingMistAmount = (104 / 100) * spellPower * versatility * 1.09 * healingMultiplier,
        envelopingMist = (60 / 100) * spellPower * versatility * 1.09 * healingMultiplier,
        expelHarm = (120 / 100) * spellPower * versatility * 1.09 * healingMultiplier,
        lifeCocoon = (60 / 100) * player.maxHealth * versatility * 1.08843,
        revival = (315 / 100) * spellPower * versatility * 1.09 * healingMultiplier,
        soothingMist = (55 / 100) * spellPower * versatility * 1.09 * healingMultiplier,
        essenceFont = (47.2 / 100) * spellPower * versatility * 1.09 * healingMultiplier,
        tigerPalm = (27.027 / 100) * spellPower * versatility * 0.81 * (250 / 100),
        blackoutKick = (84.7 / 100) * spellPower * versatility * 0.77 * (250 / 100),
        risingSunKick = (143.8 / 100) * spellPower * versatility * 1.12 * (250 / 100)
    }
    --for key, value in pairs(healingValues) do
    --    print('\t', key, value)
    --end
    local getMissingHP = function(unit)
        return br._G.UnitGetTotalAbsorbs(unit) + br._G.UnitHealthMax(unit) + br._G.UnitGetIncomingHeals(unit) - br._G.UnitHealth(unit)
    end
    local function countMissingHPAllies(Value, unitTable)
        local lowAllies = 0
        for i = 1, #unitTable do
            if getMissingHP(unitTable[i].unit) >= Value then
                lowAllies = lowAllies + 1
            end
        end
        return lowAllies
    end
    local hasMouse = br.GetObjectExists("mouseover")
    if hasMouse then
        br.memberSetup:new("mouseover")
    end

    transcendence = {
        x = 0,
        y = 0,
        z = 0
    }
    local jadeSerpentStatue = {
        x = 0,
        y = 0,
        z = 0
    }

    if buff.transcendence.exists() or talent.summonJadeSerpentStatue then
        for i = 1, br._G.GetObjectCount() do
            local thisUnit = br._G.GetObjectWithIndex(i)
            local ID = br._G.ObjectID(thisUnit)
            if ID == 54569 then
                transcendence.x, transcendence.y, transcendence.z = br.GetObjectPosition(thisUnit)
            end
            if ID == 60849 then
                jadeSerpentStatue.x, jadeSerpentStatue.y, jadeSerpentStatue.z = br.GetObjectPosition(thisUnit)
            end
            if jadeSerpentStatue.x > 0 and transcendence.x > 0 then
                break
            end
        end
    end

    for index = 1, 4 do
        local exists, totemName, startTime, duration, _ = GetTotemInfo(index)
        if exists and totemName ~= nil then
            local estimateDuration = br.round2(startTime + duration - GetTime())
            if string.find(totemName, "Jade") then
                totemInfo.jadeSerpentStatueDuration = estimateDuration
            elseif string.find(totemName, "Yu'lon") then
                totemInfo.yulonDuration = estimateDuration
            elseif string.find(totemName, "Chi") then
                totemInfo.chiJiDuration = estimateDuration
            end
        end
    end

    local function AlwaysRotation()

        -- CDS
        if cd.lifeCocoon.ready() and getMissingHP(friends.lowest.unit) >= healingValues.lifeCocoon then
            return cast.lifeCocoon(friends.lowest.unit)
        end
        local revivalLimit = 1
        if #friends.all == 5 then
            revivalLimit = 3
        elseif #friends.all > 5 then
            revivalLimit = 8
        end
        if cd.revival.ready() and countMissingHPAllies(healingValues.revival, friends.all) >= revivalLimit then
            return cast.revival()
        end
        -- Self Healing
        if br.timer:useTimer("healingElixir", 0.5) then
            if (charges.healingElixir.count() > 1 and player.hp <= 75 and soothingMistUnit == nil) or (charges.healingElixir.count() > 0 and player.hp <= 45 and soothingMistUnit == nil) then
                return cast.healingElixir(player.unit)
            end
        end
        if gcd <= 0.1 then
            if cd.expelHarm.ready() and getMissingHP(player.unit) >= healingValues.expelHarm + healingValues.gustOfMist and soothingMistUnit == nil then
                return cast.expelHarm(player.unit)
            end
            -- Fortifying Brew
            if ui.checked(text.autoCDS.fortifyingBrew) and player.hp <= ui.value(text.autoCDS.fortifyingBrew) and cd.fortifyingBrew.ready() then
                return cast.fortifyingBrew(player.unit)
            end
            -- Diffuse Magic
            -- Dampen Harm
            -- Touch Of Death
            local function ToD(enemy)
                local function doIT(enemy)
                    br._G.SpellStopCasting()
                    br._G.StartAttack(enemy)
                    if cast.touchOfDeath(enemy) then
                        return true
                    end
                end
                if unit.distance(enemy) <= 5 and unit.facing(player.unit, enemy) then
                    if br._G.UnitIsPlayer(enemy) then
                        if unit.hp(enemy) <= 15 then
                            return doIT(enemy)
                        end
                    elseif unit.isBoss(enemy) then
                        if unit.health(player.unit) > unit.health(enemy) then
                            return doIT(enemy)
                        end
                    elseif unit.health(player.unit) > unit.health(enemy) then
                        return doIT(enemy)
                    end
                end
            end

            if cd.touchOfDeath.ready() then
                for i = 1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    if ToD(thisUnit) then
                        return true
                    end
                end
            end
            -- Detox
            if cd.detox.ready() then
                for i = 1, #friends.all do
                    local dispelUnit = friends.all[i]
                    if br.getLineOfSight(dispelUnit.unit) and br.getDistance(dispelUnit.unit) <= 40 then
                        if br.canDispel(dispelUnit.unit, spell.detox) and friends.lowest.hp >= 60 then
                            return cast.detox(dispelUnit.unit)
                        end
                    end
                end
            end
            -- Renewing Mist
            if charges.renewingMist.exists() and cd.renewingMist.ready() and soothingMistUnit == nil then
                for i = 1, #friends.all do
                    local tempUnit = friends.all[i]
                    if not buff.renewingMist.exists(tempUnit.unit) then
                        return cast.renewingMist(tempUnit.unit)
                    end
                end
            end
            -- Refreshing Jade Wind
            -- Jade Statue Soothing Mist
            if cast.timeSinceLast.soothingMist() > 7 and talent.summonJadeSerpentStatue and totemInfo.jadeSerpentStatueDuration > 0 then
                br._G.C_Timer.After(0.8, function()
                    br._G.SpellStopCasting()
                end)
                return cast.soothingMist(friends.lowest.unit)
            end
            if talent.summonJadeSerpentStatue and cd.summonJadeSerpentStatue.ready() and friends.lowest.hp >= 75 then
                local px, py, pz = br._G.ObjectPosition("player")
                if jadeSerpentStatue.x and jadeSerpentStatue.y and jadeSerpentStatue.z then
                    local distance = br._G.GetDistanceBetweenPositions(px, py, pz, jadeSerpentStatue.x, jadeSerpentStatue.y, jadeSerpentStatue.z)
                    if distance > 38 or totemInfo.jadeSerpentStatueDuration <= 5 then
                        px = px + math.random(-2, 2)
                        py = py + math.random(-2, 2)
                        if br.castGroundAtLocation({ x = px, y = py, z = pz }, spell.summonJadeSerpentStatue) then
                            return true
                        end
                    end
                else
                    px = px + math.random(-2, 2)
                    py = py + math.random(-2, 2)
                    if br.castGroundAtLocation({ x = px, y = py, z = pz }, spell.summonJadeSerpentStatue) then
                        return true
                    end
                end
            end
            -- Tigers Lust
        end
        -- Extra stuff
        if br.player.module.BasicHealing() then
            return true
        end
        return false
    end

    local DamageRotation = {
        ChiJiRotation = function()
            if cd.envelopingMist.ready() then
                if buff.invokeChiJiTheRedCrane.stack() == 3 or (totemInfo.chiJiDuration == 0 and buff.invokeChiJiTheRedCrane.stack() > 0 and not player.isMoving) then
                    local theUnit
                    for i = 1, #friends.all do
                        local tempUnit = friends.all[i]
                        if buff.envelopingMist.remains(tempUnit.unit) < 2 and theUnit == nil then
                            theUnit = tempUnit
                        end
                    end
                    if theUnit == nil then
                        theUnit = friends.lowest.unit
                    end
                    return cast.envelopingMist(theUnit.unit)
                end
            end
            -- essence font legendary?
            if cd.risingSunKick.ready() then
                if cd.thunderFocusTea.ready() then
                    cast.thunderFocusTea(player.unit)
                end
                return cast.risingSunKick(mysticTouch.lowest)
            end

            if cd.blackoutKick.ready() then
                if (buff.invokeChiJiTheRedCrane.stack() == 0 and buff.teachingsOfTheMonastery.stack() == 3) or
                        (buff.invokeChiJiTheRedCrane.stack() == 0 and buff.teachingsOfTheMonastery.stack() == 2) or
                        (buff.invokeChiJiTheRedCrane.stack() == 1 and buff.teachingsOfTheMonastery.stack() == 1) then
                    return cast.blackoutKick(mysticTouch.lowest)
                end
            end

            if cd.spinningCraneKick.ready() and not cast.active.spinningCraneKick() and #enemies.yards5 - mysticTouch.count >= 3 then
                return cast.spinningCraneKick(player.unit)
            end
            if cd.tigerPalm.ready() and buff.teachingsOfTheMonastery.stack() < 3 then
                return cast.tigerPalm(mysticTouch.lowest)
            end
            if buff.invokeChiJiTheRedCrane.stack() < 3 then
                return cast.spinningCraneKick(player.unit)
            end

            return false
        end,
        AncientTeachingsOfTheMonasteryRotation = function()
            if (not buff.ancientTeachingOfTheMonastery.exists() or buff.ancientTeachingOfTheMonastery.remains() <= 3) and cd.essenceFont.ready() then
                return cast.essenceFont(player.unit)
            end
            if cd.risingSunKick.ready() and getMissingHP(friends.lowest.unit) >= healingValues.risingSunKick then
                if cd.thunderFocusTea.ready() then
                    cast.thunderFocusTea(player.unit)
                end
                return cast.risingSunKick(mysticTouch.lowest)
            end
            if cd.blackoutKick.ready() then
                if (buff.teachingsOfTheMonastery.stack() == 3 and getMissingHP(friends.lowest.unit) >= healingValues.blackoutKick * 4) or
                        (buff.teachingsOfTheMonastery.stack() == 2 and getMissingHP(friends.lowest.unit) >= healingValues.blackoutKick * 3) or
                        (buff.teachingsOfTheMonastery.stack() == 1 and getMissingHP(friends.lowest.unit) >= healingValues.blackoutKick * 2 and not talent.spiritOfTheCrane) or
                        (buff.teachingsOfTheMonastery.stack() == 0 and getMissingHP(friends.lowest.unit) >= healingValues.blackoutKick * 1 and not talent.spiritOfTheCrane) then
                    return cast.blackoutKick(mysticTouch.lowest)
                end
            end
            if cd.spinningCraneKick.ready() and not cast.active.spinningCraneKick() and #enemies.yards5 - mysticTouch.count >= 3 then
                return cast.spinningCraneKick(player.unit)
            end
            if cd.tigerPalm.ready() then
                return cast.tigerPalm(mysticTouch.lowest)
            end
            return false
        end,
        NormalRotation = function()
            if cd.risingSunKick.ready() then
                if cd.thunderFocusTea.ready() then
                    cast.thunderFocusTea(player.unit)
                end
                return cast.risingSunKick(mysticTouch.lowest)
            end

            if #enemies.yards8 >= 3 then
                if cd.spinningCraneKick.ready() and not cast.active.spinningCraneKick() then
                    return cast.spinningCraneKick(player.unit)
                end
            end

            if #enemies.yards5 < 3 and #enemies.yards5 > 1 then
                if cd.blackoutKick.ready() then
                    if (not talent.spiritOfTheCrane and buff.teachingsOfTheMonastery.stack() > 0) or (talent.spiritOfTheCrane and buff.teachingsOfTheMonastery.stack() == 3) then
                        return cast.blackoutKick(mysticTouch.lowest)
                    end
                end
                if cd.spinningCraneKick.ready() and not cast.active.spinningCraneKick() then
                    return cast.spinningCraneKick(player.unit)
                end
            end

            if #enemies.yards5 == 1 then
                if cd.blackoutKick.ready() then
                    if buff.teachingsOfTheMonastery.stack() == 3 then
                        return cast.blackoutKick(mysticTouch.lowest)
                    end
                end
                if cd.tigerPalm.ready() then
                    return cast.tigerPalm(mysticTouch.lowest)
                end
            end
            return false
        end
    }

    local function TeleportRotation()
        if not buff.transcendence.exists() then
            return cast.transcendence()
        end
        local usable, _ = IsUsableSpell(spell.transcendenceTransfer)
        if usable and cd.transcendenceTransfer.ready() then
            cast.transcendenceTransfer(player.unit)
            br._G.C_Timer.After(2, function()
                cast.transcendence()
            end)
            return true
        end
        return false
    end

    local function HealRotation()
        if not cast.active.vivify() then
            local countUnitsWithRenewingMistUnderHealth = 0
            for i = 1, #friends.all do
                local tempUnit = friends.all[i]
                if buff.renewingMist.exists(tempUnit.unit) and getMissingHP(tempUnit.unit) >= healingValues.vivifyRenewingMistAmount then
                    countUnitsWithRenewingMistUnderHealth = countUnitsWithRenewingMistUnderHealth + 1
                end
            end
            if not buff.renewingMist.exists(friends.lowest.unit) then
                countUnitsWithRenewingMistUnderHealth = countUnitsWithRenewingMistUnderHealth + 1
            end
            if countUnitsWithRenewingMistUnderHealth >= 2 then
                if getMissingHP(friends.lowest.unit) >= (healingValues.vivify + healingValues.gustOfMist) + healingValues.soothingMist then
                    if soothingMistUnit == nil then
                        --print("Casting Soothing Mist AOE")
                        soothingMistUnit = friends.lowest.unit
                        return cast.soothingMist(soothingMistUnit)
                    end
                end
                if buff.envelopingMist.remains(soothingMistUnit) < 2 then
                    if getMissingHP(soothingMistUnit) >= healingValues.envelopingMist + healingValues.gustOfMist + healingValues.soothingMist + healingValues.vivify + healingValues.gustOfMist then
                        --print("Enveloping Mist AOE Soothing Mist")
                        return cast.envelopingMist(soothingMistUnit)
                    end
                end
                if soothingMistUnit ~= nil and getMissingHP(soothingMistUnit) >= (healingValues.vivify + healingValues.gustOfMist) + healingValues.soothingMist then
                    --print("Vivify AOE Soothing Mist")
                    return cast.vivify(soothingMistUnit)
                end
            end
        end
        --

        if not cast.active.vivify() and soothingMistUnit == nil and getMissingHP(friends.lowest.unit) >= healingValues.soothingMist + healingValues.envelopingMist + healingValues.gustOfMist + healingValues.soothingMist + healingValues.vivify + healingValues.gustOfMist then
            --print("Casting Soothing Mist ST")
            soothingMistUnit = friends.lowest.unit
            return cast.soothingMist(soothingMistUnit)
        end
        if soothingMistUnit ~= nil then
            if buff.envelopingMist.remains(soothingMistUnit) < 2 then
                if getMissingHP(soothingMistUnit) >= healingValues.envelopingMist + healingValues.gustOfMist + healingValues.soothingMist + healingValues.vivify + healingValues.gustOfMist then
                    --print("Enveloping Mist ST Soothing Mist")
                    return cast.envelopingMist(soothingMistUnit)
                end
            elseif buff.envelopingMist.remains(soothingMistUnit) > 1 then
                if getMissingHP(soothingMistUnit) >= healingValues.soothingMist + healingValues.vivify + healingValues.gustOfMist then
                    --print("Vivify ST Soothing Mist")
                    return cast.vivify(soothingMistUnit)
                end
            end
        end
        --
        if soothingMistUnit == nil and not cast.active.vivify() and getMissingHP(friends.lowest.unit) >= healingValues.vivify + healingValues.gustOfMist then
            --print("Vivify ST")
            return cast.vivify(friends.lowest.unit)
        end
        return false
    end

    local function localToggle(toggleValue, newValue)
        newValue = tonumber(newValue)
        br.data.settings[br.selectedSpec].toggles[tostring(toggleValue)] = newValue
        --br.changeButton(toggleValue, index)
        if newValue == 0 then
            newValue = 1
        end
        local Icon
        -- define text
        br["text" .. toggleValue]:SetText(br[toggleValue .. "Modes"][newValue].mode)
        -- define icon
        if type(br[toggleValue .. "Modes"][newValue].icon) == "number" then
            Icon = select(3, _G.GetSpellInfo(br[toggleValue .. "Modes"][newValue].icon))
        else
            Icon = br[toggleValue .. "Modes"][newValue].icon
        end
        br["button" .. toggleValue]:SetNormalTexture(Icon or br.emptyIcon)
        -- define highlight
        if br[toggleValue .. "Modes"][newValue].highlight == 0 then
            br["frame" .. toggleValue].texture:SetTexture(br.genericIconOff)
        else
            br["frame" .. toggleValue].texture:SetTexture(br.genericIconOn)
        end
        ---- We tell the user we changed mode
        --br.ChatOverlay("\124cFF3BB0FF" .. br[toggleValue .. "Modes"][newValue].overlay)
        ---- We reset the tip
        --br.ResetTip(toggleValue, newValue)
    end

    if ui.toggle(text.keys.damage) then
        --br._G.RunMacroText("/br toggle Damaging 1")
        localToggle("Damaging", "1")
        if AlwaysRotation() then
            return true
        elseif totemInfo.chiJiDuration > 0 or buff.invokeChiJiTheRedCrane.stack() > 0 then
            if DamageRotation.ChiJiRotation() then
                return true
            end
            return false
        elseif runeforge.ancientTeachingsOfTheMonastery.equiped then
            if cast.active.essenceFont() then
                if #friends.all > 5 then
                    return true
                elseif gcd <= 0.1 then
                    br._G.SpellStopCasting()
                end
            end
            if DamageRotation.AncientTeachingsOfTheMonasteryRotation() then
                return true
            end
            return false
        else
            if DamageRotation.NormalRotation() then
                return true
            end
            return false
        end
        return true
    else
        --br._G.RunMacroText("/br toggle Damaging 2")
        localToggle("Damaging", "2")
    end

    if ui.toggle(text.keys.heal) then
        localToggle("Healing", "1")
        --br._G.RunMacroText("/br toggle Healing 1")
        return AlwaysRotation() or HealRotation()
    else
        localToggle("Healing", "2")
        --br._G.RunMacroText("/br toggle Healing 2")
    end

    if ui.toggle(text.keys.teleport) then
        localToggle("Teleporting", "1")
        --br._G.RunMacroText("/br toggle Teleporting 1")
        return TeleportRotation()
    else
        localToggle("Teleporting", "2")
        --br._G.RunMacroText("/br toggle Teleporting 2")
    end

    if ui.checked("Auto Summon Steward") and not unit.inCombat() and not has.phialOfSerenity() and cast.able.summonSteward() then
        return cast.summonSteward()
    end

end

br._G.CreateFrame("Frame"):SetScript(
        "OnUpdate",
        function()
            if br.player then
                if br.player.ui.checked(text.draw.update) and br.timer:useTimer("Draw", br.player.ui.value(text.draw.update)) then
                    LibDraw.clearCanvas()
                    if br.UnitBuffID("player", 101643, "player") ~= nil then
                        local pX, pY, pZ = br._G.ObjectPosition("player")
                        if transcendence and transcendence.x and transcendence.y and transcendence.z then
                            local distance = br._G.GetDistanceBetweenPositions(pX, pY, pZ, transcendence.x, transcendence.y, transcendence.z)
                            if distance >= 38 then
                                LibDraw.SetColor(255, 0, 0, 100)
                            else
                                LibDraw.SetColor(0, 255, 0, 100)
                            end
                            LibDraw.Line(pX, pY, pZ, transcendence.x, transcendence.y, transcendence.z)
                        end
                    end

                    if br.GetObjectExists("target") then
                        local X1, Y1, Z1 = br._G.ObjectPosition("target")
                        if X1 and Y1 and Z1 then
                            LibDraw.SetColor(235, 64, 52, 100)
                            LibDraw.Arc(X1, Y1, Z1, 5, 160, br._G.ObjectFacing("target") + math.pi)
                        end
                    end
                end
            end
        end
)

local id = 270

if br.rotations[id] == nil then
    br.rotations[id] = {}
end

local rotationName = "LyLo Mistweaver"
tinsert(
        br.rotations[id],
        {
            name = rotationName,
            toggles = createToggles,
            options = createOptions,
            run = runRotation
        }
)