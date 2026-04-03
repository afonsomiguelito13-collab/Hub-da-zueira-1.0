local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

local ICONS = {
    anim="rbxassetid://6022668888",
    visao="rbxassetid://6035078856",
    executor="rbxassetid://6034509993",
    search="rbxassetid://6031068433",
    execute="rbxassetid://6026568220",
    clear="rbxassetid://6031094667",
    clip="rbxassetid://6022668916",
    warn="rbxassetid://6031068421",
}

local pageAnim   = _G.makeTabPage()
local pageDalton = _G.makeTabPage()

_G.pageExecutor = Instance.new("Frame")
_G.pageExecutor.Size = UDim2.new(1,0,1,0)
_G.pageExecutor.BackgroundTransparency = 1
_G.pageExecutor.BorderSizePixel = 0
_G.pageExecutor.Visible = false
_G.pageExecutor.Parent = _G.Content
local execLayout = Instance.new("UIListLayout",_G.pageExecutor)
execLayout.SortOrder = Enum.SortOrder.LayoutOrder
execLayout.Padding = UDim.new(0,8)
local execPad = Instance.new("UIPadding",_G.pageExecutor)
execPad.PaddingTop = UDim.new(0,10)
execPad.PaddingLeft = UDim.new(0,10)
execPad.PaddingRight = UDim.new(0,10)

_G.makeTabBtn("Anim",     ICONS.anim,        pageAnim)
_G.makeTabBtn("Visao",    ICONS.visao,       pageDalton)
_G.makeTabBtn("Executor", ICONS.executor,    _G.pageExecutor)

-- ========== TAB ANIM ==========
_G.addSection(pageAnim,"Animações Especiais")
local curAnim=nil
local function playAnim(id)
    if LP.Character then
        local hum=LP.Character:FindFirstChildOfClass("Humanoid")
        local anim=hum and hum:FindFirstChildOfClass("Animator")
        if anim then
            if curAnim then curAnim:Stop() end
            local ao=Instance.new("Animation")
            ao.AnimationId=id
            curAnim=anim:LoadAnimation(ao)
            curAnim:Play()
        end
    end
end
local anims={
    {name="Dança",desc="Dança padrão",id="rbxassetid://507771019"},
    {name="Laugh",desc="Risada",      id="rbxassetid://507770818"},
    {name="Point",desc="Aponta",      id="rbxassetid://507770453"},
    {name="Cheer",desc="Comemoração", id="rbxassetid://507770677"},
    {name="Wave", desc="Acena",       id="rbxassetid://507770239"},
}
for _,a in ipairs(anims) do
    _G.addButton(pageAnim,a.name,a.desc,function() playAnim(a.id) end)
end
_G.addButton(pageAnim,"Parar Anim","Para animação atual",function()
    if curAnim then curAnim:Stop() curAnim=nil end
end)
_G.addSection(pageAnim,"Estilo de Andar")
local walkAnims={
    ["Default"]="rbxassetid://913376220",  ["Old School"]="rbxassetid://180426354",
    ["Ninja"]="rbxassetid://616010382",    ["Superhero"]="rbxassetid://616008936",
    ["Zombie"]="rbxassetid://616013216",   ["Toy"]="rbxassetid://782842708",
    ["Vampire"]="rbxassetid://1083462077", ["Werewolf"]="rbxassetid://1083216690",
    ["Robot"]="rbxassetid://616006778",    ["Pirate"]="rbxassetid://750714810",
}
local curWalk=nil
_G.addDropdown(pageAnim,"Animação de Andar","Escolha o estilo",{
    "Default","Old School","Ninja","Superhero","Zombie",
    "Toy","Vampire","Werewolf","Robot","Pirate"
},function(sel)
    if LP.Character then
        local hum=LP.Character:FindFirstChildOfClass("Humanoid")
        local anim=hum and hum:FindFirstChildOfClass("Animator")
        if anim then
            if curWalk then curWalk:Stop() end
            local ao=Instance.new("Animation")
            ao.AnimationId=walkAnims[sel]
            curWalk=anim:LoadAnimation(ao)
            curWalk:Play()
        end
    end
end)

-- ========== TAB DALTONISMO ==========
_G.addSection(pageDalton,"Modo de Visão")
local fFrame=Instance.new("Frame",_G.HubGui)
fFrame.Size=UDim2.new(1,0,1,0)
fFrame.BackgroundTransparency=1
fFrame.BorderSizePixel=0
fFrame.ZIndex=0
local function applyFilter(color)
    if color==nil then
        TweenService:Create(fFrame,TweenInfo.new(0.5),{BackgroundTransparency=1}):Play()
    else
        fFrame.BackgroundColor3=color
        fFrame.BackgroundTransparency=0.75
    end
end
local filters={
    {name="Normal",        desc="Remove filtro",           color=nil},
    {name="Protanopia",    desc="Dificuldade com vermelho", color=Color3.fromRGB(255,220,100)},
    {name="Deuteranopia",  desc="Dificuldade com verde",    color=Color3.fromRGB(100,200,255)},
    {name="Tritanopia",    desc="Dificuldade com azul",     color=Color3.fromRGB(255,150,150)},
    {name="Alto Contraste",desc="Máximo contraste",         color=Color3.fromRGB(255,255,255)},
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
                    hl.FillTransparency=1
                    hl.OutlineColor=Color3.fromRGB(0,255,255)
                    hl.OutlineTransparency=0
                    hl.Parent=p.Character
                end
            else
                if h then h:Destroy() end
            end
        end
    end
end)

-- ========== POPUP ==========
_G.PopupFrame=Instance.new("Frame",_G.HubGui)
_G.PopupFrame.Size=UDim2.new(0,360,0,220)
_G.PopupFrame.Position=UDim2.new(0.5,-180,0.5,-110)
_G.PopupFrame.BackgroundColor3=Color3.fromRGB(20,10,10)
_G.PopupFrame.BorderSizePixel=0
_G.PopupFrame.Visible=false
_G.PopupFrame.ZIndex=50
Instance.new("UICorner",_G.PopupFrame).CornerRadius=UDim.new(0,12)
local popStroke=Instance.new("UIStroke",_G.PopupFrame)
popStroke.Color=Color3.fromRGB(180,50,50)
popStroke.Thickness=1.5

local warnIcon=Instance.new("ImageLabel",_G.PopupFrame)
warnIcon.Size=UDim2.new(0,30,0,30)
warnIcon.Position=UDim2.new(0,14,0,14)
warnIcon.BackgroundTransparency=1
warnIcon.Image=ICONS.warn
warnIcon.ImageColor3=Color3.fromRGB(255,80,80)
warnIcon.ZIndex=51

local popTitle=Instance.new("TextLabel",_G.PopupFrame)
popTitle.Size=UDim2.new(1,-60,0,28)
popTitle.Position=UDim2.new(0,52,0,12)
popTitle.BackgroundTransparency=1
popTitle.Text="Executar este script?"
popTitle.TextColor3=Color3.fromRGB(255,255,255)
popTitle.TextSize=15
popTitle.Font=Enum.Font.GothamBold
popTitle.TextXAlignment=Enum.TextXAlignment.Left
popTitle.ZIndex=51

local popWarn=Instance.new("TextLabel",_G.PopupFrame)
popWarn.Size=UDim2.new(1,-20,0,55)
popWarn.Position=UDim2.new(0,10,0,48)
popWarn.BackgroundTransparency=1
popWarn.Text="⚠️ Este script pode roubar seus itens, crashar o jogo ou ser detectado. Use por sua conta e risco!"
popWarn.TextColor3=Color3.fromRGB(220,160,80)
popWarn.TextSize=11
popWarn.Font=Enum.Font.Gotham
popWarn.TextWrapped=true
popWarn.ZIndex=51

local popScriptName=Instance.new("TextLabel",_G.PopupFrame)
popScriptName.Size=UDim2.new(1,-20,0,20)
popScriptName.Position=UDim2.new(0,10,0,108)
popScriptName.BackgroundTransparency=1
popScriptName.Text=""
popScriptName.TextColor3=Color3.fromRGB(180,50,50)
popScriptName.TextSize=12
popScriptName.Font=Enum.Font.GothamBold
popScriptName.TextXAlignment=Enum.TextXAlignment.Left
popScriptName.ZIndex=51

local popYes=Instance.new("TextButton",_G.PopupFrame)
popYes.Size=UDim2.new(0,100,0,34)
popYes.Position=UDim2.new(0,10,1,-44)
popYes.BackgroundColor3=Color3.fromRGB(180,50,50)
popYes.Text="Executar"
popYes.TextColor3=Color3.fromRGB(255,255,255)
popYes.TextSize=13
popYes.Font=Enum.Font.GothamBold
popYes.BorderSizePixel=0
popYes.ZIndex=51
Instance.new("UICorner",popYes).CornerRadius=UDim.new(0,8)

_G.popSave=Instance.new("TextButton",_G.PopupFrame)
_G.popSave.Size=UDim2.new(0,80,0,34)
_G.popSave.Position=UDim2.new(0.5,-40,1,-44)
_G.popSave.BackgroundColor3=Color3.fromRGB(40,80,40)
_G.popSave.Text="Salvar"
_G.popSave.TextColor3=Color3.fromRGB(200,255,200)
_G.popSave.TextSize=13
_G.popSave.Font=Enum.Font.GothamBold
_G.popSave.BorderSizePixel=0
_G.popSave.ZIndex=51
Instance.new("UICorner",_G.popSave).CornerRadius=UDim.new(0,8)

local popNo=Instance.new("TextButton",_G.PopupFrame)
popNo.Size=UDim2.new(0,100,0,34)
popNo.Position=UDim2.new(1,-110,1,-44)
popNo.BackgroundColor3=Color3.fromRGB(40,20,20)
popNo.Text="Cancelar"
popNo.TextColor3=Color3.fromRGB(200,180,180)
popNo.TextSize=13
popNo.Font=Enum.Font.GothamBold
popNo.BorderSizePixel=0
popNo.ZIndex=51
Instance.new("UICorner",popNo).CornerRadius=UDim.new(0,8)

_G.pendingScript=""
_G.pendingName=""

_G.showPopup=function(name,script)
    _G.pendingScript=script
    _G.pendingName=name
    popScriptName.Text="Script: "..name
    _G.PopupFrame.Visible=true
    _G.PopupFrame.Size=UDim2.new(0,0,0,0)
    _G.PopupFrame.Position=UDim2.new(0.5,0,0.5,0)
    TweenService:Create(_G.PopupFrame,TweenInfo.new(0.3,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
        Size=UDim2.new(0,360,0,220),
        Position=UDim2.new(0.5,-180,0.5,-110)
    }):Play()
end

local function hidePopup()
    TweenService:Create(_G.PopupFrame,TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{
        Size=UDim2.new(0,0,0,0),
        Position=UDim2.new(0.5,0,0.5,0)
    }):Play()
    task.delay(0.2,function() _G.PopupFrame.Visible=false end)
end

popNo.MouseButton1Click:Connect(hidePopup)
popYes.MouseButton1Click:Connect(function()
    hidePopup()
    task.delay(0.3,function()
        local ok,err=pcall(function() loadstring(_G.pendingScript)() end)
        if not ok then warn("Erro: "..tostring(err)) end
    end)
end)

-- ========== SAVED SCRIPTS ==========
_G.savedScripts=_G.savedScripts or {}

local savedPanel=Instance.new("Frame",_G.HubGui)
savedPanel.Size=UDim2.new(0,320,0,400)
savedPanel.Position=UDim2.new(0.5,-160,0.5,-200)
savedPanel.BackgroundColor3=Color3.fromRGB(18,10,10)
savedPanel.BorderSizePixel=0
savedPanel.Visible=false
savedPanel.ZIndex=60
Instance.new("UICorner",savedPanel).CornerRadius=UDim.new(0,12)
local spStroke=Instance.new("UIStroke",savedPanel)
spStroke.Color=Color3.fromRGB(180,50,50)
spStroke.Thickness=1.5

local spHeader=Instance.new("Frame",savedPanel)
spHeader.Size=UDim2.new(1,0,0,45)
spHeader.BackgroundColor3=Color3.fromRGB(12,5,5)
spHeader.BorderSizePixel=0
spHeader.ZIndex=61
Instance.new("UICorner",spHeader).CornerRadius=UDim.new(0,12)

local spTitle=Instance.new("TextLabel",spHeader)
spTitle.Size=UDim2.new(1,-50,1,0)
spTitle.Position=UDim2.new(0,14,0,0)
spTitle.BackgroundTransparency=1
spTitle.Text="Scripts Salvos"
spTitle.TextColor3=Color3.fromRGB(255,255,255)
spTitle.TextSize=15
spTitle.Font=Enum.Font.GothamBold
spTitle.TextXAlignment=Enum.TextXAlignment.Left
spTitle.ZIndex=62

local spClose=Instance.new("ImageButton",spHeader)
spClose.Size=UDim2.new(0,26,0,26)
spClose.Position=UDim2.new(1,-36,0.5,-13)
spClose.BackgroundColor3=Color3.fromRGB(180,40,40)
spClose.Image=ICONS.clear
spClose.ImageColor3=Color3.fromRGB(255,255,255)
spClose.BorderSizePixel=0
spClose.ZIndex=62
Instance.new("UICorner",spClose).CornerRadius=UDim.new(1,0)

local spList=Instance.new("ScrollingFrame",savedPanel)
spList.Size=UDim2.new(1,-12,1,-55)
spList.Position=UDim2.new(0,6,0,50)
spList.BackgroundTransparency=1
spList.BorderSizePixel=0
spList.ScrollBarThickness=3
spList.ScrollBarImageColor3=Color3.fromRGB(180,50,50)
spList.CanvasSize=UDim2.new(0,0,0,0)
spList.AutomaticCanvasSize=Enum.AutomaticSize.Y
spList.ZIndex=61
local spLayout=Instance.new("UIListLayout",spList)
spLayout.Padding=UDim.new(0,6)
spLayout.SortOrder=Enum.SortOrder.LayoutOrder
local spPad=Instance.new("UIPadding",spList)
spPad.PaddingTop=UDim.new(0,6)
spPad.PaddingLeft=UDim.new(0,4)
spPad.PaddingRight=UDim.new(0,4)

local spEmpty=Instance.new("TextLabel",spList)
spEmpty.Size=UDim2.new(1,0,0,40)
spEmpty.BackgroundTransparency=1
spEmpty.Text="Nenhum script salvo ainda"
spEmpty.TextColor3=Color3.fromRGB(130,100,100)
spEmpty.TextSize=12
spEmpty.Font=Enum.Font.Gotham
spEmpty.ZIndex=62

_G.refreshSavedList=function()
    for _,c in ipairs(spList:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end
    spEmpty.Visible=#_G.savedScripts==0
    for i,s in ipairs(_G.savedScripts) do
        local card=Instance.new("Frame",spList)
        card.Size=UDim2.new(1,0,0,65)
        card.BackgroundColor3=Color3.fromRGB(25,12,12)
        card.BorderSizePixel=0
        card.LayoutOrder=i
        card.ZIndex=62
        Instance.new("UICorner",card).CornerRadius=UDim.new(0,8)

        local thumb=Instance.new("ImageLabel",card)
        thumb.Size=UDim2.new(0,50,0,50)
        thumb.Position=UDim2.new(0,8,0.5,-25)
        thumb.BackgroundColor3=Color3.fromRGB(40,20,20)
        thumb.BorderSizePixel=0
        thumb.Image=s.thumb or ICONS.executor
        thumb.ZIndex=63
        Instance.new("UICorner",thumb).CornerRadius=UDim.new(0,6)

        local sName=Instance.new("TextLabel",card)
        sName.Size=UDim2.new(1,-100,0,22)
        sName.Position=UDim2.new(0,66,0,10)
        sName.BackgroundTransparency=1
        sName.Text=s.name or "Script"
        sName.TextColor3=Color3.fromRGB(230,230,230)
        sName.TextSize=13
        sName.Font=Enum.Font.GothamBold
        sName.TextXAlignment=Enum.TextXAlignment.Left
        sName.TextTruncate=Enum.TextTruncate.AtEnd
        sName.ZIndex=63

        local delBtn=Instance.new("ImageButton",card)
        delBtn.Size=UDim2.new(0,24,0,24)
        delBtn.Position=UDim2.new(1,-30,0.5,-12)
        delBtn.BackgroundColor3=Color3.fromRGB(180,40,40)
        delBtn.Image=ICONS.clear
        delBtn.ImageColor3=Color3.fromRGB(255,255,255)
        delBtn.BorderSizePixel=0
        delBtn.ZIndex=64
        Instance.new("UICorner",delBtn).CornerRadius=UDim.new(1,0)
        local idx=i
        delBtn.MouseButton1Click:Connect(function()
            table.remove(_G.savedScripts,idx)
            _G.refreshSavedList()
        end)

        local clickBtn=Instance.new("TextButton",card)
        clickBtn.Size=UDim2.new(1,-40,1,0)
        clickBtn.BackgroundTransparency=1
        clickBtn.Text=""
        clickBtn.ZIndex=63
        clickBtn.MouseButton1Click:Connect(function()
            _G.showPopup(s.name,s.script)
        end)
    end
end

_G.popSave.MouseButton1Click:Connect(function()
    table.insert(_G.savedScripts,{
        name=_G.pendingName,
        script=_G.pendingScript,
        thumb=ICONS.executor
    })
    _G.refreshSavedList()
    _G.popSave.Text="Salvo! ✓"
    _G.popSave.BackgroundColor3=Color3.fromRGB(50,120,50)
    task.delay(1.5,function()
        _G.popSave.Text="Salvar"
        _G.popSave.BackgroundColor3=Color3.fromRGB(40,80,40)
    end)
end)

local spOpen=false
_G.toggleSavedPanel=function()
    spOpen=not spOpen
    if spOpen then
        _G.refreshSavedList()
        savedPanel.Visible=true
        savedPanel.Size=UDim2.new(0,0,0,0)
        savedPanel.Position=UDim2.new(0.5,0,0.5,0)
        TweenService:Create(savedPanel,TweenInfo.new(0.3,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
            Size=UDim2.new(0,320,0,400),
            Position=UDim2.new(0.5,-160,0.5,-200)
        }):Play()
    else
        TweenService:Create(savedPanel,TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{
            Size=UDim2.new(0,0,0,0),
            Position=UDim2.new(0.5,0,0.5,0)
        }):Play()
        task.delay(0.2,function() savedPanel.Visible=false end)
    end
end

spClose.MouseButton1Click:Connect(function()
    spOpen=false
    TweenService:Create(savedPanel,TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{
        Size=UDim2.new(0,0,0,0),
        Position=UDim2.new(0.5,0,0.5,0)
    }):Play()
    task.delay(0.2,function() savedPanel.Visible=false end)
end)

print("Parte3a carregada!")
