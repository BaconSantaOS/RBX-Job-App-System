local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BadgeService = game:GetService("BadgeService")

if not BadgeService then
	warn("BadgeService is not available! Badge awarding will not work.")
end

local Config = require(ReplicatedStorage.JobApp.Config)
local Questions = require(ReplicatedStorage.JobApp.Questions)

local SubmitAnswer = ReplicatedStorage.JobApp.Remotes.SubmitAnswer
local FinishApplication = ReplicatedStorage.JobApp.Remotes.FinishApplication

local BADGE_ID = 1234567890 -- Put your badge ID here.

local scores = {}
local answeredTracker = {}

Players.PlayerRemoving:Connect(function(player)
	local userId = player.UserId
	scores[userId] = nil
	answeredTracker[userId] = nil
end)

SubmitAnswer.OnServerEvent:Connect(function(player, qId, answer)
	local userId = player.UserId
	answeredTracker[userId] = answeredTracker[userId] or {}

	if answeredTracker[userId][qId] then return end

	scores[userId] = scores[userId] or 0

	for _, q in ipairs(Questions) do
		if q.Id == qId then
			answeredTracker[userId][qId] = true
			for _, correct in ipairs(q.CorrectAnswers) do
				if string.lower(tostring(answer)) == string.lower(tostring(correct)) then
					scores[userId] += q.Points
					break
				end
			end
		end
	end
end)

FinishApplication.OnServerEvent:Connect(function(player)
	local userId = player.UserId
	local score = scores[userId] or 0

	if score >= Config.PassScore then
		if BadgeService then
			local success, err = pcall(function()
				local hasBadge = BadgeService:UserHasBadgeAsync(userId, BADGE_ID)
				if not hasBadge then
					local badgeService = BadgeService :: BadgeService
					badgeService:AwardBadge(userId, BADGE_ID) -- Do not worry about the error blue line here it works.
					print("Awarded badge to " .. player.Name)
					player:Kick("You passed the job application. Please go to the main game and you will have your rank.")
				else
					print(player.Name .. " already has the badge")
					player:Kick("You already passed the job application.")
				end
			end)

			if not success then 
				warn("Badge Error for " .. player.Name .. ": " .. tostring(err)) 
				print("Player " .. player.Name .. " passed but badge awarding failed")
			end
		else
			warn("BadgeService not available - cannot award badge to " .. player.Name)
		end
	else
		local msg = "\n--- APPLICATION FAILED ---\n\n" ..
			"Score: " .. score .. " / " .. Config.PassScore .. "\n" ..
			"Status: Denied\n\n" ..
			"Please study the requirements and try again!"

		task.wait(0.5)
		player:Kick(msg)
	end

	scores[userId] = nil
	answeredTracker[userId] = nil
end)
