AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

CV = CV or {}
CV.SV = CV.SV or {}
CV.SV.Node = CV.SV.Node or {}

ENT.CurrencyAmount = ENT.CurrencyAmount or 0

function ENT:Initialize()
	local minCurrency = GetConVar("gcv_value_objective_min"):GetInt()
	local maxCurrency = GetConVar("gcv_value_objective_max"):GetInt()

	self:SetModel( "models/Items/item_item_crate.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	self.CurrencyAmount = math.floor(math.random(minCurrency, maxCurrency))

  local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end

	if !CV.SV.Node.Data then
  	CV.SV.Node.GenerateNodeDataFromFile()
	end

	local pos = table.Random(CV.SV.Node.Data).pos
	self:SetPos(pos + Vector(0, 0, 20))

end

function ENT:Use(ply)
  CV.SV.AddCurrencyToPlayer(ply, self.CurrencyAmount)
	self:Remove()
end
