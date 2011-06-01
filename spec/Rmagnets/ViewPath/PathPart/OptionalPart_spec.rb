
#-----------------------------------------------------------------------------------------------------------#
#----------------------------------  Rmagnets View Path Optional Part  -------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

require_relative '../../../lib/rmagnets-view-path.rb'

describe Rmagnets::ViewPath::OptionalPart do

  $option1 = Rmagnets::ViewPath::Variable.new( :option1 )
  $option2 = Rmagnets::ViewPath::Variable.new( :option2 )
  $option3 = Rmagnets::ViewPath::Variable.new( :option3 )
  $option4 = Rmagnets::ViewPath::Variable.new( :option4 )
  $path    = Rmagnets::ViewPath::Constant.new( 'path' )
  $part    = Rmagnets::ViewPath::Constant.new( 'part' )
  $optional_descriptor_array = [ $option1, $option2, [ $option3, [ $option4 ] ] ]
  $optional_part = Rmagnets::ViewPath::OptionalPart.new( *$optional_descriptor_array )
	
	#############################################
	#  path_parts_remaining_after_optional_set  #
	#############################################

  it 'can return an array of path parts that remain if optional set matches' do

    # full option set
    optional_set = [ $option1, $option2, $option3, $option4 ]
    remaining_request_path_parts  = [ 'optional_part1', 'optional_part2', 'optional_part3', 'optional_part4', 'path', 'other_part' ]
    $optional_part.path_parts_remaining_after_optional_set( optional_set, remaining_request_path_parts ).should == [ 'path', 'other_part' ]

    # 3/4 set
    optional_set = [ $option1, $option2, $option3 ]
    remaining_request_path_parts  = [ 'optional_part1', 'optional_part2', 'optional_part3', 'optional_part4', 'path', 'other_part' ]
    $optional_part.path_parts_remaining_after_optional_set( optional_set, remaining_request_path_parts ).should == [ 'optional_part4', 'path', 'other_part' ]

    # minimal set
    optional_set = [ $option1, $option2 ]
    remaining_request_path_parts  = [ 'optional_part1', 'optional_part2', 'optional_part3', 'optional_part4', 'path', 'other_part' ]
    $optional_part.path_parts_remaining_after_optional_set( optional_set, remaining_request_path_parts ).should == [ 'optional_part3', 'optional_part4', 'path', 'other_part' ]

  end

	##################################################
	#  match_remaining_descriptors_for_optional_set  #
	##################################################

  it 'can look ahead to match remaining descriptors past this optional descriptor' do
    
    optional_set = [ $option1, $option2, $option3, $option4 ]
    remaining_descriptor_elements = [ $path, $part ]

    remaining_request_path_parts  = [ 'optional_part1', 'optional_part2', 'optional_part3', 'optional_part4', 'path', 'part' ]
    $optional_part.match_remaining_descriptors_for_optional_set( optional_set, remaining_descriptor_elements, remaining_request_path_parts ).should == [ 'path', 'part' ]

    remaining_request_path_parts  = [ 'optional_part3', 'optional_part4', 'path', 'other_part' ]
    $optional_part.match_remaining_descriptors_for_optional_set( optional_set, remaining_descriptor_elements, remaining_request_path_parts ).should == nil

    remaining_request_path_parts  = [ 'optional_part4', 'path', 'other_part' ]
    $optional_part.match_remaining_descriptors_for_optional_set( optional_set, remaining_descriptor_elements, remaining_request_path_parts ).should == nil

  end

	###############################################
	#  match_option_descriptors_for_optional_set  #
	###############################################

  it 'can match optional parts' do

    optional_set = [ $option1, $option2, $option3, $option4 ]
    remaining_descriptor_elements = [ $path, $part ]

    remaining_request_path_parts  = [ 'optional_part1', 'optional_part2', 'optional_part3', 'optional_part4', 'path', 'other_part' ]
    $optional_part.match_option_descriptors_for_optional_set( optional_set, remaining_descriptor_elements, remaining_request_path_parts ).should == [ 'optional_part1', 'optional_part2', 'optional_part3', 'optional_part4' ]

  end

	###################
	#  match_request  #
	###################

  it 'can match nested optional parts' do

    remaining_descriptor_elements = [ $path, $part ]

    remaining_request_path_parts  = [ 'optional_part1', 'optional_part2', 'optional_part3', 'optional_part4', 'path', 'other_part' ]
    $optional_part.match_request( remaining_descriptor_elements, remaining_request_path_parts ).should == [ 'optional_part1', 'optional_part2', 'optional_part3', 'optional_part4' ]

    remaining_request_path_parts  = [ 'optional_part1', 'optional_part2', 'optional_part3', 'path', 'other_part' ]
    $optional_part.match_request( remaining_descriptor_elements, remaining_request_path_parts ).should == [ 'optional_part1', 'optional_part2', 'optional_part3' ] 

    remaining_request_path_parts  = [ 'optional_part1', 'optional_part2', 'path', 'other_part' ]
    $optional_part.match_request( remaining_descriptor_elements, remaining_request_path_parts ).should == [ 'optional_part1', 'optional_part2' ] 

    remaining_request_path_parts  = [ 'optional_part1', 'optional_part2', 'optional_part3', 'optional_part4', 'other_part' ]
    $optional_part.match_request( remaining_descriptor_elements, remaining_request_path_parts ).should == nil 

    remaining_request_path_parts  = [ 'optional_part1', 'optional_part2', 'optional_part3', 'other_part' ]
    $optional_part.match_request( remaining_descriptor_elements, remaining_request_path_parts ).should == nil 

    remaining_request_path_parts  = [ 'optional_part1', 'optional_part2' ]
    $optional_part.match_request( remaining_descriptor_elements, remaining_request_path_parts ).should == nil 

  end

end
