CV = CV or {}
CV.Util = CV.Util or {}

CV.SV = CV.SV or {}
CV.SV.Node = CV.SV.Node or {}
CV.SV.Node.Data = CV.SV.Node.Data or {}

-- Credits for the NodeGraph File Conversion to a usable Object goes to Silverlan
--2 = info_nodes
--3 = playerspawns
--4 = wall climbers
CV.SV.Node.GenerateNodeDataFromFile = function()
	local nodeFile = file.Open("maps/graphs/" ..game.GetMap() ..".ain","rb","GAME")

  if (!nodeFile) then
		return
	end

	local ainet_ver = CV.Util.ReadInt(nodeFile)
	local map_ver = CV.Util.ReadInt(nodeFile)

	if (ainet_ver != CV.Util.AINET_VERSION_NUMBER) then
		print("Unknown graph file")
		return
	end

	local nodeAmount = CV.Util.ReadInt(nodeFile)
	if (nodeAmount < 0) then
		print("Graph file has an unexpected amount of nodes")
		return
	end

	for i = 1, nodeAmount do
		local v = Vector(nodeFile:ReadFloat(),nodeFile:ReadFloat(),nodeFile:ReadFloat())
		local yaw = nodeFile:ReadFloat()
		local flOffsets = {}
		for i = 1,NUM_HULLS do
			flOffsets[i] = nodeFile:ReadFloat()
		end
		local nodetype = nodeFile:ReadByte()
		local nodeinfo = CV.Util.ReadUShort(nodeFile)
		local zone = nodeFile:ReadShort()

		local node = {
			pos = v,
			yaw = yaw,
			offset = flOffsets,
			type = nodetype,
			info = nodeinfo,
			zone = zone,
			neighbor = {},
			numneighbors = 0,
			link = {},
			numlinks = 0
		}

		table.insert(CV.SV.Node.Data, node)
	end
end

hook.Add("Initialize", "sv_init_node_data", CV.SV.Node.GenerateNodeDataFromFile)
