local Class = createClass{name="MT5Control",bases={"base.Object"}};

require "iuplua"
require "cdlua"
require "imlua"
require "imlua_process"
require "iupluaim"
require "iupluacontrols"

local lm = require "log.LogManager"
local im = require "gui.ImageManager"

--[[
Class: gui.MT5Control

Main interface definition for the MT5 Control app.

This class inherits from <base.Object>.
]]

--[=[
--[[
Constructor: MT5Control

Create a new instance of the class.

Parameters:
	 No parameter
]]
function MT5Control(options)
]=]
function Class:initialize(options)
	self._reload = false

	-- Main Application GUI.

	local reload_btn = iup.button{title = "Reload", image=im:getImage("refresh")}
	local test_btn = iup.button{title = "Test", image=im:getImage("test")}

	local line = iup.hbox { reload_btn, test_btn, gap=2, alignment="acenter"}

	local logArea = iup.multiline{expand = "YES", appendnewline="yes", formatting="yes"}

	self:createLogSink(logArea)

	local col = iup.vbox { line, logArea, gap=2, margin="1x1" }
	dlg = iup.dialog{col; title="MT5 Control", size="400x200", icon=im:getImage("nerv")}
	dlg:show()

	reload_btn.action = function()
		self._reload = true
		dlg:destroy()
		return iup.CLOSE
	end

	test_btn.action = function()
		self:debug("Should print this line.")
		self:debug("Timetag: ", os.time())
  end
end

--[[
Function: createLogSink

Create the default log sink
]]
function Class:createLogSink(target)
	-- Implement a minimal log sink class here:
	local LogClass = createClass{name="GUILogSink",bases={"log.LogSink"}}

	local levelColors = {
		[lm.SEV_FATAL]="200 0 0",
		[lm.SEV_ERROR]="255 0 0",
		[lm.SEV_WARNING]="255 128 0",
		[lm.SEV_NOTICE]="0 120 0",
		[lm.SEV_INFO]="0 0 120",
	}

	function LogClass:output(level,trace,msg)
		target.addformattag = iup.user { fgcolor = levelColors[level] or "0 0 0" }
		target.append = msg
	end
	
	lm:removeAllSinks()

	-- Connect the log sink:
	lm:addSink(LogClass())
end

--[[
Function: run

Main function to run this app.
]]
function Class:run()
	--  Execute the main loop of IUP:
	if (iup.MainLoopLevel()==0) then
	  iup.MainLoop()
	end	

	-- release the log manager:
	lm:release()

	return self._reload
end

-- return singleton:
return Class()