CV = CV or {}

CV.Util = CV.Util or {}
CV.Util.FindPlayerByName = function(name)
  target = nil

  for i, v in ipairs(player.GetAll()) do
    if v:GetName() == name then
      target = v
    end
  end

  return target
end
