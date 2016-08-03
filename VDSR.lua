
local nninit =require 'nninit'

function convAdd(net,ind,outd,option)

local  k = option.kernel or 3
local pad = option.pad or 1
if option.kaiming then
net:add(nn.SpatialConvolution(ind,outd,k,k,1,1,pad,pad):init('weight',nninit.kaiming))
else
net:add(nn.SpatialConvolution(ind,outd,k,k,1,1,pad,pad))
end

end

function VDSR(layer,option) -- with batch
print('VDSR',layer,option)

local output_ch =1
local input_ch =1

local vdsr = nn.Sequential()
local net = nn.Sequential()
local cc = nn.ConcatTable()

local interdim =64

local  k = option.kernel or 3
local pad = option.pad or 1


--convAdd(net,input_ch,interdim,option)
net:add(nn.SpatialConvolution(input_ch,interdim,k,k,1,1,pad,pad):init('weight',nninit.kaiming))

for i =1,layer-2 do
--net:add(nn.SpatialBatchNormalization(interdim))
net:add(nn.ReLU())
--convAdd(net,interdim,interdim,option)
net:add(nn.SpatialConvolution(interdim,interdim,k,k,1,1,pad,pad):init('weight',nninit.kaiming))


end
--net:add(nn.SpatialBatchNormalization(interdim))
net:add(nn.ReLU())
--convAdd(net,interdim,output_ch,option)
net:add(nn.SpatialConvolution(interdim,output_ch,k,k,1,1,pad,pad):init('weight',nninit.kaiming))





if option.zoom then
local zoom =option.zoom
net:add(nn.MulConstant(1/zoom))
end


cc:add(net)
cc:add(nn.Identity())

vdsr:add(cc)
vdsr:add(nn.CAddTable())


return vdsr

end


