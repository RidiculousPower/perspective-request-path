
#-----------------------------------------------------------------------------------------------------------#
#---------------------------------------  Rmagnets View Path  ----------------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

#require 'rmagnets-view-html'
require_relative '../../view-html/lib/rmagnets-view-html.rb'

module ::Rmagnets
	class ViewPath
    module Array
    	class Nested < ::Array
    	end
    end
    module Hash
    	class Nested < ::Hash
    	end
    end
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

require_relative 'rmagnets-view-path/Rmagnets/ViewPath/Array.rb'
require_relative 'rmagnets-view-path/Rmagnets/ViewPath/Array/Nested.rb'
require_relative 'rmagnets-view-path/Rmagnets/ViewPath/Hash.rb'
require_relative 'rmagnets-view-path/Rmagnets/ViewPath/Hash/Nested.rb'

require_relative 'rmagnets-view-path/Rmagnets/ViewPath.rb'
require_relative 'rmagnets-view-path/Rmagnets/ViewPath/PathPart.rb'
require_relative 'rmagnets-view-path/Rmagnets/ViewPath/PathPart/AnyParts.rb'
require_relative 'rmagnets-view-path/Rmagnets/ViewPath/PathPart/Constant.rb'
require_relative 'rmagnets-view-path/Rmagnets/ViewPath/PathPart/Variable.rb'
require_relative 'rmagnets-view-path/Rmagnets/ViewPath/PathPart/OptionalPart.rb'
require_relative 'rmagnets-view-path/Rmagnets/ViewPath/PathPart/OptionalPart/Named.rb'
require_relative 'rmagnets-view-path/Rmagnets/ViewPath/PathPart/RegularExpression.rb'

class Hash
  include ::Rmagnets::ViewPath::Hash
end

