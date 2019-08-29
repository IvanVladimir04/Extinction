local ScoreboardDerma = nil
local PlayerList = nil

function GM:ScoreboardShow()
if !IsValid(ScoreboardDerma) then
ScoreboardDerma = vgui.Create("DFrame")
ScoreboardDerma:SetSize(750, 500)
ScoreboardDerma:SetPos(ScrW() / 2 - 325, ScrH() / 2 - 250)
ScoreboardDerma:SetTitle("Scoreboard")
ScoreboardDerma:SetDraggable(false)
ScoreboardDerma:ShowCloseButton(false)
ScoreboardDerma.Paint = function()
draw.RoundedBox(5, 0, 0, ScoreboardDerma:GetWide(), ScoreboardDerma:GetTall(), Color(60, 60, 60, 255))
end

local PlayerScrollPanel = vgui.Create("DScrollPanel", ScoreboardDerma)
PlayerScrollPanel:SetSize(ScoreboardDerma:GetWide(), ScoreboardDerma:GetTall() - 20)
PlayerScrollPanel:SetPos(0, 20)

PlayerList = vgui.Create("DListLayout", PlayerScrollPanel)
PlayerList:SetSize(PlayerScrollPanel:GetWide(), PlayerScrollPanel:GetTall())
PlayerList:SetPos(0, 0)
end

if IsValid(ScoreboardDerma) then
PlayerList:Clear()

for k, v in pairs(player.GetAll()) do
local PlayerPanel = vgui.Create("DPanel", PlayerList)
PlayerPanel:SetSize(PlayerList:GetWide(), 50)
PlayerPanel:SetPos(0, 0)
PlayerPanel.Paint = function()
draw.RoundedBox(0, 0, 0, PlayerPanel:GetWide(), PlayerPanel:GetTall(), Color(50, 50, 50, 255))
draw.RoundedBox(0, 0, 49, PlayerPanel:GetWide(), 1, Color(255, 255, 255, 255))

draw.SimpleText(v:GetName().." - Level "..v:GetNWInt("playerLvl"), "DermaDefault", 20, 10, Color(255, 255, 255))
draw.SimpleText("$"..v:GetNWInt("playerMoney"), "DermaDefault", 20, 25, Color(255, 255, 255))
draw.SimpleText("Kills: "..v:Frags(), "DermaDefault", PlayerList:GetWide() - 20, 10, Color(255, 255, 255), TEXT_ALIGN_RIGHT)
draw.SimpleText("Deaths: "..v:Deaths(), "DermaDefault", PlayerList:GetWide() - 20, 25, Color(255, 255, 255), TEXT_ALIGN_RIGHT)
end
end

ScoreboardDerma:Show()
ScoreboardDerma:MakePopup()
ScoreboardDerma:SetKeyboardInputEnabled(false)
end
end

function GM:ScoreboardHide()
if IsValid(ScoreboardDerma) then
ScoreboardDerma:Hide()
end
end
