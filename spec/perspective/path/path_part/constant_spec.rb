
require_relative '../../../../lib/perspective/request/path.rb'

describe ::Perspective::Request::Path::PathPart::Constant do

	###########
	#  match  #
	###########

  it 'can match a constant path portion' do

    constant_one = ::Perspective::Request::Path::PathPart::Constant.new( 'somepath' )
    constant_two = ::Perspective::Request::Path::PathPart::Constant.new( 'to' )
    constant_three = ::Perspective::Request::Path::PathPart::Constant.new( 'const' )
	  path = ::Perspective::Request::Path.new( constant_one, constant_two, constant_three )


    request_path = ::Perspective::Request::Path::RequestPath.new( '/somepath/to/const/', path )
    constant_one.match( request_path ).should == true

    request_path = ::Perspective::Request::Path::RequestPath.new( '/somepath/to/const/', path )
    constant_two.match( request_path ).should == false

    request_path = ::Perspective::Request::Path::RequestPath.new( '/somepath/to/const/', path )
    constant_three.match( request_path ).should == false

    request_path = ::Perspective::Request::Path::RequestPath.new( '/somepath/to/const/', path )
    constant_one.match( request_path ).should == true
    constant_one.match( request_path ).should == false

    request_path = ::Perspective::Request::Path::RequestPath.new( '/somepath/to/const/', path )
    constant_one.match( request_path ).should == true
    constant_three.match( request_path ).should == false

    request_path = ::Perspective::Request::Path::RequestPath.new( '/somepath/to/const/', path )
    constant_one.match( request_path ).should == true
    constant_two.match( request_path ).should == true
    constant_one.match( request_path ).should == false

    request_path = ::Perspective::Request::Path::RequestPath.new( '/somepath/to/const/', path )
    constant_one.match( request_path ).should == true
    constant_two.match( request_path ).should == true
    constant_two.match( request_path ).should == false

    request_path = ::Perspective::Request::Path::RequestPath.new( '/somepath/to/const/', path )
    constant_one.match( request_path ).should == true
    constant_two.match( request_path ).should == true
    constant_three.match( request_path ).should == true

  end

end
