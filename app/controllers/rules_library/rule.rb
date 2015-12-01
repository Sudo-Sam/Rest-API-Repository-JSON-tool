module RuleLibrary

class Rule
	attr_accessor :name, :condition, :action, :priority

	def initialize
		@priority = 0
		@match = false
	end

	def fire( object )
		@object = object
		begin
			@match = @condition.eval? object
		rescue
			@match = false
		end
		@match
	end

	def match?
		@match
	end

	def priority=( num )
		if num > 1 then num = 1 end
		@priority = num
	end

	def do_action
		if String === @action then
			actions = [@action]
		else
			actions = @action
		end

		actions.each do |act|
			@object.instance_eval "self.#{act}"
		end
	end
end

end
