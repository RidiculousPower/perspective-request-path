
require_relative '../../../../../lib/perspective/request/path.rb'

describe ::Perspective::Request::Path::PathPart::Fragment::ConstantFragment do

	###########
	#  match  #
	###########

  it 'can match a constant portion of a path fragment' do
    constant_fragment_one = ::Perspective::Request::Path::PathPart::Fragment::ConstantFragment.new( 'const' )
    constant_fragment_two = ::Perspective::Request::Path::PathPart::Fragment::ConstantFragment.new( 'ant' )
    constant_fragment_three = ::Perspective::Request::Path::PathPart::Fragment::ConstantFragment.new( 'other' )
    multiple = ::Perspective::Request::Path::PathPart::Multiple.new( constant_fragment_one, constant_fragment_two )
    path = ::Perspective::Request::Path.new( multiple )
    request_path = ::Perspective::Request::Path::RequestPath.new( '/constant/', path )
    request_path.declare_current_frame_has_fragments!
    constant_fragment_three.match( request_path ).should == false
    constant_fragment_one.match( request_path ).should == true
    constant_fragment_two.match( request_path ).should == true
  end

end
