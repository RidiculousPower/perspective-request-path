
require_relative '../../../../lib/perspective/request/path.rb'

describe ::Perspective::Request::Path::PathPart::Variable do

	###########
	#  match  #
	###########

  it 'can match a constant path portion' do
    variable_one = ::Perspective::Request::Path::PathPart::Variable.new( 'somepath' )
    variable_two = ::Perspective::Request::Path::PathPart::Variable.new( 'to' )
    variable_three = ::Perspective::Request::Path::PathPart::Variable.new( 'const' )
	  path = ::Perspective::Request::Path.new( variable_one, variable_two, variable_three )
    request_path = ::Perspective::Request::Path::RequestPath.new( '/somepath/to/const/', path )
    variable_one.match( request_path ).should == true
    variable_two.match( request_path ).should == true
    variable_three.match( request_path ).should == true
  end

end
