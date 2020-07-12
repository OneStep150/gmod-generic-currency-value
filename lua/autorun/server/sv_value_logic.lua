CV.SV = CV.SV or {}

CV.SV.HandlePropValue = function(ply, model, entity)
  if !GetConVar("gcv_value_enabled"):GetBool() then return end

  value = GetConVar("gcv_value_prop_default"):GetInt()

  if CV.SV.Conf.PropValues[model] then
    value = CV.SV.Conf.PropValues[model]
  end

  value = value * entity:GetPhysicsObject():GetMass() * GetConVar("gcv_value_prop_weight_mul"):GetInt()
  value = math.floor(value)

  if !CV.SV.RemoveCurrencyToPlayer(ply, value) then
    entity:Remove()
    CV.SV.NotifyPlayer(ply, "You need ".. value .. " currency to spawn this item.")
  end
end

hook.Add("PlayerSpawnedProp", "sv_handle_prop_value", CV.SV.HandlePropValue)

CV.SV.HandleRagdollValue = function(ply, model, entity)
  if !GetConVar("gcv_value_enabled"):GetBool() then return end

  value = GetConVar("gcv_value_ragdoll_default"):GetInt()

  if CV.SV.Conf.RagdollValues[model] then
    value = CV.SV.Conf.RagdollValues[model]
  end

  value = value * entity:GetPhysicsObject():GetMass() * GetConVar("gcv_value_prop_weight_mul"):GetInt()
  value = math.floor(value)

  if !CV.SV.RemoveCurrencyToPlayer(ply, value) then
    entity:Remove()
    CV.SV.NotifyPlayer(ply, "You need ".. value .. " currency to spawn this item.")
  end
end

hook.Add("PlayerSpawnedRagdoll", "sv_handle_ragdoll_value", CV.SV.HandleRagdollValue)

CV.SV.HandleSwepValue = function(ply, entity)
  if !GetConVar("gcv_value_enabled"):GetBool() then return end

  value = GetConVar("gcv_value_swep_default"):GetInt()

  if CV.SV.Conf.SwepValues[entity:GetClass()] then
    value = CV.SV.Conf.SwepValues[entity:GetClass()]
  end

  if !CV.SV.RemoveCurrencyToPlayer(ply, value) then
    entity:Remove()
    CV.SV.NotifyPlayer(ply, "You need ".. value .. " currency to spawn this item.")
  end
end

hook.Add("PlayerSpawneSWEP", "sv_handle_swep_value", CV.SV.HandleSwepValue)

CV.SV.HandleSwepGiveValue = function(ply, class)
  if !GetConVar("gcv_value_enabled"):GetBool() then return end

  value = GetConVar("gcv_value_swep_default"):GetInt()

  if CV.SV.Conf.SwepValues[class] then
    value = CV.SV.Conf.SwepValues[class]
  end

  if !CV.SV.RemoveCurrencyToPlayer(ply, value) then
    CV.SV.NotifyPlayer(ply, "You need ".. value .. " currency to spawn this item.")
    return false
  end
end

hook.Add("PlayerGiveSWEP", "sv_handle_swep_give_value", CV.SV.HandleSwepGiveValue)

CV.SV.HandleSentValue = function(ply, entity)
  if !GetConVar("gcv_value_enabled"):GetBool() then return end

  value = GetConVar("gcv_value_swep_default"):GetInt()

  if CV.SV.Conf.EntityValues[entity:GetClass()] then
    value = CV.SV.Conf.EntityValues[entity:GetClass()]
  end

  value = value * entity:GetPhysicsObject():GetMass() * GetConVar("gcv_value_entity_weight_mul"):GetInt()
  value = math.floor(value)

  if !CV.SV.RemoveCurrencyToPlayer(ply, value) then
    entity:Remove()
    CV.SV.NotifyPlayer(ply, "You need ".. value .. " currency to spawn this item.")
  end
end

hook.Add("PlayerSpawnedSENT", "sv_handle_sent_value", CV.SV.HandleSentValue)

CV.SV.HandleVehicleValue = function(ply, entity)
  if !GetConVar("gcv_value_enabled"):GetBool() then return end

  value = GetConVar("gcv_value_vehicle_default"):GetInt()

  if CV.SV.Conf.VehicleValues[entity:GetClass()] then
    value = CV.SV.Conf.VehicleValues[entity:GetClass()]
  end

  value = value * entity:GetPhysicsObject():GetMass() * GetConVar("gcv_value_vehicle_weight_mul"):GetInt()
  value = math.floor(value)

  if !CV.SV.RemoveCurrencyToPlayer(ply, value) then
    entity:Remove()
    CV.SV.NotifyPlayer(ply, "You need ".. value .. " currency to spawn this item.")
  end
end

hook.Add("PlayerSpawnedVehicle", "sv_handle_vehicle_value", CV.SV.HandleVehicleValue)

CV.SV.HandleNPCValue = function(ply, entity)
  if !GetConVar("gcv_value_enabled"):GetBool() then return end

  value = GetConVar("gcv_value_npc_default"):GetInt()

  if CV.SV.Conf.NPCValues[entity:GetClass()] then
    value = CV.SV.Conf.NPCValues[entity:GetClass()]
  end

  value = value * entity:Health() * GetConVar("gcv_value_npc_health_mul"):GetInt()
  value = math.floor(value)

  if !CV.SV.RemoveCurrencyToPlayer(ply, value) then
    entity:Remove()
    CV.SV.NotifyPlayer(ply, "You need ".. value .. " currency to spawn this item.")
  end
end

hook.Add("PlayerSpawnedNPC", "sv_handle_npc_value", CV.SV.HandleNPCValue)

CV.SV.HandleToolValue = function(ply, tr, tool)
  if !GetConVar("gcv_value_enabled"):GetBool() then return end

  value = GetConVar("gcv_value_tool_default"):GetInt()

  if CV.SV.Conf.ToolValues[tool] then
    value = CV.SV.Conf.ToolValues[tool]
  end

  if !CV.SV.RemoveCurrencyToPlayer(ply, value) then
    CV.SV.NotifyPlayer(ply, "You need ".. value .. " currency to use this tool.")
    return false
  end
end

hook.Add("CanTool", "sv_handle_tool_value", CV.SV.HandleToolValue)
