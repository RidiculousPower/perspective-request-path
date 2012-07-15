
require_relative '../../../../../lib/magnets-path.rb'

describe ::Magnets::Path::PathPart::Fragment::RegexpFragment do

	###########
	#  match  #
	###########

  it 'can match a regexp portion of a path fragment' do
    regexp_fragment_one = ::Magnets::Path::PathPart::Fragment::RegexpFragment.new( /const/ )
    regexp_fragment_two = ::Magnets::Path::PathPart::Fragment::RegexpFragment.new( /ant/ )
    regexp_fragment_three = ::Magnets::Path::PathPart::Fragment::RegexpFragment.new( /other/ )
    multiple = ::Magnets::Path::PathPart::Multiple.new( regexp_fragment_one, regexp_fragment_two )
    path = ::Magnets::Path.new( multiple )
    request_path = ::Magnets::Path::RequestPath.new( '/constant/', path )
    request_path.declare_current_frame_has_fragments!
    regexp_fragment_three.match( request_path ).should == false
    regexp_fragment_one.match( request_path ).should == true
    regexp_fragment_two.match( request_path ).should == true
  end

end
