--require 'Dropbox/MulSR/SRNet'
require 'Training'			
require 'param'
local nnOption =require 'nnOption'

require 'net_'
require 'net_name'
----------------------------------------
cmd = torch.CmdLine()

cmd:text('training option')
cmd:text('Options')
cmd:option('-cont',false,'boolean option')
cmd:option('-net_type','amp','string option')
cmd:option('-DL',false , 'dl option')
cmd:option('-DO',false, 'do option')
cmd:option('-clip',false,'clip option')
cmd:option('-kaiming',false,'initialize')

cmdparams = cmd:parse(arg or {})


----------------------------
local cuManage = require 'cuManage'
local deviceNum =cuManage.Device() 

cutorch.setDevice(deviceNum )
----------------------------
--------nn option-----------
net_type = cmdparams.net_type or 'amp' --------------type setting
print(net_type)
 netoptload =nnOption.load(net_type)

if cmdparams.kaiming then option1.kaiming =true ; option2.kaiming =true end

--------------------------------------------------
local SRnetname = netname_return(net_type,netoption)
print(SRnetname)

local cont =cmdparams.cont
print('continue',cont)


cliping = cmdparams.clip
----------------------------------------------
local srnet ,criterion
local sizeAverage = false


print('dataname',dataname)

------------------------------


srnet, criterion =net_return(net_type)
criterion.sizeAverage =sizeAverage


--- training
SRnetname = SRnetname
print(SRnetname,'assemble training')  
if cont == true then 
	if paths.filep(SRnetname..'.t7') ~= true then goto others end
srnet = torch.load(SRnetname..'.t7')

end

::others::

srnet:training()
training(srnet,criterion,SRnetname)  
 
  srnet:clearState()
  torch.save(SRnetname..'.t7',srnet)
print(SRnetname..'saved')


