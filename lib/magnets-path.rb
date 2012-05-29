
require 'rack'

require 'cascading-configuration-array-sorted-unique'

module ::Magnets
  class Path
    class RequestPath
      class Frame
      end
    end
		module PathPart
  		class Empty
  		end
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

files = [
  'PathPart/Empty',
  'PathPart/Constant',
  'PathPart/Variable',
  'PathPart/Optional/Interface',
  'PathPart/Optional',
  'PathPart/Optional/NamedOptional/Interface',
  'PathPart/Optional/NamedOptional',
  'PathPart/Regexp',
  'PathPart/Multiple',
  'PathPart/Multiple/MultipathVariable',
  'PathPart/Fragment/ConstantFragment',
  'PathPart/Fragment/ExclusionFragment',
  'PathPart/Fragment/RegexpFragment',
  'PathPart/Fragment/VariableFragment',
  'PathPart/Fragment/MultipathVariableFragment',
  'PathPart/Fragment/OptionalFragment',
  'PathPart/Fragment/OptionalFragment/NamedOptionalFragment',
  'PathPart/Fragment',
  'PathPart',
  'RequestPath/Frame',
  'RequestPath',
  'Parser'
]

files.each do |this_file|
  require_relative( File.join( basepath, this_file ) + '.rb' )
end

require_relative( basepath + '.rb' )
