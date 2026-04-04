local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer

local ICONS = {
    misc="rbxassetid://6026568198",
}

local pageMisc = _G.makeTabPage()
_G.makeTabBtn("Misc", ICONS.misc, pageMisc)

-- ========== TAB MISC ==========
_G.addSection(pageMisc,"Servidor")

_G.addButton(pageMisc,"Rejoin","Entra no mesmo servidor novamente",function()
    local placeId=game.PlaceId
    local jobId=game.JobId
    game:GetService("TeleportService"):TeleportToPlaceInstance(placeId,jobId,LP)
end)

_G.addButton(pageMisc,"Sair do Jogo","Fecha o jogo",function()
    game:Shutdown()
end)

_G.addButton(pageMisc,"Copiar Link do Servidor","Copia o link pro clipboard",function()
    local link="roblox://experiences/start?placeId="..game.PlaceId.."&gameInstanceId="..game.JobId
    local ok=pcall(function()
        game:GetService("GuiService"):SetClipboard(link)
    end)
    if ok then
        -- Notificação de sucesso
        local notif=Instance.new("Frame",_G.HubGui)
        notif.Size=UDim2.new(0,280,0,50)
        notif.Position=UDim2.new(0.5,-140,0,20)
        notif.BackgroundColor3=Color3.fromRGB(25,12,12)
        notif.BorderSizePixel=0
        notif.ZIndex=100
        Instance.new("UICorner",notif).CornerRadius=UDim.new(0,10)
        local nStroke=Instance.new("UIStroke",notif)
        nStroke.Color=_G.themeColor or Color3.fromRGB(180,50,50)
        nStroke.Thickness=1.5

        local nLabel=Instance.new("TextLabel",notif)
        nLabel.Size=UDim2.new(1,0,1,0)
        nLabel.BackgroundTransparency=1
        nLabel.Text="✓ Link copiado!"
        nLabel.TextColor3=Color3.fromRGB(255,255,255)
        nLabel.TextSize=14
        nLabel.Font=Enum.Font.GothamBold
        nLabel.ZIndex=101

        notif.Position=UDim2.new(0.5,-140,0,-60)
        TweenService:Create(notif,TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
            Position=UDim2.new(0.5,-140,0,20)
        }):Play()
        task.delay(2,function()
            TweenService:Create(notif,TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{
                Position=UDim2.new(0.5,-140,0,-60)
            }):Play()
            task.delay(0.3,function() notif:Destroy() end)
        end)
    end
end)

_G.addSection(pageMisc,"Jogador")

_G.addButton(pageMisc,"Anti-AFK","Previne kick por inatividade",function()
    local vu=game:GetService("VirtualUser")
    LP.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end)
end)

_G.addButton(pageMisc,"Copiar ID do Servidor","Copia o JobId pro clipboard",function()
    local ok=pcall(function()
        game:GetService("GuiService"):SetClipboard(game.JobId)
    end)
    if ok then
        local notif=Instance.new("Frame",_G.HubGui)
        notif.Size=UDim2.new(0,280,0,50)
        notif.BackgroundColor3=Color3.fromRGB(25,12,12)
        notif.BorderSizePixel=0
        notif.ZIndex=100
        Instance.new("UICorner",notif).CornerRadius=UDim.new(0,10)
        local nStroke=Instance.new("UIStroke",notif)
        nStroke.Color=_G.themeColor or Color3.fromRGB(180,50,50)
        nStroke.Thickness=1.5
        local nLabel=Instance.new("TextLabel",notif)
        nLabel.Size=UDim2.new(1,0,1,0)
        nLabel.BackgroundTransparency=1
        nLabel.Text="✓ ID copiado!"
        nLabel.TextColor3=Color3.fromRGB(255,255,255)
        nLabel.TextSize=14
        nLabel.Font=Enum.Font.GothamBold
        nLabel.ZIndex=101
        notif.Position=UDim2.new(0.5,-140,0,-60)
        TweenService:Create(notif,TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
            Position=UDim2.new(0.5,-140,0,20)
        }):Play()
        task.delay(2,function()
            TweenService:Create(notif,TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{
                Position=UDim2.new(0.5,-140,0,-60)
            }):Play()
            task.delay(0.3,function() notif:Destroy() end)
        end)
    end
end)

_G.addButton(pageMisc,"Respawn","Respawna o personagem",function()
    LP:LoadCharacter()
end)

_G.addToggle(pageMisc,"Mostrar FPS","Mostra FPS no canto",function(v)
    if v then
        _G.fpsGui=Instance.new("ScreenGui",LP.PlayerGui)
        _G.fpsGui.Name="FPSCounter"
        _G.fpsGui.ResetOnSpawn=false
        _G.fpsGui.IgnoreGuiInset=true
        local fpsLabel=Instance.new("TextLabel",_G.fpsGui)
        fpsLabel.Size=UDim2.new(0,100,0,30)
        fpsLabel.Position=UDim2.new(0,10,0,10)
        fpsLabel.BackgroundColor3=Color3.fromRGB(15,8,8)
        fpsLabel.TextColor3=Color3.fromRGB(255,255,255)
        fpsLabel.TextSize=13
        fpsLabel.Font=Enum.Font.GothamBold
        fpsLabel.ZIndex=99
        Instance.new("UICorner",fpsLabel).CornerRadius=UDim.new(0,6)
        local stroke=Instance.new("UIStroke",fpsLabel)
        stroke.Color=_G.themeColor or Color3.fromRGB(180,50,50)
        stroke.Thickness=1.5
        game:GetService("RunService").RenderStepped:Connect(function()
            if not _G.fpsGui or not _G.fpsGui.Parent then return end
            fpsLabel.Text="  FPS: "..math.floor(1/game:GetService("Stats").FrameTime)
        end)
    else
        if _G.fpsGui then _G.fpsGui:Destroy() _G.fpsGui=nil end
    end
end)

print("Parte5 carregada! Hub da Zueira v1.4 🇧🇷")
