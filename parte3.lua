local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer

local ICONS = {
    hub="rbxassetid://10723407389",
    anim="rbxassetid://6022668888",
    visao="rbxassetid://6035078856",
    settings="rbxassetid://6022668916",
    credits="rbxassetid://6022668898",
    executor="rbxassetid://6034509993",
    search="rbxassetid://6031068433",
    execute="rbxassetid://6026568220",
    clear="rbxassetid://6031094667",
    clip="rbxassetid://6022668916",
    warn="rbxassetid://6031068421",
}

-- PAGES
local pageAnim     = _G.makeTabPage()
local pageDalton   = _G.makeTabPage()
local pageCreditos = _G.makeTabPage()
local pageSettings = _G.makeTabPage()

-- Executor page custom (sem makeTabPage pra ter controle total)
local pageExecutor = Instance.new("Frame")
pageExecutor.Size = UDim2.new(1,0,1,0)
pageExecutor.BackgroundTransparency = 1
pageExecutor.BorderSizePixel = 0
pageExecutor.Visible = false
pageExecutor.Parent = _G.Content

local execPad = Instance.new("UIPadding", pageExecutor)
execPad.PaddingTop = UDim.new(0,10)
execPad.PaddingLeft = UDim.new(0,10)
execPad.PaddingRight = UDim.new(0,10)

local execLayout = Instance.new("UIListLayout", pageExecutor)
execLayout.SortOrder = Enum.SortOrder.LayoutOrder
execLayout.Padding = UDim.new(0,8)

_G.makeTabBtn("Anim",     ICONS.anim,     pageAnim)
_G.makeTabBtn("Visao",    ICONS.visao,    pageDalton)
_G.makeTabBtn("Executor", ICONS.executor, pageExecutor)
_G.makeTabBtn("Credits",  ICONS.credits,  pageCreditos)
_G.makeTabBtn("Settings", ICONS.settings, pageSettings)

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

-- ========== TAB EXECUTOR ==========

-- Search label
local searchLabel = Instance.new("TextLabel", pageExecutor)
searchLabel.Size = UDim2.new(1,0,0,20)
searchLabel.BackgroundTransparency = 1
searchLabel.Text = "  Buscar Script"
searchLabel.TextColor3 = Color3.fromRGB(180,50,50)
searchLabel.TextSize = 13
searchLabel.Font = Enum.Font.GothamBold
searchLabel.TextXAlignment = Enum.TextXAlignment.Left
searchLabel.LayoutOrder = 1

-- Search bar
local searchBar = Instance.new("Frame", pageExecutor)
searchBar.Size = UDim2.new(1,0,0,42)
searchBar.BackgroundColor3 = Color3.fromRGB(25,12,12)
searchBar.BorderSizePixel = 0
searchBar.LayoutOrder = 2
Instance.new("UICorner",searchBar).CornerRadius = UDim.new(0,8)

local searchBox = Instance.new("TextBox", searchBar)
searchBox.Size = UDim2.new(1,-50,1,0)
searchBox.Position = UDim2.new(0,12,0,0)
searchBox.BackgroundTransparency = 1
searchBox.Text = ""
searchBox.PlaceholderText = "Pesquisar no ScriptBlox..."
searchBox.PlaceholderColor3 = Color3.fromRGB(100,60,60)
searchBox.TextColor3 = Color3.fromRGB(220,220,220)
searchBox.TextSize = 13
searchBox.Font = Enum.Font.Gotham
searchBox.TextXAlignment = Enum.TextXAlignment.Left
searchBox.ClearTextOnFocus = false

local searchBtn = Instance.new("ImageButton", searchBar)
searchBtn.Size = UDim2.new(0,28,0,28)
searchBtn.Position = UDim2.new(1,-36,0.5,-14)
searchBtn.BackgroundTransparency = 1
searchBtn.Image = ICONS.search
searchBtn.ImageColor3 = Color3.fromRGB(180,50,50)

-- Resultados
local resultsFrame = Instance.new("ScrollingFrame", pageExecutor)
resultsFrame.Size = UDim2.new(1,0,0,160)
resultsFrame.BackgroundColor3 = Color3.fromRGB(20,10,10)
resultsFrame.BorderSizePixel = 0
resultsFrame.ScrollBarThickness = 3
resultsFrame.ScrollBarImageColor3 = Color3.fromRGB(180,50,50)
resultsFrame.CanvasSize = UDim2.new(0,0,0,0)
resultsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
resultsFrame.LayoutOrder = 3
Instance.new("UICorner",resultsFrame).CornerRadius = UDim.new(0,8)
local resLayout = Instance.new("UIListLayout",resultsFrame)
resLayout.Padding = UDim.new(0,4)
local resPad = Instance.new("UIPadding",resultsFrame)
resPad.PaddingTop = UDim.new(0,6)
resPad.PaddingLeft = UDim.new(0,6)
resPad.PaddingRight = UDim.new(0,6)

local statusLabel = Instance.new("TextLabel", resultsFrame)
statusLabel.Size = UDim2.new(1,0,0,30)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Pesquise um script acima"
statusLabel.TextColor3 = Color3.fromRGB(130,100,100)
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.Gotham

-- Popup confirmação
local PopupFrame = Instance.new("Frame",_G.HubGui)
PopupFrame.Size = UDim2.new(0,360,0,200)
PopupFrame.Position = UDim2.new(0.5,-180,0.5,-100)
PopupFrame.BackgroundColor3 = Color3.fromRGB(20,10,10)
PopupFrame.BorderSizePixel = 0
PopupFrame.Visible = false
PopupFrame.ZIndex = 50
Instance.new("UICorner",PopupFrame).CornerRadius = UDim.new(0,12)
local popStroke = Instance.new("UIStroke",PopupFrame)
popStroke.Color = Color3.fromRGB(180,50,50)
popStroke.Thickness = 1.5

local warnIcon = Instance.new("ImageLabel",PopupFrame)
warnIcon.Size = UDim2.new(0,30,0,30)
warnIcon.Position = UDim2.new(0,14,0,14)
warnIcon.BackgroundTransparency = 1
warnIcon.Image = ICONS.warn
warnIcon.ImageColor3 = Color3.fromRGB(255,80,80)
warnIcon.ZIndex = 51

local popTitle = Instance.new("TextLabel",PopupFrame)
popTitle.Size = UDim2.new(1,-60,0,28)
popTitle.Position = UDim2.new(0,52,0,12)
popTitle.BackgroundTransparency = 1
popTitle.Text = "Executar este script?"
popTitle.TextColor3 = Color3.fromRGB(255,255,255)
popTitle.TextSize = 15
popTitle.Font = Enum.Font.GothamBold
popTitle.TextXAlignment = Enum.TextXAlignment.Left
popTitle.ZIndex = 51

local popWarn = Instance.new("TextLabel",PopupFrame)
popWarn.Size = UDim2.new(1,-20,0,60)
popWarn.Position = UDim2.new(0,10,0,50)
popWarn.BackgroundTransparency = 1
popWarn.Text = "⚠️ Este script pode roubar seus itens, crashar o jogo ou ser detectado. Use por sua conta e risco!"
popWarn.TextColor3 = Color3.fromRGB(220,160,80)
popWarn.TextSize = 11
popWarn.Font = Enum.Font.Gotham
popWarn.TextWrapped = true
popWarn.ZIndex = 51

local popScriptName = Instance.new("TextLabel",PopupFrame)
popScriptName.Size = UDim2.new(1,-20,0,22)
popScriptName.Position = UDim2.new(0,10,0,118)
popScriptName.BackgroundTransparency = 1
popScriptName.Text = ""
popScriptName.TextColor3 = Color3.fromRGB(180,50,50)
popScriptName.TextSize = 12
popScriptName.Font = Enum.Font.GothamBold
popScriptName.TextXAlignment = Enum.TextXAlignment.Left
popScriptName.ZIndex = 51

local popYes = Instance.new("TextButton",PopupFrame)
popYes.Size = UDim2.new(0,120,0,34)
popYes.Position = UDim2.new(0,10,1,-44)
popYes.BackgroundColor3 = Color3.fromRGB(180,50,50)
popYes.Text = "Executar"
popYes.TextColor3 = Color3.fromRGB(255,255,255)
popYes.TextSize = 13
popYes.Font = Enum.Font.GothamBold
popYes.BorderSizePixel = 0
popYes.ZIndex = 51
Instance.new("UICorner",popYes).CornerRadius = UDim.new(0,8)

local popNo = Instance.new("TextButton",PopupFrame)
popNo.Size = UDim2.new(0,120,0,34)
popNo.Position = UDim2.new(1,-130,1,-44)
popNo.BackgroundColor3 = Color3.fromRGB(40,20,20)
popNo.Text = "Cancelar"
popNo.TextColor3 = Color3.fromRGB(200,180,180)
popNo.TextSize = 13
popNo.Font = Enum.Font.GothamBold
popNo.BorderSizePixel = 0
popNo.ZIndex = 51
Instance.new("UICorner",popNo).CornerRadius = UDim.new(0,8)

local pendingScript = ""
local function showPopup(name,script)
    pendingScript = script
    popScriptName.Text = "Script: "..name
    PopupFrame.Visible = true
    PopupFrame.Size = UDim2.new(0,0,0,0)
    PopupFrame.Position = UDim2.new(0.5,0,0.5,0)
    TweenService:Create(PopupFrame,TweenInfo.new(0.3,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
        Size=UDim2.new(0,360,0,200),
        Position=UDim2.new(0.5,-180,0.5,-100)
    }):Play()
end
local function hidePopup()
    TweenService:Create(PopupFrame,TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{
        Size=UDim2.new(0,0,0,0),
        Position=UDim2.new(0.5,0,0.5,0)
    }):Play()
    task.delay(0.2,function() PopupFrame.Visible=false end)
end
popNo.MouseButton1Click:Connect(hidePopup)
popYes.MouseButton1Click:Connect(function()
    hidePopup()
    task.delay(0.3,function()
        local ok,err=pcall(function() loadstring(pendingScript)() end)
        if not ok then warn("Erro: "..tostring(err)) end
    end)
end)

-- Busca ScriptBlox
local function searchScripts(query)
    statusLabel.Text = "Buscando..."
    for _,c in ipairs(resultsFrame:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end
    local ok,result=pcall(function()
        return game:HttpGet("https://scriptblox.com/api/script/search?q="..query.."&max=10")
    end)
    if not ok then statusLabel.Text="Erro ao buscar." return end
    local data
    local pok=pcall(function() data=HttpService:JSONDecode(result) end)
    if not pok or not data or not data.result or not data.result.scripts then
        statusLabel.Text="Nenhum resultado." return
    end
    local scripts=data.result.scripts
    if #scripts==0 then statusLabel.Text="Nenhum script encontrado." return end
    statusLabel.Text=""
    for _,s in ipairs(scripts) do
        local card=Instance.new("Frame",resultsFrame)
        card.Size=UDim2.new(1,0,0,70)
        card.BackgroundColor3=Color3.fromRGB(30,14,14)
        card.BorderSizePixel=0
        Instance.new("UICorner",card).CornerRadius=UDim.new(0,8)

        local thumb=Instance.new("ImageLabel",card)
        thumb.Size=UDim2.new(0,60,0,60)
        thumb.Position=UDim2.new(0,6,0.5,-30)
        thumb.BackgroundColor3=Color3.fromRGB(40,20,20)
        thumb.BorderSizePixel=0
        Instance.new("UICorner",thumb).CornerRadius=UDim.new(0,6)
        thumb.Image=(s.game and s.game.imageUrl and s.game.imageUrl~="") and s.game.imageUrl or ICONS.executor

        local sName=Instance.new("TextLabel",card)
        sName.Size=UDim2.new(1,-80,0,22)
        sName.Position=UDim2.new(0,74,0,8)
        sName.BackgroundTransparency=1
        sName.Text=s.title or "Sem título"
        sName.TextColor3=Color3.fromRGB(230,230,230)
        sName.TextSize=13
        sName.Font=Enum.Font.GothamBold
        sName.TextXAlignment=Enum.TextXAlignment.Left
        sName.TextTruncate=Enum.TextTruncate.AtEnd

        local views=Instance.new("TextLabel",card)
        views.Size=UDim2.new(1,-80,0,18)
        views.Position=UDim2.new(0,74,0,30)
        views.BackgroundTransparency=1
        views.Text="Usado: "..(s.views or 0).."x"
        views.TextColor3=Color3.fromRGB(160,100,100)
        views.TextSize=11
        views.Font=Enum.Font.Gotham
        views.TextXAlignment=Enum.TextXAlignment.Left

        local gName=Instance.new("TextLabel",card)
        gName.Size=UDim2.new(1,-80,0,16)
        gName.Position=UDim2.new(0,74,0,48)
        gName.BackgroundTransparency=1
        gName.Text=(s.game and s.game.name) and s.game.name or "Universal"
        gName.TextColor3=Color3.fromRGB(120,80,80)
        gName.TextSize=10
        gName.Font=Enum.Font.Gotham
        gName.TextXAlignment=Enum.TextXAlignment.Left
        gName.TextTruncate=Enum.TextTruncate.AtEnd

        local clickBtn=Instance.new("TextButton",card)
        clickBtn.Size=UDim2.new(1,0,1,0)
        clickBtn.BackgroundTransparency=1
        clickBtn.Text=""
        clickBtn.ZIndex=5
        local sc=s.script or ""
        local st=s.title or "Script"
        clickBtn.MouseButton1Click:Connect(function()
            TweenService:Create(card,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(50,20,20)}):Play()
            task.delay(0.15,function()
                TweenService:Create(card,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(30,14,14)}):Play()
            end)
            showPopup(st,sc)
        end)
    end
end

searchBtn.MouseButton1Click:Connect(function()
    if searchBox.Text~="" then searchScripts(searchBox.Text) end
end)
searchBox.FocusLost:Connect(function(enter)
    if enter and searchBox.Text~="" then searchScripts(searchBox.Text) end
end)

-- Editor label
local execLabel = Instance.new("TextLabel",pageExecutor)
execLabel.Size = UDim2.new(1,0,0,20)
execLabel.BackgroundTransparency = 1
execLabel.Text = "  Editor de Script"
execLabel.TextColor3 = Color3.fromRGB(180,50,50)
execLabel.TextSize = 13
execLabel.Font = Enum.Font.GothamBold
execLabel.TextXAlignment = Enum.TextXAlignment.Left
execLabel.LayoutOrder = 4

-- Text area
local textArea = Instance.new("Frame",pageExecutor)
textArea.Size = UDim2.new(1,0,0,120)
textArea.BackgroundColor3 = Color3.fromRGB(14,7,7)
textArea.BorderSizePixel = 0
textArea.LayoutOrder = 5
Instance.new("UICorner",textArea).CornerRadius = UDim.new(0,8)
local taStroke = Instance.new("UIStroke",textArea)
taStroke.Color = Color3.fromRGB(60,30,30)
taStroke.Thickness = 1

local scriptBox = Instance.new("TextBox",textArea)
scriptBox.Size = UDim2.new(1,-10,1,-10)
scriptBox.Position = UDim2.new(0,5,0,5)
scriptBox.BackgroundTransparency = 1
scriptBox.Text = ""
scriptBox.PlaceholderText = "-- Cole ou escreva seu script aqui..."
scriptBox.PlaceholderColor3 = Color3.fromRGB(80,50,50)
scriptBox.TextColor3 = Color3.fromRGB(200,220,180)
scriptBox.TextSize = 12
scriptBox.Font = Enum.Font.Code
scriptBox.TextXAlignment = Enum.TextXAlignment.Left
scriptBox.TextYAlignment = Enum.TextYAlignment.Top
scriptBox.MultiLine = true
scriptBox.ClearTextOnFocus = false
scriptBox.TextWrapped = true

-- Botões Execute/Clear/Clipboard
local btnRow = Instance.new("Frame",pageExecutor)
btnRow.Size = UDim2.new(1,0,0,44)
btnRow.BackgroundTransparency = 1
btnRow.BorderSizePixel = 0
btnRow.LayoutOrder = 6
local btnLayout = Instance.new("UIListLayout",btnRow)
btnLayout.FillDirection = Enum.FillDirection.Horizontal
btnLayout.Padding = UDim.new(0,6)
btnLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function makeExecBtn(label,icon,color,order,cb)
    local f=Instance.new("Frame",btnRow)
    f.Size=UDim2.new(0,0,1,0)
    f.AutomaticSize=Enum.AutomaticSize.X
    f.BackgroundColor3=color
    f.BorderSizePixel=0
    f.LayoutOrder=order
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,8)

    local ic=Instance.new("ImageLabel",f)
    ic.Size=UDim2.new(0,20,0,20)
    ic.Position=UDim2.new(0,10,0.5,-10)
    ic.BackgroundTransparency=1
    ic.Image=icon
    ic.ImageColor3=Color3.fromRGB(255,255,255)

    local lb=Instance.new("TextLabel",f)
    lb.Size=UDim2.new(0,0,1,0)
    lb.Position=UDim2.new(0,36,0,0)
    lb.AutomaticSize=Enum.AutomaticSize.X
    lb.BackgroundTransparency=1
    lb.Text=label.."  "
    lb.TextColor3=Color3.fromRGB(255,255,255)
    lb.TextSize=13
    lb.Font=Enum.Font.GothamBold

    local btn=Instance.new("TextButton",f)
    btn.Size=UDim2.new(1,0,1,0)
    btn.BackgroundTransparency=1
    btn.Text=""
    btn.ZIndex=5
    btn.MouseButton1Click:Connect(function()
        TweenService:Create(f,TweenInfo.new(0.1),{BackgroundTransparency=0.3}):Play()
        task.delay(0.15,function()
            TweenService:Create(f,TweenInfo.new(0.1),{BackgroundTransparency=0}):Play()
        end)
        cb()
    end)
end

makeExecBtn("Execute",ICONS.execute,Color3.fromRGB(180,50,50),1,function()
    if scriptBox.Text~="" then showPopup("Script personalizado",scriptBox.Text) end
end)
makeExecBtn("Clear",ICONS.clear,Color3.fromRGB(60,30,30),2,function()
    scriptBox.Text=""
end)
makeExecBtn("Clipboard",ICONS.clip,Color3.fromRGB(40,20,40),3,function()
    local ok,clip=pcall(function()
        return game:GetService("GuiService"):GetClipboardText()
    end)
    if ok and clip~="" then scriptBox.Text=clip end
end)

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

 
