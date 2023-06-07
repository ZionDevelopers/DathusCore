Dathus' Core
=====
![Logo](https://raw.githubusercontent.com/ZionDevelopers/DathusCore/master/logo.png)

A [Garry's Mod][] addon that is Library of Expression 2 Functions.

### Expression 2 Functions
```
entity:teleport(Vector) -- Teleport Entity to a Position on Gmod Map
Entity:playerUniqueId() -- Return the Player Unique ID
Entity:applyPlayerForce(Vector) -- Like ApplyForce but with Player
Entity:hasNoCollideAll() -- Check if Prop Has NO-Collide All and return 1 or 0 (True or False)
Entity:setCollideAll() -- Set NO-Collide All on a Prop
Entity:removeNoCollideAll() -- Remove the NO-Collide All from the Prop
Entity:setOwner(Entity) -- ReSet the Owner of the Prop (ADMIN ONLY)
Entity:ignite(Number) -- Put a Entity on Fire
Entity:extinguish(Number) -- Remove the Fire of the Entity
Entity:setHealth(Number) -- Set Player's Health (ADMIN ONLY)
Entity:takeDamage(Number) -- Do Damage on Prop (NOT WORK WITH PLAYERS)
Entity:set(String, String) -- Set A Property on a Entity (Like Color) (ADMIN ONLY)
Entity:set(String, Number) -- Set A Property on a Entity (Like Color) (ADMIN ONLY)
Entity:animate(Number) -- Animate a Prop (Sequence) (Only with Props)
Entity:animate(String) -- Animate a Prop (Sequence) (Only with Props)
Entity:animate(Number, Number) -- Animate a Prop (Sequence) (Only with Props)
Entity:animate(String, Number) -- Animate a Prop (Sequence) (Only with Props)
Entity:getAnimation() -- Get the Current Prop's Animation
Entity:getAnimationByName(String) -- Get The Animation Number by Aninamtion Name (Like Fire)
Entity:egpHUDSetPlayer(Entity) -- Set a Player to See an EGP HUD
```

Functions With AntiSpam (2 Seconds Delay) Protection
Teleport, TakeDamage
* Functions With Prop Protection: Teleport, ApplyPlayerForce, SetCollideAll, RemoveNoCollideAll, Ignite, Extinguish, TakeDamage, Animate, egpHUDSetPlayer.

E2 Code Demonstration: http://pastebin.com/MSV6tUJr

All functions developed by me, I took a good time to make it.

### Setup

Just download this addon by clicking on Download ZIP and extract the addon in ````Steam\SteamApps\common\GarrysMod\garrysmod\addons\```` as usual.

### Workshop Ready!

Dathus' Core is now available via the Steam Workshop! Go to [its Workshop page][workshop] and press `Subscribe`, and it will automatically appear in Garry's Mod.

### Manual Installation

Simply clone this repository into your `addons` folder:

    cd "%programfiles(x86)%/Steam/SteamApps/common/GarrysMod/garrysmod/addons"
    git clone https://github.com/ZionDevelopers/DathusCore.git DathusCore

### License

This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
To view a copy of this license, visit [Common Creative's Website][License].

[Garry's Mod]: <http://garrysmod.com/>
[workshop]: <https://steamcommunity.com/sharedfiles/filedetails/?id=106681516>
[License]: <https://creativecommons.org/licenses/by-nc-sa/4.0/>


