
require 'rack'

require 'cascading-configuration-array-sorted-unique'

require_relative '../../bindings/lib/magnets-bindings.rb'

module ::Magnets
  class Path
    class RequestPath
    end
		module PathPart
  		class Constant
  		end
  		class Variable
  		end
  		class Regexp
  		end
  		class Multiple
    		class MultipathVariable
  		  end
		  end
  		class Optional
  			class Named < ::Magnets::Path::PathPart::Optional
  			end
  		end
  		module Fragment
  		  class ConstantFragment
		    end
  		  class ExclusionFragment
		    end
  		  class RegexpFragment
		    end
  		  class VariableFragment
		    end
  		  class WildcardFragment
		    end
  		  class MultipathWildcardFragment
		    end
		  end
		end
	end
end

require_relative 'magnets-path/Magnets/Path/PathPart/Fragment/ConstantFragment.rb'
require_relative 'magnets-path/Magnets/Path/PathPart/Fragment/ExclusionFragment.rb'
require_relative 'magnets-path/Magnets/Path/PathPart/Fragment/RegexpFragment.rb'
require_relative 'magnets-path/Magnets/Path/PathPart/Fragment/VariableFragment.rb'

require_relative 'magnets-path/Magnets/Path/PathPart/Fragment.rb'

require_relative 'magnets-path/Magnets/Path/PathPart/Multiple.rb'
require_relative 'magnets-path/Magnets/Path/PathPart/Multiple/MultipathVariable.rb'

require_relative 'magnets-path/Magnets/Path/PathPart/Constant.rb'
require_relative 'magnets-path/Magnets/Path/PathPart/Variable.rb'
require_relative 'magnets-path/Magnets/Path/PathPart/Optional.rb'
require_relative 'magnets-path/Magnets/Path/PathPart/Optional/NamedOptional.rb'
require_relative 'magnets-path/Magnets/Path/PathPart/Regexp.rb'

require_relative 'magnets-path/Magnets/Path/PathPart.rb'

require_relative 'magnets-path/Magnets/Path/RequestPath.rb'

require_relative 'magnets-path/Magnets/Path.rb'

