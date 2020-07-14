AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

CV.SV = CV.SV or {}
CV.SV.ENT = CV.SV.ENT or {}
CV.SV.ENT.Currency = CV.SV.ENT.Currency or {}
CV.SV.ENT.Currency.Ents = CV.SV.ENT.Currency.Ents or {}

CV.SV.ENT.Currency.AddToRegister = function(ent)
	table.insert(CV.SV.ENT.Currency.Ents, ent)
	CV.SV.ENT.Currency.HandleEntityLimit()
end

CV.SV.ENT.Currency.HandleEntityLimit = function()
	if table.Count(CV.SV.ENT.Currency.Ents) > GetConVar("gcv_currency_maxentities"):GetInt() then
		ent = table.GetFirstValue(CV.SV.ENT.Currency.Ents)
		table.RemoveByValue(CV.SV.ENT.Currency.Ents, ent)
		ent:Remove()
	end
end

ENT.CurrencyAmount = ENT.CurrencyAmount or 1

function ENT:Initialize()

	self:SetModel( "models/props/cs_assault/Money.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	self:SetNWInt("CurrencyAmount", self.CurrencyAmount)

  local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end

	CV.SV.ENT.Currency.AddToRegister(self)
end

function ENT:Use(ply)
  CV.SV.AddCurrencyToPlayer(ply, self.CurrencyAmount)
	self:Remove()
end

function ENT:OnRemove()
	table.RemoveByValue(CV.SV.ENT.Currency.Ents, self)
end
