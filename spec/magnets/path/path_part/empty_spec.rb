
require_relative '../../../../lib/magnets-path.rb'

describe ::Magnets::Path::PathPart::Empty do

	###########
	#  match  #
	###########

  it 'can match a constant path portion' do
    empty_path = ::Magnets::Path::PathPart::Empty.new
	  path = ::Magnets::Path.new( empty_path )
    request_path = ::Magnets::Path::RequestPath.new( '/', path )
    empty_path.match( request_path ).should == true
    request_path = ::Magnets::Path::RequestPath.new( '/somepath/to/const/', path )
    empty_path.match( request_path ).should == false
  end

end
