<h1 align="center">The Ex-Machina</h1>  

![panorama](./manual/pics/manual-panorama.png)  

## Disclaimer
This is a prototype made for PirateJam 2025 Summer. Bugs and unexpected behavior are expected.

<h1 align="center">Contents</h1>  

[Gameplay Overview](#gameplay-overview)  
[Setting Overview](#setting-overview)  
[AI Overview](#ai-overview)  
[Level Overview](#level-overview)  
[Weapons and Stuff Overview](#weapons-and-stuff-overview)  

## Gameplay overview
The Ex-Machina is an 3d third person action shooter, where player supposed to controll the only one left machine: fight, die, reborn - make your way through that junk-metal pile. And remember, crowd is looking at you - do your best.  
Level placed in big arena, with unique locations. Bots miss a little, so there is need in coveres and covered maneuvers and terrain with ruins can give such oportunity. Find way through and minimie damage because second tries not infinite.  
Enemies - Bots. Straightforward algorythm control theme but not stupid. They follow not very long ditance but aim is something else. They even jump.  
Weapons - player has decent amount of tools for destroying bots. Every gun is unique visually and by gameplay. Three weapons - three types, combination is the key to problem.  
Robot stuff - player's killing machine can be upgradet and refilled with ammo. Search for gear, it could be hided somewhere. And even change some spare-parts - legs, it could upgrade walkspeed and strafe cool down.  

### Gameplay in Action  

<p align="center">   
    <img src="./manual/vids/action-strafe.gif" height="75%">
</p>  


### Screenshots
![1](./screenshots/1.png)  

![2](./screenshots/2.png)  

### [Ex-Machina Full-Walkthrough Presentation](https://youtu.be/g-B_9nhvfcg)
[![Watch the video](https://img.youtube.com/vi/g-B_9nhvfcg/maxresdefault.jpg)](https://youtu.be/g-B_9nhvfcg)

Further will be featured development details and game underhood.  

## Setting Overview  
The Ex-Machina takes place in near future, humanized robots with modern guns fights to death in huge arena. It's a show, and it will be spectacular.  

<p align="center">
    <img src="./manual/pics/loc_concept.png" width="40%">
</p>  

Sounds cool, it looks even better. Overall design is pretty grounded and was inspired by real life counterparts, for example robot takes example from Boston Dynamics, and even such tiny detail(on look but huge in gameplay) as robot booster inspired by NASAs engines.

<p align="center">
    <img src="./manual/pics/robot-concept.png" width="40%">
    <img src="./manual/pics/strafe-concept.png" width="57.25%">
</p>

## AI Overview  
If there is robots - there is ai. Enemies ai utilizes extended features of Godot engine platform. The goal was to make straightforward but nit stupid machine, that won't allow player get bored.  
Enemies have 2 global states: patroling and attacking. If they spot player - they will follow, if they lost - they patrol. There are some specificity of their behaviour - nice precision, slow rotation, so despite they being straightforward for player chase, they will deal real damage. Player forced to strafe, jump and dodge bots aim, and to shoot moving target won't be so easy.
They have pathfinding mechanic that will allow them to find player:  
<p align="center">   
    <img src="./manual/vids/ai-path2.gif" height="75%">
</p>  
<p align="center">   
    <img src="./manual/vids/ai-path3.gif" height="75%">
</p>  

Another interesting detail is their ability to jump. There are several spots on level that is designed to ne jumped through, so bots also can do such things:  

<p align="center">   
    <img src="./manual/vids/jump.gif" height="75%">
</p>

## Level Overview  


## Weapons and Stuff Overview  

## How to build project

Requirements:
    
    OS: Windows, Linux or WEB
    Godot 4.4.1
    OpenGl 3.3+ or WebGL 2.0+ compatible GPU

1. Open project.godot file using godot editor
2. Run project


![boat-1](./manual/pics/boat-1.png)

![boat-2](./manual/pics/boat-2.png)

![boat-3](./manual/pics/boat-3.png)

![boat-4](./manual/pics/boat-4.png)

![bot](./manual/pics/bot.png)

![cranes-1](./manual/pics/cranes-1.png)

![cranes-2](./manual/pics/cranes-2.png)

![cranes-3](./manual/pics/cranes-3.png)

![cranes-4](./manual/pics/cranes-4.png)

![map_layout](./manual/pics/map_layout.png)

![plane-1](./manual/pics/plane-1.png)

![plane-2](./manual/pics/plane-2.png)

![plane-3](./manual/pics/plane-3.png)

![projectile](./manual/pics/projectile.png)

![launcher](./manual/pics/launcher.png)

![hitscan](./manual/pics/hitscan.png)

![robot-concept](./manual/pics/robot-concept.png)

![strafe-concept](./manual/pics/strafe-concept.png)
