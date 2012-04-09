
require_relative '../../../../../lib/magnets-path.rb'

describe ::Magnets::Path::PathPart::Fragment::OptionalFragment do

	########################################
	#  initialize                          #
	#  initialize_sub_option_combinations  #
	########################################

	it 'can initialize with nested parts' do
	  
	  optional_part = ::Magnets::Path::PathPart::Fragment::OptionalFragment.new( 'some', 'path', 'to', 'constant' )

	  optional_part.configurations.count.should == 1
	  optional_part.configurations[ 0 ].count.should == 4
	  optional_part.configurations[ 0 ].sub_options.should == nil

	  optional_sub_part = ::Magnets::Path::PathPart::Fragment::OptionalFragment.new( 'other' )
	  optional_part = ::Magnets::Path::PathPart::Fragment::OptionalFragment.new( 'path', 'to', optional_sub_part )

	  optional_part.configurations.count.should == 2
	  optional_part.configurations[ 0 ].count.should == 3
	  optional_part.configurations[ 0 ].sub_options.should == { optional_sub_part => 0 } 
	  optional_part.configurations[ 1 ].count.should == 2
	  optional_part.configurations[ 1 ].sub_options.should == nil
	  
	  optional_sub_one_sub_part = ::Magnets::Path::PathPart::Fragment::OptionalFragment.new( 'path', 'to' )
	  optional_sub_part_one = ::Magnets::Path::PathPart::Fragment::OptionalFragment.new( 'other', optional_sub_one_sub_part )
	  optional_sub_two_sub_part = ::Magnets::Path::PathPart::Fragment::OptionalFragment.new( 'or', 'two' )
	  optional_sub_part_two = ::Magnets::Path::PathPart::Fragment::OptionalFragment.new( 'and', 'option', optional_sub_two_sub_part )
	  optional_part = ::Magnets::Path::PathPart::Fragment::OptionalFragment.new( 'some', optional_sub_part_one, 'constant', optional_sub_part_two )
	  
	  optional_part.configurations.count.should == 10
	  
	  optional_part.configurations[ 0 ].count.should == 9
	  optional_part.configurations[ 0 ].sub_options.should == { optional_sub_part_one => 0, optional_sub_part_two => 0 }
	  optional_part.configurations[ 1 ].count.should == 7
	  optional_part.configurations[ 1 ].sub_options.should == { optional_sub_part_one => 1, optional_sub_part_two => 0 }
	  optional_part.configurations[ 2 ].count.should == 7
	  optional_part.configurations[ 2 ].sub_options.should == { optional_sub_part_one => 0, optional_sub_part_two => 1 }
	  optional_part.configurations[ 3 ].count.should == 6
	  optional_part.configurations[ 3 ].sub_options.should == { optional_sub_part_two => 0 }
	  optional_part.configurations[ 4 ].count.should == 5
	  optional_part.configurations[ 4 ].sub_options.should == { optional_sub_part_one => 1, optional_sub_part_two => 1 }
	  optional_part.configurations[ 5 ].count.should == 5
	  optional_part.configurations[ 5 ].sub_options.should == { optional_sub_part_one => 0 }
	  optional_part.configurations[ 6 ].count.should == 4
	  optional_part.configurations[ 6 ].sub_options.should == { optional_sub_part_two => 1 }
	  optional_part.configurations[ 7 ].count.should == 3
	  optional_part.configurations[ 7 ].sub_options.should == { optional_sub_part_one => 1 }
	  optional_part.configurations[ 8 ].count.should == 2
	  optional_part.configurations[ 8 ].sub_options.should == { }
	  
  end

	###########
	#  match  #
	###########
  
  it 'can match an optional path portion' do
    
    optional_sub_one_sub_part = ::Magnets::Path::PathPart::Fragment::OptionalFragment.new( 'path', 'to' )
	  optional_sub_part_one = ::Magnets::Path::PathPart::Fragment::OptionalFragment.new( 'other', optional_sub_one_sub_part )
	  optional_sub_two_sub_part = ::Magnets::Path::PathPart::Fragment::OptionalFragment.new( 'or', 'two' )
	  optional_sub_part_two = ::Magnets::Path::PathPart::Fragment::OptionalFragment.new( 'and', 'option', optional_sub_two_sub_part )
	  optional_part = ::Magnets::Path::PathPart::Fragment::OptionalFragment.new( 'some', optional_sub_part_one, 'constant', optional_sub_part_two )

	  multiple_part = ::Magnets::Path::PathPart::Multiple.new( optional_part )
	  path = ::Magnets::Path.new( optional_part )
	  
	  request_path = ::Magnets::Path::RequestPath.new( '/someconstant/', path )
	  optional_part.match( request_path ).should == true
    
	  request_path = ::Magnets::Path::RequestPath.new( '/somebadconstant/', path )
	  optional_part.match( request_path ).should == false
    
    request_path = ::Magnets::Path::RequestPath.new( '/someconstantbadpath', path )
	  optional_part.match( request_path ).should == true
	  request_path.current_fragment.should == 'badpath'
    
	  request_path = ::Magnets::Path::RequestPath.new( '/someotherconstant/', path )
	  optional_part.match( request_path ).should == true
    
	  request_path = ::Magnets::Path::RequestPath.new( '/someotherotherconstant/', path )
	  optional_part.match( request_path ).should == false
    
	  request_path = ::Magnets::Path::RequestPath.new( '/someotherpathtoconstant/', path )
	  optional_part.match( request_path ).should == true
    
	  request_path = ::Magnets::Path::RequestPath.new( '/someotherpathtosomeotherconstant/', path )
	  optional_part.match( request_path ).should == false
    
	  request_path = ::Magnets::Path::RequestPath.new( '/someconstantandoption', path )
	  optional_part.match( request_path ).should == true
    
	  request_path = ::Magnets::Path::RequestPath.new( '/someconstantandoption/2', path )
	  optional_part.match( request_path ).should == true
	  request_path.current_part.should == '2'
    
	  request_path = ::Magnets::Path::RequestPath.new( '/someotherconstantandoption', path )
	  optional_part.match( request_path ).should == true
    
	  request_path = ::Magnets::Path::RequestPath.new( '/someotherconstantandoptionalpath', path )
	  optional_part.match( request_path ).should == true
	  request_path.current_part.should == 'and'
    
	  request_path = ::Magnets::Path::RequestPath.new( '/someotherpathtoconstantandoption', path )
	  optional_part.match( request_path ).should == true
    
	  request_path = ::Magnets::Path::RequestPath.new( '/someotherpathtoconstantandthenanoption', path )
	  optional_part.match( request_path ).should == true
	  request_path.current_part.should == 'and'
    
	  request_path = ::Magnets::Path::RequestPath.new( '/someconstantandoptionortwo', path )
	  optional_part.match( request_path ).should == true
    
	  request_path = ::Magnets::Path::RequestPath.new( '/someconstantandoptionortwothree', path )
	  optional_part.match( request_path ).should == true
	  request_path.current_part.should == 'three'
    
	  request_path = ::Magnets::Path::RequestPath.new( '/someotherconstantandoptionortwo', path )
	  optional_part.match( request_path ).should == true
    
	  request_path = ::Magnets::Path::RequestPath.new( '/someotherconstantandoptionoroneortwo', path )
	  optional_part.match( request_path ).should == true
	  request_path.current_part.should == 'or'
	  
	  request_path = ::Magnets::Path::RequestPath.new( '/someotherpathtoconstantandoptionortwo', path )
	  optional_part.match( request_path ).should == true
    
	  request_path = ::Magnets::Path::RequestPath.new( '/someotherpathtoconstantandanoptionortwo', path )
	  optional_part.match( request_path ).should == true
	  request_path.current_part.should == 'and'

  end
  
end
