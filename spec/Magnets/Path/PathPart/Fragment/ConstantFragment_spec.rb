
require_relative '../../../../../lib/magnets-path.rb'

describe ::Magnets::Path::PathPart::Fragment::ConstantFragment do

	###########
	#  match  #
	###########

  it 'can match a constant portion of a path fragment' do
    constant_fragment_one = ::Magnets::Path::PathPart::Fragment::ConstantFragment.new( 'const' )
    constant_fragment_two = ::Magnets::Path::PathPart::Fragment::ConstantFragment.new( 'ant' )
    constant_fragment_three = ::Magnets::Path::PathPart::Fragment::ConstantFragment.new( 'other' )
    multiple = ::Magnets::Path::PathPart::Multiple.new( constant_fragment_one, constant_fragment_two )
    path = ::Magnets::Path.new( multiple )
    request_path = ::Magnets::Path::RequestPath.new( '/constant/', path )
    request_path.declare_current_frame_has_fragments!
    constant_fragment_three.match( request_path ).should == false
    constant_fragment_one.match( request_path ).should == true
    constant_fragment_two.match( request_path ).should == true
  end

end
