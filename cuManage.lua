require 'cutorch'

local cuManage = {}
local AdmDev ={3,4}

function has_value (tab,val)
	for index, value in ipairs (tab) do

	if value == val then
	return true
	end
	end

	return false
end

function cuManage.Device()
local count = cutorch.getDeviceCount()

local maxIdx = 1 
local maxFreeMemory  =0

for i = 1,count do

--adm list
if has_value(AdmDev,i) == true then


local freeMemory , totalMemory = cutorch.getMemoryUsage(i)
print(i,freeMemory)
if freeMemory >maxFreeMemory then
maxIdx = i
maxFreeMemory = freeMemory
end -- if end


end -- if end

end -- for end
print('proper cuDevice is ',maxIdx)

return maxIdx
end

return cuManage

