require 'torch'
require 'paramofTraining'
torch.setdefaulttensortype('torch.FloatTensor')
local start = math.random(maxDataNum)

    print('start data num:',start)
    
    addData = torch.load(dataname..start..'.t7')
addDataN = addData.target:size(1)
dataNmax = addDataN



function loadData(num)

num = num%maxDataNum+1
addData = torch.load(dataname..num..'.t7')
addDataN = addData.target:size(1)
print('new addData loaded',num)
end



function datamixing(data)
  
  local datan = data.target:size(1)
  
  local randperm = torch.randperm(datan):long()
  
  data.target = data.target:index(1,randperm)
  data.train = data.train:index(1,randperm)
print('datamixed')  
  return data
end


function extractData()


local randperm = torch.randperm(addDataN):long()
randperm = randperm[{{1,batch_size}}]
local inputdata = torch.Tensor(batch_size,1,patch_size,patch_size)
  local targetdata = torch.Tensor(batch_size,1,patch_size,patch_size)

inputdata = addData.train:index(1,randperm)
targetdata = addData.target:index(1,randperm)

local data ={}
data.train =inputdata
data.target =targetdata

return data



end


