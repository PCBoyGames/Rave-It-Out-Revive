return Def.ActorFrame{
	LoadActor("/BACKGROUNDS/Arcade")..{
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT+10);
	};
	
	LoadActor("fade")..{
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffusealpha,0.6);
	};
};