if select(3,UnitClass("player")) == 2 then

	function Blessings()
		if UnitBuffID("player",144051) ~= nil then return false end
		local BlessingCount = 0
		for i = 1, #nNova do
			local _, MemberClass = select(2,UnitClass(nNova[i].unit))
			if UnitExists(nNova[i].unit) then
				if MemberClass ~= nil then
					if MemberClass == "DRUID" then BlessingCount = BlessingCount + 1 end
					if MemberClass == "MONK" then BlessingCount = BlessingCount + 1 end
					if MemberClass == "PALADIN" then BlessingCount = BlessingCount + 50 end
					if MemberClass == "SHAMAN" then BlessingCount = BlessingCount + 1000 end
				end
			end
		end
		if BlessingCount > 50 and BlessingCount < 1000 then
			MyBlessing = _BlessingOfMight
		else
			MyBlessing = _BlessingOfKings
		end
		if ActiveBlessingsValue == 2 then
			MyBlessing = _BlessingOfKings
		elseif ActiveBlessingsValue == 3 then
			MyBlessing = _BlessingOfMight
		end
		if MyBlessing == _BlessingOfMight and not Spells[_BlessingOfMight].known then MyBlessing = _BlessingOfKings end
		if MyBlessing == _BlessingOfKings and not Spells[_BlessingOfKings].known then BuffTimer = GetTime() + 600 return false end
		if BuffTimer == nil or BuffTimer < GetTime() then
			for i=1, #nNova do
				if not UnitBuffID(nNova[i].unit,MyBlessing) then
					BuffTimer = GetTime() + random(15,30);
					if castSpell("player",MyBlessing,true,false) then return; end
				end
			end
		end
	end

    function PaladinProtFunctions()

		function ProtPaladinControl(unit)
			--If no unit then we should check autotargetting
			-- If the unit is a player controlled then assume pvp and always CC
			-- Otherwise check towards config, always or whitelist.
			-- we have the following CCs HammerOFJustice, Fist of Justice, Repentance, Blinding Light, Turn Evil, Holy Wrath
			-- We should be able to configure, always stun, stun based on whitelist, stun if low health, stun if target is casting/buffed
			if isChecked("Crowd Control") then
				if getValue("Crowd Control") == 1 then -- This is set to never but we should use the box tick for this so atm this is whitelist
					--Todo: Create whitelist of mobs we are going to stun always
					--Todo: Create whitelist of (de)buffs we are going to stun always or scenarios(more then x number of attackers
				elseif getValue("Crowd Control") == 2 then -- This is set to to CD

				elseif getValue("Crowd Control") == 3 then -- This is set to Always

				end
			end
			if unit then

			end
			-- put auto logic here
			return false
		end

		function ProtPaladinUtility()
			if castHandOfSacrifice() then
				return true
			end
			if castHandOfSalvation() then
				return true
			end
			-- Todo Blinding Light, Turn Evil, HoP, HoF etc, revive
		end

		-- Functionality regarding interrupting target(s) spellcasting
		-- Rebuke is used if available and implemented as of now. This could be enhanced to use other spells for interrup
		-- returns of the cast is succesful or not.
		-- ToDos:  Add multiple interrupts such as binding light(if within 10 yards and facing, Fist of Justice(stuns), Avengers shield
		-- Should perhaps move out the spellCD and ranged outside canInterrupt?? So first check if range and cd is ok for cast, then check for timeframe?d
		function ProtPaladinInterrupt()
			if BadBoy_data["Interrupts"] ~= 1 then
				--See what spell we want to use
				if castRebuke("target") then  -- We should handle who to interrupt outside the castRebuke etc, hardocded to target atm
					return true
				end
			end
			-- Should add Avengers Shield
			-- Should add Fist of Justice
			-- Should add Blinding Light with facing logic.
			return false
		end

		function ProtPaladinSurvivalSelf() -- Check if we are close to dying and act accoridingly
			local playerHP = getHP("player")

			-- Logic goes from lowest HP, ie the most critical prioritised spells
			-- Lay on Hands, we get full health back and is the last resort due to the other spells have damage reduction
			-- However do not cast if Ardent Defender is available or we have the AD buff removing killing blow and heals us to 15%.
			-- Todo, add if the box is checked or not
			-- Todo: Reset values dependent on using defensive CDs, ie dont pop all at once if getting very low.
			-- Todo: Reset values dependent on if single, dungeon(with or without healer), raid, pvp.

			if castLayOnHands("player") then
				return true
			end
			-- Should check that we dont use other defensiv first (UnitBuffID("player", _ArdentDefender) or canCast(_ArdentDefender)) then

			-- Todo, how should we handle the other defensive CDs, we should lower health threshold if GoaK is up for example
			--if BadBoy_data["Check Ardent Defender"] == 1 and canCast(_ArdentDefender) and playerHP <= getValue("Ardent Defender") and not (UnitBuffID("player", _GuardianOfAncientKings) or canCast(_GuardianOfAncientKings))then
			--	if castSpell("player",_ArdentDefender,true) then
			--		return;
			--	end
			--end
			-- Divine Protection
			---if BadBoy_data["Check Divine Protection"] == 1 and getHP("player") <= BadBoy_data["Box Divine Protection"] then -- Should we check if damage is physical?
			--	if castSpell("player",_DivineProtection,true) then
			--		return;
			--	end
			--end

			-- Guardian of the Ancient Kings
			--if BadBoy_data["Check GotAK Prot"] == 1 and getHP("player") <= BadBoy_data["Box GotAK Prot"] then
			--	if castSpell("player",_GuardianOfAncientKings,true) then
			--		return;
			--	end
			--end
			-- Todos: Add more defensive actions. Pot, trinket, Spells(WoG, Sacred Shield, Hand Of Protection, Hand of Salvation, Flash Of Light if Instant....
		end

		-- ProtPaladinSurvivalOther() -- Check if raidmember are close to dying and act accoridingly
		function ProtPaladinSurvivalOther()
			-- Lay on Hands
			-- It should be possible to set this so we only cast it on non tanks, or tanks or all.
			if castLayOnHands() then
				return true
			end
		end

		function ProtPaladinBuffs() -- Make sure that we are buffed, 2 modes, inCombat and Out Of Combat, Blessings, RF, -- ProtPaladinBuffs()
			-- Righteous Fury
			if castRighteousFury() then
				return true
			end
			-- Blessings Logic here, incombat mode, self check or party/raid check
			-- Seal Logic here, wait for emp seal logic to settle.
			-- Food checks, flask, etc

			return false
		end

		function  ProtPaladinDispell() -- Handling the dispelling self and party
			-- Defensive and offensive dispelling, ie debuffs or buffs
			--canDispel(Unit,spellID)
			return false -- Return false until we have coded it
		end
		-- ProtPaladinCooldowns() -- Handles the use of offensive Coolsdowns, ProtPaladinSurvival... handles the defensive.

		-- Todo: Create logic for when to use it, proccs or whatever
		-- 	Also toggle/configuration for more flexibility, at the moment its on or off

		function ProtPaladinEnemyUnitHandler() -- Handles Enemy Units gathering
			-- At the moment only populating table to see performance.
			makeEnemiesTable(40)-- Unit in 40 range
			--print("Table has " ..#enemiesTable)

			return 
		end	

		function ProtPaladinFriendlyUnitHandler() -- Handles Enemy Units gathering
			-- At the moment only populating table to see performance.
			
			--print("Table has " ..#nNova)

			return 
		end	

		function ProtPaladinHolyPowerConsumers() -- Handle the use of HolyPower

			if UnitBuffID("player", _DivinePurposeBuff) then
			-- we can cast ShieldOfRightoues or Word Of Glory regardless of HoPo
			-- ToDo: What is the logic here? What scenarios can we see? At the moment we have in castWord and castRight we check hopo or divine
			end
			-- We should have 2 different levels here, on regarding bastion and one without, WoG should not be cast all the time but rather to help healers up a bit
			-- So we need to see how much resolve and bastion helps a WoG and have that as minimum. Tha aim is to cast Shield often and WoG only to help.
			if castWordOfGlory("player", 0, 3) then
				return true
			end

			if castShieldOfTheRighteous("target", 5) then
				return true
			end
			--Todo, we could check other targets to use HP on but this should be controlled by config.
		end

		function ProtPaladinHolyPowerCreaters() -- Handle the normal rotation
			-- Todos: Talents, only light hammer is handled, Prism and Sentence is not
			-- Todos: Glyphs, we have no support for the Holy Wrath glyph which should put it higher on priority after Judgement.

			local strike = strike; -- We use either Crusader Strike or Hammer of Right dependent on how many unfriendly
			if BadBoy_data["AoE"] == 2 or (BadBoy_data["AoE"] == 3 and numberOfTargetsMelee > 2) or keyPressAoE then  --If Toggle to 2(AoE) or 3(Auto and more then 2 targets, its actually 4 but its just simplier to do aoe
				strike = _HammerOfTheRighteous;
			else
				strike = _CrusaderStrike;
			end

			-- Cast Crusader for Single and Hammer of Right if aoe
			if isInMelee() then
				if castSpell("target",strike,false,false) then
					return
				end
			end

			if castJudgement("target") then
				--print("Casting Judgement")
				return true
			end

			if castAvengersShield("target") then
				--print("Casting lights Hammer in rotation")
				return true
			end
			-- Todo We could add functionality that cycle all unit to find one that is casting since the Avenger Shield is silencing as well.

			if castLightsHammer("target") then
				--print("Casting lights Hammer in rotation")
				return true
			end

			if castHammerOfWrath("target") then
				--print("Casting Hammer of Wrath")
				return true
			end

			-- Todo: Could use enhanced logic here, cluster of mobs, cluster of damaged friendlies etc
			if castHolyWrath("target") then
				--print("Casting Holy Wrath")
				return true
			end
			-- Todo, we could check number of mobs in melee ranged

			if castConsecration() then
				--print("Casting Consecration")
				return true
			end

			-- If we are waiting for CDs we can cast SS
			if castSacredShield(5) then
					return true
			end
			--Todo Check number of targets in range do Concentration and have it earlier.
		end

		function ProtPaladingHolyPowerCreatersAoE() -- Rotation that focus on AoE, should be done to pick up group of adds
			-- Todos: Talents, only light hammer is handled, Prism and Sentence is not

			local strike = strike; -- We use either Crusader Strike or Hammer of Right dependent on how many unfriendly
			if BadBoy_data["AoE"] == 2 or (BadBoy_data["AoE"] == 3 and numberOfTargetsMelee > 2) or keyPressAoE then  --If Toggle to 2(AoE) or 3(Auto and more then 2 targets, its actually 4 but its just simplier to do aoe
				strike = _HammerOfTheRighteous;
			else
				strike = _CrusaderStrike;
			end

			-- Cast Crusader for Single and Hammer of Right if aoe
			if isInMelee() then
				if castSpell("target",strike,false,false) then
					return
				end
			end

			if castAvengersShield("target") then
				--print("Casting lights Hammer in AoE rotation")
				return true
			end
			-- Todo We could add functionality that cycle all unit to find one that is casting since the Avenger Shield is silencing as well.

			if castLightsHammer("target") then
				--print("Casting lights Hammer in AoE rotation")
				return true
			end

			if castHolyWrath("target") then
				--print("Casting AoE Holy Wrath")
				return true
			end
			-- Todo, we could check number of mobs in melee ranged

			if castConsecration("target") then
				--print("Casting AOE Consecration")
				return true
			end
		--Todo Check number of targets in range do Concentration and have it earlier.
		end
	end
--[[

Holy

]]	function PaladinHolyFunctions()

		-- Eternal Flame
		function EternalFlame(hpValue)
			if _HolyPower > 3 then
				for i = 1, #nNova do
					if (nNova[i].hp < hpValue and getBuffRemain(nNova[i].unit,_EternalFlame) < 5) or (nNova[i].hp < 100 and _HolyPower == 5 and getBuffRemain(nNova[i].unit,_EternalFlame) < 5) or nNova[i].hp < hpValue - 20 then
						if castSpell(nNova[i].unit, _EternalFlame, true, false) then return end
					end
				end
			end
		end
		-- Holy Light
		function HolyLight(hpValue)
			for i = 1, #nNova do
				if nNova[i].hp < hpValue then
					if castSpell(nNova[i].unit, _HolyLight, true, true) then return end
				end
			end
		end

		-- Flash Of Light
		function FlashOfLight(hpValue)
			for i = 1, #nNova do
				if nNova[i].hp < hpValue then
					if castSpell(nNova[i].unit, _FlashOfLight, true, true) then return end
				end
			end
		end

		-- Holy Shock
		function HolyShock(hpValue)
			if _HolyPower < 5 or lowestHP < 90 then
				for i = 1, #nNova do
					if nNova[i].hp < hpValue then
						if castSpell(nNova[i].unit, _HolyShock, true, false) then return end
					end
				end
			end
		end

		-- Word Of Glory
		function WordOfGlory(hpValue)
			if _HolyPower > 3 then
				for i = 1, #nNova do
					if nNova[i].hp < hpValue or (nNova[i].hp < 100 and _HolyPower == 5) then
						if castSpell(nNova[i].unit, _WordOfGlory, true, false) then return end
					end
				end
			end
		end

		-- Beacon Of Light
		function BeaconOfLight()
			beaconTarget, beaconRole, beaconHP = "player", "HEALER", getHP("player")
			-- Find if we have any, note if its a tank.
			for i = 1, #nNova do
				if UnitBuffID(nNova[i].unit,_BeaconOfLight,"player") then
					beaconTarget, beaconRole, beaconHP = nNova[i].unit, nNova[i].role, nNova[i].hp
				end
			end
			-- if we are not beacon on a tank and on tanks is checked we find a proper tank if focus dont exists.
			if beaconRole ~= "TANK" then
				if UnitExists("focus") == true and UnitInRaid("focus") == true and UnitIsVisible("focus") then
					if castSpell("folcus",_BeaconOfLight,true,false) then return end
				else
					for i = 1, #nNova do
						if nNova[i].role == "TANK" then
							if castSpell(nNova[i].unit,_BeaconOfLight,true,false) then return end
						end
					end
				end
			end
		end
	end
end