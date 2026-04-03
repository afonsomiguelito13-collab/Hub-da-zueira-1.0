local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer

local ICONS = {
    executor="rbxassetid://6034509993",
    search="rbxassetid://6031068433",
    execute="rbxassetid://6026568220",
    clear="rbxassetid://6031094667",
    clip="rbxassetid://6022668916",
}

-- Botão scripts salvos
local savedBtn=Instance.new("ImageButton",_G.pageExecutor)
savedBtn.Size=UDim2.new(1,0,0,42)
savedBtn.BackgroundColor3=Color3.fromRGB(25,12,12)
savedBtn.BorderSizePixel=0
savedBtn.LayoutOrder=0
savedBtn.ZIndex=5
Instance.new("UICorner",savedBtn).CornerRadius=UDim.new(0,8)

local savedBtnIcon=Instance.new("ImageLabel",savedBtn)
savedBtnIcon.Size=UDim2.new(0,22,0,22)
savedBtnIcon.Position=UDim2.new(0,12,0.5,-11)
savedBtnIcon.BackgroundTransparency=1
savedBtnIcon.Image=ICONS.executor
savedBtnIcon.ImageColor3=Color3.fromRGB(180,50,50)

local savedBtnLabel=Instance.new("TextLabel",savedBtn)
savedBtnLabel.Size=UDim2.new(1,-80,1,0)
savedBtnLabel.Position=UDim2.new(0,42,0,0)
savedBtnLabel.BackgroundTransparency=1
savedBtnLabel.Text="Scripts Salvos"
savedBtnLabel.TextColor3=Color3.fromRGB(230,230,230)
savedBtnLabel.TextSize=14
savedBtnLabel.Font=Enum.Font.GothamBold
savedBtnLabel.TextXAlignment=Enum.TextXAlignment.Left

local savedCount=Instance.new("TextLabel",savedBtn)
savedCount.Size=UDim2.new(0,30,0,24)
savedCount.Position=UDim2.new(1,-40,0.5,-12)
savedCount.BackgroundColor3=Color3.fromRGB(180,50,50)
savedCount.Text="0"
savedCount.TextColor3=Color3.fromRGB(255,255,255)
savedCount.TextSize=12
savedCount.Font=Enum.Font.GothamBold
savedCount.ZIndex=6
Instance.new("UICorner",savedCount).CornerRadius=UDim.new(1,0)

savedBtn.MouseButton1Click:Connect(function()
    savedCount.Text=tostring(#_G.savedScripts)
    _G.toggleSavedPanel()
end)

-- Search label
local searchLabel=Instance.new("TextLabel",_G.pageExecutor)
searchLabel.Size=UDim2.new(1,0,0,20)
searchLabel.BackgroundTransparency=1
searchLabel.Text="  Buscar Script"
searchLabel.TextColor3=Color3.fromRGB(180,50,50)
searchLabel.TextSize=13
searchLabel.Font=Enum.Font.GothamBold
searchLabel.TextXAlignment=Enum.TextXAlignment.Left
searchLabel.LayoutOrder=1

-- Search bar
local searchBar=Instance.new("Frame",_G.pageExecutor)
searchBar.Size=UDim2.new(1,0,0,42)
searchBar.BackgroundColor3=Color3.fromRGB(25,12,12)
searchBar.BorderSizePixel=0
searchBar.LayoutOrder=2
Instance.new("UICorner",searchBar).CornerRadius=UDim.new(0,8)

local searchBox=Instance.new("TextBox",searchBar)
searchBox.Size=UDim2.new(1,-50,1,0)
searchBox.Position=UDim2.new(0,12,0,0)
searchBox.BackgroundTransparency=1
searchBox.Text=""
searchBox.PlaceholderText="Pesquisar no ScriptBlox..."
searchBox.PlaceholderColor3=Color3.fromRGB(100,60,60)
searchBox.TextColor3=Color3.fromRGB(220,220,220)
searchBox.TextSize=13
searchBox.Font=Enum.Font.Gotham
searchBox.TextXAlignment=Enum.TextXAlignment.Left
searchBox.ClearTextOnFocus=false

local searchBtn=Instance.new("ImageButton",searchBar)
searchBtn.Size=UDim2.new(0,28,0,28)
searchBtn.Position=UDim2.new(1,-36,0.5,-14)
searchBtn.BackgroundTransparency=1
searchBtn.Image=ICONS.search
searchBtn.ImageColor3=Color3.fromRGB(180,50,50)

-- Resultados
local resultsFrame=Instance.new("ScrollingFrame",_G.pageExecutor)
resultsFrame.Size=UDim2.new(1,0,0,160)
resultsFrame.BackgroundColor3=Color3.fromRGB(20,10,10)
resultsFrame.BorderSizePixel=0
resultsFrame.ScrollBarThickness=3
resultsFrame.ScrollBarImageColor3=Color3.fromRGB(180,50,50)
resultsFrame.CanvasSize=UDim2.new(0,0,0,0)
resultsFrame.AutomaticCanvasSize=Enum.AutomaticSize.Y
resultsFrame.LayoutOrder=3
Instance.new("UICorner",resultsFrame).CornerRadius=UDim.new(0,8)
local resLayout=Instance.new("UIListLayout",resultsFrame)
resLayout.Padding=UDim.new(0,4)
local resPad=Instance.new("UIPadding",resultsFrame)
resPad.PaddingTop=UDim.new(0,6)
resPad.PaddingLeft=UDim.new(0,6)
resPad.PaddingRight=UDim.new(0,6)

local statusLabel=Instance.new("TextLabel",resultsFrame)
statusLabel.Size=UDim2.new(1,0,0,30)
statusLabel.BackgroundTransparency=1
statusLabel.Text="Pesquise um script acima"
statusLabel.TextColor3=Color3.fromRGB(130,100,100)
statusLabel.TextSize=12
statusLabel.Font=Enum.Font.Gotham

local function searchScripts(query)
    statusLabel.Text="Buscando..."
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
            _G.showPopup(st,sc)
        end)
    end
end

searchBtn.MouseButton1Click:Connect(function()
    if searchBox.Text~="" then searchScripts(searchBox.Text) end
end)
searchBox.FocusLost:Connect(function(enter)
    if enter and searchBox.Text~="" then searchScripts(searchBox.Text) end
end)

-- Editor
local execLabel=Instance.new("TextLabel",_G.pageExecutor)
execLabel.Size=UDim2.new(1,0,0,20)
execLabel.BackgroundTransparency=1
execLabel.Text="  Editor de Script"
execLabel.TextColor3=Color3.fromRGB(180,50,50)
execLabel.TextSize=13
execLabel.Font=Enum.Font.GothamBold
execLabel.TextXAlignment=Enum.TextXAlignment.Left
execLabel.LayoutOrder=4

local textArea=Instance.new("Frame",_G.pageExecutor)
textArea.Size=UDim2.new(1,0,0,120)
textArea.BackgroundColor3=Color3.fromRGB(14,7,7)
textArea.BorderSizePixel=0
textArea.LayoutOrder=5
Instance.new("UICorner",textArea).CornerRadius=UDim.new(0,8)
local taStroke=Instance.new("UIStroke",textArea)
taStroke.Color=Color3.fromRGB(60,30,30)
taStroke.Thickness=1

_G.scriptBox=Instance.new("TextBox",textArea)
_G.scriptBox.Size=UDim2.new(1,-10,1,-10)
_G.scriptBox.Position=UDim2.new(0,5,0,5)
_G.scriptBox.BackgroundTransparency=1
_G.scriptBox.Text=""
_G.scriptBox.PlaceholderText="-- Cole ou escreva seu script aqui..."
_G.scriptBox.PlaceholderColor3=Color3.fromRGB(80,50,50)
_G.scriptBox.TextColor3=Color3.fromRGB(200,220,180)
_G.scriptBox.TextSize=12
_G.scriptBox.Font=Enum.Font.Code
_G.scriptBox.TextXAlignment=Enum.TextXAlignment.Left
_G.scriptBox.TextYAlignment=Enum.TextYAlignment.Top
_G.scriptBox.MultiLine=true
_G.scriptBox.ClearTextOnFocus=false
_G.scriptBox.TextWrapped=true

local btnRow=Instance.new("Frame",_G.pageExecutor)
btnRow.Size=UDim2.new(1,0,0,44)
btnRow.BackgroundTransparency=1
btnRow.BorderSizePixel=0
btnRow.LayoutOrder=6
local btnLayout=Instance.new("UIListLayout",btnRow)
btnLayout.FillDirection=Enum.FillDirection.Horizontal
btnLayout.Padding=UDim.new(0,6)
btnLayout.SortOrder=Enum.SortOrder.LayoutOrder

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
    if _G.scriptBox.Text~="" then _G.showPopup("Script personalizado",_G.scriptBox.Text) end
end)
makeExecBtn("Clear",ICONS.clear,Color3.fromRGB(60,30,30),2,function()
    _G.scriptBox.Text=""
end)
makeExecBtn("Clipboard",ICONS.clip,Color3.fromRGB(40,20,40),3,function()
    local ok,clip=pcall(function()
        return game:GetService("GuiService"):GetClipboardText()
    end)
    if ok and clip~="" then _G.scriptBox.Text=clip end
end)

print("Parte3b carregada! v1.3 🇧🇷")
