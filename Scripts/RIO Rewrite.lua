ToBoolean = function(value) if value == "true" then return true else return false end end

RIO = {}

RIO.Noteskin = 1
RIO.NoteskinsEnabled = false
RIO.NoteskinList = {}

RIO.Config = function(Key,Value)
	local Ret = Config.Load(Key,THEME:GetCurrentThemeDirectory().."/Config.ini")
	if Ret then return Ret end
	Config.Save(Key,Value,THEME:GetCurrentThemeDirectory().."/Config.ini")
	return Value
end

RIO.LoadNoteskins = function()
	for _,v in ipairs(NOTESKIN:GetNoteSkinNames()) do
		local ToAdd = true
		for DisabledSkin in string.gmatch(RIO.Config("DisabledNoteskins","delta-routine-p1,delta-routine-p2,cmd-routine-p1,cmd-routine-p2,routine-p1,routine-p2,rio-p1,rio-p2,rio-p3,rio-p4,rio-p5,perfor1,perfor2,perfor3,_disabled")..",", "(.-),") do
			if v == DisabledSkin then ToAdd = false end
		end
		if ToAdd then RIO.NoteskinList[#RIO.NoteskinList+1] = v end
	end
end	

RIO.DoDebug = ToBoolean(RIO.Config("DebugMode","false"))
RIO.InternalName = RIO.Config("InternalName","RIOS2")
RIO.Version = RIO.Config("Version","Storm 2019")
RIO.ScreenInRatio =  RIO.Config("FadeInRatio",0.25)
RIO.AnimationInLength = RIO.Config("FadeInTween",0.25)
RIO.ScreenOutRatio =  RIO.Config("FadeOutRatio",0.25)
RIO.AnimationOutLength = RIO.Config("FadeOutTween",0.25)


RIO.TitleMenu = function()
	if GAMESTATE:GetCoinMode() == "CoinMode_Home" then
		return "RIOScreenTitleMenu"
	end
	if GAMESTATE:GetCoinsNeededToJoin() > GAMESTATE:GetCoins() then
		return "RIOScreenTitleJoin"
	else
		return "RIOScreenTitleJoin"
	end
end

RIO.AfterInit = function()
	if GAMESTATE:GetCoinMode() == 'CoinMode_Home' then
		return RIO.TitleMenu()
	else
		return "RIOScreenInit"
	end
end

RIO.UnlockCheck = function(LockedSong)
	for _,song in ipairs(SONGMAN:GetAllSongs()) do
		if string.find(song:GetDisplayMainTitle(), LockedSong) then	
			return UNLOCKMAN:IsSongLocked(song)
		end
	end
	return -1
end

function RIO.Input(self)
	return function(event)
		if not event.PlayerNumber then return end
		self.pn = event.PlayerNumber		
		if ToEnumShortString(event.type) == "FirstPress" or ToEnumShortString(event.type) == "Repeat" then
			self:queuecommand(event.GameButton)			
		end
		if ToEnumShortString(event.type) == "Release" then
			self:queuecommand(event.GameButton.."Release")	
		end
	end
end

function RIO.NoteSkins()
	RIO.LoadNoteskins()
	local t = {
		Name="NoteskinsCustom",
		LayoutType="ShowAllInRow",
		SelectType="SelectOne",
		OneChoiceForAllPlayers=false,
		ExportOnChange=false,
		Choices=RIO.NoteskinList,
		LoadSelections=function(self, list, pn)
			for i=1,#list do
				if RIO.NoteskinList[i] == GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):NoteSkin() then
					list[i] = true
					return
				end
			end
			print("Noteskin Not Found!, Using first value as fallback.")
			list[1] = true
		end,
		SaveSelections=function(self, list, pn)
			for i=1,#list do
				if list[i] == true then
					GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):NoteSkin(RIO.NoteskinList[i]);
				end
			end
		end
	}
	setmetatable(t, t)
	return t
end