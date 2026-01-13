local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local Config = require(ReplicatedStorage.JobApp.Config)
local Questions = require(ReplicatedStorage.JobApp.Questions)

local SubmitAnswer = ReplicatedStorage.JobApp.Remotes.SubmitAnswer
local FinishApplication = ReplicatedStorage.JobApp.Remotes.FinishApplication

local gui = script.Parent.Parent
local mainFrame = script.Parent

local THEME_COLOR = Color3.fromRGB(0, 170, 255)
local BG_COLOR = Color3.fromRGB(25, 25, 30)
local ACCENT_COLOR = Color3.fromRGB(40, 40, 45)
local TEXT_COLOR = Color3.fromRGB(255, 255, 255)


mainFrame.BackgroundColor3 = BG_COLOR
mainFrame.Size = UDim2.new(0, 450, 0, 550)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame:ClearAllChildren()

local function createPadding(parent, amount)
	local p = Instance.new("UIPadding", parent)
	p.PaddingBottom = UDim.new(0, amount)
	p.PaddingTop = UDim.new(0, amount)
	p.PaddingLeft = UDim.new(0, amount)
	p.PaddingRight = UDim.new(0, amount)
end


Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 16)
local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = THEME_COLOR
stroke.Thickness = 2
stroke.Transparency = 0.5


local progBg = Instance.new("Frame", mainFrame)
progBg.Size = UDim2.new(1, 0, 0, 4)
progBg.BackgroundColor3 = ACCENT_COLOR
progBg.BorderSizePixel = 0
local progBar = Instance.new("Frame", progBg)
progBar.Size = UDim2.new(0, 0, 1, 0)
progBar.BackgroundColor3 = THEME_COLOR
progBar.BorderSizePixel = 0


local content = Instance.new("Frame", mainFrame)
content.Size = UDim2.new(1, 0, 1, -10)
content.BackgroundTransparency = 1
createPadding(content, 25)

local currentQuestion = 1


local function hoverEffect(obj)
	obj.MouseEnter:Connect(function()
		TweenService:Create(obj, TweenInfo.new(0.2), {BackgroundColor3 = THEME_COLOR}):Play()
	end)
	obj.MouseLeave:Connect(function()
		TweenService:Create(obj, TweenInfo.new(0.2), {BackgroundColor3 = ACCENT_COLOR}):Play()
	end)
end

local function showQuestion(q)
	content:ClearAllChildren()

	local progress = currentQuestion / #Questions
	TweenService:Create(progBar, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {Size = UDim2.new(progress, 0, 1, 0)}):Play()
	local qText = Instance.new("TextLabel", content)
	qText.Size = UDim2.new(1, 0, 0, 80)
	qText.Text = q.Question
	qText.Font = Enum.Font.GothamBold
	qText.TextSize = 22
	qText.TextColor3 = TEXT_COLOR
	qText.TextWrapped = true
	qText.BackgroundTransparency = 1
	qText.TextXAlignment = Enum.TextXAlignment.Left

	local list = Instance.new("Frame", content)
	list.Position = UDim2.new(0, 0, 0, 100)
	list.Size = UDim2.new(1, 0, 1, -100)
	list.BackgroundTransparency = 1

	local layout = Instance.new("UIListLayout", list)
	layout.Padding = UDim.new(0, 12) 
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.SortOrder = Enum.SortOrder.LayoutOrder

	if q.Type == "Choice" then
		for _, opt in ipairs(q.Options) do
			local btn = Instance.new("TextButton", list)
			btn.Size = UDim2.new(1, 0, 0, 50)
			btn.BackgroundColor3 = ACCENT_COLOR
			btn.Text = opt
			btn.Font = Enum.Font.Gotham
			btn.TextColor3 = TEXT_COLOR
			btn.TextSize = 16
			Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
			hoverEffect(btn)

			btn.MouseButton1Click:Connect(function()
				SubmitAnswer:FireServer(q.Id, opt)
				nextStep()
			end)
		end
	else
		local input = Instance.new("TextBox", list)
		input.Size = UDim2.new(1, 0, 0, 120)
		input.BackgroundColor3 = ACCENT_COLOR
		input.PlaceholderText = "Type your response here..."
		input.Text = ""
		input.Font = Enum.Font.Gotham
		input.TextColor3 = TEXT_COLOR
		input.TextSize = 16
		input.TextWrapped = true
		input.ClearTextOnFocus = false
		input.TextYAlignment = Enum.TextYAlignment.Top
		Instance.new("UICorner", input).CornerRadius = UDim.new(0, 8)
		createPadding(input, 12)

		local submit = Instance.new("TextButton", list)
		submit.Size = UDim2.new(1, 0, 0, 50)
		submit.BackgroundColor3 = THEME_COLOR
		submit.Text = "Continue"
		submit.Font = Enum.Font.GothamBold
		submit.TextColor3 = TEXT_COLOR
		Instance.new("UICorner", submit).CornerRadius = UDim.new(0, 8)

		submit.MouseButton1Click:Connect(function()
			if input.Text ~= "" then
				SubmitAnswer:FireServer(q.Id, input.Text)
				nextStep()
			end
		end)
	end
end

function nextStep()
	currentQuestion += 1
	if Questions[currentQuestion] then
		showQuestion(Questions[currentQuestion])
	else
		FinishApplication:FireServer()
		mainFrame:TweenPosition(UDim2.new(0.5, 0, 1.5, 0), "In", "Back", 0.5)
		task.wait(0.5)
		gui.Enabled = false
	end
end
mainFrame.Position = UDim2.new(0.5, 0, 1.2, 0)
mainFrame:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), "Out", "Back", 0.7)
showQuestion(Questions[currentQuestion])
