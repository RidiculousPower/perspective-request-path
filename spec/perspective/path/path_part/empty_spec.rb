
require_relative '../../../../lib/perspective/request/path.rb'

describe ::Perspective::Request::Path::PathPart::Empty do

	###########
	#  match  #
	###########

  it 'can match a constant path portion' do
    empty_path = ::Perspective::Request::Path::PathPart::Empty.new
	  path = ::Perspective::Request::Path.new( empty_path )
    request_path = ::Perspective::Request::Path::RequestPath.new( '/', path )
    empty_path.match( request_path ).should == true
    request_path = ::Perspective::Request::Path::RequestPath.new( '/somepath/to/const/', path )
    empty_path.match( request_path ).should == false
  end

end
