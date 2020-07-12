AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

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
end

function ENT:Use(ply)
  CV.SV.AddCurrencyToPlayer(ply, self.CurrencyAmount)
	self:Remove()
end
