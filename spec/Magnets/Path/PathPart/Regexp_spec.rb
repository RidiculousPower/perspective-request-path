
require_relative '../../../../lib/magnets-path.rb'

describe ::Magnets::Path::PathPart::Regexp do

	###########
	#  match  #
	###########

  it 'can match a constant path portion' do
    regexp_one = ::Magnets::Path::PathPart::Regexp.new( /somepath/ )
    regexp_two = ::Magnets::Path::PathPart::Regexp.new( /to/ )
    regexp_three = ::Magnets::Path::PathPart::Regexp.new( /const/ )
	  path = ::Magnets::Path.new( regexp_one, regexp_two, regexp_three )
    request_path = ::Magnets::Path::RequestPath.new( '/somepath/to/const/', path )
    # we don't match the first one
    regexp_two.match( request_path ).should == false
    regexp_three.match( request_path ).should == false
    regexp_one.match( request_path ).should == true
    # or the second
    regexp_one.match( request_path ).should == false
    regexp_three.match( request_path ).should == false
    regexp_two.match( request_path ).should == true
    # but we do match the third
    regexp_one.match( request_path ).should == false
    regexp_two.match( request_path ).should == false
    regexp_three.match( request_path ).should == true
  end

end
