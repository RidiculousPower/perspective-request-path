
#-----------------------------------------------------------------------------------------------------------#
#---------------------------------------  Rmagnets View Path  ----------------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

#require 'rmagnets-view-xhtml'
require_relative '../../view-xhtml/lib/rmagnets-view-xhtml.rb'

class Rmagnets
	class ViewPath
		class Constant < String
		end
		class Variable
		end
		class MultipathVariable
		end
		class OptionalPart
		end
		class NamedOptionalPart < Rmagnets::ViewPath::OptionalPart
		end
		class RegularExpression < Regexp
			class Multipath < Rmagnets::ViewPath::RegularExpression
			end
		end
		module PathPart
		end
	end
end

class Array
end
class Hash
	class Nested < Hash
	end
end

require_relative 'rmagnets-view-path/Array.rb'
require_relative 'rmagnets-view-path/Hash.rb'
require_relative 'rmagnets-view-path/Hash/Nested.rb'

###########################################################################################################
#   private ###############################################################################################
###########################################################################################################

require_relative 'rmagnets-view-path/Rmagnets/ViewPath.rb'
require_relative 'rmagnets-view-path/Rmagnets/ViewPath/Constant.rb'
require_relative 'rmagnets-view-path/Rmagnets/ViewPath/Variable.rb'
require_relative 'rmagnets-view-path/Rmagnets/ViewPath/MultipathVariable.rb'
require_relative 'rmagnets-view-path/Rmagnets/ViewPath/NamedOptionalPart.rb'
require_relative 'rmagnets-view-path/Rmagnets/ViewPath/OptionalPart.rb'
require_relative 'rmagnets-view-path/Rmagnets/ViewPath/RegularExpression.rb'
require_relative 'rmagnets-view-path/Rmagnets/ViewPath/RegularExpression/Multipath.rb'
require_relative 'rmagnets-view-path/Rmagnets/ViewPath/PathPart.rb'
