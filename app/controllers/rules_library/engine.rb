require 'yaml'

module Rule_Library

class RuleEngine
	attr_accessor :rules, :conflict_resolver, :operators

	def initialize( file )
		f = File.new file
		conf = YAML::load f
		f.close

		# conflict resolver
		case conf['conflict']
		when 'priority' then @conflict_resolver = PriorityConflictResolver.new
		else                 @conflict_resolver = PriorityConflictResolver.new
		end

		# rules
		@rules = []
		@rule_hash = {}
		conf['rules'].each do |set|
			rule = Rule.new
			rule.name = set['name']
			rule.condition = QualifierParser.new(set['condition']).qualifier
			rule.action = set['action']
			rule.priority = set['priority'] unless set['priority'].nil?
			@rules << rule
			@rule_hash[rule.name] = rule
		end
	end

	def rule( name )
		@rule_hash[name]
	end

	def fire( object )
		@rules.each do |rule|
			rule.fire object
		end

		if resolved = @conflict_resolver.resolve(@rules) then
			resolved.do_action
			true
		else
			false
		end
	end
end


end
