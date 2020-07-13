CV = CV or {}
CV.CL = CV.CL or {}

CV.CL.DisplaySVNotification = function()
  msg = net.ReadString()
  notification.AddLegacy(msg, NOTIFY_GENERIC, 4 )
  surface.PlaySound("buttons/blip1.wav")
end

net.Receive("cv_notify_player", CV.CL.DisplaySVNotification)

CV.CL.DisplayPlayerCurrency = function(ply, msg)
  if msg == "!currency" then
     CV.CL.DisplayCLNotification("Your balance is ".. ply:GetNWInt("Currency") .. " currency.")
  end
end

hook.Add("OnPlayerChat", "cl_print_player_currency_on_chat", CV.CL.DisplayPlayerCurrency)

CV.CL.DisplayCLNotification = function(msg)
  notification.AddLegacy("[Generic Currency Value] ".. msg, NOTIFY_GENERIC, 4 )
  surface.PlaySound("buttons/blip1.wav")
end
