--[[ 
.__   __.  __________   ___  __    __       _______.     ______   ______   .______       _______ 
|  \ |  | |   ____\  \ /  / |  |  |  |     /       |    /      | /  __  \  |   _  \     |   ____|
|   \|  | |  |__   \  V  /  |  |  |  |    |   (----`   |  ,----'|  |  |  | |  |_)  |    |  |__   
|  . `  | |   __|   >   <   |  |  |  |     \   \       |  |     |  |  |  | |      /     |   __|  
|  |\   | |  |____ /  .  \  |  `--'  | .----)   |      |  `----.|  `--'  | |  |\  \----.|  |____ 
|__| \__| |_______/__/ \__\  \______/  |_______/        \______| \______/  | _| `._____||_______|
                                                                
Copyright (c) 2013 Nexus [BR] <http://www.nexusbr.net>
 
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 2 of the License, or
(at your option) any later version.
 
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.


Version: 1.3.0
Author: Nexus [BR]
Created: 05-11-2012
Updated: 09-08-2013	08:03 PM
]]--

local PLUGIN = exsto.CreatePlugin()

PLUGIN:SetInfo({
	Name = "Nexus Core",
	ID = "nexuscore",
	Desc = "Give access to Expression 2 Admin Functions.",
	Owner = "Nexus [BR]",
	CleanUnload = true;
} )

function PLUGIN:Init()
	exsto.CreateFlag( "nexuscoreaccess", "Allows users to use Nexus Core Admin Functions." )
end

function PLUGIN:OnUnload()
	exsto.Flags["nexuscoreaccess"] = nil
end

PLUGIN:Register()