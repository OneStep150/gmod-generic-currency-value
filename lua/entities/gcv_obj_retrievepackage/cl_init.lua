include('shared.lua')

CV.CL = CV.CL or {}
CV.CL.ENT = CV.CL.ENT or {}
CV.CL.ENT.Objective = CV.CL.ENT.Objective or {}
CV.CL.ENT.Objective.RetrievePackage = CV.CL.ENT.Objective.RetrievePackage or {}

CV.CL.ENT.Objective.RetrievePackage.TextScale = function(ent)
  local distanceToLocalPlayer = LocalPlayer():GetPos():DistToSqr(ent:GetPos())
  return math.Clamp(1 + distanceToLocalPlayer / 2500000, 0, 20 )
end

CV.CL.ENT.Objective.RetrievePackage.TextAngle = function(ent)
  local targetAngle = (LocalPlayer():GetPos() - ent:GetPos()):Angle()
  return Angle(0, 90 + targetAngle.yaw, 90 + targetAngle.pitch)
end

function ENT:Draw()
   self:DrawModel()

   if GetConVar("gcv_objective_drawpos"):GetBool() then
     cam.IgnoreZ(true)
     cam.Start3D2D( self:GetPos(), CV.CL.ENT.Objective.RetrievePackage.TextAngle(self), CV.CL.ENT.Objective.RetrievePackage.TextScale(self))
         draw.SimpleTextOutlined( "Retrieve!", "DermaDefault", 0, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )
     cam.End3D2D()
   end
end

CV.CL.ENT.Objective.RetrievePackage.AddHalo = function()
  if GetConVar("gcv_objective_drawpos"):GetBool() then
     halo.Add( ents.FindByClass( "gcv_obj_retrievepackage" ), Color( 255, 0, 0 ), 5, 5, 2, false, true )
  end
end

hook.Add( "PreDrawHalos", "cl_objective_drawhalo", CV.CL.ENT.Objective.RetrievePackage.AddHalo)
