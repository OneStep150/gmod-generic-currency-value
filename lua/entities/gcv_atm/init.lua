AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

util.AddNetworkString("cv_atm_openmenu")
util.AddNetworkString("cv_atm_request_data")
util.AddNetworkString("cv_atm_response_data")

util.AddNetworkString("cv_atm_deposit_request")
util.AddNetworkString("cv_atm_deposit_response")

util.AddNetworkString("cv_atm_withdraw_request")
util.AddNetworkString("cv_atm_withdraw_response")

util.AddNetworkString("cv_atm_transfer_request")
util.AddNetworkString("cv_atm_transfer_response")

CV.SV = CV.SV or {}
CV.SV.ENT = CV.SV.ENT or {}
CV.SV.ENT.ATM = CV.SV.ENT.ATM or {}

CV.SV.ENT.ATM.Deposit = function(len, ply)
	steamid = net.ReadString()
	amount = net.ReadInt(32)

	print(amount)

	successful = false

	if CV.SV.RemoveCurrencyFromPlayer(ply, amount) then
		atmBalance = CV.SV.Conf.ATMValues[steamid] or 0
		atmBalance = atmBalance + amount
		CV.SV.Conf.AddValue(CV.SV.Conf.ATMValues, steamid, atmBalance)
		CV.SV.Conf.SaveATMValue()
		successful = true
	end

	net.Start("cv_atm_deposit_response")
	net.WriteBool(successful)
	net.Send(ply)
end

net.Receive("cv_atm_deposit_request", CV.SV.ENT.ATM.Deposit)

CV.SV.ENT.ATM.Withdraw = function(len, ply)
	steamid = net.ReadString()
	amount = net.ReadInt(32)

	successful = false

	atmBalance = CV.SV.Conf.ATMValues[steamid] or 0
	if atmBalance - amount >= 0 then
		atmBalance = atmBalance - amount
		CV.SV.AddCurrencyToPlayer(ply, amount)
		CV.SV.Conf.AddValue(CV.SV.Conf.ATMValues, steamid, atmBalance)
		CV.SV.Conf.SaveATMValue()
		successful = true
	end

	net.Start("cv_atm_withdraw_response")
	net.WriteBool(successful)
	net.Send(ply)
end

net.Receive("cv_atm_withdraw_request", CV.SV.ENT.ATM.Withdraw)

CV.SV.ENT.ATM.Transfer = function(len, ply)
	steamid = net.ReadString()
	amount = net.ReadInt(32)

	successful = false

	atmBalance = CV.SV.Conf.ATMValues[ply:SteamID64()] or 0
	targetATMBalance = CV.SV.Conf.ATMValues[steamid] or 0

	print(atmBalance - amount)
	if atmBalance - amount >= 0 then
		atmBalance = atmBalance - amount
		targetATMBalance = targetATMBalance + amount
		CV.SV.Conf.AddValue(CV.SV.Conf.ATMValues, ply:SteamID64(), atmBalance)
		CV.SV.Conf.AddValue(CV.SV.Conf.ATMValues, steamid, targetATMBalance)
		CV.SV.Conf.SaveATMValue()
		successful = true
	end

	net.Start("cv_atm_transfer_response")
	net.WriteBool(successful)
	net.Send(ply)
end

net.Receive("cv_atm_transfer_request", CV.SV.ENT.ATM.Transfer)

CV.SV.ENT.ATM.RequestData = function(len, ply)
	net.Start("cv_atm_response_data")
	net.WriteTable(CV.SV.Conf.ATMValues or {})
	net.Send(ply)
end

net.Receive("cv_atm_request_data", CV.SV.ENT.ATM.RequestData)

function ENT:Initialize()

	self:SetModel( "models/props_lab/reciever_cart.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetPos(self:GetPos() + Vector(0, 0, 50))

	self:SetUseType(SIMPLE_USE)

  local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:Use(ply)
	net.Start("cv_atm_openmenu")
	net.Send(ply)
end

function ENT:PhysicsCollide(data, ent)
	if data.HitEntity:GetClass() == "currency" && !ent.Dispensed then
		data.HitEntity:Remove()
	end
end
