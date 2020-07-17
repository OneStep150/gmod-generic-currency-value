include('shared.lua')

CV.CL = CV.CL or {}
CV.CL.ENT = CV.CL.ENT or {}
CV.CL.ENT.Currency = CV.CL.ENT.Currency or {}

CV.CL.ENT.Currency.TextScale = 0.3
CV.CL.ENT.Currency.TextMaxDistance = 100
CV.CL.ENT.Currency.TextPosition = function(ent)
  return ent:GetPos() + ent:GetUp() * 1 + ent:GetRight() * -0.3
end
CV.CL.ENT.Currency.TextPositionBack = function(ent)
  return ent:GetPos() + ent:GetUp() * 0 + ent:GetRight() * -0.3
end
CV.CL.ENT.Currency.TextAngleBack = function(ent)
return ent:LocalToWorldAngles(Angle(180, 0, 0))
end

function ENT:Draw()
   self:DrawModel()

   distanceToLocalPlayer = LocalPlayer():GetPos():DistToSqr(self:GetPos())
   allowedDistance = CV.CL.ENT.Currency.TextMaxDistance * CV.CL.ENT.Currency.TextMaxDistance

   if self:BeingLookedAtByLocalPlayer() and distanceToLocalPlayer < allowedDistance then
     cam.Start3D2D( CV.CL.ENT.Currency.TextPosition(self), self:GetAngles(), CV.CL.ENT.Currency.TextScale )
     		draw.SimpleTextOutlined( self:GetNWInt("CurrencyAmount"), "DermaDefault", 0, 0, Color(150, 255, 150), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )
   	  cam.End3D2D()

      cam.Start3D2D( CV.CL.ENT.Currency.TextPositionBack(self), CV.CL.ENT.Currency.TextAngleBack(self), CV.CL.ENT.Currency.TextScale )
         draw.SimpleTextOutlined( self:GetNWInt("CurrencyAmount"), "DermaDefault", 0, 0, Color(150, 255, 150), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )
       cam.End3D2D()
   end

end
