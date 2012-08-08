
require_relative '../../../../../lib/perspective/request/path.rb'

describe ::Perspective::Request::Path::PathPart::Fragment::RegexpFragment do

	###########
	#  match  #
	###########

  it 'can match a regexp portion of a path fragment' do
    regexp_fragment_one = ::Perspective::Request::Path::PathPart::Fragment::RegexpFragment.new( /const/ )
    regexp_fragment_two = ::Perspective::Request::Path::PathPart::Fragment::RegexpFragment.new( /ant/ )
    regexp_fragment_three = ::Perspective::Request::Path::PathPart::Fragment::RegexpFragment.new( /other/ )
    multiple = ::Perspective::Request::Path::PathPart::Multiple.new( regexp_fragment_one, regexp_fragment_two )
    path = ::Perspective::Request::Path.new( multiple )
    request_path = ::Perspective::Request::Path::RequestPath.new( '/constant/', path )
    request_path.declare_current_frame_has_fragments!
    regexp_fragment_three.match( request_path ).should == false
    regexp_fragment_one.match( request_path ).should == true
    regexp_fragment_two.match( request_path ).should == true
  end

end
