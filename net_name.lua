

function netname_return(net_type,net_option)
local name

if net_type =='MulNet' then
require 'Dropbox/MulSR/param'

name = netnamefromflag(net_type)
name = name .. netoption
elseif net_type == 'zoom' then
require 'Dropbox/MulSR/zoomparam'

if type(zoom) =='number' then
name = 'zoom'..'ly'..eachlayer..'z'..zoom..'cap'..capNum ..zoomOption.. 'net'
elseif type(zoom) =='table' then
name = 'zoom'..'ly'..eachlayer..'z'..'tab'..zoom[capNum]..'cap'..capNum ..zoomOption.. 'net'

end


elseif net_type == 'amp' then
net_option = net_option or ''
layer =layer or 20
name = 'amp'..layer..net_option

elseif net_type == 'mulVDSR' then 


name = 'mulVDSR64'
elseif net_type =='VDSR' then 

name = 'VDSR'
end









return name

end
