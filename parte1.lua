local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

local ICONS = {
    hub="rbxassetid://10723407389", player="rbxassetid://6026568198",
    troll="rbxassetid://6035067836", teleport="rbxassetid://6026568220",
    anim="rbxassetid://6022668888", visao="rbxassetid://6035078856",
    settings="rbxassetid://6022668916", close="rbxassetid://6031094667",
    minus="rbxassetid://6031094678",
}

_G.HubGui = Instance.new("ScreenGui")
_G.HubGui.Name = "HubDaZueira"
_G.HubGui.ResetOnSpawn = false
_G.HubGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
_G.HubGui.IgnoreGuiInset = true
_G.HubGui.Parent = LP.PlayerGui

-- LOADING
local LF = Instance.new("Frame", _G.HubGui)
LF.Size = UDim2.new(1,0,1,0)
LF.BackgroundColor3 = Color3.fromRGB(10,5,5)
LF.BorderSizePixel = 0
LF.ZIndex = 100

local LIcon = Instance.new("ImageLabel", LF)
LIcon.Size = UDim2.new(0,80,0,80)
LIcon.Position = UDim2.new(0.5,-40,0.5,-80)
LIcon.BackgroundTransparency = 1
LIcon.Image = ICONS.hub
LIcon.ZIndex = 101

local LTitle = Instance.new("TextLabel", LF)
LTitle.Size = UDim2.new(0,300,0,35)
LTitle.Position = UDim2.new(0.5,-150,0.5,15)
LTitle.BackgroundTransparency = 1
LTitle.Text = "Hub da Zueira"
LTitle.TextColor3 = Color3.fromRGB(255,255,255)
LTitle.TextSize = 24
LTitle.Font = Enum.Font.GothamBold
LTitle.ZIndex = 101

local LSub = Instance.new("TextLabel", LF)
LSub.Size = UDim2.new(0,300,0,22)
LSub.Position = UDim2.new(0.5,-150,0.5,50)
LSub.BackgroundTransparency = 1
LSub.Text = "Carregando..."
LSub.TextColor3 = Color3.fromRGB(160,100,100)
LSub.TextSize = 14
LSub.Font = Enum.Font.Gotham
LSub.ZIndex = 101

local BBg = Instance.new("Frame", LF)
BBg.Size = UDim2.new(0,300,0,6)
BBg.Position = UDim2.new(0.5,-150,0.5,85)
BBg.BackgroundColor3 = Color3.fromRGB(40,20,20)
BBg.BorderSizePixel = 0
BBg.ZIndex = 101
Instance.new("UICorner", BBg).CornerRadius = UDim.new(1,0)

_G.BFill = Instance.new("Frame", BBg)
_G.BFill.Size = UDim2.new(0,0,1,0)
_G.BFill.BackgroundColor3 = Color3.fromRGB(180,50,50)
_G.BFill.BorderSizePixel = 0
_G.BFill.ZIndex = 102
Instance.new("UICorner", _G.BFill).CornerRadius = UDim.new(1,0)

_G.LSub = LSub
_G.LF = LF
_G.LIcon = LIcon

_G.iPulse = TweenService:Create(LIcon, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
    Size = UDim2.new(0,90,0,90),
    Position = UDim2.new(0.5,-45,0.5,-85)
})
_G.iPulse:Play()

-- ICON BTN
local IconBtn = Instance.new("ImageButton", _G.HubGui)
IconBtn.Size = UDim2.new(0,60,0,60)
IconBtn.Position = UDim2.new(0.5,-30,0,20)
IconBtn.BackgroundColor3 = Color3.fromRGB(15,15,15)
IconBtn.Image = ICONS.hub
IconBtn.ZIndex = 10
Instance.new("UICorner", IconBtn).CornerRadius = UDim.new(1,0)

local stroke = Instance.new("UIStroke", IconBtn)
stroke.Color = Color3.fromRGB(180,50,50)
stroke.Thickness = 2
TweenService:Create(stroke, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Thickness=4}):Play()

-- MAIN FRAME
_G.MainFrame = Instance.new("Frame", _G.HubGui)
_G.MainFrame.Size = UDim2.new(0,720,0,500)
_G.MainFrame.Position = UDim2.new(0.5,-360,0.5,-250)
_G.MainFrame.BackgroundColor3 = Color3.fromRGB(18,10,10)
_G.MainFrame.BorderSizePixel = 0
_G.MainFrame.ClipsDescendants = true
_G.MainFrame.Visible = false
Instance.new("UICorner", _G.MainFrame).CornerRadius = UDim.new(0,10)
local mStroke = Instance.new("UIStroke", _G.MainFrame)
mStroke.Color = Color3.fromRGB(120,30,30)
mStroke.Thickness = 1.5

local isOpen = false
local isMin = false
_G.tabs = {}
_G.activeTab = nil

_G.openTab = function(td)
    if _G.activeTab == td then return end
    if _G.activeTab then
        _G.activeTab.page.Visible = false
        TweenService:Create(_G.activeTab.btn, TweenInfo.new(0.2), {BackgroundColor3=Color3.fromRGB(14,7,7)}):Play()
        _G.activeTab.btnIcon.ImageColor3 = Color3.fromRGB(160,100,100)
        _G.activeTab.btnLabel.TextColor3 = Color3.fromRGB(160,100,100)
        TweenService:Create(_G.activeTab.indicator, TweenInfo.new(0.2), {BackgroundTransparency=1}):Play()
    end
    _G.activeTab = td
    td.page.Visible = true
    td.page.Position = UDim2.new(0,0,0,0)
    TweenService:Create(td.btn, TweenInfo.new(0.2), {BackgroundColor3=Color3.fromRGB(30,12,12)}):Play()
    td.btnIcon.ImageColor3 = Color3.fromRGB(255,255,255)
    td.btnLabel.TextColor3 = Color3.fromRGB(255,255,255)
    TweenService:Create(td.indicator, TweenInfo.new(0.2), {BackgroundTransparency=0}):Play()
end

local function openHub()
    isOpen = true
    _G.MainFrame.Visible = true
    _G.MainFrame.Size = UDim2.new(0,0,0,0)
    _G.MainFrame.Position = UDim2.new(0.5,0,0.5,0)
    TweenService:Create(_G.MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size=UDim2.new(0,720,0,500), Position=UDim2.new(0.5,-360,0.5,-250)
    }):Play()
end

local function closeHub()
    isOpen = false
    TweenService:Create(_G.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size=UDim2.new(0,0,0,0), Position=UDim2.new(0.5,0,0.5,0)
    }):Play()
    task.delay(0.3, function() _G.MainFrame.Visible = false end)
end

IconBtn.MouseButton1Click:Connect(function()
    if isOpen then closeHub() else openHub() end
end)

-- HEADER
local Header = Instance.new("Frame", _G.MainFrame)
Header.Size = UDim2.new(1,0,0,55)
Header.BackgroundColor3 = Color3.fromRGB(12,5,5)
Header.BorderSizePixel = 0

local HIcon = Instance.new("ImageLabel", Header)
HIcon.Size=UDim2.new(0,35,0,35) HIcon.Position=UDim2.new(0,12,0.5,-17)
HIcon.BackgroundTransparency=1 HIcon.Image=ICONS.hub

local HTitl = Instance.new("TextLabel", Header)
HTitl.Size=UDim2.new(0,200,0,25) HTitl.Position=UDim2.new(0,55,0,8)
HTitl.BackgroundTransparency=1 HTitl.Text="Hub da Zueira"
HTitl.TextColor3=Color3.fromRGB(255,255,255) HTitl.TextSize=18
HTitl.Font=Enum.Font.GothamBold HTitl.TextXAlignment=Enum.TextXAlignment.Left

local HSub = Instance.new("TextLabel", Header)
HSub.Size=UDim2.new(0,200,0,18) HSub.Position=UDim2.new(0,55,0,32)
HSub.BackgroundTransparency=1 HSub.Text="Developer zueiro BR"
HSub.TextColor3=Color3.fromRGB(160,100,100) HSub.TextSize=12
HSub.Font=Enum.Font.Gotham HSub.TextXAlignment=Enum.TextXAlignment.Left

local CBtn = Instance.new("ImageButton", Header)
CBtn.Size=UDim2.new(0,26,0,26) CBtn.Position=UDim2.new(1,-35,0.5,-13)
CBtn.BackgroundColor3=Color3.fromRGB(180,40,40) CBtn.Image=ICONS.close
CBtn.ImageColor3=Color3.fromRGB(255,255,255) CBtn.BorderSizePixel=0
Instance.new("UICorner",CBtn).CornerRadius=UDim.new(1,0)
CBtn.MouseButton1Click:Connect(function() closeHub() end)

local MBtn = Instance.new("ImageButton", Header)
MBtn.Size=UDim2.new(0,26,0,26) MBtn.Position=UDim2.new(1,-68,0.5,-13)
MBtn.BackgroundColor3=Color3.fromRGB(60,60,60) MBtn.Image=ICONS.minus
MBtn.ImageColor3=Color3.fromRGB(255,255,255) MBtn.BorderSizePixel=0
Instance.new("UICorner",MBtn).CornerRadius=UDim.new(1,0)
MBtn.MouseButton1Click:Connect(function()
    if isMin then
        isMin = false
        TweenService:Create(_G.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size=UDim2.new(0,720,0,500)}):Play()
    else
        isMin = true
        TweenService:Create(_G.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size=UDim2.new(0,720,0,55)}):Play()
    end
end)

-- DRAG
local drag, dragS, dragP
Header.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
        drag=true dragS=i.Position dragP=_G.MainFrame.Position
    end
end)
UIS.InputChanged:Connect(function(i)
    if drag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
        local d=i.Position-dragS
        _G.MainFrame.Position=UDim2.new(dragP.X.Scale,dragP.X.Offset+d.X,dragP.Y.Scale,dragP.Y.Offset+d.Y)
    end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=false end
end)

-- SIDEBAR + CONTENT
_G.Sidebar = Instance.new("Frame", _G.MainFrame)
_G.Sidebar.Size=UDim2.new(0,160,1,-55) _G.Sidebar.Position=UDim2.new(0,0,0,55)
_G.Sidebar.BackgroundColor3=Color3.fromRGB(14,7,7) _G.Sidebar.BorderSizePixel=0
local SL=Instance.new("UIListLayout",_G.Sidebar)
SL.SortOrder=Enum.SortOrder.LayoutOrder SL.Padding=UDim.new(0,2)

_G.Content = Instance.new("Frame", _G.MainFrame)
_G.Content.Size=UDim2.new(1,-160,1,-55) _G.Content.Position=UDim2.new(0,160,0,55)
_G.Content.BackgroundColor3=Color3.fromRGB(18,10,10)
_G.Content.BorderSizePixel=0 _G.Content.ClipsDescendants=true

-- HELPERS
_G.makeTabPage = function()
    local p=Instance.new("ScrollingFrame",_G.Content)
    p.Size=UDim2.new(1,0,1,0) p.BackgroundTransparency=1
    p.BorderSizePixel=0 p.ScrollBarThickness=3
    p.ScrollBarImageColor3=Color3.fromRGB(180,50,50)
    p.CanvasSize=UDim2.new(0,0,0,0) p.AutomaticCanvasSize=Enum.AutomaticSize.Y
    p.Visible=false
    local l=Instance.new("UIListLayout",p)
    l.SortOrder=Enum.SortOrder.LayoutOrder l.Padding=UDim.new(0,6)
    local pad=Instance.new("UIPadding",p)
    pad.PaddingTop=UDim.new(0,10) pad.PaddingLeft=UDim.new(0,10) pad.PaddingRight=UDim.new(0,10)
    return p
end

_G.makeTabBtn = function(name, iconId, page)
    local btn=Instance.new("TextButton",_G.Sidebar)
    btn.Size=UDim2.new(1,0,0,44) btn.BackgroundColor3=Color3.fromRGB(14,7,7)
    btn.BorderSizePixel=0 btn.Text="" btn.LayoutOrder=#_G.tabs+1

    local ind=Instance.new("Frame",btn)
    ind.Size=UDim2.new(0,3,1,0) ind.BackgroundColor3=Color3.fromRGB(180,50,50)
    ind.BorderSizePixel=0 ind.BackgroundTransparency=1

    local ic=Instance.new("ImageLabel",btn)
    ic.Size=UDim2.new(0,22,0,22) ic.Position=UDim2.new(0,16,0.5,-11)
    ic.BackgroundTransparency=1 ic.Image=iconId ic.ImageColor3=Color3.fromRGB(160,100,100)

    local lb=Instance.new("TextLabel",btn)
    lb.Size=UDim2.new(1,-50,1,0) lb.Position=UDim2.new(0,46,0,0)
    lb.BackgroundTransparency=1 lb.Text=name
    lb.TextColor3=Color3.fromRGB(160,100,100) lb.TextSize=14
    lb.Font=Enum.Font.Gotham lb.TextXAlignment=Enum.TextXAlignment.Left

    local td={btn=btn,indicator=ind,btnIcon=ic,btnLabel=lb,page=page}
    table.insert(_G.tabs,td)
    btn.MouseButton1Click:Connect(function() _G.openTab(td) end)
    return td
end

_G.addSection = function(page, title)
    local l=Instance.new("TextLabel",page)
    l.Size=UDim2.new(1,0,0,28) l.BackgroundTransparency=1
    l.Text="  "..title l.TextColor3=Color3.fromRGB(180,50,50)
    l.TextSize=13 l.Font=Enum.Font.GothamBold l.TextXAlignment=Enum.TextXAlignment.Left
end

_G.addToggle = function(page, name, desc, cb)
    local f=Instance.new("Frame",page)
    f.Size=UDim2.new(1,0,0,60) f.BackgroundColor3=Color3.fromRGB(25,12,12)
    f.BorderSizePixel=0 Instance.new("UICorner",f).CornerRadius=UDim.new(0,8)

    local t=Instance.new("TextLabel",f)
    t.Size=UDim2.new(1,-60,0,22) t.Position=UDim2.new(0,12,0,10)
    t.BackgroundTransparency=1 t.Text=name t.TextColor3=Color3.fromRGB(230,230,230)
    t.TextSize=14 t.Font=Enum.Font.GothamBold t.TextXAlignment=Enum.TextXAlignment.Left

    local s=Instance.new("TextLabel",f)
    s.Size=UDim2.new(1,-60,0,18) s.Position=UDim2.new(0,12,0,32)
    s.BackgroundTransparency=1 s.Text=desc s.TextColor3=Color3.fromRGB(130,100,100)
    s.TextSize=11 s.Font=Enum.Font.Gotham s.TextXAlignment=Enum.TextXAlignment.Left

    local bg=Instance.new("Frame",f)
    bg.Size=UDim2.new(0,44,0,24) bg.Position=UDim2.new(1,-56,0.5,-12)
    bg.BackgroundColor3=Color3.fromRGB(50,30,30) bg.BorderSizePixel=0
    Instance.new("UICorner",bg).CornerRadius=UDim.new(1,0)

    local c=Instance.new("Frame",bg)
    c.Size=UDim2.new(0,18,0,18) c.Position=UDim2.new(0,3,0.5,-9)
    c.BackgroundColor3=Color3.fromRGB(180,50,50) c.BorderSizePixel=0
    Instance.new("UICorner",c).CornerRadius=UDim.new(1,0)

    local val=false
    local b=Instance.new("TextButton",f)
    b.Size=UDim2.new(1,0,1,0) b.BackgroundTransparency=1 b.Text="" b.ZIndex=5
    b.MouseButton1Click:Connect(function()
        val=not val
        TweenService:Create(bg,TweenInfo.new(0.2),{BackgroundColor3=val and Color3.fromRGB(140,30,30) or Color3.fromRGB(50,30,30)}):Play()
        TweenService:Create(c,TweenInfo.new(0.2),{Position=val and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)}):Play()
        cb(val)
    end)
end

_G.addButton = function(page, name, desc, cb)
    local f=Instance.new("Frame",page)
    f.Size=UDim2.new(1,0,0,60) f.BackgroundColor3=Color3.fromRGB(25,12,12)
    f.BorderSizePixel=0 Instance.new("UICorner",f).CornerRadius=UDim.new(0,8)

    local t=Instance.new("TextLabel",f)
    t.Size=UDim2.new(1,-60,0,22) t.Position=UDim2.new(0,12,0,10)
    t.BackgroundTransparency=1 t.Text=name t.TextColor3=Color3.fromRGB(230,230,230)
    t.TextSize=14 t.Font=Enum.Font.GothamBold t.TextXAlignment=Enum.TextXAlignment.Left

    local s=Instance.new("TextLabel",f)
    s.Size=UDim2.new(1,-60,0,18) s.Position=UDim2.new(0,12,0,32)
    s.BackgroundTransparency=1 s.Text=desc s.TextColor3=Color3.fromRGB(130,100,100)
    s.TextSize=11 s.Font=Enum.Font.Gotham s.TextXAlignment=Enum.TextXAlignment.Left

    local b=Instance.new("TextButton",f)
    b.Size=UDim2.new(1,0,1,0) b.BackgroundTransparency=1 b.Text="" b.ZIndex=5
    b.MouseButton1Click:Connect(function()
        TweenService:Create(f,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(50,20,20)}):Play()
        task.delay(0.15,function() TweenService:Create(f,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(25,12,12)}):Play() end)
        cb()
    end)
end

_G.addSlider = function(page, name, min, max, default, cb)
    local f=Instance.new("Frame",page)
    f.Size=UDim2.new(1,0,0,75) f.BackgroundColor3=Color3.fromRGB(25,12,12)
    f.BorderSizePixel=0 Instance.new("UICorner",f).CornerRadius=UDim.new(0,8)

    local t=Instance.new("TextLabel",f)
    t.Size=UDim2.new(1,-60,0,20) t.Position=UDim2.new(0,12,0,8)
    t.BackgroundTransparency=1 t.Text=name t.TextColor3=Color3.fromRGB(230,230,230)
    t.TextSize=13 t.Font=Enum.Font.GothamBold t.TextXAlignment=Enum.TextXAlignment.Left

    local vl=Instance.new("TextLabel",f)
    vl.Size=UDim2.new(0,50,0,20) vl.Position=UDim2.new(1,-62,0,8)
    vl.BackgroundTransparency=1 vl.Text=tostring(default)
    vl.TextColor3=Color3.fromRGB(180,50,50) vl.TextSize=13
    vl.Font=Enum.Font.GothamBold vl.TextXAlignment=Enum.TextXAlignment.Right

    local tr=Instance.new("Frame",f)
    tr.Size=UDim2.new(1,-24,0,8) tr.Position=UDim2.new(0,12,0,46)
    tr.BackgroundColor3=Color3.fromRGB(50,30,30) tr.BorderSizePixel=0
    Instance.new("UICorner",tr).CornerRadius=UDim.new(1,0)

    local fl=Instance.new("Frame",tr)
    fl.Size=UDim2.new((default-min)/(max-min),0,1,0)
    fl.BackgroundColor3=Color3.fromRGB(180,50,50) fl.BorderSizePixel=0
    Instance.new("UICorner",fl).CornerRadius=UDim.new(1,0)

    local kn=Instance.new("Frame",tr)
    kn.Size=UDim2.new(0,30,0,30) kn.Position=UDim2.new((default-min)/(max-min),-15,0.5,-15)
    kn.BackgroundColor3=Color3.fromRGB(255,255,255) kn.BorderSizePixel=0 kn.ZIndex=5
    Instance.new("UICorner",kn).CornerRadius=UDim.new(1,0)

    local sliding=false
    local function upd(px)
        local rel=math.clamp((px-tr.AbsolutePosition.X)/tr.AbsoluteSize.X,0,1)
        local val=math.floor(min+(max-min)*rel)
        vl.Text=tostring(val)
        TweenService:Create(fl,TweenInfo.new(0.05),{Size=UDim2.new(rel,0,1,0)}):Play()
        TweenService:Create(kn,TweenInfo.new(0.05),{Position=UDim2.new(rel,-15,0.5,-15)}):Play()
        cb(val)
    end
    kn.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sliding=true end end)
    tr.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sliding=true upd(i.Position.X) end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sliding=false end end)
    UIS.InputChanged:Connect(function(i) if sliding and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then upd(i.Position.X) end end)
end

_G.addDropdown = function(page, name, desc, options, cb)
    local ddOpen=false
    local f=Instance.new("Frame",page)
    f.Size=UDim2.new(1,0,0,60) f.BackgroundColor3=Color3.fromRGB(25,12,12)
    f.BorderSizePixel=0 f.ClipsDescendants=false
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,8)

    local t=Instance.new("TextLabel",f)
    t.Size=UDim2.new(1,-50,0,22) t.Position=UDim2.new(0,12,0,10)
    t.BackgroundTransparency=1 t.Text=name t.TextColor3=Color3.fromRGB(230,230,230)
    t.TextSize=14 t.Font=Enum.Font.GothamBold t.TextXAlignment=Enum.TextXAlignment.Left

    local s=Instance.new("TextLabel",f)
    s.Size=UDim2.new(1,-50,0,18) s.Position=UDim2.new(0,12,0,32)
    s.BackgroundTransparency=1 s.Text=desc s.TextColor3=Color3.fromRGB(130,100,100)
    s.TextSize=11 s.Font=Enum.Font.Gotham s.TextXAlignment=Enum.TextXAlignment.Left

    local arr=Instance.new("TextLabel",f)
    arr.Size=UDim2.new(0,30,0,30) arr.Position=UDim2.new(1,-40,0.5,-15)
    arr.BackgroundTransparency=1 arr.Text="▼" arr.TextColor3=Color3.fromRGB(180,50,50)
    arr.TextSize=14 arr.Font=Enum.Font.GothamBold

    local dl=Instance.new("Frame",f)
    dl.Size=UDim2.new(1,0,0,0) dl.Position=UDim2.new(0,0,1,4)
    dl.BackgroundColor3=Color3.fromRGB(20,10,10) dl.BorderSizePixel=0
    dl.ClipsDescendants=true dl.ZIndex=20
    Instance.new("UICorner",dl).CornerRadius=UDim.new(0,8)
    Instance.new("UIListLayout",dl).Padding=UDim.new(0,2)

    local totalH=#options*38+4
    for i,opt in ipairs(options) do
        local ob=Instance.new("TextButton",dl)
        ob.Size=UDim2.new(1,0,0,36) ob.BackgroundColor3=Color3.fromRGB(30,14,14)
        ob.BorderSizePixel=0 ob.Text="  "..opt ob.TextColor3=Color3.fromRGB(200,180,180)
        ob.TextSize=13 ob.Font=Enum.Font.Gotham ob.TextXAlignment=Enum.TextXAlignment.Left
        ob.ZIndex=21 ob.LayoutOrder=i
        Instance.new("UICorner",ob).CornerRadius=UDim.new(0,6)
        ob.MouseButton1Click:Connect(function()
            s.Text=opt cb(opt) ddOpen=false
            TweenService:Create(dl,TweenInfo.new(0.2),{Size=UDim2.new(1,0,0,0)}):Play()
            TweenService:Create(arr,TweenInfo.new(0.2),{Rotation=0}):Play()
        end)
    end

    local b=Instance.new("TextButton",f)
    b.Size=UDim2.new(1,0,1,0) b.BackgroundTransparency=1 b.Text="" b.ZIndex=5
    b.MouseButton1Click:Connect(function()
        ddOpen=not ddOpen
        if ddOpen then
            TweenService:Create(dl,TweenInfo.new(0.25,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.new(1,0,0,totalH)}):Play()
            TweenService:Create(arr,TweenInfo.new(0.2),{Rotation=180}):Play()
        else
            TweenService:Create(dl,TweenInfo.new(0.2),{Size=UDim2.new(1,0,0,0)}):Play()
            TweenService:Create(arr,TweenInfo.new(0.2),{Rotation=0}):Play()
        end
    end)
end

print("Part1 carregada!")
