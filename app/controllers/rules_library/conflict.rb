module Rule_Library

class ConflictResolver
	def resolve( rules )
		matched = []
		rules.each do |rule|
			if rule.match? then
				matched << rule
			end
		end

		if matched.size == 1 then
			matched.first
		elsif matched.size > 1 then
			resolve_conflict matched
		else
			nil
		end
	end
end


class PriorityConflictResolver < ConflictResolver
	def resolve_conflict( rules )
		max = 0
		rules.each do |rule|
			if rule.priority >= max then
				max = rule.priority
			end
		end

		conflicts = []
		rules.each do |rule|
			if rule.priority == max then
				return rule
			end
		end
	end
end

end
