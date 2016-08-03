--require 'Dropbox/MulSR/param'
--require 'Dropbox/MulSR/mulNet'
require 'modMSE'
function net_return(net_type)

local net, criterion


if net_type == 'srnet' then
require 'Dropbox/SR/SRNet'

net , criterion = SRResnet(layer)
elseif net_type == 'botsrnet' then
require 'Dropbox/SR/SRNet'

net, criterion = BotRBU(layer)

elseif net_type == 'botRUnet' then
require 'Dropbox/SR/SRNet'

net, criterion = BotRU(layer)


elseif net_type == 'MulNet' then

require 'Dropbox/MulSR/mulNet'

net,criterion = MulNet(layer)
elseif net_type == 'zoom' then

require 'Dropbox/MulSR/ZoomNet' 
require 'Dropbox/MulSR/zoomparam'
net,criterion = ZoomNet(capNum,eachlayer,zoom,adjConst)

elseif net_type == 'amp' then
require 'SuperResolution/AmpNet'
require 'ampOpt'
print(option1)
net,criterion = ampNet(layer,option1,option2)

elseif net_type == 'VDSR' then
require 'SuperResolution/VDSR'
require 'VDSRopt'
net = VDSR(20,option)

criterion = nn.modMSE()
end



return net, criterion
end
