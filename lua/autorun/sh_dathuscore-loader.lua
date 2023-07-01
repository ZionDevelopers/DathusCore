--[[

Dathus' Core by Dathus [BR] is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
----------------------------------------------------------------------------------------------------------------------------
Copyright (c) 2014 - 2023 Dathus [BR] <http://www.juliocesar.me> <http://steamcommunity.com/profiles/76561197983103320>

This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
To view a copy of this license, visit <http://creativecommons.org/licenses/by-nc-sa/4.0/deed.en_US> .
----------------------------------------------------------------------------------------------------------------------------

$Id$
Version 1.3 - 2023-06-30 11:00 PM (UTC -03:00)

]]--

-- Setup Class
DathusCore = {}
-- Dathus' Core version
DathusCore.version = "1.3.1"

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

Msg( "\n/====================================\\\n")
Msg( "||           Dathus' Core           ||\n" )
Msg( "||----------------------------------||\n" )
loadingLog("Version " .. DathusCore.version)
loadingLog("Updated on 2023-06-30 11:00 PM")
Msg( "\\====================================/\n\n" )

if SERVER then
  -- Add Files to Client
  AddCSLuaFile()
end