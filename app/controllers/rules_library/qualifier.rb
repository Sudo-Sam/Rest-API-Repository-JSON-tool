require 'strscan'
require 'set'

module RuleLibrary

class DefaultComparisonSupport
	EQUAL            = :'equal?'
	NOT_EQUAL        = :'not_equal?'
	GREATER          = :'greater?'
	GREATER_OR_EQUAL = :'greater_or_equal?'
	LESS             = :'less?'
	LESS_OR_EQUAL    = :'less_or_equal?'
	MATCH            = :'match?'

	def self.coerce( left, right )
		coerced = left

		case right
		when String
			coerced = left.to_s
		when Integer
			coerced = left.to_i
		when Float
			coerced = left.to_f
		when NilClass
			if left == '' then
				coerced = nil
			end
		when Regexp
			coerced = left.to_s
		end

		coerced
	end

	def self.equal?( left, right )
		left = coerce(left, right)
		left == right
	end

	def self.not_equal?( left, right )
		left = coerce(left, right)
		left != right
	end

	def self.greater?( left, right )
		left = coerce(left, right)
		left > right
	end

	def self.greater_or_equal?( left, right )
		left = coerce(left, right)
		left >= right
	end

	def self.less?( left, right )
		left = coerce(left, right)
		left < right
	end

	def self.less_or_equal?( left, right )
		left = coerce(left, right)
		left <= right
	end

	def self.match?( left, right )
		left = coerce(left, right)
		if left =~ right then
			true
		else
			false
		end
	end
end


class QualifierOperatorDelegation
	attr_reader :object, :op_str, :op_symbol

	def initialize( op_str, op_symbol, object )
		@object = object
		@op_str = op_str
		@op_symbol = op_symbol
	end
end


class QualifierParser
	class ParseError < StandardError; end #:nodoc:

	attr_reader :qualifier

	def initialize( format )
		tokens     = _analyze format.to_s.dup
		@qualifier = _parse tokens
	end

	private

	def _analyze( format )
		format    = "(#{format})"
		scanner   = StringScanner.new format
		qualifier = nil
		tokens    = []
		ops = []
		Qualifier.operators.each do |op| ops << Regexp.escape(op.op_str) end
		op_reg = /\A(#{ops.join('|')})/im

		until scanner.eos? do
			scanner.skip /\A[\s]+/

			if str = scanner.scan(/\A(\(|\))/) then
				tokens << str
			elsif str = scanner.scan(op_reg) then
				tokens << Qualifier.operator_symbol(str)
			elsif str = scanner.scan(/\A\d+\.\d+/) then
				tokens << str.to_f
			elsif str = scanner.scan(/\A\d+/) then
				tokens << str.to_i
			elsif scanner.match?(/\Atrue\W/) then
				scanner.scan /\Atrue/
				tokens << true
			elsif scanner.match?(/\Afalse\W/) then
				scanner.scan /\Afalse/
				tokens << false
			elsif scanner.match?(/\Anil\W/) then
				scanner.scan /\Anil/
				tokens << nil
			elsif scanner.scan(/\A\//) then
				tokens << _parse_regexp(scanner)
			elsif str = scanner.scan(/\A'(([^'\\]|\\.)*)'/) then
				tokens << scanner[0]
			elsif str = scanner.scan(/\A"(([^"\\]|\\.)*)"/) then
				tokens << scanner[0]
			else
				str = scanner.scan /\A[^\s\(\)]+/
				tokens << str
			end
		end

		tokens
	end

	def _parse_regexp( scanner )
		regstr = ''
		char = nil
		pre_char = nil
		option = nil

		until scanner.eos? do
			char = scanner.getch

			if (pre_char != '\\') and (char == '/') then
				option = scanner.scan(/\A\w+/)
				break
			end

			regstr << char
			pre_char = char
		end

		Regexp.new(regstr, option)
	end

	def _parse( tokens )
		op_stack  = []
		out_stack = []
		op = left = right = q = nil

		reg_and = /\Aand\Z/mi
		reg_or  = /\Aor\Z/mi
		reg_not = /\Anot\Z/mi

		tokens.each do |token|
			case token
			when '('
				op_stack << token
			when ')'
				if out_stack == [true] then
					out_stack.pop
					op_stack.pop
					out_stack << TrueQualifier.new
					next
				end

				until op_stack.last == '(' do
					op    = op_stack.pop
					right = out_stack.pop
					left  = out_stack.pop

					case op
					when Symbol
						if Regexp === right then
							q = KeyValueQualifier.new(left, op, right)
						elsif right =~ /\A'(([^'\\]|\\.)*)'/ then
							q = KeyValueQualifier.new(left, op, $1)
						elsif right =~ /\A"(([^"\\]|\\.)*)"/ then
							q = KeyValueQualifier.new(left, op, $1)
						elsif (Numeric === right) or (right == true) or \
							(right == false) or right.nil? then
							q = KeyValueQualifier.new(left, op, right)
						else
							q = KeyComparisonQualifier.new(left, op, right)
						end
					when reg_and
						if AndQualifier === right then
							right.qualifiers.unshift left
							q = right
						else
							q = AndQualifier.new [left, right]
						end
					when reg_or
						if OrQualifier === right then
							right.qualifiers.unshift left
							q = right
						else
							q = OrQualifier.new [left, right]
						end
					when reg_not
						q = NotQualifier.new right
					end
					out_stack << q
				end
				op_stack.pop
			when reg_and
				op_stack << token
			when reg_or
				op_stack << token
			when reg_not
				op_stack << token
			when Symbol
				op_stack << token
			else
				out_stack << token
			end
		end

		result = out_stack.pop
		unless out_stack.empty? and op_stack.empty? then
			raise ParseError, 'parse error'
		end

		result
	end
end


class Qualifier
	class UnknownKeyError < StandardError; end #:nodoc:

	@@operators = []

	class << self
		def operators
			@@operators
		end

		def support( symbol )
			@@operators.each do |op|
				if op.op_symbol == symbol then
					return op.object
				end
			end
			nil			
		end

		def set_operator( op_str, op_symbol, object )
			op = QualifierOperatorDelegation.new(op_str, op_symbol, object)
			@@operators << op
		end

		def operator_symbol( str )
			@@operators.each do |op|
				if op.op_str == str then
					return op.op_symbol
				end
			end
			nil
		end

		def operator_string( symbol )
			@@operators.each do |op|
				if op.op_symbol == symbol then
					return op.op_str
				end
			end
			nil
		end

		def new_with_format( format )
			parser = QualifierParser.new(format)
			parser.qualifier
		end

		alias format new_with_format
	end

	set_operator('!=', DefaultComparisonSupport::NOT_EQUAL,
		DefaultComparisonSupport)
	set_operator('>=', DefaultComparisonSupport::GREATER_OR_EQUAL,
		DefaultComparisonSupport)
	set_operator('<=', DefaultComparisonSupport::LESS_OR_EQUAL,
		DefaultComparisonSupport)
	set_operator('>',  DefaultComparisonSupport::GREATER,
		DefaultComparisonSupport)
	set_operator('<',  DefaultComparisonSupport::LESS,
		DefaultComparisonSupport)
	set_operator('=~', DefaultComparisonSupport::MATCH,
		DefaultComparisonSupport)
	set_operator('=',  DefaultComparisonSupport::EQUAL,
		DefaultComparisonSupport)

	def qualifier_keys
		set = Set.new
		add_qualifier_keys set
		set
	end

	# abstract - subclasses must override it
	def add_qualifier_keys( set ); end

	alias inspect to_s
end


class KeyValueQualifier < Qualifier
	attr_reader :key, :value, :symbol

	def initialize( key, symbol, value )
		super()
		@key = key
		@symbol = symbol
		@value = value
	end

	def add_qualifier_keys( set )
		set << @key
	end

	def ==( other )
		bool = false
		if KeyValueQualifier === other then
			if (@key == other.key) and (@symbol == other.symbol) and \
				(@value == other.value) then
				bool = true
			end
		end

		bool
	end

	def eval?( object )
		Qualifier.support(@symbol).__send__(symbol,
			object.instance_eval(@key), @value)
	end

	public

	def to_s
		op = Qualifier.operator_string @symbol
		if String === @value then
			value_s = "'#@value'"
		else
			value_s = @value
		end

		"(#@key #{op} #{value_s})"
	end
end


class KeyComparisonQualifier < Qualifier
	attr_reader :left, :symbol, :right

	def initialize( left, symbol, right )
		super()
		@left   = left
		@symbol = symbol
		@right  = right
	end

	def add_qualifier_keys( set )
		set << @left
	end

	def ==( other )
		bool = false
		if KeyComparisonQualifier === other then
			if (@left == other.left) and (@symbol == other.symbol) and \
				(@right == other.right) then
				bool = true
			end
		end

		bool
	end

	def eval?( object )
		Qualifier.support(@symbol).__send__(symbol,
			object.instance_eval(@left),
			object.instance_eval(@right))
	end

	def to_s
		op = Qualifier.operator_string @symbol
		"(#@left #{op} #@right)"
	end
end


class AndQualifier < Qualifier
	attr_reader :qualifiers

	def initialize( qualifiers )
		super()
		@qualifiers = qualifiers
	end

	def each
		qualifiers.each do |qualifier|
			yield qualifier
		end
	end

	def add_qualifier_keys( set )
		@qualifiers.each do |qualifier|
			qualifier.add_qualifier_keys set
		end
	end

	def ==( other )
		bool = false
		if AndQualifier === other then
			if @qualifiers == other.qualifiers then
				bool = true
			end
		end

		bool
	end

	def eval?( object )
		@qualifiers.each do |qualifier|
			unless qualifier.eval? object then
				return false
			end
		end
		true
	end

	def to_s
		str = '('
		@qualifiers.each do |q|
			str << q.to_s
			unless @qualifiers.last == q then
				str << " AND "
			end
		end
		str << ')'
		str
	end
end


class OrQualifier < Qualifier
	attr_reader :qualifiers

	def initialize( qualifiers )
		super()
		@qualifiers = qualifiers
	end

	def each
		qualifiers.each do |qualifier|
			yield qualifier
		end
	end

	def add_qualifier_keys( set )
		@qualifiers.each do |qualifier|
			qualifier.add_qualifier_keys set
		end
	end

	def ==( other )
		bool = false
		if OrQualifier === other then
			if @qualifiers == other.qualifiers then
				bool = true
			end
		end

		bool
	end

	def eval?( object )
		@qualifiers.each do |qualifier|
			if qualifier.eval? object then
				return true
			end
		end
		false
	end

	def to_s
		str = '('
		@qualifiers.each do |q|
			str << q.to_s
			unless @qualifiers.last == q then
				str << " OR "
			end
		end
		str << ')'
		str
	end
end


class NotQualifier < Qualifier
	attr_reader :qualifier

	def initialize( qualifier )
		super()
		@qualifier = qualifier
	end

	def add_qualifier_keys( set )
		qualifier.add_qualifier_keys set
	end

	def ==( other )
		bool = false
		if NotQualifier === other then
			if @qualifier == other.qualifier then
				bool = true
			end
		end

		bool
	end

	def eval?( object )
		unless @qualifier.eval? object then
			true
		else
			false
		end
	end

	def to_s
		"(NOT #{qualifier})"
	end
end


class TrueQualifier < Qualifier
	def eval?( object )
		true
	end

	def to_s
		"(true)"
	end
end

end
