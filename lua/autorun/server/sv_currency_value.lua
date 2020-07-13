CV = CV or {}
CV.SV = CV.SV or {}

util.AddNetworkString("cv_init_player_currency")
util.AddNetworkString("cv_sync_player_currency")
util.AddNetworkString("cv_notify_player")
util.AddNetworkString("cv_transfer_data_request")
util.AddNetworkString("cv_transfer_data_response")
util.AddNetworkString("cv_run_cmd")
util.AddNetworkString("cv_save_data")

CV.SV.TransferData = function()
  ply = net.ReadEntity()
  net.Start("cv_transfer_data_response")
  net.WriteBool(GetConVar("gcv_value_enabled"):GetBool())
  net.WriteBool(GetConVar("gcv_value_ignore_admin"):GetBool())
  net.WriteTable(CV.SV.Conf.PropValues or {})
  net.WriteTable(CV.SV.Conf.RagdollValues or {})
  net.WriteTable(CV.SV.Conf.EntityValues or {})
  net.WriteTable(CV.SV.Conf.VehicleValues or {})
  net.WriteTable(CV.SV.Conf.NPCValues or {})
  net.WriteTable(CV.SV.Conf.SwepValues or {})
  net.WriteTable(CV.SV.Conf.ToolValues or {})
  net.Send(ply)
end

net.Receive("cv_transfer_data_request", CV.SV.TransferData)

CV.SV.RunCMD = function()
  cmd = net.ReadString()
  args = net.ReadTable()

  if table.Count(args) == 1 then
    RunConsoleCommand(cmd, args[1])
  end

  if table.Count(args) == 2 then
    RunConsoleCommand(cmd, args[1], (math.floor(args[2])))
  end
end

net.Receive("cv_run_cmd", CV.SV.RunCMD)

CV.SV.NotifyPlayer = function(ply, msg)
  net.Start("cv_notify_player")
  net.WriteString("[Generic Currency Value] ".. msg)
  net.Send(ply)
end

CV.SV.NotfiyAll = function(msg)
  net.Start("cv_notify_player")
  net.WriteString("[Generic Currency Value] ".. msg)
  net.Broadcast()
end

CV.SV.PlayerInit = function(ply)
  ply:SetNWInt("Currency", 0)
end

hook.Add("PlayerInitialSpawn", "sv_player_init", CV.SV.PlayerInit)

CV.SV.DropPlayerCurrencyOnChat = function(ply, msg)
  if string.StartWith(msg, "!drop") then
    amount = string.Split(msg, " ")[2]
    amount = tonumber(amount)
    if amount then
      CV.SV.DropPlayerCurrency(ply, amount)
    end
  end
end

hook.Add("PlayerSay", "sv_drop_player_currency_on_chat", CV.SV.DropPlayerCurrencyOnChat)

CV.SV.AddPlayerCurrencyOnChat = function(ply, msg)
  if !ply:IsAdmin() then return end
  if string.StartWith(msg, "!add") then

    target = CV.Util.FindPlayerByName(string.Split(msg, " ")[2])

    amount = string.Split(msg, " ")[3]
    amount = tonumber(amount)
    if amount and target then
      CV.SV.AddCurrencyToPlayer(target, amount)
    end
  end
end

hook.Add("PlayerSay", "sv_add_player_currency_on_chat", CV.SV.AddPlayerCurrencyOnChat)

CV.SV.RemovePlayerCurrencyOnChat = function(ply, msg)
  if !ply:IsAdmin() then return end
  if string.StartWith(msg, "!remove") then

    target = CV.Util.FindPlayerByName(string.Split(msg, " ")[2])

    amount = string.Split(msg, " ")[3]
    amount = tonumber(amount)
    if amount and target then
      CV.SV.RemoveCurrencyToPlayer(target, amount)
    end
  end
end

hook.Add("PlayerSay", "sv_remove_player_currency_on_chat", CV.SV.RemovePlayerCurrencyOnChat)

CV.SV.SetPlayerCurrencyOnChat = function(ply, msg)
  if !ply:IsAdmin() then return end
  if string.StartWith(msg, "!set") then

    target = CV.Util.FindPlayerByName(string.Split(msg, " ")[2])

    amount = string.Split(msg, " ")[3]
    amount = tonumber(amount)
    if amount and target then
      CV.SV.SetCurrencyToPlayer(target, amount)
      CV.SV.NotifyPlayer(ply, "Your currency has been set to ".. amount)
    end
  end
end

hook.Add("PlayerSay", "sv_set_player_currency_on_chat", CV.SV.SetPlayerCurrencyOnChat)

CV.SV.SummonCurrencyEntityOnChat = function(ply, msg)
  if !ply:IsAdmin() then return end
  if string.StartWith(msg, "!summon") then

    amount = string.Split(msg, " ")[2]
    amount = tonumber(amount)
    if amount then
      CV.SV.CreateCurrencyEntity(ply:EyePos() + ply:GetAimVector() * 30, amount)
      CV.SV.NotifyPlayer(ply, "You have summoned ".. amount .." currency.")
    end
  end
end

hook.Add("PlayerSay", "sv_summon_currency_entity_on_chat", CV.SV.SummonCurrencyEntityOnChat)

CV.SV.DropPlayerCurrencyOnDeath = function(ply)
  playerCurrency = ply:GetNWInt("Currency")

  if playerCurrency > 0 then
    CV.SV.CreateCurrencyEntity(ply:GetPos() + Vector(0, 0, 10), playerCurrency)
  end

  CV.SV.SetCurrencyToPlayer(ply, 0)
end

hook.Add("PostPlayerDeath", "sv_drop_currency_ondeath", CV.SV.DropPlayerCurrencyOnDeath)

CV.SV.CreateCurrencyEntity = function(pos, amount)
  currency = ents.Create("currency")
  currency.CurrencyAmount = amount
  currency:SetPos(pos)
  currency:Spawn()

  return currency
end

CV.SV.DropPlayerCurrency = function(ply, amount)
  if !CV.SV.RemoveCurrencyToPlayer(ply, amount) then
    CV.SV.NotifyPlayer(ply, "You dont have enough to drop ".. amount .. " currency.")
    return
  end

  CV.SV.CreateCurrencyEntity(ply:EyePos() + ply:GetAimVector() * 30, amount)

end

CV.SV.AddCurrencyToPlayer = function(ply, amount)
  ply:SetNWInt("Currency", ply:GetNWInt("Currency") + amount or amount)
  CV.SV.NotifyPlayer(ply, "You have obtained ".. amount .. " currency.")
end

CV.SV.RemoveCurrencyToPlayer = function(ply, amount)
  if ply:GetNWInt("Currency") - amount < 0 then
    return false
  end

  ply:SetNWInt("Currency", ply:GetNWInt("Currency") - amount or 0)

  CV.SV.NotifyPlayer(ply, "You have been deducted ".. amount .. " currency.")

  return true
end

CV.SV.SetCurrencyToPlayer = function(ply, amount)
  ply:SetNWInt("Currency", amount)

  if ply:GetNWInt("Currency") < 0 then
    ply:SetNWInt("Currency", 0)
  end
end
