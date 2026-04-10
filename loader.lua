local Gui = Instance.new("ScreenGui")
Gui.Name = "HubLoader"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.Parent = game.Players.LocalPlayer.PlayerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0,400,0,300)
Frame.Position = UDim2.new(0.5,-200,0.5,-150)
Frame.BackgroundColor3 = Color3.fromRGB(18,10,10)
Frame.BorderSizePixel = 0
Frame.Parent = Gui
Instance.new("UICorner",Frame).CornerRadius = UDim.new(0,12)

local Title = Instance.new("TextLabel",Frame)
Title.Size = UDim2.new(1,0,0,50)
Title.BackgroundTransparency = 1
Title.Text = "Hub da Zueira — Escolhe a versão"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold

local base = "https://raw.githubusercontent.com/afonsomiguelito13-collab/Hub-da-zueira-1.0/main/"

local versions = {
    {name="v1 — Stable", desc="UI custom, tweens, executor", url=base.."main.lua"},
    {name="v2 — Redz Lib", desc="Versão com Redz Library", url=base.."v2.lua"},
    {name="Open Source", desc="Script comunidade", url=base.."opensource.lua"},
}

local layout = Instance.new("UIListLayout",Frame)
layout.Padding = UDim.new(0,8)
layout.SortOrder = Enum.SortOrder.LayoutOrder

local pad = Instance.new("UIPadding",Frame)
pad.PaddingTop = UDim.new(0,60)
pad.PaddingLeft = UDim.new(0,16)
pad.PaddingRight = UDim.new(0,16)

for i,v in ipairs(versions) do
    local btn = Instance.new("TextButton",Frame)
    btn.Size = UDim2.new(1,0,0,60)
    btn.BackgroundColor3 = Color3.fromRGB(25,12,12)
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.LayoutOrder = i
    Instance.new("UICorner",btn).CornerRadius = UDim.new(0,8)

    local nm = Instance.new("TextLabel",btn)
    nm.Size = UDim2.new(1,0,0,28)
    nm.Position = UDim2.new(0,12,0,6)
    nm.BackgroundTransparency = 1
    nm.Text = v.name
    nm.TextColor3 = Color3.fromRGB(180,50,50)
    nm.TextSize = 14
    nm.Font = Enum.Font.GothamBold
    nm.TextXAlignment = Enum.TextXAlignment.Left

    local desc = Instance.new("TextLabel",btn)
    desc.Size = UDim2.new(1,0,0,20)
    desc.Position = UDim2.new(0,12,0,32)
    desc.BackgroundTransparency = 1
    desc.Text = v.desc
    desc.TextColor3 = Color3.fromRGB(130,100,100)
    desc.TextSize = 11
    desc.Font = Enum.Font.Gotham
    desc.TextXAlignment = Enum.TextXAlignment.Left

    local url = v.url
    btn.MouseButton1Click:Connect(function()
        Gui:Destroy()
        loadstring(game:HttpGet(url))()
    end)
end
