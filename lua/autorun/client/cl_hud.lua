CV = CV or {}
CV.CL = CV.CL or {}
CV.CL.HUD = CV.CL.HUD or {}

CV.CL.HUD.ContextMenuOpen = false

CV.CL.HUD.BoxMargin = 5
CV.CL.HUD.BoxWidth = 100
CV.CL.HUD.BoxHeight = 50

CV.CL.HUD.TextHWidth = 53
CV.CL.HUD.TextHeight = 20

CV.CL.HUD.Text2HWidth = 53
CV.CL.HUD.Text2Height = 40

CV.CL.HUD.GlobalHeightOffset = 0

CV.CL.HUD.Draw = function ()
  if !GetConVar("gcv_hud_enabled"):GetBool() then return end
  if GetConVar("gcv_hud_draw_on_contextmenu"):GetBool() and !CV.CL.HUD.ContextMenuOpen then return end
	draw.RoundedBox(15, surface.ScreenWidth() - CV.CL.HUD.BoxWidth - CV.CL.HUD.BoxMargin, 5 + CV.CL.HUD.GlobalHeightOffset, CV.CL.HUD.BoxWidth, CV.CL.HUD.BoxHeight, Color(51, 58, 51, 255))
	draw.SimpleText("Currency:", "gcv_hud_font", surface.ScreenWidth() - CV.CL.HUD.TextHWidth, CV.CL.HUD.TextHeight + CV.CL.HUD.GlobalHeightOffset, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
  draw.SimpleText(LocalPlayer():GetNWInt("Currency"), "gcv_hud_font", surface.ScreenWidth() - CV.CL.HUD.Text2HWidth, CV.CL.HUD.Text2Height + CV.CL.HUD.GlobalHeightOffset, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

hook.Add("HUDPaint", "cl_gcv_drawhud", CV.CL.HUD.Draw)

CV.CL.HUD.ContextMenuOpenCallback = function()
  CV.CL.HUD.ContextMenuOpen = true
  CV.CL.HUD.GlobalHeightOffset = surface.ScreenHeight() / 2
end

hook.Add("OnContextMenuOpen", "cl_gcv_contextmenu_open_callback", CV.CL.HUD.ContextMenuOpenCallback)

CV.CL.HUD.ContextMenuCloseCallback = function()
  CV.CL.HUD.ContextMenuOpen = false
  CV.CL.HUD.GlobalHeightOffset = 0
end

hook.Add("OnContextMenuClose", "cl_gcv_contextmenu_close_callback", CV.CL.HUD.ContextMenuCloseCallback)

surface.CreateFont( "gcv_hud_font", {
	font = "Arial",
	extended = false,
	size = 20,
	weight = 800,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )
