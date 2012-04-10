
require_relative '../../../../../lib/magnets-path.rb'

describe ::Magnets::Path::PathPart::Fragment::VariableFragment do

	###########
	#  match  #
	###########

  # before constant or end
  it 'can match a variable portion of a path fragment before/after a constant fragment' do
    variable_fragment_one = ::Magnets::Path::PathPart::Fragment::VariableFragment.new( :left )
    constant_fragment_two = ::Magnets::Path::PathPart::Fragment::ConstantFragment.new( '-' )
    variable_fragment_three = ::Magnets::Path::PathPart::Fragment::VariableFragment.new( :right )
    multiple = ::Magnets::Path::PathPart::Multiple.new( variable_fragment_one, constant_fragment_two, variable_fragment_three )
    path = ::Magnets::Path.new( multiple )
    request_path = ::Magnets::Path::RequestPath.new( '/left-right/', path )
    request_path.declare_current_frame_has_fragments!
    variable_fragment_one.match( request_path ).should == true
    request_path.matched_fragment( variable_fragment_one ).should == 'left'
    constant_fragment_two.match( request_path ).should == true
    request_path.matched_fragment( constant_fragment_two ).should == '-'
    variable_fragment_three.match( request_path ).should == true
    request_path.matched_fragment( variable_fragment_three ).should == 'right'
  end

  # before regexp or end
  it 'can match a variable portion of a path fragment before/after a regexp fragment' do
    variable_fragment_one = ::Magnets::Path::PathPart::Fragment::VariableFragment.new( :left )
    regexp_fragment_two = ::Magnets::Path::PathPart::Fragment::RegexpFragment.new( /-/ )
    variable_fragment_three = ::Magnets::Path::PathPart::Fragment::VariableFragment.new( :right )
    multiple = ::Magnets::Path::PathPart::Multiple.new( variable_fragment_one, regexp_fragment_two, variable_fragment_three )
    path = ::Magnets::Path.new( multiple )
    request_path = ::Magnets::Path::RequestPath.new( '/left-right/', path )
    request_path.declare_current_frame_has_fragments!
    variable_fragment_one.match( request_path ).should == true
    request_path.matched_fragment( variable_fragment_one ).should == 'left'
    regexp_fragment_two.match( request_path ).should == true
    request_path.matched_fragment( regexp_fragment_two ).should == '-'
    variable_fragment_three.match( request_path ).should == true
    request_path.matched_fragment( variable_fragment_three ).should == 'right'
  end
  
  # before excluded part or end
  
  # before multipath variable - variable will get remainder of current part

  # cannot be followed by variable fragment
  
  # before optional part or named optional part - which cannot start with a variable
  
end
