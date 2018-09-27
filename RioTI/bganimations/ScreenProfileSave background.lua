-- Timerseconds for this screen is controlled by:
-- NextStageSleepTime+WallpaperSleepTime values in ScreenProfileSaveOverlay
-- Wallpaper transition system by ROAD24 and NeobeatIKK

local t =							Def.ActorFrame{};
local SongsPlayed =					STATSMAN:GetAccumPlayedStageStats():GetPlayedSongs();
local LastSong =					SongsPlayed[#SongsPlayed]
local LastSongPlayedArtist =		LastSong:GetDisplayArtist();
local IsImage =						false;
local ShowRIOLogo =					false;
--
-- TODO: this values should be defaulted and reseted between games to avoid issues like this
local LastStageAccuracyP1 =			tonumber(getenv("LastStageAccuracyP1")) or 0;
local LastStageAccuracyP2 =			tonumber(getenv("LastStageAccuracyP2")) or 0;
local LastStageAccuracyHighest =	math.max(LastStageAccuracyP1,LastStageAccuracyP2);
local LastStageGradeP1 =			tonumber(getenv("LastStageGradeP1")) or 0;
local LastStageGradeP2 =			tonumber(getenv("LastStageGradeP2")) or 0;
local LastStageGradeHighest =		math.max(LastStageGradeP1,LastStageGradeP2);

function getRandomWall()
-- Cortes quiere random wallpaper, este script cargara de forma aleatoria
--  una imagen dentro del folder _RandomWalls en BGAnimations
	local sImagesPath = THEME:GetPathB("","_RandomWalls/NewWalls");
	local sRandomWalls = FILEMAN:GetDirListing(sImagesPath.."/",false,true);
	-- El random seed
	 math.randomseed(Hour()*3600+Second());
	return sRandomWalls[math.random(#sRandomWalls)];
end;

--//set conditions
if LastSongPlayedArtist == "Kanye West" and LastStageAccuracyHighest >= 90 then
	function getSpecialRandom()
		local sImagesPath = THEME:GetPathB("","_SpecialTransitions/ArtistKanyeWest");
		local sRandomWalls = FILEMAN:GetDirListing(sImagesPath.."/",false,true);
		math.randomseed(Hour()*3600+Second());
		return sRandomWalls[math.random(#sRandomWalls)];
	end;
	LoadSpecialTransition = getSpecialRandom()
	SpecialTransition = true
--	ShowRIOLogo = false
else
	SpecialTransition = false
end;
if SpecialTransition then		--load wallpaper or special transition
	t[#t+1] = Def.ActorFrame{
		LoadActor(LoadSpecialTransition)..{
			InitCommand=cmd();	--leave at x,0;y,0; if the file loaded is an animation, check if is an image and resolve in the OnCommand function -NeobeatIKK
			OnCommand=function(self)
				local fPath = LoadSpecialTransition
				local fFormat = {".jpg",".png",".jpeg"};	--search for these matches in filepath
				for i = 1,#fFormat,1 do					--find formats and switch IsImage if file found
					if string.match(fPath,fFormat[i]) == fFormat[i] then
						IsImage = true
					end;
				end;
				if IsImage then		--if the file loaded for the special transition is an image then
					self:Center();	--center this actor
				end;
			end;
		};
	};
else
	t[#t+1] = Def.ActorFrame{
		LoadActor(getRandomWall())..{
			-- Algunas imagenes pierden calidad enormemente con FullScreen, por que?	--ni idea, pero al menos ya sé que hay una diferencia... -NeobeatIKK
			--OnCommand=cmd(FullScreen);
			OnCommand=function(self)
				self:Center();
				if IsUsingWideScreen() then
					self:zoomto(SCREEN_WIDTH+20,SCREEN_HEIGHT);
				else
					self:zoomto(SCREEN_WIDTH,SCREEN_HEIGHT);
				end;
			end;
		};
	};

end;
if ShowRIOLogo then				--load rio logo in bottom right corner
	t[#t+1] = LoadActor("_wallpaperriologo.lua");
end;



return t