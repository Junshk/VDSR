require  'optim'
require 'cunn'
require 'SuperResolution/extraction'
require 'Dropbox/klib/safeCuda'
require 'gnuplot'
require 'cudnn'
require 'SuperResolution/paramofTraining'

torch.setdefaulttensortype('torch.FloatTensor')

-- LOSS and TEST
--local test_flag = true

if clipping ~=true then
print('no gradient clip')
else print('clip',clipMag)

end

local plotbound = 10
local testData 

if test_flag ==true then 
print(testdatanamet7)
testData= torch.load(testdatanamet7)
end
-------------------------------------------
function training(model,criterion,netname)


clipvalue = clipMag/optimState.learningRate


  model:training()
 print(model)
  print(netname)

  model:cuda()
model=  cudnn.convert(model,cudnn)

  criterion:cuda()


  local params, grads =model:getParameters()

--------------------------------------------------------------
  local feval = function(x)

    if x~=params then
      params:copy(x)
    end

    local data = extractData()

    local batch_input = data.train
    local batch_target = data.target

--print(batch_input:size(),batch_target:size())

    if batch_input:size(1) ~= batch_size then
  print('size',batch_input:size(1)) end

------forward
    grads:zero()
    
    local f = 0
    
    local numUnit = batch_size/unit_size
    
    
    
    for batch_iter = 1,numUnit do
      
      --unit setting
      local unitInput = batch_input[{{1+(batch_iter-1)*unit_size,batch_iter*unit_size}}]
      local unitTarget = batch_target[{{1+(batch_iter-1)*unit_size,batch_iter*unit_size}}]
      
  
      local output = model:forward(unitInput:cuda()):float()
--     print(unitInput:size(),output:size())
      local err =criterion:forward(output:cuda(),unitTarget:cuda())
      f = f+ err
--print(err,'err')    
      local df_do = criterion:backward(output:cuda(),unitTarget:cuda()):float()
--print(df_do)
model:backward(unitInput:cuda(),df_do:cuda())
      
      
--print('backward')      
    end
    
    grads:div(unit_size)
    f = f/unit_size
    
   

--- clip gradient element-wise

if clipping ==true then
clipvalue = clipMag  / optimState.learningRate
grads:clamp(-clipvalue,clipvalue)
end
    return f,grads
    
    
  end


--------------------------------




  local losses ={}
--  local trainerres ={}
--  local testerres ={}
  local testloss ={}
  
  local epoch_iter = math.floor(dataNmax/batch_size)
  print('epoch',epoch_iter)
 
 
 local iter1 =  10 *epoch_iter

  
--  local iter2 = 20 *epoch_iter
  local iter3 = 30 *epoch_iter
  local enditer = 50 *epoch_iter

for iteration =1,enditer do

--print(iteration)
    local  _ ,loss=optim.sgd(feval,params,optimState)
--    losses[#losses+1] =loss[1]
--	print(iteration,loss[1])

torch.save(netname..'loss.t7',losses)
    if iteration% epoch_iter ==0 then

      --calculate error
      
      print(string.format("iteration %4d, loss = %6.6f",iteration,loss[1]))
   
      model:training()
    end
   
   local testEpoch =100
   if iteration %testEpoch ==0 then
   losses[#losses+1]=loss[1]
 model:evaluate()
        if test_flag ==true then
      local p = safeCudaforward(model,testData.train,20)
--print(p)
local vec = p:float() -testData.target:float();
-- print(#testData.target)
testloss[#testloss+1] = torch.norm(vec,2)/testData.target:size(1)--math.sqrt(torch.numel(testData.target))
--	print('train loss',losses[#losses])
--      print('test loss',testloss[#testloss])
      print('psnr',- math.log10(testloss[#testloss])*20)
   end
if iteration% 1000 == 0 then
torch.save(netname..'trainerr.t7',losses)
  torch.save(netname..'testerr.t7',testloss)


    --  gnuplot.figure(1)
    --  gnuplot.plot({'loss',torch.range(1,#losses),torch.Tensor(losses),'-'})
     -- gnuplot.figure(2)
      gnuplot.plot(
        {netname..'testerr',torch.range(1,#testloss)*testEpoch,torch.Tensor(testloss),'-'},
        {netname ..'trainerr',torch.range(1,#losses)*testEpoch,torch.Tensor(losses):clamp(0,plotbound),'-'}) 

	print(netname..'intersave')
      torch.save(netname..'.t7',model)
end
end



	if iteration %(epoch_iter)==0 then loadData(math.random(maxDataNum)) end

    if iteration == iter1 or iteration ==iter2 or iteration ==iter3 then 

      optimState.learningRate =optimState.learningRate/4
print('lr modified:',optimState.learningRate)
    end

  end

  torch.save(netname..'loss.t7',losses)
  torch.save(netname..'testerr.t7',testerres)


end --function end
