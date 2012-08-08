
require_relative '../../../../lib/perspective/request/path.rb'

describe ::Perspective::Request::Path::PathPart::Regexp do

	###########
	#  match  #
	###########

  it 'can match a constant path portion' do
    regexp_one = ::Perspective::Request::Path::PathPart::Regexp.new( /somepath/ )
    regexp_two = ::Perspective::Request::Path::PathPart::Regexp.new( /to/ )
    regexp_three = ::Perspective::Request::Path::PathPart::Regexp.new( /const/ )
	  path = ::Perspective::Request::Path.new( regexp_one, regexp_two, regexp_three )

    request_path = ::Perspective::Request::Path::RequestPath.new( '/somepath/to/const/', path )
    regexp_two.match( request_path ).should == false

    request_path = ::Perspective::Request::Path::RequestPath.new( '/somepath/to/const/', path )
    regexp_three.match( request_path ).should == false

    request_path = ::Perspective::Request::Path::RequestPath.new( '/somepath/to/const/', path )
    regexp_one.match( request_path ).should == true
    regexp_three.match( request_path ).should == false

    request_path = ::Perspective::Request::Path::RequestPath.new( '/somepath/to/const/', path )
    regexp_one.match( request_path ).should == true
    regexp_two.match( request_path ).should == true
    regexp_one.match( request_path ).should == false

    request_path = ::Perspective::Request::Path::RequestPath.new( '/somepath/to/const/', path )
    regexp_one.match( request_path ).should == true
    regexp_two.match( request_path ).should == true
    regexp_two.match( request_path ).should == false

    request_path = ::Perspective::Request::Path::RequestPath.new( '/somepath/to/const/', path )
    regexp_one.match( request_path ).should == true
    regexp_two.match( request_path ).should == true
    regexp_three.match( request_path ).should == true

  end

end
