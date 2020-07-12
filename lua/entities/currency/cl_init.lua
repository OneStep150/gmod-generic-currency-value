include('shared.lua')

function ENT:Draw()
   self:DrawModel()

   distanceToLocalPlayer = LocalPlayer():GetPos():DistToSqr(self:GetPos())
   --Distance is Squared because of Distance func above, docs say its faster this way.
   allowedDistance = 50*50

   if self:BeingLookedAtByLocalPlayer() and distanceToLocalPlayer < allowedDistance then
     AddWorldTip( self:EntIndex(), self:GetNWInt("CurrencyAmount") .. " Currency", 0.5, self:GetPos(), self  )
   end

end
