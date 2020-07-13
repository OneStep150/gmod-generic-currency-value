CV = CV or {}
CV.CL = CV.CL or {}

CV.CL.ValueEnabled = CV.CL.ValueEnabled or {}
CV.CL.ValueIgnoreAdmins = CV.CL.ValueIgnoreAdmins or {}

CV.CL.PropValues = CV.CL.PropValues or {}
CV.CL.RagdollValues = CV.CL.RagdollValues or {}
CV.CL.EntityValues = CV.CL.EntityValues or {}
CV.CL.VehicleValues = CV.CL.VehicleValues or {}
CV.CL.NPCValues = CV.CL.NPCValues or {}
CV.CL.SwepValues = CV.CL.SwepValues or {}
CV.CL.ToolValues = CV.CL.ToolValues or {}

CV.CL.ResponseData = function()
  CV.CL.ValueEnabled = net.ReadBool()
  CV.CL.ValueIgnoreAdmins = net.ReadBool()

  CV.CL.PropValues = net.ReadTable()
  CV.CL.RagdollValues = net.ReadTable()
  CV.CL.EntityValues = net.ReadTable()
  CV.CL.VehicleValues = net.ReadTable()
  CV.CL.NPCValues = net.ReadTable()
  CV.CL.SwepValues = net.ReadTable()
  CV.CL.ToolValues = net.ReadTable()

  CV.CL.GUI.OpenMenu()
end

net.Receive("cv_transfer_data_response", CV.CL.ResponseData)

CV.CL.DisplaySVNotification = function()
  msg = net.ReadString()
  notification.AddLegacy(msg, NOTIFY_GENERIC, 4 )
  surface.PlaySound("buttons/blip1.wav")
end

net.Receive("cv_notify_player", CV.CL.DisplaySVNotification)

CV.CL.RequestData = function()
  net.Start("cv_transfer_data_request")
  net.SendToServer()
end

concommand.Add("gcv_menu", CV.CL.RequestData)

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
