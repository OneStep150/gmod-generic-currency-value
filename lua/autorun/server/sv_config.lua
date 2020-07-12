CV.SV = CV.SV or {}
CV.SV.Conf = CV.SV.Conf or {}
CV.SV.FCVARS = { FCVAR_SERVER_CAN_EXECUTE, FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_NOTIFY }

CreateConVar("gcv_value_enabled", 1, CV.SV.FCVARS)
CreateConVar("gcv_reward_enabled", 1, CV.SV.FCVARS)
CreateConVar("gcv_drop_ondeath_enabled", 1, CV.SV.FCVARS)

CreateConVar("gcv_value_prop_default", 50, CV.SV.FCVARS)
CreateConVar("gcv_value_prop_weight_mul", 2, CV.SV.FCVARS)

CreateConVar("gcv_value_ragdoll_default", 50, CV.SV.FCVARS)
CreateConVar("gcv_value_ragdoll_weight_mul", 2, CV.SV.FCVARS)

CreateConVar("gcv_value_entity_default", 100, CV.SV.FCVARS)
CreateConVar("gcv_value_entity_weight_mul", 2, CV.SV.FCVARS)

CreateConVar("gcv_value_vehicle_default", 1000, CV.SV.FCVARS)
CreateConVar("gcv_value_vehicle_weight_mul", 2, CV.SV.FCVARS)

CreateConVar("gcv_value_npc_default", 1000, CV.SV.FCVARS)
CreateConVar("gcv_value_npc_health_mul", 2, CV.SV.FCVARS)

CreateConVar("gcv_value_swep_default", 200, CV.SV.FCVARS)

CreateConVar("gcv_value_tool_default", 10, CV.SV.FCVARS)

if !file.Exists("gcv", "DATA") then
  file.CreateDir("gcv")
end

CV.SV.Conf.PropValues = CV.SV.Conf.PropValues or util.JSONToTable(file.Read("gcv/prop_values.txt", "DATA") or "") or {}
CV.SV.Conf.RagdollValues = CV.SV.Conf.RagdollValues or util.JSONToTable(file.Read("gcv/ragdoll_values.txt", "DATA") or "") or {}
CV.SV.Conf.EntityValues = CV.SV.Conf.EntityValues or util.JSONToTable(file.Read("gcv/entity_values.txt", "DATA") or "") or {}
CV.SV.Conf.VehicleValues = CV.SV.Conf.VehicleValues or util.JSONToTable(file.Read("gcv/vehicle_values.txt", "DATA") or "") or {}
CV.SV.Conf.NPCValues = CV.SV.Conf.NPCValues or util.JSONToTable(file.Read("gcv/npc_values.txt", "DATA") or "") or {}
CV.SV.Conf.SwepValues = CV.SV.Conf.SwepValues or util.JSONToTable(file.Read("gcv/swep_values.txt", "DATA") or "") or {}
CV.SV.Conf.ToolValues = CV.SV.Conf.ToolValues or util.JSONToTable(file.Read("gcv/tool_values.txt", "DATA") or "") or {}

CV.SV.Conf.SavePropValue = function()
  file.Write("gcv/prop_values.txt", util.TableToJSON(CV.SV.Conf.PropValues))
end
CV.SV.Conf.SaveRagdollValue = function()
  file.Write("gcv/ragdoll_values.txt", util.TableToJSON(CV.SV.Conf.RagdollValues))
end
CV.SV.Conf.SaveEntityValue = function()
  file.Write("gcv/entity_values.txt", util.TableToJSON(CV.SV.Conf.EntityValues))
end
CV.SV.Conf.SaveVehicleValue = function()
  file.Write("gcv/vehicle_values.txt", util.TableToJSON(CV.SV.Conf.VehicleValues))
end
CV.SV.Conf.SaveNPCValue = function()
  file.Write("gcv/npc_values.txt", util.TableToJSON(CV.SV.Conf.NPCValues))
end
CV.SV.Conf.SaveSwepValue = function()
  file.Write("gcv/swep_values.txt", util.TableToJSON(CV.SV.Conf.SwepValues))
end
CV.SV.Conf.SaveToolValue = function()
  file.Write("gcv/tool_values.txt", util.TableToJSON(CV.SV.Conf.ToolValues))
end

CV.SV.Conf.AddValue = function(tValues, class, value)
  tValues[class] = value
end

CV.SV.Conf.RemoveValue = function(tValues, class)
  tValues[class] = nil
end

CV.SV.Conf.AddPropValueOnCMD = function(ply, cmd, args)
  class = tostring(args[1])
  value = tonumber(args[2])
  if class and value then
    CV.SV.Conf.AddValue(CV.SV.Conf.PropValues, args[1], args[2])
    CV.SV.Conf.SavePropValue()
  end
end

concommand.Add("gcv_value_prop_add", CV.SV.Conf.AddPropValueOnCMD)

CV.SV.Conf.RemovePropValueOnCMD = function(ply, cmd, args)
  class = tostring(args[1])
  if class then
    CV.SV.Conf.RemoveValue(CV.SV.Conf.PropValues, class)
    CV.SV.Conf.SavePropValue()
  end
end

concommand.Add("gcv_value_prop_remove", CV.SV.Conf.RemovePropValueOnCMD)

CV.SV.Conf.ClearPropValueOnCMD = function(ply, cmd, args)
  table.Empty(CV.SV.Conf.PropValues)
  CV.SV.Conf.SavePropValue()
end

concommand.Add("gcv_value_prop_clear", CV.SV.Conf.ClearPropValueOnCMD)

CV.SV.Conf.AddEntityValueOnCMD = function(ply, cmd, args)
  class = tostring(args[1])
  value = tonumber(args[2])
  if class and value then
    CV.SV.Conf.AddValue(CV.SV.Conf.EntityValues, args[1], args[2])
    CV.SV.Conf.SaveEntityValue()
  end
end

concommand.Add("gcv_value_entity_add", CV.SV.Conf.AddEntityValueOnCMD)

CV.SV.Conf.RemoveEntityValueOnCMD = function(ply, cmd, args)
  class = tostring(args[1])
  if class then
    CV.SV.Conf.RemoveValue(CV.SV.Conf.EntityValues, class)
    CV.SV.Conf.SaveEntityValue()
  end
end

concommand.Add("gcv_value_entity_remove", CV.SV.Conf.RemoveEntityValueOnCMD)

CV.SV.Conf.ClearEntityValueOnCMD = function(ply, cmd, args)
  table.Empty(CV.SV.Conf.EntityValues)
  CV.SV.Conf.SaveEntityValue()
end

concommand.Add("gcv_value_entity_clear", CV.SV.Conf.ClearEntityValueOnCMD)

CV.SV.Conf.AddToolValueOnCMD = function(ply, cmd, args)
  class = tostring(args[1])
  value = tonumber(args[2])
  if class and value then
    CV.SV.Conf.AddValue(CV.SV.Conf.ToolValues, args[1], args[2])
    CV.SV.Conf.SaveToolValue()
  end
end

concommand.Add("gcv_value_tool_add", CV.SV.Conf.AddToolValueOnCMD)

CV.SV.Conf.RemoveToolValueOnCMD = function(ply, cmd, args)
  class = tostring(args[1])
  if class then
    CV.SV.Conf.RemoveValue(CV.SV.Conf.ToolValues, class)
    CV.SV.Conf.SaveToolValue()
  end
end

concommand.Add("gcv_value_tool_remove", CV.SV.Conf.RemoveToolValueOnCMD)

CV.SV.Conf.ClearToolValueOnCMD = function(ply, cmd, args)
  table.Empty(CV.SV.Conf.ToolValues)
  CV.SV.Conf.SaveToolValue()
end

concommand.Add("gcv_value_tool_clear", CV.SV.Conf.ClearToolValueOnCMD)

CV.SV.Conf.AddSwepValueOnCMD = function(ply, cmd, args)
  class = tostring(args[1])
  value = tonumber(args[2])
  if class and value then
    CV.SV.Conf.AddValue(CV.SV.Conf.SwepValues, args[1], args[2])
    CV.SV.Conf.SaveSwepValue()
  end
end

concommand.Add("gcv_value_swep_add", CV.SV.Conf.AddSwepValueOnCMD)

CV.SV.Conf.RemoveSwepValueOnCMD = function(ply, cmd, args)
  class = tostring(args[1])
  if class then
    CV.SV.Conf.RemoveValue(CV.SV.Conf.SwepValues, class)
    CV.SV.Conf.SaveSwepValue()
  end
end

concommand.Add("gcv_value_swep_remove", CV.SV.Conf.RemoveSwepValueOnCMD)

CV.SV.Conf.ClearSwepValueOnCMD = function(ply, cmd, args)
  table.Empty(CV.SV.Conf.SwepValues)
  CV.SV.Conf.SaveSwepValue()
end

concommand.Add("gcv_value_swep_clear", CV.SV.Conf.ClearSwepValueOnCMD)

CV.SV.Conf.AddVehicleValueOnCMD = function(ply, cmd, args)
  class = tostring(args[1])
  value = tonumber(args[2])
  if class and value then
    CV.SV.Conf.AddValue(CV.SV.Conf.VehicleValues, args[1], args[2])
    CV.SV.Conf.SaveVehicleValue()
  end
end

concommand.Add("gcv_value_vehicle_add", CV.SV.Conf.AddVehicleValueOnCMD)

CV.SV.Conf.RemoveVehicleValueOnCMD = function(ply, cmd, args)
  class = tostring(args[1])
  if class then
    CV.SV.Conf.RemoveValue(CV.SV.Conf.VehicleValues, class)
    CV.SV.Conf.SaveVehicleValue()
  end
end

concommand.Add("gcv_value_vehicle_remove", CV.SV.Conf.RemoveVehicleValueOnCMD)

CV.SV.Conf.ClearVehicleValueOnCMD = function(ply, cmd, args)
  table.Empty(CV.SV.Conf.VehicleValues)
  CV.SV.Conf.SaveVehicleValue()
end

concommand.Add("gcv_value_vehicle_clear", CV.SV.Conf.ClearVehicleValueOnCMD)

CV.SV.Conf.AddNPCValueOnCMD = function(ply, cmd, args)
  class = tostring(args[1])
  value = tonumber(args[2])
  if class and value then
    CV.SV.Conf.AddValue(CV.SV.Conf.NPCValues, args[1], args[2])
    CV.SV.Conf.SaveNPCValue()
  end
end

concommand.Add("gcv_value_npc_add", CV.SV.Conf.AddNPCValueOnCMD)

CV.SV.Conf.RemoveNPCValueOnCMD = function(ply, cmd, args)
  class = tostring(args[1])
  if class then
    CV.SV.Conf.RemoveValue(CV.SV.Conf.NPCValues, class)
    CV.SV.Conf.SaveNPCValue()
  end
end

concommand.Add("gcv_value_npc_remove", CV.SV.Conf.RemoveNPCValueOnCMD)

CV.SV.Conf.ClearNPCValueOnCMD = function(ply, cmd, args)
  table.Empty(CV.SV.Conf.NPCValues)
  CV.SV.Conf.SaveNPCValue()
end

concommand.Add("gcv_value_npc_clear", CV.SV.Conf.ClearNPCValueOnCMD)

CV.SV.Conf.AddRagdollValueOnCMD = function(ply, cmd, args)
  class = tostring(args[1])
  value = tonumber(args[2])
  if class and value then
    CV.SV.Conf.AddValue(CV.SV.Conf.RagdollValues, args[1], args[2])
    CV.SV.Conf.SaveRagdollValue()
  end
end

concommand.Add("gcv_value_ragdoll_add", CV.SV.Conf.AddRagdollValueOnCMD)

CV.SV.Conf.RemoveRagdollValueOnCMD = function(ply, cmd, args)
  class = tostring(args[1])
  if class then
    CV.SV.Conf.RemoveValue(CV.SV.Conf.RagdollValues, class)
    CV.SV.Conf.SaveRagdollValue()
  end
end

concommand.Add("gcv_value_ragdoll_remove", CV.SV.Conf.RemoveRagdollValueOnCMD)

CV.SV.Conf.ClearRagdollValueOnCMD = function(ply, cmd, args)
  table.Empty(CV.SV.Conf.RagdollValues)
  CV.SV.Conf.SaveRagdollValue()
end

concommand.Add("gcv_value_ragdoll_clear", CV.SV.Conf.ClearRagdollValueOnCMD)
