CV.SV = CV.SV or {}

util.AddNetworkString("cv_init_player_currency")
util.AddNetworkString("cv_sync_player_currency")
util.AddNetworkString("cv_notify_player")

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
  if string.StartWith(msg, "!set") then

    target = CV.Util.FindPlayerByName(string.Split(msg, " ")[2])

    amount = string.Split(msg, " ")[3]
    amount = tonumber(amount)
    if amount and target then
      CV.SV.SetCurrencyToPlayer(target, amount)
    end
  end
end

hook.Add("PlayerSay", "sv_set_player_currency_on_chat", CV.SV.SetPlayerCurrencyOnChat)

CV.SV.DropPlayerCurrency = function(ply, amount)
  if !CV.SV.RemoveCurrencyToPlayer(ply, amount) then
    CV.SV.NotifyPlayer(ply, "You dont have enough to drop ".. amount .. " currency.")
    return
  end

  currency = ents.Create("currency")
  currency.CurrencyAmount = amount
  currency:SetPos(ply:EyePos() + ply:GetAimVector() * 30)
  currency:Spawn()
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

  CV.SV.NotifyPlayer(ply, "Your currency has been set to ".. amount .. " currency.")
end
