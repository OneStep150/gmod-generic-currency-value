CV = CV or {}
CV.SV = CV.SV or {}

CV.SV.RewardOnNPCKilled = function(npc, killer)
  if !GetConVar("gcv_reward_enabled"):GetBool() then return end

  local value = GetConVar("gcv_value_npc_default"):GetInt()

  if CV.SV.Conf.NPCValues[npc:GetClass()] then
    value = CV.SV.Conf.NPCValues[npc:GetClass()]
  else
    value = value * npc:GetMaxHealth() * GetConVar("gcv_value_npc_health_mul"):GetInt()
    value = math.floor(value)
  end

  if GetConVar("gcv_reward_autopickup_enabled"):GetBool() then
    if !killer:IsValid() then return end
    if !killer:IsPlayer() then return end
    CV.SV.AddCurrencyToPlayer(killer, value)
  else
    CV.SV.CreateCurrencyEntity(npc:GetPos() + Vector(0, 0, 10), value)
  end
end

hook.Add("OnNPCKilled", "sv_reward_on_npc_killed", CV.SV.RewardOnNPCKilled)
