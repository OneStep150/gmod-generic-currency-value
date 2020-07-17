CV = CV or {}

CV.Util = CV.Util or {}

CV.Util.SIZEOF_INT = 4
CV.Util.SIZEOF_SHORT = 2
CV.Util.AINET_VERSION_NUMBER = 37

CV.Util.ToUShort = function(b)
	local i = {string.byte(b,1, CV.Util.SIZEOF_SHORT)}
	return i[1] +i[2] *256
end

CV.Util.ToInt = function(b)
	local i = {string.byte(b, 1, CV.Util.SIZEOF_INT)}
	i = i[1] +i[2] *256 +i[3] *65536 +i[4] *16777216

	if (i > 2147483647) then
		return i -4294967296
	end

	return i
end

CV.Util.ReadInt = function(f)
  return CV.Util.ToInt(f:Read(CV.Util.SIZEOF_INT))
end

CV.Util.ReadUShort = function(f)
  return CV.Util.ToUShort(f:Read(CV.Util.SIZEOF_SHORT))
end

CV.Util.FindPlayerByName = function(name)
  local target = nil

  for i, v in ipairs(player.GetAll()) do
    if v:GetName() == name then
      target = v
    end
  end

  return target
end

CV.Util.ComformCurrencyAmount = function(amount)
  return math.floor(amount)
end
