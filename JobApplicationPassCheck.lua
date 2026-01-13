local Players = game:GetService("Players")
local BadgeService = game:GetService("BadgeService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BADGE_ID = 1234567890 -- Your same badge ID that in Job Application Server Script.
local RANK_NAME = "Mod"-- The rank you want to give if they have the badge.


print("[HD CHECK] Waiting for HD Admin to load...")

while not _G.HDAdminMain do
	task.wait(0.1)
end

print("[HD CHECK] HD Admin MAIN detected!")

local hdMain = _G.HDAdminMain
local hd = hdMain:GetModule("API")

print("[HD CHECK] HD Admin API loaded successfully!")


local function tryRank(player)
	task.spawn(function()
		local success, hasBadge = pcall(function()
			return BadgeService:UserHasBadgeAsync(player.UserId, BADGE_ID)
		end)

		if not success then
			warn("[HD CHECK] Badge check failed for", player.Name)
			return
		end

		if hasBadge then
			print("[HD CHECK] Badge found for", player.Name, "→ ranking...")
			hd:SetRank(player, RANK_NAME, "Perm")
		else
			print("[HD CHECK] Player", player.Name, "does NOT have badge")
		end
	end)
end


Players.PlayerAdded:Connect(function(player)
	print("[HD CHECK] Player joined:", player.Name)
	tryRank(player)
end)


for _, player in ipairs(Players:GetPlayers()) do
	tryRank(player)
end

