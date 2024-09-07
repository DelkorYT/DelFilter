local f = CreateFrame("frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, ...)
	if event == "ADDON_LOADED" then
		DelFiltered = DelFiltered or {}
		DelReplaced = DelReplaced or {}
		DelChannel = DelChannel or {}
	end
end)

local function myChatFilter(self, event, msg, author, ...)
	if event == "CHAT_MSG_BN_WHISPER" then
		return true
	end

	if DelFiltered[string.lower(msg)] then
		return true
	end

	local altMsg = msg
	for k, v in pairs(DelReplaced) do
		while true do
			local startPos, endPos = string.find(string.lower(altMsg), k)
			if startPos then
				local first = string.sub(altMsg, 1, startPos - 1)
				local second = string.sub(altMsg, endPos + 1)

				altMsg = first .. v .. second
			else
				break
			end
		end
	end

	if not (altMsg == msg) then
		return false, altMsg, author, ...
	end
end

--SLASH_DELCHANNEL1 = "/delchannel"

--local function MyChannelCommands(msg, _)
--	local lowerMsg = string.lower(msg)

--end

--SlashCmdList["DELCHANNEL"] = MyChannelCommands

ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_WARNING", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_EMOTE", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_DND", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", myChatFilter)

SLASH_DELFILTER1, SLASH_DELFILTER2 = "/filter", "/delfilter"

local function MyFilterCommands(msg, _)
	if msg == "" then
		print("Please use the correct syntax:\n/filter <word-to-filter>")
		return
	end

	local lowerMsg = string.lower(msg)
	if DelFiltered[lowerMsg] == nil then
		DelFiltered[lowerMsg] = true
		print("[DelFilter]: '" .. lowerMsg .. "' (case insensitive) is now getting filtered")
	else
		DelFiltered[lowerMsg] = nil
		print("[DelFilter]: '" .. lowerMsg .. "' is no longer getting filtered")
	end
end

SlashCmdList["DELFILTER"] = MyFilterCommands

SLASH_DELREPLACE1, SLASH_DELREPLACE2 = "/replace", "/delreplace"

local function MyReplaceCommands(msg, _)
	if msg == "" then
		print("[DelFilter]: Please use the correct syntax:\n/replace <word-to-replace>;<word-to-show>")
		return
	end

	local toReplace, replaceWith = string.match(msg, "(%D+);(%D+)")
	if toReplace == nil then
		toReplace = msg
	end
	local lowerToReplace = string.lower(toReplace)

	if DelReplaced[lowerToReplace] == nil then
		DelReplaced[lowerToReplace] = replaceWith
		print(
			"[DelFilter]: '"
				.. lowerToReplace
				.. "' (case insensitive) is now getting replaced with '"
				.. replaceWith
				.. "'"
		)
	else
		DelReplaced[lowerToReplace] = nil
		print("[DelFilter]: '" .. lowerToReplace .. "' (case insensitive) is no longer getting replaced")
	end
end

SlashCmdList["DELREPLACE"] = MyReplaceCommands
