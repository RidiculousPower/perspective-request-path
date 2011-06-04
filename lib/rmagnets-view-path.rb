
#-----------------------------------------------------------------------------------------------------------#
#---------------------------------------  Rmagnets View Path  ----------------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

#require 'rmagnets-view-xhtml'
require_relative '../../view-xhtml/lib/rmagnets-view-xhtml.rb'

class Rmagnets
	class ViewPath
		class AnyParts
		end
		class Constant < String
		end
		class Variable
		end
		class MultipathVariable
		end
		module OptionalPart
			module Named
			end
		end
		module RegularExpression
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

require_relative 'rmagnets-view-path/Rmagnets/ViewPath.rb'
require_relative 'rmagnets-view-path/Rmagnets/ViewPath/PathPart.rb'
require_relative 'rmagnets-view-path/Rmagnets/ViewPath/PathPart/AnyParts.rb'
require_relative 'rmagnets-view-path/Rmagnets/ViewPath/PathPart/Constant.rb'
require_relative 'rmagnets-view-path/Rmagnets/ViewPath/PathPart/Variable.rb'
require_relative 'rmagnets-view-path/Rmagnets/ViewPath/PathPart/OptionalPart.rb'
require_relative 'rmagnets-view-path/Rmagnets/ViewPath/PathPart/OptionalPart/Named.rb'
require_relative 'rmagnets-view-path/Rmagnets/ViewPath/PathPart/RegularExpression.rb'

###########################################################################################################
#   private ###############################################################################################
###########################################################################################################

require_relative 'rmagnets-view-path/Rmagnets/_private_/ViewPath.rb'
