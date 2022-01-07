include('shared.lua')

CV.CL = CV.CL or {}

CV.CL.ATMValues = CV.CL.ATMValues or {}

CV.CL.ENT = CV.CL.ENT or {}
CV.CL.ENT.ATM = CV.CL.ENT.ATM or {}

CV.CL.ENT.ATM.GUI = CV.CL.ENT.ATM.GUI or {}
CV.CL.ENT.ATM.GUI.Frame = CV.CL.ENT.ATM.GUI.Frame or {}

CV.CL.ENT.ATM.GUI.CurrencyPersonalOffset = CV.CL.ENT.ATM.GUI.CurrencyPersonalOffset or 0
CV.CL.ENT.ATM.GUI.CurrencyATMOffset = CV.CL.ENT.ATM.GUI.CurrencyATMOffset or 0

CV.CL.ENT.ATM.GUI.OpenMenu = function()
  local frame = vgui.Create("DFrame")
  frame:SetTitle("Generic Currency Value | ATM")
  frame:SetSize(512, 512)
  frame:Center()
  frame:IsVisible(true)
  frame:MakePopup()

  CV.CL.ENT.ATM.GUI.Frame = frame

  frame.list = vgui.Create( "DListView", frame )
  frame.list:SetPos(10, 175)
  frame.list:SetSize(490, 325)
  frame.list:SetMultiSelect(false)
  frame.list:AddColumn("Name")

  for i,v in ipairs(player.GetAll()) do
    if v != LocalPlayer() then
      frame.list:AddLine(v:GetName())
    end
  end

  frame.labelCurrency = vgui.Create("DLabel", frame)
  frame.labelCurrency:SetPos(10, 30)
  frame.labelCurrency:SetSize(200, 15)
  frame.labelCurrency:SetTextColor(Color(0, 0, 0))
  frame.labelCurrency:SetText("Your personal balance:")

  frame.labelCurrencyValue = vgui.Create("DLabel", frame)
  frame.labelCurrencyValue:SetPos(150, 30)
  frame.labelCurrencyValue:SetSize(200, 15)
  frame.labelCurrencyValue:SetTextColor(Color(0, 0, 0))
  frame.labelCurrencyValue:SetText(LocalPlayer():GetNWInt("Currency"))

  frame.labelCurrencyATM = vgui.Create("DLabel", frame)
  frame.labelCurrencyATM:SetPos(10, 50)
  frame.labelCurrencyATM:SetSize(200, 15)
  frame.labelCurrencyATM:SetTextColor(Color(0, 0, 0))
  frame.labelCurrencyATM:SetText("Your ATM balance:")

  frame.labelCurrencyATMValue = vgui.Create("DLabel", frame)
  frame.labelCurrencyATMValue:SetPos(150, 50)
  frame.labelCurrencyATMValue:SetSize(200, 15)
  frame.labelCurrencyATMValue:SetTextColor(Color(0, 0, 0))
  frame.labelCurrencyATMValue:SetText(CV.CL.ATMValues[LocalPlayer():SteamID64()] or 0)

  frame.toAddValue = vgui.Create("DNumberWang", frame)
  frame.toAddValue:SetPos(300, 30)
  frame.toAddValue:SetSize(200, 40)
  frame.toAddValue:SetDecimals(0)
  frame.toAddValue:SetMin(0)
  frame.toAddValue:SetMax(1000000)

  frame.buttonDeposit = vgui.Create("DButton", frame)
  frame.buttonDeposit:SetPos(10, 80)
  frame.buttonDeposit:SetSize(490, 30)
  frame.buttonDeposit:SetText("Deposit")
  frame.buttonDeposit.DoClick = CV.CL.ENT.ATM.GUI.DepositButton

  frame.buttonWithdraw = vgui.Create("DButton", frame)
  frame.buttonWithdraw:SetPos(10, 110)
  frame.buttonWithdraw:SetSize(490, 30)
  frame.buttonWithdraw:SetText("Withdraw")
  frame.buttonWithdraw.DoClick = CV.CL.ENT.ATM.GUI.WithdrawButton

  frame.buttonTransfer = vgui.Create("DButton", frame)
  frame.buttonTransfer:SetPos(10, 140)
  frame.buttonTransfer:SetSize(490, 30)
  frame.buttonTransfer:SetText("Transfer")
  frame.buttonTransfer.DoClick = CV.CL.ENT.ATM.GUI.TransferButton
end

CV.CL.ENT.ATM.RequestData = function()
  net.Start("cv_atm_request_data")
  net.SendToServer()
end

net.Receive("cv_atm_openmenu", CV.CL.ENT.ATM.RequestData)

CV.CL.ENT.ATM.ResponseData = function()
  CV.CL.ATMValues = net.ReadTable()
  CV.CL.ENT.ATM.GUI.OpenMenu()
end

net.Receive("cv_atm_response_data", CV.CL.ENT.ATM.ResponseData)

CV.CL.ENT.ATM.GUI.DepositResponse = function()
  local successful = net.ReadBool()

  if successful and CV.CL.ENT.ATM.GUI.Frame then
    CV.CL.ENT.ATM.GUI.Frame.labelCurrencyValue:SetText(CV.CL.ENT.ATM.GUI.Frame.labelCurrencyValue:GetValue() + CV.CL.ENT.ATM.GUI.CurrencyPersonalOffset)
    CV.CL.ENT.ATM.GUI.Frame.labelCurrencyATMValue:SetText(CV.CL.ENT.ATM.GUI.Frame.labelCurrencyATMValue:GetValue() + CV.CL.ENT.ATM.GUI.CurrencyATMOffset)
  else
    CV.CL.DisplayCLNotification("You don't have enough currency to deposit this amount.")
  end
end

net.Receive("cv_atm_deposit_response", CV.CL.ENT.ATM.GUI.DepositResponse)

CV.CL.ENT.ATM.GUI.WithdrawResponse = function()
  local successful = net.ReadBool()

  if successful and CV.CL.ENT.ATM.GUI.Frame then
    CV.CL.ENT.ATM.GUI.Frame.labelCurrencyValue:SetText(CV.CL.ENT.ATM.GUI.Frame.labelCurrencyValue:GetValue() + CV.CL.ENT.ATM.GUI.CurrencyPersonalOffset)
    CV.CL.ENT.ATM.GUI.Frame.labelCurrencyATMValue:SetText(CV.CL.ENT.ATM.GUI.Frame.labelCurrencyATMValue:GetValue() + CV.CL.ENT.ATM.GUI.CurrencyATMOffset)
  else
    CV.CL.DisplayCLNotification("You don't have enough currency to withdraw this amount.")
  end
end

net.Receive("cv_atm_withdraw_response", CV.CL.ENT.ATM.GUI.WithdrawResponse)

CV.CL.ENT.ATM.GUI.TransferResponse = function()
  local successful = net.ReadBool()

  if successful and CV.CL.ENT.ATM.GUI.Frame then
    CV.CL.ENT.ATM.GUI.Frame.labelCurrencyValue:SetText(CV.CL.ENT.ATM.GUI.Frame.labelCurrencyValue:GetValue() + CV.CL.ENT.ATM.GUI.CurrencyPersonalOffset)
    CV.CL.ENT.ATM.GUI.Frame.labelCurrencyATMValue:SetText(CV.CL.ENT.ATM.GUI.Frame.labelCurrencyATMValue:GetValue() + CV.CL.ENT.ATM.GUI.CurrencyATMOffset)
    CV.CL.DisplayCLNotification("You have transfered the specified amount of currency.")
  else
    CV.CL.DisplayCLNotification("You don't have enough currency to transfer this amount.")
  end
end

net.Receive("cv_atm_transfer_response", CV.CL.ENT.ATM.GUI.TransferResponse)

CV.CL.ENT.ATM.GUI.DepositButton = function()
  local amount = CV.CL.ENT.ATM.GUI.Frame.toAddValue:GetValue()
  amount = math.abs(amount)

  CV.CL.ENT.ATM.GUI.CurrencyPersonalOffset = -amount
  CV.CL.ENT.ATM.GUI.CurrencyATMOffset = amount

  net.Start("cv_atm_deposit_request")
  net.WriteString(LocalPlayer():SteamID64())
  net.WriteInt(amount, 32)
  net.SendToServer()
end

CV.CL.ENT.ATM.GUI.WithdrawButton = function()
  local amount = CV.CL.ENT.ATM.GUI.Frame.toAddValue:GetValue()
  amount = math.abs(amount)

  CV.CL.ENT.ATM.GUI.CurrencyPersonalOffset = amount
  CV.CL.ENT.ATM.GUI.CurrencyATMOffset = -amount

  net.Start("cv_atm_withdraw_request")
  net.WriteString(LocalPlayer():SteamID64())
  net.WriteInt(amount, 32)
  net.SendToServer()
end

CV.CL.ENT.ATM.GUI.TransferButton = function()
  if table.Count(CV.CL.ENT.ATM.GUI.Frame.list:GetSelected()) != 0 then
    local ply = CV.Util.FindPlayerByName(table.GetFirstValue(CV.CL.ENT.ATM.GUI.Frame.list:GetSelected()):GetValue(1))
    local steamid = ply:SteamID64()

    if !steamid then
      CV.CL.DisplayCLNotification("Invalid target, cant transfer currency. (Possibly a Bot?)")
      return
    end

    local amount = CV.CL.ENT.ATM.GUI.Frame.toAddValue:GetValue()
    amount = math.abs(amount)

    CV.CL.ENT.ATM.GUI.CurrencyPersonalOffset = 0
    CV.CL.ENT.ATM.GUI.CurrencyATMOffset = -amount

    net.Start("cv_atm_transfer_request")
    net.WriteString(steamid)
    net.WriteInt(amount, 32)
    net.SendToServer()
  end
end

CV.CL.ENT.ATM.TextMaxDistance = 150
CV.CL.ENT.ATM.TextScale = 1

CV.CL.ENT.ATM.TextPosition = function(ent)
  return ent:GetPos() + ent:GetUp() * 50 + ent:GetRight() * -3
end
CV.CL.ENT.ATM.TextAngle = function(ent)
  local targetAngle = (LocalPlayer():GetPos() - ent:GetPos()):Angle()
  return Angle(0, 90 + targetAngle.yaw, 90)
end

function ENT:Draw()
   self:DrawModel()

   local distanceToLocalPlayer = LocalPlayer():GetPos():DistToSqr(self:GetPos())
   local allowedDistance = CV.CL.ENT.ATM.TextMaxDistance * CV.CL.ENT.ATM.TextMaxDistance

   if self:BeingLookedAtByLocalPlayer() and distanceToLocalPlayer < allowedDistance then
     cam.Start3D2D( CV.CL.ENT.ATM.TextPosition(self), CV.CL.ENT.ATM.TextAngle(self), CV.CL.ENT.ATM.TextScale )
     		draw.SimpleTextOutlined( "ATM", "DermaDefault", 0, 0, Color(150, 255, 150), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )
   	  cam.End3D2D()
   end
end
