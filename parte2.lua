local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

local ICONS = {
    hub="rbxassetid://10723407389", player="rbxassetid://6026568198",
    troll="rbxassetid://6035067836", teleport="rbxassetid://6026568220",
    anim="rbxassetid://6022668888", visao="rbxassetid://6035078856",
    settings="rbxassetid://6022668916", credits="rbxassetid://6022668898",
    executor="rbxassetid://6034509993",
    up="rbxassetid://6031068421", down="rbxassetid://6031094667",
}

_G.pagePlayer   = _G.makeTabPage()
_G.pageTroll    = _G.makeTabPage()
_G.pageTeleport = _G.makeTabPage()

_G.makeTabBtn("Player",   ICONS.player,   _G.pagePlayer)
_G.makeTabBtn("Troll",    ICONS.troll,    _G.pageTroll)
_G.makeTabBtn("Teleport", ICONS.teleport, _G.pageTeleport)

-- ========== TAB PLAYER ==========
_G.addSection(_G.pagePlayer,"Movimentação")
local ws=16
_G.addSlider(_G.pagePlayer,"WalkSpeed",16,500,16,function(v)
    ws=v
    if LP.Character then LP.Character.Humanoid.WalkSpeed=v end
end)
_G.addSlider(_G.pagePlayer,"JumpPower",50,500,50,function(v)
    if LP.Character then LP.Character.Humanoid.JumpPower=v end
end)
_G.addToggle(_G.pagePlayer,"Infinite Jump","Pula infinitamente",function(v)
    _G.infJump=v
end)
UIS.JumpRequest:Connect(function()
    if _G.infJump and LP.Character then
        LP.Character.Humanoid:ChangeState("Jumping")
    end
end)
LP.CharacterAdded:Connect(function(c)
    c:WaitForChild("Humanoid").WalkSpeed=ws
end)

_G.addSection(_G.pagePlayer,"Movimento Especial")

local noclip=false
_G.addToggle(_G.pagePlayer,"Noclip","Atravessa paredes",function(v) noclip=v end)
RunService.Stepped:Connect(function()
    if noclip and LP.Character then
        for _,p in ipairs(LP.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide=false end
        end
    end
end)

-- FLY COM SUPORTE MOBILE
local flyOn=false
local flyBV=nil
local flyBG=nil
local flySpd=60
local goUp=false
local goDown=false

_G.addToggle(_G.pagePlayer,"Fly","Voa pelo mapa",function(v)
    flyOn=v
    local char=LP.Character
    if not char then return end
    local hrp=char:FindFirstChild("HumanoidRootPart")
    local hum=char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    if v then
        hum.PlatformStand=true
        flyBV=Instance.new("BodyVelocity")
        flyBV.Velocity=Vector3.zero
        flyBV.MaxForce=Vector3.new(1e9,1e9,1e9)
        flyBV.Parent=hrp
        flyBG=Instance.new("BodyGyro")
        flyBG.MaxTorque=Vector3.new(1e9,1e9,1e9)
        flyBG.P=1e6
        flyBG.CFrame=hrp.CFrame
        flyBG.Name="FlyGyro"
        flyBG.Parent=hrp

        -- Botões mobile subir/descer
        local flyGui=Instance.new("ScreenGui",LP.PlayerGui)
        flyGui.Name="FlyButtons"
        flyGui.ResetOnSpawn=false
        flyGui.IgnoreGuiInset=true
        _G.flyGui=flyGui

        local function makeFlyBtn(icon, posX, posY, onHold)
            local btn=Instance.new("ImageButton",flyGui)
            btn.Size=UDim2.new(0,65,0,65)
            btn.Position=UDim2.new(posX,-32,posY,-32)
            btn.BackgroundColor3=Color3.fromRGB(20,10,10)
            btn.Image=icon
            btn.ImageColor3=Color3.fromRGB(255,255,255)
            btn.BorderSizePixel=0
            Instance.new("UICorner",btn).CornerRadius=UDim.new(1,0)
            local stroke=Instance.new("UIStroke",btn)
            stroke.Color=Color3.fromRGB(180,50,50)
            stroke.Thickness=2

            btn.InputBegan:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.Touch
                or i.UserInputType==Enum.UserInputType.MouseButton1 then
                    onHold(true)
                end
            end)
            btn.InputEnded:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.Touch
                or i.UserInputType==Enum.UserInputType.MouseButton1 then
                    onHold(false)
                end
            end)
            return btn
        end

        -- Subir (canto direito inferior)
        makeFlyBtn(ICONS.up, 1, 1, function(state)
            goUp=state
        end)

        -- Descer
        makeFlyBtn(ICONS.down, 1, 1, function(state)
            goDown=state
        end)

        -- Posicionar botões
        local btns=flyGui:GetChildren()
        if btns[1] then btns[1].Position=UDim2.new(1,-90,1,-170) end
        if btns[2] then btns[2].Position=UDim2.new(1,-90,1,-95) end

    else
        hum.PlatformStand=false
        if flyBV then flyBV:Destroy() flyBV=nil end
        if flyBG then flyBG:Destroy() flyBG=nil end
        local g=hrp:FindFirstChild("FlyGyro")
        if g then g:Destroy() end
        if _G.flyGui then _G.flyGui:Destroy() _G.flyGui=nil end
        goUp=false goDown=false
    end
end)

RunService.RenderStepped:Connect(function()
    if not flyOn or not LP.Character then return end
    local hrp=LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp or not flyBV then return end
    local cam=workspace.CurrentCamera
    local dir=Vector3.zero

    -- PC
    if UIS:IsKeyDown(Enum.KeyCode.W) then dir=dir+cam.CFrame.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.S) then dir=dir-cam.CFrame.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.A) then dir=dir-cam.CFrame.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.D) then dir=dir+cam.CFrame.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.Space) then dir=dir+Vector3.new(0,1,0) end
    if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then dir=dir-Vector3.new(0,1,0) end

    -- Mobile thumbstick
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

    -- Mobile botões subir/descer
    if goUp then dir=dir+Vector3.new(0,1,0) end
    if goDown then dir=dir-Vector3.new(0,1,0) end

    flyBV.Velocity=dir.Magnitude>0 and dir.Unit*flySpd or Vector3.zero
    local g=hrp:FindFirstChild("FlyGyro")
    if g then g.CFrame=cam.CFrame end
end)

_G.addSlider(_G.pagePlayer,"Fly Speed",10,300,60,function(v) flySpd=v end)

-- ========== TAB TROLL ==========
_G.addSection(_G.pageTroll,"Fling")
_G.addButton(_G.pageTroll,"Fling All","Joga todos pra longe",function()
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and p.Character then
            local hrp=p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local bv=Instance.new("BodyVelocity")
                bv.Velocity=Vector3.new(math.random(-300,300),400,math.random(-300,300))
                bv.MaxForce=Vector3.new(1e9,1e9,1e9)
                bv.Parent=hrp
                game:GetService("Debris"):AddItem(bv,0.2)
            end
        end
    end
end)

_G.addSection(_G.pageTroll,"ESP")
local espBoxes={}
_G.addToggle(_G.pageTroll,"ESP Jogadores","Mostra jogadores pelo mapa",function(v)
    for _,h in pairs(espBoxes) do if h then h:Destroy() end end
    espBoxes={}
    if v then
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=LP and p.Character then
                local h=Instance.new("Highlight")
                h.FillColor=Color3.fromRGB(255,0,0)
                h.OutlineColor=Color3.fromRGB(255,255,255)
                h.FillTransparency=0.5
                h.Parent=p.Character
                table.insert(espBoxes,h)
            end
        end
    end
end)

-- ========== TAB TELEPORT ==========
_G.addSection(_G.pageTeleport,"Jogadores")
_G.addButton(_G.pageTeleport,"Teleport para Spawn","Vai para o spawn",function()
    local sp=workspace:FindFirstChildOfClass("SpawnLocation")
    if sp and LP.Character then
        LP.Character:PivotTo(sp.CFrame+Vector3.new(0,5,0))
    end
end)
_G.addButton(_G.pageTeleport,"Ir ao Player mais perto","Teleporta ao primeiro player",function()
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and p.Character then
            local hrp=p.Character:FindFirstChild("HumanoidRootPart")
            if hrp and LP.Character then
                LP.Character:PivotTo(hrp.CFrame+Vector3.new(0,3,3))
                break
            end
        end
    end
end)
_G.addSection(_G.pageTeleport,"Info")
_G.addButton(_G.pageTeleport,"Pegar Posição Atual","Printa no output",function()
    if LP.Character then
        local hrp=LP.Character:FindFirstChild("HumanoidRootPart")
        if hrp then print("Posição: "..tostring(hrp.Position)) end
    end
end)

print("Parte2 carregada!")
