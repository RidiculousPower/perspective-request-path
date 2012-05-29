
require_relative '../../configuration/lib/magnets-configuration.rb'

class ::Magnets::Path
  class RequestPath
  end
	module PathPart
		class Optional
			class NamedOptional < ::Magnets::Path::PathPart::Optional
			end
		end
		module Fragment
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
