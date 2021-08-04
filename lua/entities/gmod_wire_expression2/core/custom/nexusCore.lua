/* 
 _______   ___________    ____  _______  __        ______   .______    _______  _______     
|       \ |   ____\   \  /   / |   ____||  |      /  __  \  |   _  \  |   ____||       \    
|  .--.  ||  |__   \   \/   /  |  |__   |  |     |  |  |  | |  |_)  | |  |__   |  .--.  |   
|  |  |  ||   __|   \      /   |   __|  |  |     |  |  |  | |   ___/  |   __|  |  |  |  |   
|  '--'  ||  |____   \    /    |  |____ |  `----.|  `--'  | |  |      |  |____ |  '--'  |   
|_______/ |_______|   \__/     |_______||_______| \______/  | _|      |_______||_______/    
                                                                                            
                              .______   ____    ____                                        
                              |   _  \  \   \  /   /                                        
                              |  |_)  |  \   \/   /                                         
                              |   _  <    \_    _/                                          
                              |  |_)  |     |  |                                            
                              |______/      |__|                                            
                                                                                            
.__   __.  __________   ___  __    __       _______.    ____ .______   .______       ____   
|  \ |  | |   ____\  \ /  / |  |  |  |     /       |   |    ||   _  \  |   _  \     |    |  
|   \|  | |  |__   \  V  /  |  |  |  |    |   (----`   |  |-`|  |_)  | |  |_)  |    `-|  |  
|  . `  | |   __|   >   <   |  |  |  |     \   \       |  |  |   _  <  |      /       |  |  
|  |\   | |  |____ /  .  \  |  `--'  | .----)   |      |  |  |  |_)  | |  |\  \----.  |  |  
|__| \__| |_______/__/ \__\  \______/  |_______/       |  |-.|______/  | _| `._____|.-|  |  
                                                       |____|                       

@license: Attribution-NonCommercial 4.0 International - <https://creativecommons.org/licenses/by-nc/4.0/legalcode>
@user Steam Profile: http://steamcommunity.com/profiles/76561197983103320	

Created: 05-11-2012
Updated: 30-07-2016	08:03 PM	   
*/

if SERVER then
	--Loading Messages
	Msg( "/====================================\\\n")
	Msg( "||     Nexus Core (E2 Functions)    ||\n" )
	Msg( "||----------------------------------||\n" )
	
	-- Register
	E2Lib.RegisterExtension("nexuscore", true)
	
	local AntiSpamTimeout = 2
	local FallDamageList = {}
	
	function GetFallDamage( ply, flFallSpeed )
		if( FallDamageList[ply:UniqueID()] == "ENABLE" || not FallDamageList[ply:UniqueID()] ) then -- realistic fall damage is on
			if( GetConVarNumber( "mp_falldamage" ) > 0 ) then -- realistic fall damage is on
				return flFallSpeed * 0.225; -- near the Source SDK value
			end
			
			return 10
		elseif ( FallDamageList[ply:UniqueID()] == "DISABLE") then
			return 0
		end	
	end

	hook.Add("GetFallDamage", "Get Fall Damage", GetFallDamage)
		
	--Setup Loading Log Formatation
	function loadingLog (text)
		--Set Max Size
		local size = 32
		--If Text Len < max size
		if(string.len(text) < size) then
			-- Format the text to be Text+Spaces*LeftSize
			text = text .. string.rep( " ", size-string.len(text) )
		else
			--If Text is too much big then cut and add ...
			text = string.Left( text, size-3 ) .. "..."
		end
		--Log Messsage
		Msg( "||  "..text.."||\n" )
	end
	
	local function Animate( Ent, Animation )
		--If Entity is Valid and Animation are not Empty
		if (Ent:IsValid() and Animation != "") then
			--If Entity is not animated
			if !Ent.Animated then
				-- This must be run once on entities that will be animated
				Ent.Animated = true
				Ent.AutomaticFrameAdvance = true
				--Think on Entity
				local OldThink = Ent.Think
				function Ent:Think()
					OldThink(self)
					self:NextThink( CurTime() )
					return true
				end
			end
			
			--If Animation is String
			if type(Animation) == "string" then
				--If Animation are not Empty
				if(string.Trim(Animation) == "") then
					Animation = 0
				else
					--Find Animation Number
					Animation = Ent:LookupSequence(string.Trim(Animation)) or 0
				end
			end
			
			--Floor
			Animation = math.floor(Animation)
			
			--Reset Sequence
			Ent:ResetSequence(Animation)
			--Set Cycle of Zero
			Ent:SetCycle(0)
			--Set PlayBack Rate at One
			Ent:SetPlaybackRate(1)
		end
	end
	
	--Log Loading Message
	Msg( "|| Loading...                       ||\n" )


	/*
	.___________. _______  __       _______ .______     ______   .______     .___________.
	|           ||   ____||  |     |   ____||   _  \   /  __  \  |   _  \    |           |
	`---|  |----`|  |__   |  |     |  |__   |  |_)  | |  |  |  | |  |_)  |   `---|  |----`
		|  |     |   __|  |  |     |   __|  |   ___/  |  |  |  | |      /        |  |     
		|  |     |  |____ |  `----.|  |____ |  |      |  `--'  | |  |\  \----.   |  |     
		|__|     |_______||_______||_______|| _|       \______/  | _| `._____|   |__|     
	 */


	--Log Loading Message
	loadingLog("Entity:teleport(Vector)")

	--SetUp E2 Function Cost
	__e2setcost(50)

	--Setup E2 Function
	e2function void entity:teleport(vector pos)
		local isAdmin = false
		local antiSpam = false
		local propProtection = false
		local ReUseList = {}
		local Ent = this
		
		--If entity is not Valid
		if this and this:IsValid() then 
			--If Game is Single Player then Return True
			if game.SinglePlayer() then isAdmin = true end
			--If is Admin quit with true
			if self.player:IsAdmin() then isAdmin = true end
			
			if !isAdmin then
				--Set Player In ReUseList
				if not ReUseList[self.player:UniqueID()] then
					ReUseList[self.player:UniqueID()] = -1
				end
				
				--Check if user are not spaming with the e2
				if ReUseList[self.player:UniqueID()] == -1 then
					antiSpam = true
				elseif CurTime() > ReUseList[self.player:UniqueID()] then 
					antiSpam = true
				end
				
				--If Pass
				if antiSpam then
					--Set ReUseList Timeout
					ReUseList[self.player:UniqueID()] = CurTime() + AntiSpamTimeout
					-- If This is a Player
					if !this:IsPlayer() then
						Ent = this.player
					end
					-- Check if is Allowed
					propProtection = ( this == self.player || E2Lib.isOwner(self, this) || E2Lib.isFriend( Ent, self.player) )
				end	
			end
		end	
		
		-- If Player is Admin or passed on AntiSpam and Prop Protection
		if ( isAdmin || ( antiSpam && propProtection ) ) then
			--If is Player
			if this:IsPlayer() then
				--If Player is In Vehicle
				if this:InVehicle() then
					--Force Player get out from Vehicle
					this:ExitVehicle()
				end 
			end
			--Teleport entity to Position
			this:SetPos(Vector(pos[1], pos[2], pos[3]))	
		end		
	end

	/*
	.______    __           ___   ____    ____  _______ .______          __    __  .__   __.  __    ______      __    __   _______     __   _______  
	|   _  \  |  |         /   \  \   \  /   / |   ____||   _  \        |  |  |  | |  \ |  | |  |  /  __  \    |  |  |  | |   ____|   |  | |       \ 
	|  |_)  | |  |        /  ^  \  \   \/   /  |  |__   |  |_)  |       |  |  |  | |   \|  | |  | |  |  |  |   |  |  |  | |  |__      |  | |  .--.  |
	|   ___/  |  |       /  /_\  \  \_    _/   |   __|  |      /        |  |  |  | |  . `  | |  | |  |  |  |   |  |  |  | |   __|     |  | |  |  |  |
	|  |      |  `----. /  _____  \   |  |     |  |____ |  |\  \----.   |  `--'  | |  |\   | |  | |  `--'  '--.|  `--'  | |  |____    |  | |  '--'  |
	| _|      |_______|/__/     \__\  |__|     |_______|| _| `._____|    \______/  |__| \__| |__|  \_____\_____\\______/  |_______|   |__| |_______/ 
																																			  
	*/

	--Log Loading Message
	loadingLog("Entity:playerUniqueId()")

	--SetUp E2 Function Cost
	__e2setcost(5)

	--Setup E2 Function
	e2function number entity:playerUniqueId()
		--If entity is not Valid
		if !this:IsValid() then return 0 end 
		--If entity is Not a Player
		if !this:IsPlayer() then return 0 end
		--Return Player UniqueID
		return this:UniqueID()
	end

	/*
		 ___      .______   .______    __      ____    ____    .______    __           ___   ____    ____  _______ .______          _______   ______   .______        ______  _______ 
		/   \     |   _  \  |   _  \  |  |     \   \  /   /    |   _  \  |  |         /   \  \   \  /   / |   ____||   _  \        |   ____| /  __  \  |   _  \      /      ||   ____|
	   /  ^  \    |  |_)  | |  |_)  | |  |      \   \/   /     |  |_)  | |  |        /  ^  \  \   \/   /  |  |__   |  |_)  |       |  |__   |  |  |  | |  |_)  |    |  ,----'|  |__   
	  /  /_\  \   |   ___/  |   ___/  |  |       \_    _/      |   ___/  |  |       /  /_\  \  \_    _/   |   __|  |      /        |   __|  |  |  |  | |      /     |  |     |   __|  
	 /  _____  \  |  |      |  |      |  `----.    |  |        |  |      |  `----. /  _____  \   |  |     |  |____ |  |\  \----.   |  |     |  `--'  | |  |\  \----.|  `----.|  |____ 
	/__/     \__\ | _|      | _|      |_______|    |__|        | _|      |_______|/__/     \__\  |__|     |_______|| _| `._____|   |__|      \______/  | _| `._____| \______||_______|
	*/

	--Log Loading Message
	loadingLog("Entity:applyPlayerForce(Vector)")

	--SetUp E2 Function Cost
	__e2setcost(20)
	e2function void entity:applyPlayerForce(vector pos)
		local isAdmin = false
		local propProtection = false
		local Ent = this
		
		--If entity is not Valid
		if this:IsValid() && this:IsPlayer() then
			--If Game is Single Player then Return True
			if game.SinglePlayer() then isAdmin = true end
			--If is Admin quit with true
			if self.player:IsAdmin() then isAdmin = true end
			
			if !isAdmin then
				-- If This is a Player
				if !this:IsPlayer() then
					Ent = this.player
				end
				-- Check if is Allowed
				propProtection = ( this == self.player || E2Lib.isOwner(self, this) || E2Lib.isFriend( Ent, self.player) )
			end
		end	
		
		-- If Player is Admin or passed on AntiSpam and Prop Protection
		if ( isAdmin || propProtection ) then
			--If is Player
			if this:IsPlayer() then
				--If Player is In Vehicle
				if this:InVehicle() then
					--Force Player get out from Vehicle
					this:ExitVehicle()
				end 
			end
			--Apply Velocity to entity
			this:SetVelocity(Vector(pos[1],pos[2],pos[3]))
		end			
	end

	/*
	 __    __       ___           _______.   .__   __.   ______        ______   ______    __       __       __   _______   _______         ___       __       __      
	|  |  |  |     /   \         /       |   |  \ |  |  /  __  \      /      | /  __  \  |  |     |  |     |  | |       \ |   ____|       /   \     |  |     |  |     
	|  |__|  |    /  ^  \       |   (----`   |   \|  | |  |  |  |    |  ,----'|  |  |  | |  |     |  |     |  | |  .--.  ||  |__         /  ^  \    |  |     |  |     
	|   __   |   /  /_\  \       \   \       |  . `  | |  |  |  |    |  |     |  |  |  | |  |     |  |     |  | |  |  |  ||   __|       /  /_\  \   |  |     |  |     
	|  |  |  |  /  _____  \  .----)   |      |  |\   | |  `--'  |    |  `----.|  `--'  | |  `----.|  `----.|  | |  '--'  ||  |____     /  _____  \  |  `----.|  `----.
	|__|  |__| /__/     \__\ |_______/       |__| \__|  \______/      \______| \______/  |_______||_______||__| |_______/ |_______|   /__/     \__\ |_______||_______|
	*/

	--Log Loading Message
	loadingLog("Entity:hasNoCollideAll()")

	--SetUp E2 Function Cost
	__e2setcost(1)

	--Setup E2 Function
	e2function number entity:hasNoCollideAll()
		--If entity is not Valid
		if !this:IsValid() then return false end 
		
		--Return if entity has No CollideAll
		return util.tobool(this:GetCollisionGroup() == COLLISION_GROUP_WORLD)
	end

	/*
		 _______. _______ .___________.   .__   __.   ______        ______   ______    __       __       __   _______   _______         ___       __       __      
		/       ||   ____||           |   |  \ |  |  /  __  \      /      | /  __  \  |  |     |  |     |  | |       \ |   ____|       /   \     |  |     |  |     
	   |   (----`|  |__   `---|  |----`   |   \|  | |  |  |  |    |  ,----'|  |  |  | |  |     |  |     |  | |  .--.  ||  |__         /  ^  \    |  |     |  |     
		\   \    |   __|      |  |        |  . `  | |  |  |  |    |  |     |  |  |  | |  |     |  |     |  | |  |  |  ||   __|       /  /_\  \   |  |     |  |     
	.----)   |   |  |____     |  |        |  |\   | |  `--'  |    |  `----.|  `--'  | |  `----.|  `----.|  | |  '--'  ||  |____     /  _____  \  |  `----.|  `----.
	|_______/    |_______|    |__|        |__| \__|  \______/      \______| \______/  |_______||_______||__| |_______/ |_______|   /__/     \__\ |_______||_______|
	*/

	--Log Loading Message
	loadingLog("Entity:setCollideAll()")

	--SetUp E2 Function Cost
	__e2setcost(50)

	--Setup E2 Function
	e2function void entity:setNoCollideAll()
		local isAdmin = false
		local propProtection = false
		local Ent = this
		
		--If entity is not Valid
		if this:IsValid() && !this:IsPlayer() then
			--If Game is Single Player then Return True
			if game.SinglePlayer() then isAdmin = true end
			--If is Admin quit with true
			if self.player:IsAdmin() then isAdmin = true end
			
			if !isAdmin then				
				-- If This is a Player
				if !this:IsPlayer() then
					Ent = this.player
				end
				-- Check if is Allowed
				propProtection = ( this == self.player || E2Lib.isOwner(self, this) || E2Lib.isFriend( Ent, self.player) )
			end
		end	
		
		-- If Player is Admin or passed on Prop Protection
		if ( isAdmin || propProtection ) then
			--Apply Velocity to entity
			this:SetCollisionGroup(COLLISION_GROUP_WORLD)
		end		
	end

	/*
	.______       _______ .___  ___.   ______   ____    ____  _______    .__   __.   ______        ______   ______    __       __       __   _______   _______         ___       __       __      
	|   _  \     |   ____||   \/   |  /  __  \  \   \  /   / |   ____|   |  \ |  |  /  __  \      /      | /  __  \  |  |     |  |     |  | |       \ |   ____|       /   \     |  |     |  |     
	|  |_)  |    |  |__   |  \  /  | |  |  |  |  \   \/   /  |  |__      |   \|  | |  |  |  |    |  ,----'|  |  |  | |  |     |  |     |  | |  .--.  ||  |__         /  ^  \    |  |     |  |     
	|      /     |   __|  |  |\/|  | |  |  |  |   \      /   |   __|     |  . `  | |  |  |  |    |  |     |  |  |  | |  |     |  |     |  | |  |  |  ||   __|       /  /_\  \   |  |     |  |     
	|  |\  \----.|  |____ |  |  |  | |  `--'  |    \    /    |  |____    |  |\   | |  `--'  |    |  `----.|  `--'  | |  `----.|  `----.|  | |  '--'  ||  |____     /  _____  \  |  `----.|  `----.
	| _| `._____||_______||__|  |__|  \______/      \__/     |_______|   |__| \__|  \______/      \______| \______/  |_______||_______||__| |_______/ |_______|   /__/     \__\ |_______||_______|
	*/

	--Log Loading Message
	loadingLog("Entity:removeNoCollideAll()")

	--SetUp E2 Function Cost
	__e2setcost(25)

	--Setup E2 Function
	e2function void entity:removeNoCollideAll()
		local isAdmin = false
		local propProtection = false
		local Ent = this
		
		--If entity is not Valid
		if this:IsValid() && !this:IsPlayer() then
			--If Game is Single Player then Return True
			if game.SinglePlayer() then isAdmin = true end
			--If is Admin quit with true
			if self.player:IsAdmin() then isAdmin = true end
			
			if !isAdmin then
				-- If This is a Player
				if !this:IsPlayer() then
					Ent = this.player
				end
				-- Check if is Allowed
				propProtection = ( this == self.player || E2Lib.isOwner(self, this) || E2Lib.isFriend( Ent, self.player) )
			end
		end	
		
		-- If Player is Admin or passed on Prop Protection
		if ( isAdmin || propProtection ) then
			--Remove No CollideAll
			this:SetCollisionGroup(COLLISION_GROUP_NONE)
		end			
	end

	/*
		 _______. _______ .___________.     ______   ____    __    ____ .__   __.  _______ .______      
		/       ||   ____||           |    /  __  \  \   \  /  \  /   / |  \ |  | |   ____||   _  \     
	   |   (----`|  |__   `---|  |----`   |  |  |  |  \   \/    \/   /  |   \|  | |  |__   |  |_)  |    
		\   \    |   __|      |  |        |  |  |  |   \            /   |  . `  | |   __|  |      /     
	.----)   |   |  |____     |  |        |  `--'  |    \    /\    /    |  |\   | |  |____ |  |\  \----.
	|_______/    |_______|    |__|         \______/      \__/  \__/     |__| \__| |_______|| _| `._____|
	*/

	--Log Loading Message
	loadingLog("Entity:setOwner(Entity)")

	--SetUp E2 Function Cost
	__e2setcost(200)

	--Setup E2 Function
	e2function void entity:setOwner(entity player)
		--If is not valid then quit
		if !this:IsValid() then return end 	
		--If is player then quit
		if this:IsPlayer() then return end 
		--If Player is Really a player then quit
		if !player:IsPlayer() then return end 

		--Check if Player is not Admin and Game is Not SinglePlayer
		if self.player:IsAdmin() and !game.SinglePlayer() then 
			--Set Owner
			--this.Owner = player
			this:SetPlayer(player)
		end	
	end

	/*
	 __    _______ .__   __.  __  .___________. _______ 
	|  |  /  _____||  \ |  | |  | |           ||   ____|
	|  | |  |  __  |   \|  | |  | `---|  |----`|  |__   
	|  | |  | |_ | |  . `  | |  |     |  |     |   __|  
	|  | |  |__| | |  |\   | |  |     |  |     |  |____ 
	|__|  \______| |__| \__| |__|     |__|     |_______|
	*/

	--Log Loading Message
	loadingLog("Entity:ignite()")

	--SetUp E2 Function Cost
	__e2setcost(50)

	--Setup E2 Function
	e2function void entity:ignite()
		local isAdmin = false
		local propProtection = false
		local Ent = this
		
		--If entity is not Valid
		if this:IsValid() then
			--If Game is Single Player then Return True
			if game.SinglePlayer() then isAdmin = true end
			--If is Admin quit with true
			if self.player:IsAdmin() then isAdmin = true end
			
			if !isAdmin then
				-- If This is a Player
				if !this:IsPlayer() then
					Ent = this.player
				end
				-- Check if is Allowed
				propProtection = ( this == self.player || E2Lib.isOwner(self, this) || E2Lib.isFriend( Ent, self.player) )
			end
		end	
		
		-- If Player is Admin or passed on Prop Protection
		if ( isAdmin || propProtection ) then
			--Ignite
			this:Ignite(99999999, 0)
		end		
	end

	/*
	 _______ ___   ___ .___________. __  .__   __.   _______  __    __   __       _______. __    __  
	|   ____|\  \ /  / |           ||  | |  \ |  |  /  _____||  |  |  | |  |     /       ||  |  |  | 
	|  |__    \  V  /  `---|  |----`|  | |   \|  | |  |  __  |  |  |  | |  |    |   (----`|  |__|  | 
	|   __|    >   <       |  |     |  | |  . `  | |  | |_ | |  |  |  | |  |     \   \    |   __   | 
	|  |____  /  .  \      |  |     |  | |  |\   | |  |__| | |  `--'  | |  | .----)   |   |  |  |  | 
	|_______|/__/ \__\     |__|     |__| |__| \__|  \______|  \______/  |__| |_______/    |__|  |__| 
	*/

	--Log Loading Message
	loadingLog("Entity:extinguish()")

	--SetUp E2 Function Cost
	__e2setcost(15)

	--Setup E2 Function
	e2function void entity:extinguish()
		local isAdmin = false
		local propProtection = false
		local Ent = this
		
		--If entity is not Valid
		if this:IsValid() then
			--If Game is Single Player then Return True
			if game.SinglePlayer() then isAdmin = true end
			--If is Admin quit with true
			if self.player:IsAdmin() then isAdmin = true end
			
			if !isAdmin then
				-- If This is a Player
				if !this:IsPlayer() then
					Ent = this.player
				end
				-- Check if is Allowed
				propProtection = ( this == self.player || E2Lib.isOwner(self, this) || E2Lib.isFriend( Ent, self.player) )
			end
		end	
		
		-- If Player is Admin or passed on Prop Protection
		if ( isAdmin || propProtection ) then
			--If Is On Fire
			if(this:IsOnFire()) then
				--Extinguish
				this:Extinguish()
			end
		end	
	end

	/*
		 _______. _______ .___________. __    __   _______      ___       __      .___________. __    __  
		/       ||   ____||           ||  |  |  | |   ____|    /   \     |  |     |           ||  |  |  | 
	   |   (----`|  |__   `---|  |----`|  |__|  | |  |__      /  ^  \    |  |     `---|  |----`|  |__|  | 
		\   \    |   __|      |  |     |   __   | |   __|    /  /_\  \   |  |         |  |     |   __   | 
	.----)   |   |  |____     |  |     |  |  |  | |  |____  /  _____  \  |  `----.    |  |     |  |  |  | 
	|_______/    |_______|    |__|     |__|  |__| |_______|/__/     \__\ |_______|    |__|     |__|  |__| 
	*/

		--Log Loading Message
	loadingLog("Entity:setHealth(Number)")

	--SetUp E2 Function Cost
	__e2setcost(100)

	--Setup E2 Function
	e2function void entity:setHealth(number amount)
		--If is not valid then quit
		if !this:IsValid() then return end 	
		--If is not valid player then quit
		if !this:IsPlayer() then return end 	
		
		--Check if Player is not Admin and Game is Not SinglePlayer
		if self.player:IsAdmin() or game.SinglePlayer() then 
			this:SetHealth(amount)
		end
	end


	/*
	.___________.    ___       __  ___  _______     _______       ___      .___  ___.      ___       _______  _______ 
	|           |   /   \     |  |/  / |   ____|   |       \     /   \     |   \/   |     /   \     /  _____||   ____|
	`---|  |----`  /  ^  \    |  '  /  |  |__      |  .--.  |   /  ^  \    |  \  /  |    /  ^  \   |  |  __  |  |__   
		|  |      /  /_\  \   |    <   |   __|     |  |  |  |  /  /_\  \   |  |\/|  |   /  /_\  \  |  | |_ | |   __|  
		|  |     /  _____  \  |  .  \  |  |____    |  '--'  | /  _____  \  |  |  |  |  /  _____  \ |  |__| | |  |____ 
		|__|    /__/     \__\ |__|\__\ |_______|   |_______/ /__/     \__\ |__|  |__| /__/     \__\ \______| |_______|
	*/

		--Log Loading Message
	loadingLog("Entity:takeDamage(Number)")

	--SetUp E2 Function Cost
	__e2setcost(45)

	--Setup E2 Function
	e2function void entity:takeDamage(number damageAmount)
		local isAdmin = false
		local antiSpam = false
		local propProtection = false
		local ReUseList = {}
		local Ent = this
		
		--If entity is not Valid
		if this:IsValid() && !this:IsPlayer() then
			--If Game is Single Player then Return True
			if game.SinglePlayer() then isAdmin = true end
			--If is Admin quit with true
			if self.player:IsAdmin() then isAdmin = true end
			
			if !isAdmin then
				--Set Player In ReUseList
				if not ReUseList[self.player:UniqueID()] then
					ReUseList[self.player:UniqueID()] = -1
				end
				
				--Check if user are not spaming with the e2
				if ReUseList[self.player:UniqueID()] == -1 then
					antiSpam = true
				elseif CurTime() > ReUseList[self.player:UniqueID()] then 
					antiSpam = true
				end
				
				--If Pass
				if antiSpam then
					--Set ReUseList Timeout
					ReUseList[self.player:UniqueID()] = CurTime() + AntiSpamTimeout
					
					-- If This is a Player
					if !this:IsPlayer() then
						Ent = this.player
					end
					-- Check if is Allowed
					propProtection = ( this == self.player || E2Lib.isOwner(self, this) || E2Lib.isFriend( Ent, self.player) )
				end	
			end
		end	
		
		-- If Player is Admin or passed on AntiSpam and Prop Protection
		if ( isAdmin || ( antiSpam && propProtection ) ) then
			--Take Damage
			this:TakeDamage( damageAmount, self.player, self )
		end	
	end

	/*
		 _______. _______ .___________.
		/       ||   ____||           |
	   |   (----`|  |__   `---|  |----`
		\   \    |   __|      |  |     
	.----)   |   |  |____     |  |     
	|_______/    |_______|    |__| 
	*/

	--Log Loading Message
	loadingLog("Entity:set(String, String)")

	--SetUp E2 Function Cost
	__e2setcost(15)

	--Setup E2 Function
	e2function void entity:set(string input, string param)
		--If is not valid then quit
		if !this:IsValid() then return end 
		
		--Check if Player is not Admin and Game is Not SinglePlayer
		if self.player:IsAdmin() or game.SinglePlayer() then 
			this:Fire(input, param)
		end
	end
	
	--Log Loading Message
	loadingLog("Entity:set(String, Number)")
	
	--Setup E2 Function
	e2function void entity:set(string input, number param)
		--If is not valid then quit
		if !this:IsValid() then return end 
		
		--Check if Player is not Admin and Game is Not SinglePlayer
		if self.player:IsAdmin() or game.SinglePlayer() then 
			this:Fire(input, param)
		end
	end

	/*
			   __       _______.  ______   .__   __. 
		  |  |     /       | /  __  \  |  \ |  | 
		  |  |    |   (----`|  |  |  | |   \|  | 
	.--.  |  |     \   \    |  |  |  | |  . `  | 
	|  `--'  | .----)   |   |  `--'  | |  |\   | 
	 \______/  |_______/     \______/  |__| \__|
	*/
	
	--Log Loading Message
	loadingLog("tableToJson(Table)")
	
	--SetUp E2 Function Cost
	__e2setcost(20)
	
	--Setup E2 Function
	e2function string tableToJson(table data)
		--If is not valid then quit
		if type(data) != "table" then return "" end 
		
		--Convert Table to Json
		return util.TableToJSON( data )
	end
	
	--Log Loading Message
	loadingLog("jsonToTable(String)")
	
	--Setup E2 Function
	e2function table jsonToTable(string data)
		if data == "" then return end
		return util.JSONToTable(data)
	end
	
	
	/*
		 ___      .__   __.  __  .___  ___.      ___   .___________. _______ 
		/   \     |  \ |  | |  | |   \/   |     /   \  |           ||   ____|
	   /  ^  \    |   \|  | |  | |  \  /  |    /  ^  \ `---|  |----`|  |__   
	  /  /_\  \   |  . `  | |  | |  |\/|  |   /  /_\  \    |  |     |   __|  
	 /  _____  \  |  |\   | |  | |  |  |  |  /  _____  \   |  |     |  |____ 
	/__/     \__\ |__| \__| |__| |__|  |__| /__/     \__\  |__|     |_______|
	*/
	
	--Log Loading Message
	loadingLog("Entity:animate(Number)")
	
	--SetUp E2 Function Cost
	__e2setcost(50)
	
	--Setup E2 Function
	e2function void entity:animate(number Animation)
		local isAdmin = false
		local propProtection = false
		
		--If entity is not Valid
		if this:IsValid() then
			-- If This is a Player then quit
			if this:IsPlayer() then return end
			--If Game is Single Player then Return True
			if game.SinglePlayer() then isAdmin = true end
			--If is Admin quit with true
			if self.player:IsAdmin() then isAdmin = true end
			
			if !isAdmin then				
				-- Check if is Allowed
				propProtection = ( this == self.player || E2Lib.isOwner(self, this) || E2Lib.isFriend(this, self.player) )
			end
		end	
		
		-- If Player is Admin or passed on Prop Protection
		if ( isAdmin || propProtection ) then				
			Animate(this, Animation)
		end			
	end
	
	--Log Loading Message
	loadingLog("Entity:animate(String)")
	
	--SetUp E2 Function Cost
	__e2setcost(55)
	
	--Setup E2 Function
	e2function void entity:animate(string Animation)
		local isAdmin = false
		local propProtection = false
		
		--If entity is not Valid
		if this:IsValid() then
			-- If This is a Player then quit
			if this:IsPlayer() then return end
			--If Game is Single Player then Return True
			if game.SinglePlayer() then isAdmin = true end
			--If is Admin quit with true
			if self.player:IsAdmin() then isAdmin = true end
			
			if !isAdmin then				
				-- Check if is Allowed
				propProtection = ( this == self.player || E2Lib.isOwner(self, this) || E2Lib.isFriend(this, self.player) )
			end
		end	
		
		-- If Player is Admin or passed on Prop Protection
		if ( isAdmin || propProtection ) then				
			Animate(this, Animation)
		end		
	end
	
	--Log Loading Message
	loadingLog("Entity:animate(Number, Number)")
	
	--SetUp E2 Function Cost
	__e2setcost(60)
	
	--Setup E2 Function
	e2function void entity:animate(number Sequence, number Speed)
		local isAdmin = false
		local propProtection = false
		
		--If entity is not Valid
		if this:IsValid() then
			-- If This is a Player then quit
			if this:IsPlayer() then return end
			--If Game is Single Player then Return True
			if game.SinglePlayer() then isAdmin = true end
			--If is Admin quit with true
			if self.player:IsAdmin() then isAdmin = true end
			
			if !isAdmin then				
				-- Check if is Allowed
				propProtection = ( this == self.player || E2Lib.isOwner(self, this) || E2Lib.isFriend(this, self.player) )
			end
		end	
		
		-- If Player is Admin or passed on Prop Protection
		if ( isAdmin || propProtection ) then
			Animate(this, Sequence)
			this:SetPlaybackRate(math.max(Speed, 0))
		end	
	end
		
	--Log Loading Message
	loadingLog("Entity:animate(String, Number)")
	
	--SetUp E2 Function Cost
	__e2setcost(60)
	
	--Setup E2 Function
	e2function void entity:animate(string Animation, number Speed)
		local isAdmin = false
		local propProtection = false
		
		--If entity is not Valid
		if this:IsValid() then
			-- If This is a Player then quit
			if this:IsPlayer() then return end
			--If Game is Single Player then Return True
			if game.SinglePlayer() then isAdmin = true end
			--If is Admin quit with true
			if self.player:IsAdmin() then isAdmin = true end
			
			if !isAdmin then				
				-- Check if is Allowed
				propProtection = ( this == self.player || E2Lib.isOwner(self, this) || E2Lib.isFriend(this, self.player) )
			end
		end	
		
		-- If Player is Admin or passed on Prop Protection
		if ( isAdmin || propProtection ) then
			Animate(this, Animation)
			this:SetPlaybackRate(math.max(Speed, 0))	
		end
	end

	--Log Loading Message
	loadingLog("Entity:getAnimation()")
	
	--SetUp E2 Function Cost
	__e2setcost(5)
	
	--Setup E2 Function	
	e2function number entity:getAnimation()
		if !this:IsValid() then return 0 end
		return this:GetSequence() or 0
	end
	
	--Log Loading Message
	loadingLog("Entity:getAnimationByName(string)")
	
	--SetUp E2 Function Cost
	__e2setcost(10)
	
	--Setup E2 Function		
	e2function number entity:getAnimationByName(string Animation)
		if !this:IsValid() then return 0 end
		if(string.Trim(Animation) == "") then
			return 0
		else
			return this:LookupSequence(string.Trim(Animation)) or 0
		end
	end

	/*
	 _______    ___       __       __          _______       ___      .___  ___.      ___       _______  _______ 
	|   ____|  /   \     |  |     |  |        |       \     /   \     |   \/   |     /   \     /  _____||   ____|
	|  |__    /  ^  \    |  |     |  |        |  .--.  |   /  ^  \    |  \  /  |    /  ^  \   |  |  __  |  |__   
	|   __|  /  /_\  \   |  |     |  |        |  |  |  |  /  /_\  \   |  |\/|  |   /  /_\  \  |  | |_ | |   __|  
	|  |    /  _____  \  |  `----.|  `----.   |  '--'  | /  _____  \  |  |  |  |  /  _____  \ |  |__| | |  |____ 
	|__|   /__/     \__\ |_______||_______|   |_______/ /__/     \__\ |__|  |__| /__/     \__\ \______| |_______|
	*/
	
	--Log Loading Message
	loadingLog("Entity:disableFallDamage()")
	
	--SetUp E2 Function Cost
	__e2setcost(50)
	
	--Setup E2 Function	
	e2function number entity:disableFallDamage()
		local isAdmin = false
		local propProtection = false
		local Ent = this
		
		--If entity is not Valid
		if this:IsValid() && this:IsPlayer() then
			--If Game is Single Player then Return True
			if game.SinglePlayer() then isAdmin = true end
			--If is Admin quit with true
			if self.player:IsAdmin() then isAdmin = true end
			
			if !isAdmin then
				-- If This is a Player
				if !this:IsPlayer() then
					Ent = this.player
				end
				-- Check if is Allowed
				propProtection = ( this == self.player || E2Lib.isOwner(self, this) || E2Lib.isFriend( Ent, self.player) )
			end
		end	
		
		-- If Player is Admin or passed on AntiSpam and Prop Protection
		if ( isAdmin || propProtection ) then
			--Apply Velocity to entity
			FallDamageList[this:UniqueID()] = "DISABLE"
		end			
	end
	
	--Log Loading Message
	loadingLog("Entity:enableFallDamage()")
	
	--SetUp E2 Function Cost
	__e2setcost(50)
	
	--Setup E2 Function	
	e2function number entity:enableFallDamage()
		local isAdmin = false
		local propProtection = false
		local Ent = this
		
		--If entity is not Valid
		if this:IsValid() && this:IsPlayer() then
			--If Game is Single Player then Return True
			if game.SinglePlayer() then isAdmin = true end
			--If is Admin quit with true
			if self.player:IsAdmin() then isAdmin = true end
			
			if !isAdmin then
				-- If This is a Player
				if !this:IsPlayer() then
					Ent = this.player
				end
				-- Check if is Allowed
				propProtection = ( this == self.player || E2Lib.isOwner(self, this) || E2Lib.isFriend( Ent, self.player) )
			end
		end	
		
		-- If Player is Admin or passed on AntiSpam and Prop Protection
		if ( isAdmin || propProtection ) then
			--Apply Velocity to entity
			FallDamageList[this:UniqueID()] = "ENABLE"
		end			
	end
	
	/*
	 _______   _______ .______       __    __   __    __   _______          _______. _______ .___________.   .______    __          ___   ____    ____  _______ .______      
	|   ____| /  _____||   _  \     |  |  |  | |  |  |  | |       \        /       ||   ____||           |   |   _  \  |  |        /   \  \   \  /   / |   ____||   _  \     
	|  |__   |  |  __  |  |_)  |    |  |__|  | |  |  |  | |  .--.  |      |   (----`|  |__   `---|  |----`   |  |_)  | |  |       /  ^  \  \   \/   /  |  |__   |  |_)  |    
	|   __|  |  | |_ | |   ___/     |   __   | |  |  |  | |  |  |  |       \   \    |   __|      |  |        |   ___/  |  |      /  /_\  \  \_    _/   |   __|  |      /     
	|  |____ |  |__| | |  |         |  |  |  | |  `--'  | |  '--'  |   .----)   |   |  |____     |  |        |  |      |  `----./  _____  \   |  |     |  |____ |  |\  \----.
	|_______| \______| | _|         |__|  |__|  \______/  |_______/    |_______/    |_______|    |__|        | _|      |_______/__/     \__\  |__|     |_______|| _| `._____|
																																												
	*/
		
	--Log Loading Message
	loadingLog("Entity:egpHUDSetPlayer(Entity)")
	
	--SetUp E2 Function Cost
	__e2setcost(50)
	
	--Setup E2 Function		
	e2function void entity:egpHUDSetPlayer(entity ply)
	
		local isAdmin = false
		local propProtection = false
		local Ent = this
		
		--If entity is not Valid
		if this:IsValid() && !this:IsPlayer() then
			--If Game is Single Player then Return True
			if game.SinglePlayer() then isAdmin = true end
			--If is Admin quit with true
			if self.player:IsAdmin() then isAdmin = true end
			
			if !isAdmin then
				-- If This is a Player
				if !this:IsPlayer() then
					local Target = this.player
				end
				-- Check if is Allowed
				propProtection = ( this == self.player || E2Lib.isOwner(self, this) || E2Lib.isFriend( Target, self.player) )
			end
		end	
		
		-- If Player is Admin or passed on AntiSpam and Prop Protection
		if ( isAdmin || propProtection ) then
			if ply:IsValid() && Ent:IsValid() then
				umsg.Start( "EGP_HUD_Use", ply )
					umsg.Entity( Ent )
					umsg.Char( 1 )
				umsg.End()
			elseif Ent:IsValid() then
				umsg.Start( "EGP_HUD_Use", nil )
					umsg.Entity( Ent )
					umsg.Char( -1 )
				umsg.End()
			end
		end			
	end
	
	--SetUp E2 Function Cost
	__e2setcost(nil)

	--Log Loading Message
	Msg( "|| Load Complete!                   ||\n" )
	Msg( "\\====================================/\n" )
end
