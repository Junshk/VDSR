--require 'Dropbox/MulSR/param'
--require 'Dropbox/MulSR/mulNet'
require 'modMSE'
function net_return(net_type)

local net, criterion

if net_type == 'VDSR' then
require 'VDSR'
require 'VDSRopt'
net = VDSR(20,option)

criterion = nn.modMSE()
end



return net, criterion
end
