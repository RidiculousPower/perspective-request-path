
require_relative '../../../../lib/magnets-path.rb'

describe ::Magnets::Path::PathPart::Variable do

	###########
	#  match  #
	###########

  it 'can match a constant path portion' do
    variable_one = ::Magnets::Path::PathPart::Variable.new( 'somepath' )
    variable_two = ::Magnets::Path::PathPart::Variable.new( 'to' )
    variable_three = ::Magnets::Path::PathPart::Variable.new( 'const' )
	  path = ::Magnets::Path.new( variable_one, variable_two, variable_three )
    request_path = ::Magnets::Path::RequestPath.new( '/somepath/to/const/', path )
    variable_one.match( request_path ).should == true
    variable_two.match( request_path ).should == true
    variable_three.match( request_path ).should == true
  end

end
