CV = CV or {}
CV.CL = CV.CL or {}
CV.CL.GUI = CV.CL.GUI or {}
CV.CL.GUI.FreeTextSelectionTab = CV.CL.GUI.FreeTextSelectionTab or {}
CV.CL.GUI.ListSelectionTab = CV.CL.GUI.ListSelectionTab or {}

CV.CL.GUI.OpenMenu = function()
  local frame = vgui.Create("DFrame")
  frame:SetTitle("Generic Currency Value | Menu")
  frame:SetSize(1024, 512)
  frame:Center()
  frame:IsVisible(true)
  frame:MakePopup()

  frame.checkboxValueEnable = vgui.Create("DCheckBox", frame)
  frame.checkboxValueEnable:SetPos( 25, 50 )
  frame.checkboxValueEnable:SetValue( CV.CL.ValueEnabled )
  frame.checkboxValueEnable.OnChange = function(self)
    if !LocalPlayer():IsAdmin() then return end
    if self:GetChecked() then bool = 1 else bool = 0 end

    net.Start("cv_run_cmd")
    net.WriteString("gcv_value_enabled")
    net.WriteTable({bool})
    net.SendToServer()
  end

  frame.labelValueEnable = vgui.Create("DLabel", frame)
  frame.labelValueEnable:SetPos(45, 50)
  frame.labelValueEnable:SetSize(200, 15)
  frame.labelValueEnable:SetText("Enable Value to Spawnables?")

  frame.checkboxAdminIgnoreEnable = vgui.Create("DCheckBox", frame)
  frame.checkboxAdminIgnoreEnable:SetPos( 25, 75 )
  frame.checkboxAdminIgnoreEnable:SetValue( CV.CL.ValueIgnoreAdmins )
  frame.checkboxAdminIgnoreEnable.OnChange = function(self)
    if !LocalPlayer():IsAdmin() then return end
    if self:GetChecked() then bool = 1 else bool = 0 end

    net.Start("cv_run_cmd")
    net.WriteString("gcv_value_ignore_admin")
    net.WriteTable({bool})
    net.SendToServer()
  end

  frame.labelValueIgnoreEnable = vgui.Create("DLabel", frame)
  frame.labelValueIgnoreEnable:SetPos(45, 75)
  frame.labelValueIgnoreEnable:SetSize(200, 15)
  frame.labelValueIgnoreEnable:SetText("Ignore Value to Spawnables for Admins?")

  frame.sheet = vgui.Create("DPropertySheet", frame)
  frame.sheet:SetPos(20, 110)
  frame.sheet:SetSize(985, 385)

  frame.propTab = vgui.Create("DPanel", frame.sheet)
  frame.sheet:AddSheet("Props", frame.propTab, "icon16/bricks.png")
  CV.CL.GUI.FreeTextSelectionTab.Build(frame.propTab, "prop")

  frame.ragdollTab = vgui.Create("DPanel", frame.sheet)
  frame.sheet:AddSheet("Ragdolls", frame.ragdollTab, "icon16/group.png")
  CV.CL.GUI.FreeTextSelectionTab.Build(frame.ragdollTab, "ragdoll")

  frame.entityTab = vgui.Create("DPanel", frame.sheet)
  frame.sheet:AddSheet("Entity", frame.entityTab, "icon16/bomb.png")
  CV.CL.GUI.ListSelectionTab.Build(frame.entityTab, "entity")

  frame.vehicleTab = vgui.Create("DPanel", frame.sheet)
  frame.sheet:AddSheet("Vehicle", frame.vehicleTab, "icon16/car.png")
  CV.CL.GUI.ListSelectionTab.Build(frame.vehicleTab, "vehicle")

  frame.npcTab = vgui.Create("DPanel", frame.sheet)
  frame.sheet:AddSheet("NPCs", frame.npcTab, "icon16/user_red.png")
  CV.CL.GUI.ListSelectionTab.Build(frame.npcTab, "npc")

  frame.swepTab = vgui.Create("DPanel", frame.sheet)
  frame.sheet:AddSheet("SWEPs", frame.swepTab, "icon16/award_star_silver_3.png")
  CV.CL.GUI.ListSelectionTab.Build(frame.swepTab, "swep")

  frame.toolTab = vgui.Create("DPanel", frame.sheet)
  frame.sheet:AddSheet("Tools", frame.toolTab, "icon16/wrench.png")
  CV.CL.GUI.ListSelectionTab.Build(frame.toolTab, "tool")
end

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
  parent.toAddValue:SetDecimals(0)
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
    CV.CL.GUI.AddPropCategoryLogic(parent)
  end
  if category == "ragdoll" then
    CV.CL.GUI.AddRagdollCategoryLogic(parent)
  end
end

CV.CL.GUI.AddPropCategoryLogic = function(parent)
  for k,v in pairs(CV.CL.PropValues) do
    CV.CL.GUI.AddToListComform(parent.list, k, v)
  end

  parent.buttonAdd.DoClick = function(self)
    CV.CL.GUI.LegacyAddButtonAction(self, "gcv_value_prop_add", CV.CL.PropValues)
  end
  parent.buttonUpdate.DoClick = function(self)
    CV.CL.GUI.LegacyUpdateButtonAction(self, "gcv_value_prop_add", CV.CL.PropValues)
  end
  parent.buttonDelete.DoClick = function(self)
    CV.CL.GUI.LegacyDeleteButtonAction(self, "gcv_value_prop_remove", CV.CL.PropValues)
  end
end

CV.CL.GUI.AddRagdollCategoryLogic = function(parent)
  for k,v in pairs(CV.CL.RagdollValues) do
    CV.CL.GUI.AddToListComform(parent.list, k, v)
  end

  parent.buttonAdd.DoClick = function(self)
    CV.CL.GUI.LegacyAddButtonAction(self, "gcv_value_ragdoll_add", CV.CL.RagdollValues)
  end
  parent.buttonUpdate.DoClick = function(self)
    CV.CL.GUI.LegacyUpdateButtonAction(self, "gcv_value_ragdoll_add", CV.CL.RagdollValues)
  end
  parent.buttonDelete.DoClick = function(self)
    CV.CL.GUI.LegacyDeleteButtonAction(self, "gcv_value_ragdoll_remove", CV.CL.RagdollValues)
  end
end

CV.CL.GUI.LegacyAddButtonAction = function(self, cmd, table)
  if !LocalPlayer():IsAdmin() then return end

  local name = self:GetParent().toAddName:GetValue()
  local value = CV.Util.ComformCurrencyAmount(self:GetParent().toAddValue:GetValue())

  net.Start("cv_run_cmd")
  net.WriteString(cmd)
  net.WriteTable({name, value})
  net.SendToServer()

  table[name] = value

  CV.CL.GUI.RefreshListTable(self:GetParent(), table)
end

CV.CL.GUI.LegacyUpdateButtonAction = function(self, cmd, table)
  if !LocalPlayer():IsAdmin() then return end

  local entries = self:GetParent().list:GetSelected()
  for i,v in ipairs(entries) do
    local name = v:GetValue(1)
    local value = self:GetParent().toAddValue:GetValue()

    net.Start("cv_run_cmd")
    net.WriteString(cmd)
    net.WriteTable({name, value})
    net.SendToServer()

    table[name] = value
  end

  CV.CL.GUI.RefreshListTable(self:GetParent(), table)
end

CV.CL.GUI.LegacyDeleteButtonAction = function(self, cmd, table)
  if !LocalPlayer():IsAdmin() then return end

  local entries = self:GetParent().list:GetSelected()
  for i,v in ipairs(entries) do
    local name = v:GetValue(1)

    net.Start("cv_run_cmd")
    net.WriteString(cmd)
    net.WriteTable({name})
    net.SendToServer()

    table[name] = nil
  end

  CV.CL.GUI.RefreshListTable(self:GetParent(), table)
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

  parent.toAddValue = vgui.Create("DNumberWang", parent)
  parent.toAddValue:SetPos(725, 195)
  parent.toAddValue:SetSize(75, 30)
  parent.toAddValue:SetDecimals(0)
  parent.toAddValue:SetMin(0)
  parent.toAddValue:SetMax(1000000)

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
  for k,v in pairs(CV.CL.EntityValues) do
    CV.CL.GUI.AddToListComform(parent.list, k, v)
  end

  for i,v in ipairs(CV.CL.GUI.ListSelectionTab.GetEntities()) do
    parent.toAddList:AddLine(v)
  end

  parent.search.OnValueChange = CV.CL.GUI.ListSelectionTab.EntitySearchFunc
  parent.buttonAdd.DoClick = function(self)
    CV.CL.GUI.AddButtonAction(self, "gcv_value_entity_add", CV.CL.EntityValues)
  end
  parent.buttonUpdate.DoClick = function(self)
    CV.CL.GUI.UpdateButtonAction(self, "gcv_value_entity_add", CV.CL.EntityValues)
  end
  parent.buttonDelete.DoClick = function(self)
    CV.CL.GUI.DeleteButtonAction(self, "gcv_value_entity_remove", CV.CL.EntityValues)
  end
end

CV.CL.GUI.AddVehicleCategoryLogic = function(parent)
  for k,v in pairs(CV.CL.VehicleValues) do
    CV.CL.GUI.AddToListComform(parent.list, k, v)
  end

  for i,v in ipairs(CV.CL.GUI.ListSelectionTab.GetVehicles()) do
    parent.toAddList:AddLine(v)
  end

  parent.search.OnValueChange = CV.CL.GUI.ListSelectionTab.VehicleSearchFunc
  parent.buttonAdd.DoClick = function(self)
    CV.CL.GUI.AddButtonAction(self, "gcv_value_vehicle_add", CV.CL.VehicleValues)
  end
  parent.buttonUpdate.DoClick = function(self)
    CV.CL.GUI.UpdateButtonAction(self, "gcv_value_vehicle_add", CV.CL.VehicleValues)
  end
  parent.buttonDelete.DoClick = function(self)
    CV.CL.GUI.DeleteButtonAction(self, "gcv_value_vehicle_remove", CV.CL.VehicleValues)
  end
end

CV.CL.GUI.AddNPCCategoryLogic = function(parent)
  for k,v in pairs(CV.CL.NPCValues) do
    CV.CL.GUI.AddToListComform(parent.list, k, v)
  end

  for i,v in ipairs(CV.CL.GUI.ListSelectionTab.GetNPCs()) do
    parent.toAddList:AddLine(v)
  end

  parent.search.OnValueChange = CV.CL.GUI.ListSelectionTab.NPCSearchFunc
  parent.buttonAdd.DoClick = function(self)
    CV.CL.GUI.AddButtonAction(self, "gcv_value_npc_add", CV.CL.NPCValues)
  end
  parent.buttonUpdate.DoClick = function(self)
    CV.CL.GUI.UpdateButtonAction(self, "gcv_value_npc_add", CV.CL.NPCValues)
  end
  parent.buttonDelete.DoClick = function(self)
    CV.CL.GUI.DeleteButtonAction(self, "gcv_value_npc_remove", CV.CL.NPCValues)
  end
end

CV.CL.GUI.AddSwepCategoryLogic = function(parent)
  for k,v in pairs(CV.CL.SwepValues) do
    CV.CL.GUI.AddToListComform(parent.list, k, v)
  end

  for i,v in ipairs(CV.CL.GUI.ListSelectionTab.GetSweps()) do
    parent.toAddList:AddLine(v)
  end

  parent.search.OnValueChange = CV.CL.GUI.ListSelectionTab.SwepSearchFunc
  parent.buttonAdd.DoClick = function(self)
    CV.CL.GUI.AddButtonAction(self, "gcv_value_swep_add", CV.CL.SwepValues)
  end
  parent.buttonUpdate.DoClick = function(self)
    CV.CL.GUI.UpdateButtonAction(self, "gcv_value_swep_add", CV.CL.SwepValues)
  end
  parent.buttonDelete.DoClick = function(self)
    CV.CL.GUI.DeleteButtonAction(self, "gcv_value_swep_remove", CV.CL.SwepValues)
  end
end

CV.CL.GUI.AddToolCategoryLogic = function(parent)
  for k,v in pairs(CV.CL.ToolValues) do
    CV.CL.GUI.AddToListComform(parent.list, k, v)
  end

  for i,v in ipairs(CV.CL.GUI.ListSelectionTab.GetTools()) do
    parent.toAddList:AddLine(v)
  end

  parent.search.OnValueChange = CV.CL.GUI.ListSelectionTab.ToolSearchFunc
  parent.buttonAdd.DoClick = function(self)
    CV.CL.GUI.AddButtonAction(self, "gcv_value_tool_add", CV.CL.ToolValues)
  end
  parent.buttonUpdate.DoClick = function(self)
    CV.CL.GUI.UpdateButtonAction(self, "gcv_value_tool_add", CV.CL.ToolValues)
  end
  parent.buttonDelete.DoClick = function(self)
    CV.CL.GUI.DeleteButtonAction(self, "gcv_value_tool_remove", CV.CL.ToolValues)
  end
end

CV.CL.GUI.RefreshListTable = function(parent, table)
  parent.list:Clear()
  for k,v in pairs(table) do
    CV.CL.GUI.AddToListComform(parent.list, k, v)
  end
end

CV.CL.GUI.AddButtonAction = function(self, cmd, table)
  if !LocalPlayer():IsAdmin() then return end

  local entries = self:GetParent().toAddList:GetSelected()
  for i,v in ipairs(entries) do
    local name = v:GetValue(1)
    local value = self:GetParent().toAddValue:GetValue()

    net.Start("cv_run_cmd")
    net.WriteString(cmd)
    net.WriteTable({name, value})
    net.SendToServer()

    table[name] = value
  end

  CV.CL.GUI.RefreshListTable(self:GetParent(), table)
end

CV.CL.GUI.UpdateButtonAction = function(self, cmd, table)
  if !LocalPlayer():IsAdmin() then return end

  local entries = self:GetParent().list:GetSelected()
  for i,v in ipairs(entries) do
    local name = v:GetValue(1)
    local value = self:GetParent().toAddValue:GetValue()

    net.Start("cv_run_cmd")
    net.WriteString(cmd)
    net.WriteTable({name, value})
    net.SendToServer()

    table[name] = value
  end

  CV.CL.GUI.RefreshListTable(self:GetParent(), table)
end

CV.CL.GUI.DeleteButtonAction = function(self, cmd, table)
  if !LocalPlayer():IsAdmin() then return end

  local entries = self:GetParent().list:GetSelected()
  for i,v in ipairs(entries) do
    local name = v:GetValue(1)

    net.Start("cv_run_cmd")
    net.WriteString(cmd)
    net.WriteTable({name})
    net.SendToServer()

    table[name] = nil
  end

  CV.CL.GUI.RefreshListTable(self:GetParent(), table)
end

CV.CL.GUI.ListSelectionTab.GetEntities = function(filter)
  local entities = {}
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
  local entities = {}
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
  local entities = {}
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
  local entities = {}
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
  local entities = {}
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
  for i,v in ipairs(CV.CL.GUI.ListSelectionTab.GetTools(self:GetValue())) do
    self:GetParent().toAddList:AddLine(v)
  end
end

CV.CL.GUI.AddToListComform = function(list, name, value)
  list:AddLine(name, CV.Util.ComformCurrencyAmount(value))
end
