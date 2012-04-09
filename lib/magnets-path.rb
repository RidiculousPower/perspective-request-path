
require 'rack'

require 'cascading-configuration-array-sorted-unique'

require_relative '../../bindings/lib/magnets-bindings.rb'

module ::Magnets
  class Path
    class RequestPath
      class Frame
      end
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
  			class NamedOptional < ::Magnets::Path::PathPart::Optional
  			end
  		end
  		module Fragment
  		  class ConstantFragment
		    end
  		  class VariableFragment
		    end
    		class MultipathVariableFragment
  		  end
  		  class RegexpFragment
		    end
  		  class OptionalFragment
    		  class NamedOptionalFragment < ::Magnets::Path::PathPart::Fragment::OptionalFragment
  		    end
		    end
  		  class ExclusionFragment
		    end
		  end
		end
	end
end

basepath = 'magnets-path/Magnets/Path'

require_relative( basepath + '/PathPart/Constant.rb' )
require_relative( basepath + '/PathPart/Variable.rb' )
require_relative( basepath + '/PathPart/Optional/Interface.rb' )
require_relative( basepath + '/PathPart/Optional.rb' )
require_relative( basepath + '/PathPart/Optional/NamedOptional/Interface.rb' )
require_relative( basepath + '/PathPart/Optional/NamedOptional.rb' )
require_relative( basepath + '/PathPart/Regexp.rb' )

require_relative( basepath + '/PathPart/Multiple.rb' )
require_relative( basepath + '/PathPart/Multiple/MultipathVariable.rb' )

require_relative( basepath + '/PathPart/Fragment/ConstantFragment.rb' )
require_relative( basepath + '/PathPart/Fragment/ExclusionFragment.rb' )
require_relative( basepath + '/PathPart/Fragment/RegexpFragment.rb' )
require_relative( basepath + '/PathPart/Fragment/VariableFragment.rb' )
require_relative( basepath + '/PathPart/Fragment/MultipathVariableFragment.rb' )
require_relative( basepath + '/PathPart/Fragment/OptionalFragment.rb' )
require_relative( basepath + '/PathPart/Fragment/OptionalFragment/NamedOptionalFragment.rb' )

require_relative( basepath + '/PathPart/Fragment.rb' )

require_relative( basepath + '/PathPart.rb' )

require_relative( basepath + '/RequestPath/Frame.rb' )
require_relative( basepath + '/RequestPath.rb' )

require_relative( basepath + '/Parser.rb' )

require_relative( basepath + '.rb' )

