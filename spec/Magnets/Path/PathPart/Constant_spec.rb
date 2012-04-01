
require_relative '../../../../lib/magnets-path.rb'

describe ::Magnets::Path::PathPart::Constant do

	###########
	#  match  #
	###########

  it 'can match a constant path portion' do
    constant_one = ::Magnets::Path::PathPart::Constant.new( 'somepath' )
    constant_two = ::Magnets::Path::PathPart::Constant.new( 'to' )
    constant_three = ::Magnets::Path::PathPart::Constant.new( 'const' )
	  path = ::Magnets::Path.new( constant_one, constant_two, constant_three )
    request_path = ::Magnets::Path::RequestPath.new( '/somepath/to/const/', path )
    # we don't match the first one
    constant_two.match( request_path ).should == false
    constant_three.match( request_path ).should == false
    constant_one.match( request_path ).should == true
    # or the second
    constant_one.match( request_path ).should == false
    constant_three.match( request_path ).should == false
    constant_two.match( request_path ).should == true
    # but we do match the third
    constant_one.match( request_path ).should == false
    constant_two.match( request_path ).should == false
    constant_three.match( request_path ).should == true
  end

end
