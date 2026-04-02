local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer

local ICONS = {
    credits="rbxassetid://6022668898",
    settings="rbxassetid://6022668916",
}

local pageCreditos = _G.makeTabPage()
local pageSettings = _G.makeTabPage()

_G.makeTabBtn("Credits",  ICONS.credits,  pageCreditos)
_G.makeTabBtn("Settings", ICONS.settings, pageSettings)

-- ========== TAB CREDITOS ==========
_G.addSection(pageCreditos,"Hub da Zueira 1.2")
local creditos={
    {nome="afonsomiguelito13",role="👑 Criador / Developer"},
    {nome="Claude AI",        role="🤖 Assistente de código"},
}
for _,c in ipairs(creditos) do
    local f=Instance.new("Frame",pageCreditos)
    f.Size=UDim2.new(1,0,0,65)
    f.BackgroundColor3=Color3.fromRGB(25,12,12)
    f.BorderSizePixel=0
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,8)

    local iconBg=Instance.new("Frame",f)
    iconBg.Size=UDim2.new(0,42,0,42)
    iconBg.Position=UDim2.new(0,10,0.5,-21)
    iconBg.BackgroundColor3=Color3.fromRGB(180,50,50)
    iconBg.BorderSizePixel=0
    Instance.new("UICorner",iconBg).CornerRadius=UDim.new(1,0)

    local ini=Instance.new("TextLabel",iconBg)
    ini.Size=UDim2.new(1,0,1,0)
    ini.BackgroundTransparency=1
    ini.Text=string.upper(string.sub(c.nome,1,1))
    ini.TextColor3=Color3.fromRGB(255,255,255)
    ini.TextSize=20
    ini.Font=Enum.Font.GothamBold

    local nm=Instance.new("TextLabel",f)
    nm.Size=UDim2.new(1,-70,0,24)
    nm.Position=UDim2.new(0,62,0,12)
    nm.BackgroundTransparency=1
    nm.Text=c.nome
    nm.TextColor3=Color3.fromRGB(230,230,230)
    nm.TextSize=14
    nm.Font=Enum.Font.GothamBold
    nm.TextXAlignment=Enum.TextXAlignment.Left

    local rl=Instance.new("TextLabel",f)
    rl.Size=UDim2.new(1,-70,0,20)
    rl.Position=UDim2.new(0,62,0,36)
    rl.BackgroundTransparency=1
    rl.Text=c.role
    rl.TextColor3=Color3.fromRGB(160,100,100)
    rl.TextSize=12
    rl.Font=Enum.Font.Gotham
    rl.TextXAlignment=Enum.TextXAlignment.Left
end

_G.addSection(pageCreditos,"Versão")
local vf=Instance.new("Frame",pageCreditos)
vf.Size=UDim2.new(1,0,0,55)
vf.BackgroundColor3=Color3.fromRGB(25,12,12)
vf.BorderSizePixel=0
Instance.new("UICorner",vf).CornerRadius=UDim.new(0,8)
local vl=Instance.new("TextLabel",vf)
vl.Size=UDim2.new(1,0,1,0)
vl.BackgroundTransparency=1
vl.Text="Hub da Zueira  v1.2  🇧🇷"
vl.TextColor3=Color3.fromRGB(180,50,50)
vl.TextSize=16
vl.Font=Enum.Font.GothamBold

-- ========== TAB SETTINGS ==========
_G.addSection(pageSettings,"Hub")
_G.addButton(pageSettings,"Fechar Hub","Fecha tudo",function()
    TweenService:Create(_G.MainFrame,TweenInfo.new(0.3,Enum.EasingStyle.Back,Enum.EasingDirection.In),{
        Size=UDim2.new(0,0,0,0),
        Position=UDim2.new(0.5,0,0.5,0)
    }):Play()
    task.delay(0.3,function() _G.MainFrame.Visible=false end)
end)

-- ========== LOADING ==========
task.spawn(function()
    local msgs={"Iniciando...","Carregando funções...","Preparando troll...","Quase lá...","Pronto!"}
    for i,msg in ipairs(msgs) do
        _G.LSub.Text=msg
        TweenService:Create(_G.BFill,TweenInfo.new(0.4,Enum.EasingStyle.Quad),{
            Size=UDim2.new(i/#msgs,0,1,0)
        }):Play()
        task.wait(0.5)
    end
    _G.iPulse:Cancel()
    task.wait(0.2)
    TweenService:Create(_G.LF,TweenInfo.new(0.5),{BackgroundTransparency=1}):Play()
    for _,v in ipairs(_G.LF:GetDescendants()) do
        if v:IsA("TextLabel") then
            TweenService:Create(v,TweenInfo.new(0.5),{TextTransparency=1}):Play()
        elseif v:IsA("ImageLabel") then
            TweenService:Create(v,TweenInfo.new(0.5),{ImageTransparency=1}):Play()
        elseif v:IsA("Frame") then
            TweenService:Create(v,TweenInfo.new(0.5),{BackgroundTransparency=1}):Play()
        end
    end
    task.wait(0.5)
    _G.LF:Destroy()
    _G.MainFrame.Visible=true
    _G.MainFrame.Size=UDim2.new(0,0,0,0)
    _G.MainFrame.Position=UDim2.new(0.5,0,0.5,0)
    TweenService:Create(_G.MainFrame,TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
        Size=UDim2.new(0,720,0,500),
        Position=UDim2.new(0.5,-360,0.5,-250)
    }):Play()
    task.wait(0.1)
    _G.openTab(_G.tabs[1])
end)

print("Parte4 carregada! Hub da Zueira v1.2 🇧🇷")
