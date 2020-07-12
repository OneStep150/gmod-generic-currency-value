CV.CL = CV.CL or {}
CV.CL.GUI = CV.CL.GUI or {}
CV.CL.GUI.FreeTextSelectionTab = CV.CL.GUI.FreeTextSelectionTab or {}
CV.CL.GUI.ListSelectionTab = CV.CL.GUI.ListSelectionTab or {}

CV.CL.GUI.OpenMenu = function()
  frame = vgui.Create("DFrame")
  frame:SetTitle("Generic Currency Value | Menu")
  frame:SetSize(1024, 512)
  frame:Center()
  frame:IsVisible(true)
  frame:MakePopup()

  frame.checkboxValueEnable = vgui.Create("DCheckBox", frame)
  frame.checkboxValueEnable:SetPos( 25, 50 )
  frame.checkboxValueEnable:SetValue( true )

  frame.labelValueEnable = vgui.Create("DLabel", frame)
  frame.labelValueEnable:SetPos(45, 50)
  frame.labelValueEnable:SetSize(200, 15)
  frame.labelValueEnable:SetText("Enable Value to Spawnables?")

  frame.checkboxAdminIgnoreEnable = vgui.Create("DCheckBox", frame)
  frame.checkboxAdminIgnoreEnable:SetPos( 25, 75 )
  frame.checkboxAdminIgnoreEnable:SetValue( true )

  frame.labelValueEnable = vgui.Create("DLabel", frame)
  frame.labelValueEnable:SetPos(45, 75)
  frame.labelValueEnable:SetSize(200, 15)
  frame.labelValueEnable:SetText("Ignore Value to Spawnables for Admins?")

  frame.sheet = vgui.Create("DPropertySheet", frame)
  frame.sheet:SetPos(20, 110)
  frame.sheet:SetSize(985, 385)

  frame.propTab = vgui.Create("DPanel", frame.sheet)
  frame.sheet:AddSheet("Props", frame.propTab, "icon16/cross.png")
  CV.CL.GUI.FreeTextSelectionTab.Build(frame.propTab, "prop")

  frame.ragdollTab = vgui.Create("DPanel", frame.sheet)
  frame.sheet:AddSheet("Ragdolls", frame.ragdollTab, "icon16/cross.png")
  CV.CL.GUI.FreeTextSelectionTab.Build(frame.ragdollTab, "ragdoll")

  frame.entityTab = vgui.Create("DPanel", frame.sheet)
  frame.sheet:AddSheet("Entity", frame.entityTab, "icon16/cross.png")
  CV.CL.GUI.ListSelectionTab.Build(frame.entityTab, "entity")

  frame.vehicleTab = vgui.Create("DPanel", frame.sheet)
  frame.sheet:AddSheet("Vehicle", frame.vehicleTab, "icon16/cross.png")
  CV.CL.GUI.ListSelectionTab.Build(frame.vehicleTab, "vehicle")

  frame.npcTab = vgui.Create("DPanel", frame.sheet)
  frame.sheet:AddSheet("NPCs", frame.npcTab, "icon16/cross.png")
  CV.CL.GUI.ListSelectionTab.Build(frame.npcTab, "npc")

  frame.swepTab = vgui.Create("DPanel", frame.sheet)
  frame.sheet:AddSheet("SWEPs", frame.swepTab, "icon16/cross.png")
  CV.CL.GUI.ListSelectionTab.Build(frame.swepTab, "swep")

  frame.toolTab = vgui.Create("DPanel", frame.sheet)
  frame.sheet:AddSheet("Tools", frame.toolTab, "icon16/cross.png")
  CV.CL.GUI.ListSelectionTab.Build(frame.toolTab, "tool")
end

concommand.Add("gcv_menu", CV.CL.GUI.OpenMenu)

CV.CL.GUI.FreeTextSelectionTab.Build = function(parent, category)
  parent.list = vgui.Create( "DListView", parent )
  parent.list:SetPos(10, 10)
  parent.list:SetSize(700, 325)
  parent.list:SetMultiSelect(true)
  parent.list:AddColumn("Name")
  parent.list:AddColumn("Value")

  parent.labeltoAddName = vgui.Create("DLabel", parent)
  parent.labeltoAddName:SetPos(725, 20)
  parent.labeltoAddName:SetSize(200, 15)
  parent.labeltoAddName:SetTextColor(Color(0, 0, 0))
  parent.labeltoAddName:SetText("Name of item to add Value to:")

  parent.toAddName = vgui.Create( "DTextEntry", parent ) -- create the form as a child of frame
  parent.toAddName:SetPos(725, 40)
  parent.toAddName:SetSize(225, 30)
  parent.toAddName:SetValue("")

  parent.labeltoAddValue = vgui.Create("DLabel", parent)
  parent.labeltoAddValue:SetPos(725, 80)
  parent.labeltoAddValue:SetSize(200, 15)
  parent.labeltoAddValue:SetTextColor(Color(0, 0, 0))
  parent.labeltoAddValue:SetText("How valuable to make the item:")

  parent.toAddValue = vgui.Create("DNumberWang", parent)
  parent.toAddValue:SetPos(725, 100)
  parent.toAddValue:SetSize(150, 30)
  parent.toAddValue:SetMin(0)
  parent.toAddValue:SetMax(1000000)

  parent.buttonAdd = vgui.Create("DButton", parent)
  parent.buttonAdd:SetPos(725, 230)
  parent.buttonAdd:SetSize(225, 30)
  parent.buttonAdd:SetText("Add")

  parent.buttonUpdate = vgui.Create("DButton", parent)
  parent.buttonUpdate:SetPos(725, 265)
  parent.buttonUpdate:SetSize(225, 30)
  parent.buttonUpdate:SetText("Update")

  parent.buttonDelete = vgui.Create("DButton", parent)
  parent.buttonDelete:SetPos(725, 300)
  parent.buttonDelete:SetSize(225, 30)
  parent.buttonDelete:SetText("Delete")

  if category == "prop" then

  end
  if category == "ragdoll" then

  end
end

CV.CL.GUI.ListSelectionTab.Build = function(parent, category)
  parent.list = vgui.Create( "DListView", parent )
  parent.list:SetPos(10, 10)
  parent.list:SetSize(700, 325)
  parent.list:SetMultiSelect(true)
  parent.list:AddColumn("Name")
  parent.list:AddColumn("Value")

  parent.labelToAddName = vgui.Create("DLabel", parent)
  parent.labelToAddName:SetPos(725, 5)
  parent.labelToAddName:SetSize(200, 15)
  parent.labelToAddName:SetTextColor(Color(0, 0, 0))
  parent.labelToAddName:SetText("Name of item/s to add Value to:")

  parent.toAddList = vgui.Create( "DListView", parent )
  parent.toAddList:SetPos(725, 25)
  parent.toAddList:SetSize(225, 150)
  parent.toAddList:SetMultiSelect(true)
  parent.toAddList:AddColumn("Name")

  parent.labelToAddValue = vgui.Create("DLabel", parent)
  parent.labelToAddValue:SetPos(725, 177)
  parent.labelToAddValue:SetSize(100, 15)
  parent.labelToAddValue:SetTextColor(Color(0, 0, 0))
  parent.labelToAddValue:SetText("How valuable:")

  parent.ToAddValue = vgui.Create("DNumberWang", parent)
  parent.ToAddValue:SetPos(725, 195)
  parent.ToAddValue:SetSize(75, 30)
  parent.ToAddValue:SetMin(0)
  parent.ToAddValue:SetMax(1000000)

  parent.labelSearch = vgui.Create("DLabel", parent)
  parent.labelSearch:SetPos(810, 177)
  parent.labelSearch:SetSize(200, 15)
  parent.labelSearch:SetTextColor(Color(0, 0, 0))
  parent.labelSearch:SetText("Search:")

  parent.search = vgui.Create( "DTextEntry", parent )
  parent.search:SetPos(810, 195)
  parent.search:SetSize(140, 30)
  parent.search:SetValue("")

  parent.buttonAdd = vgui.Create("DButton", parent)
  parent.buttonAdd:SetPos(725, 230)
  parent.buttonAdd:SetSize(225, 30)
  parent.buttonAdd:SetText("Add")

  parent.buttonUpdate = vgui.Create("DButton", parent)
  parent.buttonUpdate:SetPos(725, 265)
  parent.buttonUpdate:SetSize(225, 30)
  parent.buttonUpdate:SetText("Update")

  parent.buttonDelete = vgui.Create("DButton", parent)
  parent.buttonDelete:SetPos(725, 300)
  parent.buttonDelete:SetSize(225, 30)
  parent.buttonDelete:SetText("Delete")

  if category == "entity" then
    CV.CL.GUI.AddEntityCategoryLogic(parent)
  end
  if category == "vehicle" then
    CV.CL.GUI.AddVehicleCategoryLogic(parent)
  end
  if category == "npc" then
    CV.CL.GUI.AddNPCCategoryLogic(parent)
  end
  if category == "swep" then
    CV.CL.GUI.AddSwepCategoryLogic(parent)
  end
  if category == "tool" then
    CV.CL.GUI.AddToolCategoryLogic(parent)
  end
end

CV.CL.GUI.AddEntityCategoryLogic = function(parent)
  for i,v in ipairs(CV.CL.GUI.ListSelectionTab.GetEntities()) do
    parent.toAddList:AddLine(v)
  end

  parent.search.OnValueChange = CV.CL.GUI.ListSelectionTab.EntitySearchFunc
end

CV.CL.GUI.AddVehicleCategoryLogic = function(parent)
  for i,v in ipairs(CV.CL.GUI.ListSelectionTab.GetVehicles()) do
    parent.toAddList:AddLine(v)
  end

  parent.search.OnValueChange = CV.CL.GUI.ListSelectionTab.VehicleSearchFunc
end

CV.CL.GUI.AddNPCCategoryLogic = function(parent)
  for i,v in ipairs(CV.CL.GUI.ListSelectionTab.GetNPCs()) do
    parent.toAddList:AddLine(v)
  end

  parent.search.OnValueChange = CV.CL.GUI.ListSelectionTab.NPCSearchFunc
end

CV.CL.GUI.AddSwepCategoryLogic = function(parent)
  for i,v in ipairs(CV.CL.GUI.ListSelectionTab.GetSweps()) do
    parent.toAddList:AddLine(v)
  end

  parent.search.OnValueChange = CV.CL.GUI.ListSelectionTab.SwepSearchFunc
end

CV.CL.GUI.AddToolCategoryLogic = function(parent)
  for i,v in ipairs(CV.CL.GUI.ListSelectionTab.GetTools()) do
    parent.toAddList:AddLine(v)
  end

  parent.search.OnValueChange = CV.CL.GUI.ListSelectionTab.ToolSearchFunc
end

CV.CL.GUI.ListSelectionTab.GetEntities = function(filter)
  entities = {}
  for i,v in ipairs(scripted_ents.GetSpawnable()) do
    if !filter or string.match(v.ClassName, ".*"..filter..".*") then
      table.insert(entities, v.ClassName)
    end
  end
  return entities
end

CV.CL.GUI.ListSelectionTab.EntitySearchFunc = function(self)
  self:GetParent().toAddList:Clear()
  for i,v in ipairs(CV.CL.GUI.ListSelectionTab.GetEntities(self:GetValue())) do
    self:GetParent().toAddList:AddLine(v)
  end
end

CV.CL.GUI.ListSelectionTab.GetVehicles = function(filter)
  entities = {}
  for i,v in ipairs(table.GetKeys((list.Get("Vehicles")))) do
    if !filter or string.match(v, ".*"..filter..".*") then
      table.insert(entities, v)
    end
  end
  return entities
end

CV.CL.GUI.ListSelectionTab.VehicleSearchFunc = function(self)
  self:GetParent().toAddList:Clear()
  for i,v in ipairs(CV.CL.GUI.ListSelectionTab.GetVehicles(self:GetValue())) do
    self:GetParent().toAddList:AddLine(v)
  end
end

CV.CL.GUI.ListSelectionTab.GetNPCs = function(filter)
  entities = {}
  for k,v in pairs(list.Get("NPC")) do
    if !filter or string.match(v.Class, ".*"..filter..".*") then
      if !table.HasValue(entities, v.Class) then
        table.insert(entities, v.Class)
      end
    end
  end
  return entities
end

CV.CL.GUI.ListSelectionTab.NPCSearchFunc = function(self)
  self:GetParent().toAddList:Clear()
  for i,v in ipairs(CV.CL.GUI.ListSelectionTab.GetNPCs(self:GetValue())) do
    self:GetParent().toAddList:AddLine(v)
  end
end

CV.CL.GUI.ListSelectionTab.GetSweps = function(filter)
  entities = {}
  for i,v in ipairs(weapons.GetList()) do
    if !filter or string.match(v.ClassName, ".*"..filter..".*") then
      table.insert(entities, v.ClassName)
    end
  end
  return entities
end

CV.CL.GUI.ListSelectionTab.SwepSearchFunc = function(self)
  self:GetParent().toAddList:Clear()
  for i,v in ipairs(CV.CL.GUI.ListSelectionTab.GetSweps(self:GetValue())) do
    self:GetParent().toAddList:AddLine(v)
  end
end

CV.CL.GUI.ListSelectionTab.GetTools = function(filter)
  entities = {}
  PrintTable(spawnmenu.GetTools())
  for i,v in ipairs(spawnmenu.GetTools()) do
    for b, x in ipairs(v.Items) do
      for h, z in ipairs(x) do
        if !filter or string.match(z.Controls, ".*"..filter..".*") then
          if z.Controls != "" and z.Controls then
            table.insert(entities, z.Controls)
          end
        end
      end
    end
  end
  return entities
end

CV.CL.GUI.ListSelectionTab.ToolSearchFunc = function(self)
  self:GetParent().toAddList:Clear()
  for i,v in ipairs(CV.CL.GUI.ListSelectionTab.GetSweps(self:GetValue())) do
    self:GetParent().toAddList:AddLine(v)
  end
end
