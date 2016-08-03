require 'nn'



local modMSE = torch.class('nn.modMSE','nn.MSECriterion')





function modMSE:updateOutput(input,target)


self.output_tensor = self.output_tensor or input.new(1)

input.THNN.MSECriterion_updateOutput(
	input:cdata(),
	target:cdata(),
	self.output_tensor:cdata(),
	self.sizeAverage

)

	self.output = self.output_tensor[1]


	if self.sizeAverage == false and input:nDimension()==4 then 

		local n = input:size(1)
		self.output = self.output / n /2
	end


return self.output


end


function modMSE:updateGradInput(input,target)


input.THNN.MSECriterion_updateGradInput(

	input:cdata(),
	target:cdata(),
	self.gradInput:cdata(),
	self.sizeAverage

)

if self.sizeAverage ==false and input:nDimension() ==4 then
	local n = input:size(1)--torch.numel(input)
	self.gradInput = self.gradInput/2
	
--	local mag = math.sqrt(torch.sum(torch.pow(input-target,2)))
--	self.gradInput = self.gradInput*(1/2+ 1/mag/2) 

end



return self.gradInput

end
