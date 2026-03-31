local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

local ICONS = _G.HubGui and {
    hub="rbxassetid://10723407389", teleport="rbxassetid://6026568220",
    anim="rbxassetid://6022668888", visao="rbxassetid://6035078856",
    troll="rbxassetid://6035067836", player="rbxassetid://6026568198",
    settings="rbxassetid://6022668916",
} or {}

-- PAGES
local pagePlayer   = _G.makeTabPage()
local pageTroll    = _G.makeTabPage()
local pageTeleport = _G.makeTabPage()
local pageAnim     = _G.makeTabPage()
local pageDalton   = _G.makeTabPage()
local pageSettings = _G.makeTabPage()

_G.makeTabBtn("Player",   ICONS.player,   pagePlayer)
_G.makeTabBtn("Troll",    ICONS.troll,    pageTroll)
_G.makeTabBtn("Teleport", ICONS.teleport, pageTeleport)
_G.makeTabBtn("Anim",     ICONS.anim,     pageAnim)
_G.makeTabBtn("Visao",    ICONS.visao,    pageDalton)
_G.makeTabBtn("Settings", ICONS.settings, pageSettings)

-- TAB PLAYER
_G.addSection(pagePlayer, "Movimentação")
local ws = 16
_G.addSlider(pagePlayer,"WalkSpeed",16,500,16,function(v)
    ws=v if LP.Character then LP.Character.Humanoid.WalkSpeed=v end
end)
_G.addSlider(pagePlayer,"JumpPower",50,500,50,function(v)
    if LP.Character then LP.Character.Humanoid.JumpPower=v end
end)
_G.addToggle(pagePlayer,"Infinite Jump","Pula infinitamente",function(v) _G.infJump=v end)
UIS.JumpRequest:Connect(function()
    if _G.infJump and LP.Character then LP.Character.Humanoid:ChangeState("Jumping") end
end)
LP.CharacterAdded:Connect(function(c) c:WaitForChild("Humanoid").WalkSpeed=ws end)

_G.addSection(pagePlayer,"Movimento Especial")

local noclip=false
_G.addToggle(pagePlayer,"Noclip","Atravessa paredes",function(v) noclip=v end)
RunService.Stepped:Connect(function()
    if noclip and LP.Character then
        for _,p in ipairs(LP.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide=false end
        end
    end
end)

local flyOn=false
local flyBV=nil
local flyBG=nil
local flySpd=60

_G.addToggle(pagePlayer,"Fly","Voa pelo mapa",function(v)
    flyOn=v
    local char=LP.Character
    if not char then return end
    local hrp=char:FindFirstChild("HumanoidRootPart")
    local hum=char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    if v then
        hum.PlatformStand=true
        flyBV=Instance.new("BodyVelocity")
        flyBV.Velocity=Vector3.zero flyBV.MaxForce=Vector3.new(1e9,1e9,1e9)
        flyBV.Parent=hrp
        flyBG=Instance.new("BodyGyro")
        flyBG.MaxTorque=Vector3.new(1e9,1e9,1e9) flyBG.P=1e6
        flyBG.CFrame=hrp.CFrame flyBG.Name="FlyGyro" flyBG.Parent=hrp
    else
        hum.PlatformStand=false
        if flyBV then flyBV:Destroy() flyBV=nil end
        if flyBG then flyBG:Destroy() flyBG=nil end
        local g=hrp:FindFirstChild("FlyGyro") if g then g:Destroy() end
    end
end)

RunService.RenderStepped:Connect(function()
    if not flyOn or not LP.Character then return end
    local hrp=LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp or not flyBV then return end
    local cam=workspace.CurrentCamera
    local dir=Vector3.zero
    if UIS:IsKeyDown(Enum.KeyCode.W) then dir=dir+cam.CFrame.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.S) then dir=dir-cam.CFrame.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.A) then dir=dir-cam.CFrame.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.D) then dir=dir+cam.CFrame.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.Space) then dir=dir+Vector3.new(0,1,0) end
    if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then dir=dir-Vector3.new(0,1,0) end
    local tGui=LP.PlayerGui:FindFirstChild("TouchGui")
    if tGui then
        local ctrl=tGui:FindFirstChild("TouchControlFrame")
        if ctrl then
            local dyn=ctrl:FindFirstChild("DynamicThumbstickFrame")
            if dyn then
                local sf=dyn:FindFirstChild("StartFrame")
                local tf=dyn:FindFirstChild("ThumbFrame")
                if sf and tf then
                    local dx=(tf.Position.X.Offset-sf.Position.X.Offset)/50
                    local dy=(tf.Position.Y.Offset-sf.Position.Y.Offset)/50
                    dir=dir+(cam.CFrame.LookVector*-dy)+(cam.CFrame.RightVector*dx)
                end
            end
        end
    end
    flyBV.Velocity = dir.Magnitude>0 and dir.Unit*flySpd or Vector3.zero
    local g=hrp:FindFirstChild("FlyGyro") if g then g.CFrame=cam.CFrame end
end)

_G.addSlider(pagePlayer,"Fly Speed",10,300,60,function(v) flySpd=v end)

-- TAB TROLL
_G.addSection(pageTroll,"Fling")
_G.addButton(pageTroll,"Fling All","Joga todos pra longe",function()
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and p.Character then
            local hrp=p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local bv=Instance.new("BodyVelocity")
                bv.Velocity=Vector3.new(math.random(-300,300),400,math.random(-300,300))
                bv.MaxForce=Vector3.new(1e9,1e9,1e9) bv.Parent=hrp
                game:GetService("Debris"):AddItem(bv,0.2)
            end
        end
    end
end)
_G.addSection(pageTroll,"ESP")
local espBoxes={}
_G.addToggle(pageTroll,"ESP Jogadores","Mostra jogadores pelo mapa",function(v)
    for _,h in pairs(espBoxes) do if h then h:Destroy() end end espBoxes={}
    if v then
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=LP and p.Character then
                local h=Instance.new("Highlight")
                h.FillColor=Color3.fromRGB(255,0,0) h.OutlineColor=Color3.fromRGB(255,255,255)
                h.FillTransparency=0.5 h.Parent=p.Character
                table.insert(espBoxes,h)
            end
        end
    end
end)

-- TAB TELEPORT
_G.addSection(pageTeleport,"Jogadores")
_G.addButton(pageTeleport,"Teleport para Spawn","Vai para o spawn",function()
    local sp=workspace:FindFirstChildOfClass("SpawnLocation")
    if sp and LP.Character then LP.Character:PivotTo(sp.CFrame+Vector3.new(0,5,0)) end
end)
_G.addButton(pageTeleport,"Ir ao Player mais perto","Teleporta ao primeiro player",function()
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and p.Character then
            local hrp=p.Character:FindFirstChild("HumanoidRootPart")
            if hrp and LP.Character then LP.Character:PivotTo(hrp.CFrame+Vector3.new(0,3,3)) break end
        end
    end
end)
_G.addSection(pageTeleport,"Info")
_G.addButton(pageTeleport,"Pegar Posição Atual","Printa no output",function()
    if LP.Character then
        local hrp=LP.Character:FindFirstChild("HumanoidRootPart")
        if hrp then print("Posição: "..tostring(hrp.Position)) end
    end
end)

-- TAB ANIM
_G.addSection(pageAnim,"Animações Especiais")
local curAnim=nil
local function playAnim(id)
    if LP.Character then
        local hum=LP.Character:FindFirstChildOfClass("Humanoid")
        local anim=hum and hum:FindFirstChildOfClass("Animator")
        if anim then
            if curAnim then curAnim:Stop() end
            local ao=Instance.new("Animation") ao.AnimationId=id
            curAnim=anim:LoadAnimation(ao) curAnim:Play()
        end
    end
end
local anims={
    {name="Dança",desc="Dança padrão",id="rbxassetid://507771019"},
    {name="Laugh",desc="Risada",id="rbxassetid://507770818"},
    {name="Point",desc="Aponta",id="rbxassetid://507770453"},
    {name="Cheer",desc="Comemoração",id="rbxassetid://507770677"},
    {name="Wave", desc="Acena",id="rbxassetid://507770239"},
}
for _,a in ipairs(anims) do
    _G.addButton(pageAnim,a.name,a.desc,function() playAnim(a.id) end)
end
_G.addButton(pageAnim,"Parar Anim","Para animação atual",function()
    if curAnim then curAnim:Stop() curAnim=nil end
end)

_G.addSection(pageAnim,"Estilo de Andar")
local walkAnims={
    ["Default"]="rbxassetid://913376220", ["Old School"]="rbxassetid://180426354",
    ["Ninja"]="rbxassetid://616010382",   ["Superhero"]="rbxassetid://616008936",
    ["Zombie"]="rbxassetid://616013216",  ["Toy"]="rbxassetid://782842708",
    ["Vampire"]="rbxassetid://1083462077",["Werewolf"]="rbxassetid://1083216690",
    ["Robot"]="rbxassetid://616006778",   ["Pirate"]="rbxassetid://750714810",
}
local curWalk=nil
_G.addDropdown(pageAnim,"Animação de Andar","Escolha o estilo",{
    "Default","Old School","Ninja","Superhero","Zombie","Toy","Vampire","Werewolf","Robot","Pirate"
},function(sel)
    if LP.Character then
        local hum=LP.Character:FindFirstChildOfClass("Humanoid")
        local anim=hum and hum:FindFirstChildOfClass("Animator")
        if anim then
            if curWalk then curWalk:Stop() end
            local ao=Instance.new("Animation") ao.AnimationId=walkAnims[sel]
            curWalk=anim:LoadAnimation(ao) curWalk:Play()
        end
    end
end)

-- TAB DALTONISMO
_G.addSection(pageDalton,"Modo de Visão")
local fFrame=Instance.new("Frame",_G.HubGui)
fFrame.Size=UDim2.new(1,0,1,0) fFrame.BackgroundTransparency=1
fFrame.BorderSizePixel=0 fFrame.ZIndex=0

local function applyFilter(color)
    if color==nil then
        TweenService:Create(fFrame,TweenInfo.new(0.5),{BackgroundTransparency=1}):Play()
    else
        fFrame.BackgroundColor3=color fFrame.BackgroundTransparency=0.75
    end
end

local filters={
    {name="Normal",       desc="Remove filtro",           color=nil},
    {name="Protanopia",   desc="Dificuldade com vermelho", color=Color3.fromRGB(255,220,100)},
    {name="Deuteranopia", desc="Dificuldade com verde",    color=Color3.fromRGB(100,200,255)},
    {name="Tritanopia",   desc="Dificuldade com azul",     color=Color3.fromRGB(255,150,150)},
    {name="Alto Contraste",desc="Máximo contraste",        color=Color3.fromRGB(255,255,255)},
}
for _,f in ipairs(filters) do
    _G.addButton(pageDalton,f.name,f.desc,function() applyFilter(f.color) end)
end
_G.addSection(pageDalton,"Brilho")
_G.addSlider(pageDalton,"Brilho da Tela",0,100,50,function(v)
    game:GetService("Lighting").Brightness=v/10
end)
_G.addToggle(pageDalton,"Contorno nos Players","Facilita ver jogadores",function(v)
    for _,p in ipairs(Players:GetPlayers()) do
        if p.Character then
            local h=p.Character:FindFirstChildOfClass("Highlight")
            if v then
                if not h then
                    local hl=Instance.new("Highlight")
                    hl.FillTransparency=1 hl.OutlineColor=Color3.fromRGB(0,255,255)
                    hl.OutlineTransparency=0 hl.Parent=p.Character
                end
            else if h then h:Destroy() end end
        end
    end
end)

-- TAB SETTINGS
_G.addSection(pageSettings,"Hub")
_G.addButton(pageSettings,"Fechar Hub","Fecha tudo",function()
    TweenService:Create(_G.MainFrame,TweenInfo.new(0.3,Enum.EasingStyle.Back,Enum.EasingDirection.In),{
        Size=UDim2.new(0,0,0,0),Position=UDim2.new(0.5,0,0.5,0)
    }):Play()
    task.delay(0.3,function() _G.MainFrame.Visible=false end)
end)

-- LOADING ANIMAÇÃO
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
        if v:IsA("TextLabel") then TweenService:Create(v,TweenInfo.new(0.5),{TextTransparency=1}):Play()
        elseif v:IsA("ImageLabel") then TweenService:Create(v,TweenInfo.new(0.5),{ImageTransparency=1}):Play()
        elseif v:IsA("Frame") then TweenService:Create(v,TweenInfo.new(0.5),{BackgroundTransparency=1}):Play()
        end
    end
    task.wait(0.5)
    _G.LF:Destroy()
    -- abrir hub
    _G.MainFrame.Visible=true
    _G.MainFrame.Size=UDim2.new(0,0,0,0)
    _G.MainFrame.Position=UDim2.new(0.5,0,0.5,0)
    TweenService:Create(_G.MainFrame,TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
        Size=UDim2.new(0,720,0,500),Position=UDim2.new(0.5,-360,0.5,-250)
    }):Play()
    task.wait(0.1)
    _G.openTab(_G.tabs[1])
end)

print("Part2 carregada!")
