-- phong nè má x ASTA | premium
-- HITBOX + ESP 7 màu | gọn & ổn định

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LP = Players.LocalPlayer

-- ===== GUI =====
local gui = Instance.new("ScreenGui", game.CoreGui)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,260,0,210)
frame.Position = UDim2.new(0,70,0,200)
frame.BackgroundColor3 = Color3.fromRGB(10,10,10)
frame.Active, frame.Draggable = true, true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,26)

local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 2

task.spawn(function()
	local h=0
	while task.wait() do
		h=(h+2)%360
		stroke.Color=Color3.fromHSV(h/360,1,1)
	end
end)

local function text(t,y,s)
	local l=Instance.new("TextLabel",frame)
	l.Size=UDim2.new(1,0,0,s)
	l.Position=UDim2.new(0,0,0,y)
	l.BackgroundTransparency=1
	l.Text=t
	l.Font=Enum.Font.GothamBold
	l.TextSize=s
	l.TextColor3=Color3.new(1,1,1)
	return l
end

text("phong nè má x ASTA",6,14)
local sub=text("premium",26,11)
sub.TextColor3=Color3.fromRGB(180,180,180)

local function btn(t,y)
	local b=Instance.new("TextButton",frame)
	b.Size=UDim2.new(0,210,0,30)
	b.Position=UDim2.new(0.5,-105,0,y)
	b.Text=t
	b.Font=Enum.Font.GothamBold
	b.TextSize=13
	b.TextColor3=Color3.new(1,1,1)
	b.BackgroundColor3=Color3.fromRGB(20,20,20)
	Instance.new("UICorner",b).CornerRadius=UDim.new(0,14)
	return b
end

local hitBtn = btn("HITBOX : OFF", 52)
local espBtn = btn("ESP : OFF", 88)

local input = Instance.new("TextBox", frame)
input.Size=UDim2.new(0,210,0,28)
input.Position=UDim2.new(0.5,-105,0,124)
input.PlaceholderText="Hitbox size (vd: 10)"
input.Text="12"
input.Font=Enum.Font.Gotham
input.TextSize=12
input.TextColor3=Color3.new(1,1,1)
input.BackgroundColor3=Color3.fromRGB(20,20,20)
Instance.new("UICorner",input).CornerRadius=UDim.new(0,14)

-- 🐶 toggle menu
local dog=Instance.new("TextButton",gui)
dog.Size=UDim2.new(0,46,0,46)
dog.Position=UDim2.new(0,15,0,140)
dog.Text="🐶"
dog.TextSize=22
dog.BackgroundColor3=Color3.fromRGB(15,15,15)
dog.Active, dog.Draggable=true,true
Instance.new("UICorner",dog).CornerRadius=UDim.new(1,0)
dog.MouseButton1Click:Connect(function()
	frame.Visible=not frame.Visible
end)

-- ===== LOGIC =====
local HIT=false
local ESP=false
local SIZE=12
local original={}
local boxes={}
local hue=0

local function getHRP(p)
	return p.Character and p.Character:FindFirstChild("HumanoidRootPart")
end

for _,p in ipairs(Players:GetPlayers()) do
	if p~=LP then
		local b=Drawing.new("Square")
		b.Filled=false b.Thickness=2 b.Visible=false
		boxes[p]=b
	end
end

Players.PlayerAdded:Connect(function(p)
	if p~=LP then
		local b=Drawing.new("Square")
		b.Filled=false b.Thickness=2 b.Visible=false
		boxes[p]=b
	end
end)

Players.PlayerRemoving:Connect(function(p)
	if boxes[p] then boxes[p]:Remove() boxes[p]=nil end
end)

hitBtn.MouseButton1Click:Connect(function()
	HIT=not HIT
	hitBtn.Text=HIT and "HITBOX : ON" or "HITBOX : OFF"
	if not HIT then
		for p,s in pairs(original) do
			local hrp=getHRP(p)
			if hrp then hrp.Size=s hrp.Transparency=1 end
		end
	end
end)

espBtn.MouseButton1Click:Connect(function()
	ESP=not ESP
	espBtn.Text=ESP and "ESP : ON" or "ESP : OFF"
end)

input.FocusLost:Connect(function()
	local n=tonumber(input.Text)
	if n and n>=2 and n<=50 then SIZE=n end
end)

RunService.RenderStepped:Connect(function()
	hue=(hue+2)%360
	local col=Color3.fromHSV(hue/360,1,1)

	for p,b in pairs(boxes) do
		local hrp=getHRP(p)
		if ESP and hrp then
			local pos,vis=Camera:WorldToViewportPoint(hrp.Position)
			if vis then
				b.Visible=true
				b.Color=col
				b.Size=Vector2.new(42,62)
				b.Position=Vector2.new(pos.X-21,pos.Y-31)
			else b.Visible=false end
		else b.Visible=false end

		if HIT and hrp then
			original[p]=original[p] or hrp.Size
			hrp.Size=Vector3.new(SIZE,SIZE,SIZE)
			hrp.Transparency=0.5
			hrp.CanCollide=false
		end
	end
end)
