
#-----------------------------------------------------------------------------------------------------------#
#----------------------------------  Rmagnets View Path Optional Part  -------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

require_relative '../../../../lib/rmagnets-view-path.rb'

describe ::Rmagnets::ViewPath::PathPart::OptionalPart do

  $option1 = ::Rmagnets::ViewPath::PathPart::Variable.new( :option1 )
  $option2 = ::Rmagnets::ViewPath::PathPart::Variable.new( :option2 )
  $option3 = ::Rmagnets::ViewPath::PathPart::Variable.new( :option3 )
  $option4 = ::Rmagnets::ViewPath::PathPart::Variable.new( :option4 )
  $path    = ::Rmagnets::ViewPath::PathPart::Constant.new( 'path' )
  $part    = ::Rmagnets::ViewPath::PathPart::Constant.new( 'part' )
  $optional_descriptor_array = [ $option1, $option2, [ $option3, [ $option4 ] ] ].extend( Rmagnets::ViewPath::PathPart::OptionalPart )
	
	#############################################
	#  path_parts_remaining_after_optional_set  #
	#############################################

  it 'can return an array of path parts that remain if optional set matches' do

    # full option set
    optional_set = [ $option1, $option2, $option3, $option4 ]
    remaining_request_path_parts  = [ 'optional_descriptor_array1', 'optional_descriptor_array2', 'optional_descriptor_array3', 'optional_descriptor_array4', 'path', 'other_part' ]
    $optional_descriptor_array.path_parts_remaining_after_optional_set( optional_set, remaining_request_path_parts ).should == [ 'path', 'other_part' ]

    # 3/4 set
    optional_set = [ $option1, $option2, $option3 ]
    remaining_request_path_parts  = [ 'optional_descriptor_array1', 'optional_descriptor_array2', 'optional_descriptor_array3', 'optional_descriptor_array4', 'path', 'other_part' ]
    $optional_descriptor_array.path_parts_remaining_after_optional_set( optional_set, remaining_request_path_parts ).should == [ 'optional_descriptor_array4', 'path', 'other_part' ]

    # minimal set
    optional_set = [ $option1, $option2 ]
    remaining_request_path_parts  = [ 'optional_descriptor_array1', 'optional_descriptor_array2', 'optional_descriptor_array3', 'optional_descriptor_array4', 'path', 'other_part' ]
    $optional_descriptor_array.path_parts_remaining_after_optional_set( optional_set, remaining_request_path_parts ).should == [ 'optional_descriptor_array3', 'optional_descriptor_array4', 'path', 'other_part' ]

  end

	##################################################
	#  match_remaining_descriptors_for_optional_set  #
	##################################################

  it 'can look ahead to match remaining descriptors past this optional descriptor' do
    
    optional_set = [ $option1, $option2, $option3, $option4 ]
    remaining_descriptor_elements = [ $path, $part ]

    remaining_request_path_parts  = [ 'optional_descriptor_array1', 'optional_descriptor_array2', 'optional_descriptor_array3', 'optional_descriptor_array4', 'path', 'part' ]
    $optional_descriptor_array.match_remaining_descriptors_for_optional_set( optional_set, remaining_descriptor_elements, remaining_request_path_parts ).should == [ 'path', 'part' ]

    remaining_request_path_parts  = [ 'optional_descriptor_array3', 'optional_descriptor_array4', 'path', 'other_part' ]
    $optional_descriptor_array.match_remaining_descriptors_for_optional_set( optional_set, remaining_descriptor_elements, remaining_request_path_parts ).should == nil

    remaining_request_path_parts  = [ 'optional_descriptor_array4', 'path', 'other_part' ]
    $optional_descriptor_array.match_remaining_descriptors_for_optional_set( optional_set, remaining_descriptor_elements, remaining_request_path_parts ).should == nil

  end

	###############################################
	#  match_optional_set  #
	###############################################

  it 'can match optional parts' do

    optional_set = [ $option1, $option2, $option3, $option4 ]
    remaining_descriptor_elements = [ $path, $part ]

    remaining_request_path_parts  = [ 'optional_descriptor_array1', 'optional_descriptor_array2', 'optional_descriptor_array3', 'optional_descriptor_array4', 'path', 'other_part' ]
    $optional_descriptor_array.match_optional_set( optional_set, remaining_descriptor_elements, remaining_request_path_parts ).should == [ 'optional_descriptor_array1', 'optional_descriptor_array2', 'optional_descriptor_array3', 'optional_descriptor_array4' ]

  end

	###################
	#  match_request  #
	###################

  it 'can match nested optional parts' do

    remaining_descriptor_elements = [ $path, $part ]

    remaining_request_path_parts  = [ 'optional_descriptor_array1', 'optional_descriptor_array2', 'optional_descriptor_array3', 'optional_descriptor_array4', 'path', 'other_part' ]
    $optional_descriptor_array.match_request( remaining_descriptor_elements, remaining_request_path_parts ).should == [ 'optional_descriptor_array1', 'optional_descriptor_array2', 'optional_descriptor_array3', 'optional_descriptor_array4' ]

    remaining_request_path_parts  = [ 'optional_descriptor_array1', 'optional_descriptor_array2', 'optional_descriptor_array3', 'path', 'other_part' ]
    $optional_descriptor_array.match_request( remaining_descriptor_elements, remaining_request_path_parts ).should == [ 'optional_descriptor_array1', 'optional_descriptor_array2', 'optional_descriptor_array3' ] 

    remaining_request_path_parts  = [ 'optional_descriptor_array1', 'optional_descriptor_array2', 'path', 'other_part' ]
    $optional_descriptor_array.match_request( remaining_descriptor_elements, remaining_request_path_parts ).should == [ 'optional_descriptor_array1', 'optional_descriptor_array2' ] 

    remaining_request_path_parts  = [ 'optional_descriptor_array1', 'optional_descriptor_array2', 'optional_descriptor_array3', 'optional_descriptor_array4', 'other_part' ]
    $optional_descriptor_array.match_request( remaining_descriptor_elements, remaining_request_path_parts ).should == nil 

    remaining_request_path_parts  = [ 'optional_descriptor_array1', 'optional_descriptor_array2', 'optional_descriptor_array3', 'other_part' ]
    $optional_descriptor_array.match_request( remaining_descriptor_elements, remaining_request_path_parts ).should == nil 

    remaining_request_path_parts  = [ 'optional_descriptor_array1', 'optional_descriptor_array2' ]
    $optional_descriptor_array.match_request( remaining_descriptor_elements, remaining_request_path_parts ).should == nil 

  end

end
