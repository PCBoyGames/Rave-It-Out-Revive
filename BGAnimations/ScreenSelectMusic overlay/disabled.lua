--PIU Delta NEX difficulty select, hyper minimal edition (until I can figure out why RIO has a memory leak)
local t = Def.ActorFrame{}

-- BANNER CENTRAL -- BACKGROUND

--PREVIEW BOX
t[#t+1] = Def.ActorFrame{
	
		LoadActor("preview_shine/0")..{
			InitCommand=cmd(horizalign,center;zoomx,0.65;zoomy,0.7;x,_screen.cx;y,_screen.cy);
			CurrentSongChangedMessageCommand=cmd(stoptweening;queuecommand,"Effect");
			MenuLeftP1MessageCommand=cmd(playcommand,"Effect");
			MenuLeftP2MessageCommand=cmd(playcommand,"Effect");
			MenuUpP1MessageCommand=cmd(playcommand,"Effect");
			MenuUpP2MessageCommand=cmd(playcommand,"Effect");
			MenuRightP1MessageCommand=cmd(playcommand,"Effect");
			MenuRightP2MessageCommand=cmd(playcommand,"Effect");
			MenuDownP1MessageCommand=cmd(playcommand,"Effect");
			MenuDownP2MessageCommand=cmd(playcommand,"Effect");
			EffectCommand=function(self)	
				self:stoptweening();
				self:Load(nil);
				self:Load(THEME:GetCurrentThemeDirectory().."Bganimations/ScreenSelectMusic overlay/preview_shine/"..shine_index..".png");
				self:sleep(0.03);
				if shine_index == 8 then
					self:stoptweening();
					shine_index = 1;
					self:visible(false);
				else
					self:visible(true);
					shine_index = shine_index+1
					self:queuecommand("Effect");
				end;
			end;
		};

		LoadActor("preview_frame")..{
			InitCommand=cmd(horizalign,center;zoomto,400,250;x,_screen.cx;y,_screen.cy-30);
		};
		--SONG BACKGROUND
		Def.Sprite {
			InitCommand=cmd(x,_screen.cx;y,_screen.cy-30);
			CurrentSongChangedMessageCommand=cmd(finishtweening;queuecommand,"ModifySongBackground");
			ModifySongBackgroundCommand=function(self)
				self:stoptweening();
				if GAMESTATE:GetCurrentSong() then
					self:LoadFromSongBackground(GAMESTATE:GetCurrentSong());
					self:zoomto(384,232);
					self:diffusealpha(0);
					self:linear(0.5);
					self:diffusealpha(1);
				end;
			end;
		};
		Def.Sprite{
			--Name = "BGAPreview";
			InitCommand=cmd(x,_screen.cx;y,_screen.cy-30);
			CurrentSongChangedMessageCommand=cmd(stoptweening;queuecommand,"PlayVid");
			MenuLeftP1MessageCommand=cmd(playcommand,"PlayVid");
			MenuLeftP2MessageCommand=cmd(playcommand,"PlayVid");
			MenuUpP1MessageCommand=cmd(playcommand,"PlayVid");
			MenuUpP2MessageCommand=cmd(playcommand,"PlayVid");
			MenuRightP1MessageCommand=cmd(playcommand,"PlayVid");
			MenuRightP2MessageCommand=cmd(playcommand,"PlayVid");
			MenuDownP1MessageCommand=cmd(playcommand,"PlayVid");
			MenuDownP2MessageCommand=cmd(playcommand,"PlayVid");
			PlayVidCommand=function(self)
				self:Load(nil);
				local song = GAMESTATE:GetCurrentSong()
				path = GetBGAPreviewPath("PREVIEWVID");
				--path = song:GetBannerPath();
				self:Load(path);
				self:diffusealpha(0);
				self:zoomto(384,232);
				self:sleep(0.5);
				self:linear(0.2);
				if path == "/Backgrounds/Title.mp4" then
					self:diffusealpha(0.5);
				else
					self:diffusealpha(1);
				end
			end;
		};
	
		LoadActor("preview_songinfo")..{
			InitCommand=cmd(horizalign,center;zoomto,385,75;x,_screen.cx;y,_screen.cy+50;diffusealpha,1);
		};
	
		Def.Sprite {
			InitCommand=cmd(Load,nil;diffusealpha,0;zoomto,70,70;horizalign,left;x,_screen.cx-190;y,_screen.cy+50);
			CurrentSongChangedMessageCommand=function(self)
				(cmd(stoptweening;Load,nil;diffusealpha,0;zoom,0.25;linear,0.5;decelerate,0.25;))(self);
				if GAMESTATE:GetCurrentSong():HasJacket() then
					self:Load(GAMESTATE:GetCurrentSong():GetJacketPath());
				else
					self:LoadFromSongBanner(GAMESTATE:GetCurrentSong());
				end;
				(cmd(diffusealpha,1;zoomto,70,70))(self);
			end;
		};

		--Genre display
		LoadFont("monsterrat/_montserrat semi bold 60px")..{
			InitCommand=cmd(horizalign,left;x,_screen.cx-115;y,_screen.cy+25.75;zoom,0.6;skewx,-0.2);
			CurrentSongChangedMessageCommand=function(self)
				self:settext("GENRE:");
				(cmd(finishtweening;zoomy,0;zoomx,0.5;decelerate,0.33;zoom,0.2;)) (self)
			end;
		};
		LoadFont("monsterrat/_montserrat light 60px")..{
			InitCommand=cmd(horizalign,left;uppercase,true;x,_screen.cx-67.5;y,_screen.cy+25.5);
			CurrentSongChangedMessageCommand=function(self)
				self:settext(GAMESTATE:GetCurrentSong():GetGenre());
				(cmd(finishtweening;zoomy,0;zoomx,0.5;decelerate,0.33;zoom,0.2;skewx,-0.2)) (self)
			end;
		};
	
		--Year display
		LoadFont("monsterrat/_montserrat semi bold 60px")..{
			InitCommand=cmd(horizalign,left;x,_screen.cx-115;y,_screen.cy+40.75;zoom,0.6;skewx,-0.2);
			CurrentSongChangedMessageCommand=function(self)
				self:settext("YEAR:");
				(cmd(finishtweening;zoomy,0;zoomx,0.5;decelerate,0.33;zoom,0.2;)) (self)
			end;
		};
		LoadFont("monsterrat/_montserrat light 60px")..{
			InitCommand=cmd(horizalign,left;uppercase,true;x,_screen.cx-76;y,_screen.cy+40.5);
			OnCommand=cmd(playcommand,"YearTag");
			CurrentSongChangedMessageCommand=cmd(playcommand,"YearTag");
			YearTagCommand=function(self)
				ssc_year = GetCourseDescription(GAMESTATE:GetCurrentSong():GetSongFilePath(),"ORIGIN")
				if ssc_year == nil or ssc_year == "" then
					self:settext("????");
				else
					self:settext(ssc_year);
				end;
				(cmd(finishtweening;zoomy,0;zoomx,0.5;decelerate,0.33;zoom,0.2;skewx,-0.2)) (self)
			end;
		};
		
		--BPM DISPLAY
		LoadFont("monsterrat/_montserrat semi bold 60px")..{
			InitCommand=cmd(horizalign,left;x,_screen.cx-115;y,_screen.cy+55.75;zoom,0.6;skewx,-0.2);
			CurrentSongChangedMessageCommand=function(self)
				self:settext("BPM:");
				(cmd(finishtweening;zoomy,0;zoomx,0.5;decelerate,0.33;zoom,0.2;)) (self)
			end;
		};
		
		LoadFont("monsterrat/_montserrat light 60px")..{
			InitCommand=cmd(horizalign,left;uppercase,true;x,_screen.cx-83;y,_screen.cy+55.5;zoom,0.22;skewx,-0.2);
			CurrentSongChangedMessageCommand=function(self)

				local song = GAMESTATE:GetCurrentSong();
				-- ROAD24: more checks,
				-- TODO: decide what to do if no song is chosen, ignore or hide ??
				if song then
					local rawbpm = GAMESTATE:GetCurrentSong():GetDisplayBpms();
					local lobpm = math.ceil(rawbpm[1]);
					local hibpm = math.ceil(rawbpm[2]);
					if lobpm == hibpm then
						speedvalue = hibpm
					else
						speedvalue = lobpm.." - "..hibpm
					end;
					self:settext(speedvalue);
					(cmd(finishtweening;zoomy,0;zoomx,0.5;decelerate,0.33;zoom,0.2;)) (self)
				else
					self:stoptweening();self:linear(0.25);self:diffusealpha(0);
				end;
			end;
		};
		
		
		--HEART
		--[[LoadActor(THEME:GetPathG("","USB_stuff/heart_foreground.png"))..{
		InitCommand=cmd(x,_screen.cx-105;y,_screen.cy+85;zoom,0.6;);
		OnCommand=cmd(playcommand,"Refresh";);
		CurrentSongChangedMessageCommand=cmd(finishtweening;diffusealpha,0;sleep,0.01;queuecommand,"Refresh";);
		RefreshCommand=function(self)
			(cmd(diffusealpha,0;sleep,0.3;y,_screen.cy+85;linear,0.3;diffusealpha,1;y,_screen.cy+75))(self);
		end;
		};]]
		
		LoadFont("monsterrat/_montserrat semi bold 60px")..{
			InitCommand=cmd(horizalign,left;x,_screen.cx-95;y,_screen.cy+74;zoom,0.3;);
			CurrentSongChangedMessageCommand=function(self)
				self:settext("X"..GAMESTATE:GetNumStagesForCurrentSongAndStepsOrCourse()*GAMESTATE:GetNumSidesJoined());
				(cmd(finishtweening;zoomy,0;zoomx,0.5;decelerate,0.33;zoom,0.2;skewx,-0.2)) (self)
			end;
		};
		
		--SONG COUNTER
		LoadFont("monsterrat/_montserrat light 60px")..{
			InitCommand=cmd(horizalign,right;uppercase,true;x,_screen.cx+190;y,_screen.cy+75;zoom,0.8;skewx,-0.2);
			CurrentSongChangedMessageCommand=function(self)
				local song = GAMESTATE:GetCurrentSong();
				if song then
					self:stoptweening();
					local num = SCREENMAN:GetTopScreen():GetChild('MusicWheel'):GetCurrentIndex();
					if not num then num = 0 else num = num + 1 end;
					local numb = num < 1000 and string.format("%.3i", num) or scorecap(num);
					local index = SCREENMAN:GetTopScreen():GetChild('MusicWheel'):GetNumItems();
					if not index then index = 0 end;
					local total = index < 1000 and string.format("%.3i", index) or scorecap(index);
					self:settext( numb.."/"..total );
					(cmd(finishtweening;zoomy,0;zoomx,0.5;decelerate,0.33;zoom,0.275;)) (self)
				else
					self:stoptweening();self:linear(0.25);self:diffusealpha(0);
				end;
			end;
		};
		--SONG/ARTIST BACKGROUND
		LoadActor("songartist_name")..{
			InitCommand=cmd(x,_screen.cx;y,SCREEN_CENTER_Y-170;zoomto,547,46);
		};
	
		-- CURRENT SONG NAME
		LoadFont("bebas/_bebas neue bold 90px")..{	
			InitCommand=cmd(uppercase,true;x,_screen.cx;y,_screen.cy-171;zoom,0.45;maxwidth,(_screen.w/0.9);skewx,-0.1);
			CurrentSongChangedMessageCommand=function(self)
			local song = GAMESTATE:GetCurrentSong()
				if song then
					self:settext(song:GetDisplayFullTitle());
					self:finishtweening();self:diffusealpha(0);
					self:x(_screen.cx+75);self:sleep(0.25);self:decelerate(0.75);self:x(_screen.cx);self:diffusealpha(1);
				else
					self:stoptweening();self:linear(0.25);self:diffusealpha(0);
				end;
			end;

		};
		-- CURRENT SONG ARTIST
		LoadFont("monsterrat/_montserrat semi bold 60px")..{	
			InitCommand=cmd(uppercase,true;x,_screen.cx;y,_screen.cy-187;zoom,0.2;maxwidth,(_screen.w*2);skewx,-0.1);
			CurrentSongChangedMessageCommand=function(self)
			local song = GAMESTATE:GetCurrentSong();
				if song then
					self:settext(song:GetDisplayArtist());
					self:finishtweening();self:diffusealpha(0);
					self:x(_screen.cx-75);self:sleep(0.25);self:decelerate(0.75);self:x(_screen.cx);self:diffusealpha(1);
				else
					self:stoptweening();self:linear(0.25);self:diffusealpha(0);
				end;
			end;
		};
};



--DIFFICULTY BAR
local stage =		GAMESTATE:GetCurrentStage()
--optionlist controls
local olwid =		THEME:GetMetric("CustomRIO","OpQuadWidth")		--option list quad width
local olania =		0.1			--optionlist animation time in
local olanib =		0.2			--optionlist animation time out
local olhei	=		SCREEN_HEIGHT*0.75	--optionlist quadheight
local oltfad =		0.125		--optionlist top fade value (0..1)
local olbfad =		0.5			--optionlist bottom fade value
local ollfad =		0			--optionlist left  fade value
local olrfad =		0			--optionlist right fade value
-- Chart info helpers
local infy =		160					--Chart info Y axis position (both players, includes black quad alt)
local infx =		0					--Chart info X DIFFERENCE FROM DISC
local txytune =		-25					--Text info altitude (Y axis) finetuning
local txxtune =		0.015625*_screen.w	--Text info separation from center (X axis) finetuning (must be always a positive value)	--20 equivalent is 0.03125*_screen.w (when using 4:3)
local saz =			0.75				--Chart info Step Artist Zoom ("saz! en toda la boca!")
local diffy =		40					--Object Y axis difference
local maxwidar =	_screen.cx*0.7	--Chart info Step Artist maxwidth value
local maxwidinf =	_screen.cx*1.1	--Chart info Text maxwidth value
local infft =		0.125*0.75			--Chart info quad fade top
local inffb =		infft				--Chart info quad fade bottom
local redu =		0					--Chart info vertical reduction value for black quad (pixels)
--local bqwid =		(_screen.cx*0.625)+40	--Chart info quad width
local bqwid =		_screen.cx			--Chart info quad width
local bqalt =		244-20				--Chart info black quad height
local bqalph =		0.9					--Chart info black quad diffusealpha value
local wqwid =		_screen.cx			--
--
local npsxz =	_screen.cx*0.5		--next/previous song X zoom
local npsyz =	_screen.cy --*0.75	--next/previous song Y zoom
--
--local css1 = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1);
--local css2 = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2);
local newranktext = "NEW CHALLENGER"	--text replacing #P1# when someone does a new record
local bpmalt = 	_screen.cy+55			--Y value for BPM Display below banner

t[#t+1] = Def.ActorFrame{

	Def.ActorFrame{		--P1 info display set
		InitCommand=cmd(x,SCREEN_LEFT;y,_screen.cy+110;vertalign,middle,horizalign,right);
		SongChosenMessageCommand=cmd(stoptweening;decelerate,0.125;x,SCREEN_CENTER_X);
		SongUnchosenMessageCommand=cmd(stoptweening;accelerate,0.125*1.5;x,SCREEN_LEFT;);

		Def.Quad{		--white quad for Difficulties
			InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1) or GAMESTATE:IsHumanPlayer(PLAYER_2);horizalign,right;zoomto,_screen.cx,35;diffuse,1,1,1,0.75;x,0;y,-3;fadeleft,1;);
			PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1) or GAMESTATE:IsHumanPlayer(PLAYER_2));
		};
		
		Def.Quad{		--Black quad for Chart info P1
			InitCommand=cmd(horizalign,right;fadetop,infft;fadebottom,inffb;x,-infx;y,-infy+20;
							zoomto,bqwid*2,bqalt+50;diffuse,0,0,0,bqalph;);
		};
		
		LoadActor("p1_info")..{		--P1 INFO
			InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1);horizalign,left;zoomto,250,45;x,-320;y,-235;faderight,1;);
			PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1));
		};
		
		
		LoadActor("ready")..{		--P1 READY
			InitCommand=cmd(visible,false;horizalign,center;x,-260;y,-150);
			StepsChosenMessageCommand=function(self,param)
				if param.Player == PLAYER_1 and GAMESTATE:GetNumSidesJoined() == 2 then
					self:visible(GAMESTATE:IsHumanPlayer(PLAYER_1));
				end;
			end;
			StepsUnchosenMessageCommand=cmd(visible,false);
			SongUnchosenMessageCommand=cmd(visible,false);
			CurrentStepsP1ChangedMessageCommand=cmd(visible,false);
		};
		
		LoadFont("bebas/_bebas neue bold 90px")..{		--"NOT PRESENT" text
			Text="NOT PRESENT";
			InitCommand=cmd(visible,not GAMESTATE:IsHumanPlayer(PLAYER_1);x,-_screen.cx*0.7;y,-infy;zoom,0.3;skewx,-0.2);
			PlayerJoinedMessageCommand=cmd(visible,not GAMESTATE:IsHumanPlayer(PLAYER_1));
		};
		Def.ActorFrame{		--Chart Info and more for P1
			InitCommand=cmd(y,-diffy);
			LoadFont("monsterrat/_montserrat semi bold 60px")..{	--Artist text
				InitCommand=cmd(x,-120;y,-170;zoom,0.215;uppercase,true;maxwidth,400);
				PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1);queuecommand,"CurrentStepsP1ChangedMessage");
				CurrentStepsP1ChangedMessageCommand=function(self)
				--	local author = GAMESTATE:GetCurrentSteps(PLAYER_1):GetAuthorCredit()	--this is the Thor that is the auThor... lol get it? yes but... ah ok...
																							--lolXD  - road
					-- TODO: there's a special error only when reloading the screen, should i avoid or fix ??
					if GAMESTATE:IsCourseMode() and GetCourseDescription(GAMESTATE:GetCurrentCourse():GetCourseDir(),"DESCRIPTION") ~= "" then
						author = GAMESTATE:GetCurrentCourse():GetScripter();
						if author == "" then
								artist = "Not available\n...wait what? Are you freaking serious?"
								self:maxwidth(1000);
							else
								if DoDebug then		--what is code and/or stepmania... without jokes? (only for p1)
									if author == "C.Cortes" then
										artist = "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW"
									elseif author == "F.Rodriguez" then
										artist = "I LIEK TURTLES"
									else
										artist = author
									end
								else
									artist = author
								end
							end
							self:visible(GAMESTATE:IsHumanPlayer(PLAYER_1));
							self:settext(artist);
					else

					if GAMESTATE:GetCurrentSteps(PLAYER_1) then
					author = GAMESTATE:GetCurrentSteps(PLAYER_1):GetAuthorCredit();		--Cortes got lazy and opt to use Description tag lol
						if GAMESTATE:GetCurrentSong() then		--set text display
							if author == "" then
								artist = "Not available\n...wait what? Are you freaking serious?"
								self:maxwidth(1000);
							else
								if DoDebug then		--what is code and/or stepmania... without jokes? (only for p1)
									if author == "C.Cortes" then
										artist = "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW"
									elseif author == "F.Rodriguez" then
										artist = "I LIEK TURTLES"
									else
										artist = author
									end
								else
									artist = author
								end
							end
							self:visible(GAMESTATE:IsHumanPlayer(PLAYER_1));
							self:settext(artist);
						else
							self:visible(false);
						end;
					end;
					end;
				end;
			};

			LoadFont("Common normal")..{
				Text="Song List:";
				InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1);x,-infx-txxtune;y,-infy+txytune+25;zoom,0.5;skewx,-0.25;horizalign,right;vertalign,top;);
				PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1));
				OnCommand=function(self)
					if GAMESTATE:IsCourseMode() then
						self:settext("Song List:")
					else
						self:settext("");
					end;
				end;
			};


			LoadFont("Common normal")..{--"Song list from current course"
				Text="";
				InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1);x,-infx-txxtune;y,-infy+txytune+70;zoom,0.4;horizalign,right;vertalign,middle;);
				PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1));
				OnCommand=function(self)
					list = GetCourseDescription(THEME:GetCurrentThemeDirectory().."BGAnimations/ScreenSelectCourse decorations/courses_list.txt","SONG1").."\n"..GetCourseDescription(THEME:GetCurrentThemeDirectory().."BGAnimations/ScreenSelectCourse decorations/courses_list.txt","SONG2").."\n"..GetCourseDescription(THEME:GetCurrentThemeDirectory().."BGAnimations/ScreenSelectCourse decorations/courses_list.txt","SONG3").."\n"..GetCourseDescription(THEME:GetCurrentThemeDirectory().."BGAnimations/ScreenSelectCourse decorations/courses_list.txt","SONG4");
					if GAMESTATE:IsCourseMode() then
						self:settext(list)
					else
						self:settext("");
					end;
				end;
			};

			LoadFont("monsterrat/_montserrat semi bold 60px")..{								--SPEEDMOD Display
				InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1);x,infx+txxtune;addx,-120;y,-infy+txytune+10+3+20;addy,26.25;zoom,0.185;vertalign,top;maxwidth,900);
				OnCommand=function(self)
					local profilep = PROFILEMAN:GetProfileDir("ProfileSlot_Player1")
					local song = GAMESTATE:GetCurrentSong();
					if song then
						local songpath = song:GetSongDir();
						local pathlastsmod = File.Read(profilep.."RIO_SongData"..songpath.."LastSpeedModUsed.txt")
						local lastspeedmod = pathlastsmod
						if lastspeedmod == nil then		--account for nil value
							lastspeedmod = "N/A"
						end;
						local xmod = GAMESTATE:GetPlayerState(PLAYER_1):GetCurrentPlayerOptions():XMod();
						local cmod = GAMESTATE:GetPlayerState(PLAYER_1):GetCurrentPlayerOptions():CMod();
						local mmod = GAMESTATE:GetPlayerState(PLAYER_1):GetCurrentPlayerOptions():MMod();
						local rawbpm = GAMESTATE:GetCurrentSong():GetDisplayBpms();
						--GetDisplayBpms always returns two values (lowest and highest) regardless if the song has only one BPM it repeats to both values.
						--%.1f --se cambia el numero para mas decimales
				--		local lobpm = tonumber(string.format("%.0f",rawbpm[1]));
				--		local hibpm = tonumber(string.format("%.0f",rawbpm[2]));
						local lobpm = math.ceil(rawbpm[1]);
						local hibpm = math.ceil(rawbpm[2]);
						if cmod then
							curmod = "C Mod "..cmod
							speedvalue = cmod
						elseif mmod then
							curmod = "M Mod "..mmod
							speedvalue = mmod
						else
							curmod = xmod.."x"
							if lobpm == hibpm then
								speedvalue = lobpm*xmod
							else
								speedvalue = lobpm*xmod.." - "..hibpm*xmod
							end;
						end;
						self:visible(GAMESTATE:IsHumanPlayer(PLAYER_1));
						self:settext("PREVIOUS SPEEDMOD: "..lastspeedmod.."\nCURRENT SPEEDMOD: "..curmod.."\nSPEED DISPLAY (BPM*MOD): "..speedvalue);
					end;
				end;
				PlayerJoinedMessageCommand=cmd(finishtweening;playcommand,"On";);
				CurrentSongChangedMessageCommand=cmd(finishtweening;playcommand,"On";);
				CodeMessageCommand=cmd(finishtweening;playcommand,"On";);
				OptionsListClosedMessageCommand=cmd(finishtweening;playcommand,"On";);
				SongChosenMessageCommand=cmd(finishtweening;playcommand,"On";);
			};
			LoadFont("monsterrat/_montserrat semi bold 60px")..{							--Machine Top Score (numbers)
				InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1);x,-infx-txxtune;y,-infy+txytune+123;addy,5;zoom,0.25;skewx,-0.25;horizalign,right;vertalign,top;queuecommand,"Set";);
				CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");

				CurrentStepsP1ChangedMessageCommand=cmd(queuecommand,"Set");
				PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1);queuecommand,"Set");
				SetCommand=function(self)
					-- ROAD24: and more checks
					-- TODO: decide what to do when no song is selected
					local cursong =	GAMESTATE:GetCurrentSong()
					if cursong and GAMESTATE:IsPlayerEnabled(PLAYER_1) then
						if cursong:IsLong() then
							stagemaxscore = 200000000
						elseif cursong:IsMarathon() then
							stagemaxscore = 300000000
						else
							stagemaxscore = 100000000
						end;
						profile = PROFILEMAN:GetMachineProfile();
						scorelist = profile:GetHighScoreList(GAMESTATE:GetCurrentSong(),GAMESTATE:GetCurrentSteps(PLAYER_1));
						local scores = scorelist:GetHighScores();
						local topscore = scores[1];
						if topscore then
						--	if topscore >= stagemaxscore then		--temporary workaround
						--		pscore = stagemaxscore
						--	else
								pscore = topscore:GetScore();
						--	end
						else
							pscore = "0";
						end
						local percen = tonumber(string.format("%.03f",((pscore/stagemaxscore)*100)));
						if topscore then
							--self:settext(pscore.." - "..percen.."%");
							self:settext(pscore);
						else
							self:settext("0");
						end;
					end;
				end;
			};
			LoadFont("monsterrat/_montserrat semi bold 60px")..{	--Machine Top Score HOLDER (name)
				InitCommand=cmd(x,-infx-txxtune;y,-infy+txytune+10+3+20+75+12+15;addy,5;zoom,0.25;skewx,-0.25;horizalign,right;vertalign,top;queuecommand,"Set";);
				CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
				CurrentStepsP1ChangedMessageCommand=cmd(queuecommand,"Set");
				PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1);queuecommand,"Set");
				SetCommand=function(self)
					if GAMESTATE:GetCurrentSong() and GAMESTATE:IsPlayerEnabled(PLAYER_1) then
						profile = PROFILEMAN:GetMachineProfile();
						scorelist = profile:GetHighScoreList(GAMESTATE:GetCurrentSong(),GAMESTATE:GetCurrentSteps(PLAYER_1));
						local scores = scorelist:GetHighScores();
						local topscore = scores[1];
						
						if topscore then
							text = topscore:GetName();
						else
							text = "No Score";
						end
			
						self:diffusealpha(1);
						if text=="EVNT" then
							self:settext("Score holder: MACHINE BEST");
						elseif text == "#P1#" or text == "" then
							self:settext("Score holder: "..PROFILEMAN:GetProfile(PLAYER_1):GetDisplayName());
						else
							self:settext(text);
						end
						--TEMP:
						self:settext("BEST GRADE:");
					end;
				end;
			};
			
			Def.Sprite {
	InitCommand=cmd(x,-infx-txxtune;y,-infy+txytune+10+3+20+75+12+15+15;addy,10;zoom,0.15;horizalign,right;vertalign,top;queuecommand,"Set";);
	CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
	CurrentStepsP1ChangedMessageCommand=cmd(queuecommand,"Set");
	PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1);queuecommand,"Set");
	SetCommand=function(self)
	local song = GAMESTATE:GetCurrentSong();
		if song then
			self:diffusealpha(1);
			profile = PROFILEMAN:GetMachineProfile();
			scorelist = profile:GetHighScoreList(GAMESTATE:GetCurrentSong(),GAMESTATE:GetCurrentSteps(PLAYER_1));
			assert(scorelist);
			local scores = scorelist:GetHighScores();
			local topscore = scores[1];
			
				if topscore then 
							
							local dancepoints = topscore:GetPercentDP()*100
							local misses = topscore:GetTapNoteScore("TapNoteScore_Miss")+topscore:GetTapNoteScore("TapNoteScore_CheckpointMiss")
							local grade;

					if dancepoints >= 50 then
						grade = "D";
						if dancepoints >= 60 then
							grade = "C";
							if dancepoints >= 70 then
								grade = "B";
								if dancepoints >= 80 then
									grade = "A";
									if misses==0 then
										grade = "S_normal";
										if dancepoints >= 99 then
											grade = "S_plus";
											if dancepoints == 100 then
												grade = "S_S";
											end
										end
									end
								end	
							end
						end
					else 
						grade = "F";
					end

				self:Load(THEME:GetPathG("","GradeDisplayEval/"..grade));
			else
				--if no score
				self:diffusealpha(0);
			end
		else
			--if no song
			self:diffusealpha(0);
		end;
	end;
	};
		};

		Def.Quad{		--White for Chart info P1 EFFECT JOINED
			InitCommand=function(self)
				if GAMESTATE:IsHumanPlayer(PLAYER_1) then
					self:visible(false);
				else
					self:visible(true);
				end;
				(cmd(horizalign,right;fadetop,infft;fadebottom,inffb;x,-infx;y,-infy;
					 zoomto,bqwid,bqalt-redu;diffuse,1,1,1,0;blend,'BlendMode_Add';))(self)
			end;
			PlayerJoinedMessageCommand=function(self)
				(cmd(zoomy,(bqalt-redu)*1.25;diffuse,1,1,1,1;decelerate,0.75;zoomy,(bqalt-redu)*0.925;diffuse,1,1,1,0))(self)
			end;
		};
	};
	
	--[[Def.ActorFrame{		--P2 info display set
		InitCommand=cmd(x,SCREEN_RIGHT;y,_screen.cy+110);
		SongChosenMessageCommand=cmd(stoptweening;decelerate,0.125;x,_screen.cx);
		SongUnchosenMessageCommand=cmd(stoptweening;accelerate,0.125*1.5;x,SCREEN_RIGHT;);
		Def.Quad{		--white quad for Difficulties
			InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2) or GAMESTATE:IsHumanPlayer(PLAYER_1);horizalign,right;zoomto,wqwid,35;diffuse,1,1,1,0.75;x,_screen.cx;y,-3;faderight,1;);
			PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2) or GAMESTATE:IsHumanPlayer(PLAYER_1));
		};
		Def.Quad{		--Black quad for Chart info P2
			InitCommand=cmd(horizalign,left;fadetop,infft;fadebottom,inffb;x,infx;y,-infy+20;
							zoomto,bqwid*2,bqalt+50;diffuse,0,0,0,bqalph;);
		};
		
		LoadActor("p2_info")..{		--P2 INFO
			InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2);horizalign,right;zoomto,250,45;x,320;y,-235;fadeleft,1;);
			PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2));
		};
		
		LoadActor("ready")..{		--P2 READY
			InitCommand=cmd(visible,false;horizalign,center;x,260;y,-150);
			StepsChosenMessageCommand=function(self,param)
				if param.Player == PLAYER_2 and GAMESTATE:GetNumSidesJoined() == 2 then
					self:visible(GAMESTATE:IsHumanPlayer(PLAYER_2));
				end;
			end;
			StepsUnchosenMessageCommand=cmd(visible,false);
			SongUnchosenMessageCommand=cmd(visible,false);
			CurrentStepsP2ChangedMessageCommand=cmd(visible,false);
		};
		
		LoadFont("bebas/_bebas neue bold 90px")..{		--"NOT PRESENT" text
			Text="NOT PRESENT";
			InitCommand=cmd(visible,not GAMESTATE:IsHumanPlayer(PLAYER_2);x,_screen.cx*0.7;y,-infy;zoom,0.3;skewx,-0.2);
			PlayerJoinedMessageCommand=cmd(visible,not GAMESTATE:IsHumanPlayer(PLAYER_2););
		};
		Def.ActorFrame{		--Chart Info and more for P2
		InitCommand=cmd(y,-diffy);
			LoadFont("monsterrat/_montserrat semi bold 60px")..{	--Artist text
				InitCommand=cmd(x,120;y,-170;zoom,0.215;uppercase,true;maxwidth,400);
				PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2);queuecommand,"CurrentStepsP2ChangedMessage");
				CurrentStepsP2ChangedMessageCommand=function(self)
				--	local author = GAMESTATE:GetCurrentSteps(PLAYER_2):GetAuthorCredit()	--this is the Thor that is the auThor... lol get it? yes but... ah ok...
					if GAMESTATE:IsCourseMode() and GetCourseDescription(GAMESTATE:GetCurrentCourse():GetCourseDir(),"DESCRIPTION") ~= "" then
						author = GAMESTATE:GetCurrentCourse():GetScripter();
						if author == "" then
								artist = "Come on, how irresponsible could you be\nto not include the step artist name?"
								self:maxwidth(1000);
							else
								if DoDebug then		--what is code and/or stepmania... without jokes? (only for p1)
									if author == "C.Cortes" then
										artist = "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW"
									elseif author == "F.Rodriguez" then
										artist = "I LIEK TURTLES"
									else
										artist = author
									end
								else
									artist = author
								end
							end
							self:visible(GAMESTATE:IsHumanPlayer(PLAYER_1));
							self:settext(artist);
					else

					if GAMESTATE:GetCurrentSteps(PLAYER_2) then
						local author = GAMESTATE:GetCurrentSteps(PLAYER_2):GetAuthorCredit();	--this is the Thor that is the auThor... lol get it? yes but... ah ok...
						if GAMESTATE:GetCurrentSong() then		--set text display
							if author == "" then
								artist = "Come on, how irresponsible could you be\nto not include the step artist name?"
								self:maxwidth(1000);
							else
								if DoDebug then		--what is code and/or stepmania... without jokes?
									if author == "C.Cortes" then
										artist = "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW"
									elseif author == "F.Rodriguez" then
										artist = "I LIEK TURTLES"
									else
										artist = author
									end
								else
									artist = author
								end
							end
							self:visible(GAMESTATE:IsHumanPlayer(PLAYER_2));
							self:settext(artist);
						else
							self:visible(false);
						end;
					end;
					end;
				end;
			};


			LoadFont("Common normal")..{
				Text="Song List:";
				InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2);x,infx+txxtune;y,-infy+txytune+25;zoom,0.5;skewx,-0.25;horizalign,left;vertalign,top;);
				PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2));
				OnCommand=function(self)
					if GAMESTATE:IsCourseMode() then
						self:settext("Song List:")
					else
						self:settext("");
					end;
				end;
			};


			LoadFont("Common normal")..{--"Song list from current course"
				Text="";
				InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2);x,infx+txxtune;y,-infy+txytune+70;zoom,0.4;horizalign,left;vertalign,middle;);
				PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2));
				OnCommand=function(self)
					list = GetCourseDescription(THEME:GetCurrentThemeDirectory().."BGAnimations/ScreenSelectCourse decorations/courses_list.txt","SONG1").."\n"..GetCourseDescription(THEME:GetCurrentThemeDirectory().."BGAnimations/ScreenSelectCourse decorations/courses_list.txt","SONG2").."\n"..GetCourseDescription(THEME:GetCurrentThemeDirectory().."BGAnimations/ScreenSelectCourse decorations/courses_list.txt","SONG3").."\n"..GetCourseDescription(THEME:GetCurrentThemeDirectory().."BGAnimations/ScreenSelectCourse decorations/courses_list.txt","SONG4");
					if GAMESTATE:IsCourseMode() then
						self:settext(list)
					else
						self:settext("");
					end;
				end;
			};

			LoadFont("monsterrat/_montserrat semi bold 60px")..{								--SPEEDMOD Display
				InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2);x,infx+txxtune;addx,100;y,-infy+txytune+10+3+20;zoom,0.185;addy,26.25;vertalign,top;maxwidth,900);
				OnCommand=function(self)
					local profilep = PROFILEMAN:GetProfileDir("ProfileSlot_Player2")
					local song = GAMESTATE:GetCurrentSong();
					-- ROAD24: more checks
					if song then
						local songpath = song:GetSongDir()
						local pathlastsmod = File.Read(profilep.."RIO_SongData"..songpath.."LastSpeedModUsed.txt")
						local lastspeedmod = pathlastsmod
						if lastspeedmod == nil then		--account for nil value
							lastspeedmod = "N/A"
						end;
						local xmod = GAMESTATE:GetPlayerState(PLAYER_2):GetCurrentPlayerOptions():XMod();
						local cmod = GAMESTATE:GetPlayerState(PLAYER_2):GetCurrentPlayerOptions():CMod();
						local mmod = GAMESTATE:GetPlayerState(PLAYER_2):GetCurrentPlayerOptions():MMod();
						local rawbpm = GAMESTATE:GetCurrentSong():GetDisplayBpms();
						--GetDisplayBpms always returns two values (lowest and highest) regardless if the song has only one BPM it repeats to both values.
						--%.1f --se cambia el numero para mas decimales
						--local lobpm = tonumber(string.format("%.0f",rawbpm[1]));
						--local hibpm = tonumber(string.format("%.0f",rawbpm[2]));
						local lobpm = math.ceil(rawbpm[1]);
						local hibpm = math.ceil(rawbpm[2]);
						if cmod then
							curmod = "C Mod "..cmod
							speedvalue = cmod
						elseif mmod then
							curmod = "M Mod "..mmod
							speedvalue = mmod
						else
							curmod = xmod.."x"
							if lobpm == hibpm then
								speedvalue = lobpm*xmod
							else
								speedvalue = lobpm*xmod.." - "..hibpm*xmod
							end;
						end;
						self:visible(GAMESTATE:IsHumanPlayer(PLAYER_2));
						self:settext("PREVIOUS SPEEDMOD: "..lastspeedmod.."\nCURRENT SPEEDMOD: "..curmod.."\nSPEED DISPLAY (BPM*MOD): "..speedvalue);
						--	self:settext("Speed Modifier:\n"..curmod.."\nSpeed display (BPM X Mod):\n"..speedvalue);
					end;
				end;
				PlayerJoinedMessageCommand=cmd(finishtweening;playcommand,"On";);
				CurrentSongChangedMessageCommand=cmd(finishtweening;playcommand,"On";);
				CodeMessageCommand=cmd(finishtweening;playcommand,"On";);
				OptionsListClosedMessageCommand=cmd(finishtweening;playcommand,"On";);
				SongChosenMessageCommand=cmd(finishtweening;playcommand,"On";);
			};
			LoadFont("monsterrat/_montserrat semi bold 60px")..{							--Machine Top Score (numbers)
				InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2);x,infx+txxtune;y,-infy+txytune+123;addy,5;zoom,0.25;skewx,-0.25;horizalign,left;vertalign,top;queuecommand,"Set";);
				CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
				CurrentStepsP2ChangedMessageCommand=cmd(queuecommand,"Set");
				PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2);queuecommand,"Set");
				SetCommand=function(self)
					local cursong =	GAMESTATE:GetCurrentSong();
					-- ROAD24: Checks
					-- TODO: decide what to do whe no son g is selected
					if cursong ~= nil then
						if cursong:IsLong() then
							stagemaxscore = 200000000
						elseif cursong:IsMarathon() then
							stagemaxscore = 300000000
						else
							stagemaxscore = 100000000
						end
						profile = PROFILEMAN:GetMachineProfile();
						-- ROAD24: agrego algunas cosas para evitar acceder un nil
						local CurSteps = GAMESTATE:GetCurrentSteps(PLAYER_2);
						local CurSong = GAMESTATE:GetCurrentSong();
						if CurSteps and CurSong then
							scorelist = profile:GetHighScoreList(CurSong,CurSteps);
							local scores = scorelist:GetHighScores();
							local topscore = scores[1];
							if topscore then
							--	if topscore >= stagemaxscore then		--temporary workaround
							--		pscore = stagemaxscore
							--	else
									pscore = topscore:GetScore();
							--	end
							else
								pscore = "0";
							end
							local percen = tonumber(string.format("%.03f",((pscore/stagemaxscore)*100)));
							if topscore then
								--self:settext(pscore.." - "..percen.."%");
								self:settext(pscore);
							else
								self:settext("0");
							end;
						else
							self:settext("0");
						end;
					end;
				end
			};
			LoadFont("monsterrat/_montserrat semi bold 60px")..{	--Machine Top Score HOLDER (name)
				InitCommand=cmd(x,infx+txxtune;y,-infy+txytune+10+3+20+75+12+15;addy,5;zoom,0.25;skewx,-0.25;horizalign,left;vertalign,top;queuecommand,"Set";);
				CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
				CurrentStepsP2ChangedMessageCommand=cmd(queuecommand,"Set");
				PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2);queuecommand,"Set");
				SetCommand=function(self)
					if GAMESTATE:GetCurrentSong() then
						profile = PROFILEMAN:GetMachineProfile();
						-- ROAD24: more checks
						local CurSteps = GAMESTATE:GetCurrentSteps(PLAYER_2);
						local CurSong	= GAMESTATE:GetCurrentSong();
						if CurSteps then
							scorelist = profile:GetHighScoreList(CurSong,CurSteps);
							local scores = scorelist:GetHighScores();
							local topscore = scores[1];
						
						if topscore then
							text = topscore:GetName();
						else
							text = "No Score";
						end
			
						self:diffusealpha(1);
						if text=="EVNT" then
							self:settext("Score holder: MACHINE BEST");
						elseif text == "#P2#" or text == "" then
							self:settext("Score holder: "..PROFILEMAN:GetProfile(PLAYER_2):GetDisplayName());
						else
							self:settext(text);
						end
						--TEMP:
						self:settext("BEST GRADE:");
					end;
					end;
				end;
			};
			
					Def.Sprite {
	InitCommand=cmd(x,infx+txxtune;y,-infy+txytune+10+3+20+75+12+15+15;addy,10;zoom,0.15;horizalign,left;vertalign,top;queuecommand,"Set";);
	CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
	CurrentStepsP2ChangedMessageCommand=cmd(queuecommand,"Set");
	PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2);queuecommand,"Set");
	SetCommand=function(self)
	local song = GAMESTATE:GetCurrentSong();
		if song then
			self:diffusealpha(1);
			profile = PROFILEMAN:GetMachineProfile();
			scorelist = profile:GetHighScoreList(GAMESTATE:GetCurrentSong(),GAMESTATE:GetCurrentSteps(PLAYER_2));
			assert(scorelist);
			local scores = scorelist:GetHighScores();
			local topscore = scores[1];
			
				if topscore then 
							
							local dancepoints = topscore:GetPercentDP()*100
							local misses = topscore:GetTapNoteScore("TapNoteScore_Miss")+topscore:GetTapNoteScore("TapNoteScore_CheckpointMiss")
							local grade;

					if dancepoints >= 50 then
						grade = "D";
						if dancepoints >= 60 then
							grade = "C";
							if dancepoints >= 70 then
								grade = "B";
								if dancepoints >= 80 then
									grade = "A";
									if misses==0 then
										grade = "S_normal";
										if dancepoints >= 99 then
											grade = "S_plus";
											if dancepoints == 100 then
												grade = "S_S";
											end
										end
									end
								end	
							end
						end
					else 
						grade = "F";
					end

				self:Load(THEME:GetPathG("","GradeDisplayEval/"..grade));
			else
				--if no score
				self:diffusealpha(0);
			end
		else
			--if no song
			self:diffusealpha(0);
		end;
	end;
	};
		};
		Def.Quad{		--White for Chart info P2 EFFECT JOINED
			InitCommand=function(self)
				if GAMESTATE:IsHumanPlayer(PLAYER_2) then
					self:visible(false);
				else
					self:visible(true);
				end;
				(cmd(horizalign,left;fadetop,infft;fadebottom,inffb;x,infx;y,-infy;
					 zoomto,bqwid,bqalt-redu;diffuse,1,1,1,0;blend,'BlendMode_Add';))(self)
			end;
			PlayerJoinedMessageCommand=function(self)
				(cmd(zoomy,(bqalt-redu)*1.25;diffuse,1,1,1,1;decelerate,0.75;zoomy,(bqalt-redu)*0.925;diffuse,1,1,1,0))(self)
			end;
		};
	};
]]
};

--[[t[#t+1] = Def.ActorFrame{

	LoadActor(THEME:GetPathG("","DifficultyDisplay"))..{
		InitCommand=cmd(xy,SCREEN_CENTER_X,165);
	};
};]]
--Difficulty List Orbs Shadows
for i=1,12 do
	t[#t+1] = LoadActor("DifficultyList/background_orb") .. {
		InitCommand=cmd(diffusealpha,0.5;zoom,0.7;x,_screen.cx-245+i*35;y,_screen.cy+107;horizalign,left);
	};
end;
--Difficulty List Orbs
t[#t+1] = Def.ActorFrame{			
	LoadActor("DifficultyList")..{
		OnCommand=cmd(finishtweening;sleep,0.1;playcommand,"Update");
		UpdateCommand=function(self)
			local song = GAMESTATE:GetCurrentSong();
			if song then
				self:stoptweening();
				self:rotationz(270);
				self:linear(0.1);
				self:x(_screen.cx-187);
				self:y(_screen.cy+105);
				self:zoom(0.7);
			end;
		end;
		TwoPartConfirmCanceledMessageCommand=cmd(finishtweening;playcommand,"SongUnchosenMessage");
		SongUnchosenMessageCommand=cmd(stoptweening;decelerate,0.1;playcommand,"Update");
		PlayerJoinedMessageCommand=cmd(finishtweening;playcommand,"Update");
		CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Update");
		CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Update");
		CurrentSongChangedMessageCommand=cmd(finishtweening;playcommand,"Update");

	};
}

--READY BANNER

--[[t[#t+1] = Def.ActorFrame{

	InitCommand=cmd(xy,SCREEN_CENTER_X,SCREEN_HEIGHT*.8);

	LoadActor("rdy_add")..{
		InitCommand=cmd(y,-20;diffusealpha,0;zoom,0.8;draworder,100;blend,Blend.Multiply;);
		SongChosenMessageCommand=cmd(stoptweening;linear,0.15;diffusealpha,1);
		TwoPartConfirmCanceledMessageCommand=cmd(stoptweening;linear,0.15;diffusealpha,0);
		SongUnchosenMessageCommand=cmd(stoptweening;linear,0.15;diffusealpha,0);
	};

	LoadActor("rdy_add")..{
		InitCommand=cmd(y,-20;zoom,0.8;diffusealpha,0;draworder,100;blend,Blend.Add;);
		SongChosenMessageCommand=cmd(stoptweening;linear,0.15;diffusealpha,1);
		TwoPartConfirmCanceledMessageCommand=cmd(stoptweening;linear,0.15;diffusealpha,0);
		SongUnchosenMessageCommand=cmd(stoptweening;linear,0.15;diffusealpha,0);
	};


	LoadActor("rdy_sub")..{
		InitCommand=cmd(y,17;zoom,0.75;diffusealpha,0;draworder,100;diffuse,0,0,0,0);
		SongChosenMessageCommand=cmd(stoptweening;linear,0.15;y,SCREEN_CENTER_Y+17;diffusealpha,1);
		TwoPartConfirmCanceledMessageCommand=cmd(stoptweening;linear,0.15;y,SCREEN_CENTER_Y+37;diffusealpha,0);
		SongUnchosenMessageCommand=cmd(stoptweening;linear,0.15;y,SCREEN_CENTER_Y+37;diffusealpha,0);
	};




	LoadActor("rdy_logo")..{
		InitCommand=cmd(x,3;y,-42;zoom,0.4;draworder,100;thump;effectperiod,2;;diffuse,0,0,0,0;diffusetopedge,0.25,0.25,0.25,0);
		SongChosenMessageCommand=cmd(stoptweening;linear,0.2;;diffusealpha,1);
		TwoPartConfirmCanceledMessageCommand=cmd(stoptweening;linear,0.2;diffusealpha,0;);
		SongUnchosenMessageCommand=cmd(stoptweening;linear,0.2;diffusealpha,0;);
	};
	
	LoadActor(THEME:GetPathG("", "_press "..GAMESTATE:GetCurrentGame():GetName().. " 5x2"))..{
		Frames = Sprite.LinearFrames(10,.3);
		InitCommand=cmd(x,-110;y,-64;zoom,0.45;visible,false;draworder,100);
		SongChosenMessageCommand=cmd(setstate,0;visible,true);
		TwoPartConfirmCanceledMessageCommand=cmd(visible,false);
		SongUnchosenMessageCommand=cmd(visible,false);
	};
	LoadActor(THEME:GetPathG("", "_press "..GAMESTATE:GetCurrentGame():GetName().. " 5x2"))..{
		Frames = Sprite.LinearFrames(10,.3);
		InitCommand=cmd(x,110;y,-64;zoom,0.45;visible,false;draworder,100);
		SongChosenMessageCommand=cmd(setstate,0;visible,true);
		TwoPartConfirmCanceledMessageCommand=cmd(visible,false);
		SongUnchosenMessageCommand=cmd(visible,false);
	};

}]]

--TODO: Fix PlayerJoinedMessageCommand, put it inside the above actorframe (with better error handling)
if GAMESTATE:IsSideJoined(PLAYER_1) then
	t[#t+1] = LoadActor(THEME:GetPathG("","PlayerSteps"), PLAYER_1)..{
		InitCommand=cmd(draworder,100;xy,SCREEN_CENTER_X-135,SCREEN_HEIGHT*.77;visible,false);
		SongChosenMessageCommand=cmd(visible,true);
		TwoPartConfirmCanceledMessageCommand=cmd(visible,false);
		SongUnchosenMessageCommand=cmd(visible,false);
		--OnCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1));
		--PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1));
		--CurrentStepsP1ChangedMessageCommand=cmd(stoptweening;diffusealpha,0;zoomx,0;decelerate,0.075;zoomx,1;diffusealpha,1);
	}
end;

if GAMESTATE:IsSideJoined(PLAYER_2) then
	t[#t+1] = LoadActor(THEME:GetPathG("","PlayerSteps"), PLAYER_2)..{
		InitCommand=cmd(draworder,100;xy,SCREEN_CENTER_X+80,SCREEN_HEIGHT*.77;visible,false);
		SongChosenMessageCommand=cmd(visible,true);
		TwoPartConfirmCanceledMessageCommand=cmd(visible,false);
		SongUnchosenMessageCommand=cmd(visible,false);
		--OnCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2));
		--PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2));
		--CurrentStepsP2ChangedMessageCommand=cmd(stoptweening;zoomx,0;diffusealpha,0;decelerate,0.075;zoomx,1;diffusealpha,1);
	}
end;

return t;