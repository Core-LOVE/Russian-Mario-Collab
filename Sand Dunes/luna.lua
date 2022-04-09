local rng = RNG
local rooms = require("rooms");
local roomstable = table.map{6}
local darkness = require("darkness")

local DarknessField = darkness.create 
	{
	section = 0,
 	ambient = Color.fromHexRGB(0x444444),
	shadows = darkness.shadow.HARD_RAYMARCH
	}
	
local sandstorm = Particles.Emitter(0,0, "p_sandstorm.ini")
sandstorm:AttachToCamera(camera)

function onDraw()
	if not (roomstable[rooms.currentRoomIndex]) then
		sandstorm:Draw(2)
	else
		sandstorm:KillParticles()
	end
end

local pipeAPI = require("tweaks/pipecannon")

-- You can set exit speeds for every warp
pipeAPI.exitspeed = {0,20,0,0}
-- Will ignore speeds set for doors/instant warps
-- Sound effect for firing
pipeAPI.SFX = 22 -- default value (bullet bill sfx), set to 0 for silent
-- Visual effect for firing
pipeAPI.effect = 10 -- set to 0 for none

function onTick()
	for j,w in NPC.iterate(245,player.section) do
		if w.ai2 == 2 and w.ai1 == 49 then
            w.ai3 = 0
			sdeterm = rng.randomInt(1,2)
			if sdeterm == 1 then
			side = 1
			else side = -1
			end
			w.ai1 = 51
			playSFX(18)
            fier = NPC.spawn(202,w.x+0.5*w.width,w.y,player.section,false,true)
			fier.speedX = rng.randomInt(0,6) * 0.3 * side + 0.2 * side
			fier.speedY = rng.randomInt(-75,-55) * 0.15
        end
		if w.ai2 == 2 and w.ai1 > 50 then
            w.ai3 = w.ai3 + 1
			if w.ai3 == 20 then
			w.ai3 = w.ai3 + 1
			playSFX(18)
			fier = NPC.spawn(202,w.x+0.5*w.width,w.y,player.section,false,true)
			fier.speedX = rng.randomInt(0,6) * -0.3 * side + 0.2 * side
			fier.speedY = rng.randomInt(-75,-55) * 0.15
			end
			if w.ai3 == 40 then
			w.ai3 = w.ai3 + 1
			playSFX(18)
			fier = NPC.spawn(202,w.x+0.5*w.width,w.y,player.section,false,true)
			fier.speedX = rng.randomInt(0,6) * 0.3 * side + 0.2 * side
			fier.speedY = rng.randomInt(-75,-55) * 0.15
			end
        end
    end
	
	if roomstable[rooms.currentRoomIndex] then
        DarknessField.section = 0
		if not player.hasStarman then
			Audio.MusicVolume(15)
		else
			Audio.MusicPause() 
		end
		triggerEvent("bonus")
    else
		DarknessField.section = 1
		if not player.hasStarman then
			Audio.MusicVolume(40)
		else
			Audio.MusicPause() 
		end
    end
	if player.x >= -193248 and player.x <= -192864 then
		triggerEvent("king bill 1 hide")
	end
	if player.x >= -185184 and player.x <= -184800 then
		triggerEvent("king bill 2 hide")
	end
	if ((player.x >= -175776) or (player.x >= -176192 and player.y <= -200832)) and player.x <= -175392 then
		triggerEvent("king bill 3 hide")
	end
	if player.x >= -171968 and player.x <= -171584 then
		triggerEvent("king bill 4 hide")
	end
	if (player.x >= -178944 and player.x <= -160640 and player.y >= -200032) or (player.x >= -200000 and player.x <= -179104 and player.y >= -199936 and (not roomstable[rooms.currentRoomIndex])) then
		if player:mem(0x140,FIELD_WORD) == 0 --[[changing powerup state]] and player.deathTimer == 0 --[[already dead]] then
			player:kill()
		end
	end
end

function onCameraUpdate()
	if player.x <= -187664 and (roomstable[rooms.currentRoomIndex]) then
		triggerEvent("sc2")
	elseif player.x <= -179488 and not (player.x >= -187664 and player.y >= -199776) then
		triggerEvent("defpos")
	elseif (player.x >= -179424 and player.x <= -178624) or (player.x >= -187664 and player.y >= -199776) then
		triggerEvent("defpos15")
	elseif player.x >= -178624 and not (player.x <= -178176 and player.y <= -200768) and not (player.x >= -174528 and player.x <= -173728 and player.y <= -200736) then
		triggerEvent("defpos2")
	elseif (player.x <= -178176 and player.y <= -200768) or (player.x >= -174528 and player.x <= -173728 and player.y <= -200736) then
		triggerEvent("sc3pos")
	end
end