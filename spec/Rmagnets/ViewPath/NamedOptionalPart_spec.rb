
#-----------------------------------------------------------------------------------------------------------#
#--------------------------------  Rmagnets View Path Named Optional Part  ---------------------------------#
#-----------------------------------------------------------------------------------------------------------#

require_relative '../../../lib/rmagnets-view-path.rb'

describe Rmagnets::ViewPath::NamedOptionalPart do

  $option1 = Rmagnets::ViewPath::Variable.new( :option1 )
  $option2 = Rmagnets::ViewPath::Variable.new( :option2 )
  $option3 = Rmagnets::ViewPath::Variable.new( :option3 )
  $option4 = Rmagnets::ViewPath::Variable.new( :option4 )
  $path    = Rmagnets::ViewPath::Constant.new( 'path' )
  $part    = Rmagnets::ViewPath::Constant.new( 'part' )
  $optional_descriptor_hash = { :option_name1 => $option1, :option_name2 => $option2, :option_group1 => { :option_name3 => $option3, :option_group2 => { :option_name4 => $option4 } } }
  $optional_part = Rmagnets::ViewPath::NamedOptionalPart.new( $optional_descriptor_hash )
	
	#############################################
	#  path_parts_remaining_after_optional_set  #
	#############################################

  it 'can return an array of path parts that remain if optional set matches' do

    # full option set
    optional_set = { :option_name1 => $option1, :option_name2 => $option2, :option_name3 => $option3, :option_name4 => $option4 }
    remaining_request_path_parts  = [ 'optional_part1', 'optional_part2', 'optional_part3', 'optional_part4', 'path', 'part' ]
    $optional_part.path_parts_remaining_after_optional_set( optional_set, remaining_request_path_parts ).should == [ 'path', 'part' ]
    
    # 3/4 set
    optional_set = { :option_name1 => $option1, :option_name2 => $option2, :option_name3 => $option3 }
    remaining_request_path_parts  = [ 'optional_part1', 'optional_part2', 'optional_part3', 'optional_part4', 'path', 'part' ]
    $optional_part.path_parts_remaining_after_optional_set( optional_set, remaining_request_path_parts ).should == [ 'optional_part4', 'path', 'part' ]

    # minimal set
    optional_set = { :option_name1 => $option1, :option_name2 => $option2 }
    remaining_request_path_parts  = [ 'optional_part1', 'optional_part2', 'optional_part3', 'optional_part4', 'path', 'part' ]
    $optional_part.path_parts_remaining_after_optional_set( optional_set, remaining_request_path_parts ).should == [ 'optional_part3', 'optional_part4', 'path', 'part' ]

  end

	##################################################
	#  match_remaining_descriptors_for_optional_set  #
	##################################################

  it 'can look ahead to match remaining descriptors past this optional descriptor' do
    
    optional_set = { :option_name1 => $option1, :option_name2 => $option2, :option_name3 => $option3, :option_name4 => $option4 }
    remaining_descriptor_elements = [ Rmagnets::ViewPath::Constant.new( 'path' ), Rmagnets::ViewPath::Variable.new( :part ) ]

    remaining_request_path_parts  = [ 'optional_part1', 'optional_part2', 'optional_part3', 'optional_part4', 'path', 'part' ]
    $optional_part.match_remaining_descriptors_for_optional_set( optional_set, remaining_descriptor_elements, remaining_request_path_parts ).should == [ 'path', 'part' ]

    remaining_request_path_parts  = [ 'optional_part3', 'optional_part4', 'path', 'part' ]
    $optional_part.match_remaining_descriptors_for_optional_set( optional_set, remaining_descriptor_elements, remaining_request_path_parts ).should == nil

    remaining_request_path_parts  = [ 'optional_part4', 'path', 'part' ]
    $optional_part.match_remaining_descriptors_for_optional_set( optional_set, remaining_descriptor_elements, remaining_request_path_parts ).should == nil

  end

	###############################################
	#  match_option_descriptors_for_optional_set  #
	###############################################

  it 'can match optional parts' do

    optional_set = { :option_name1 => $option1, :option_name2 => $option2, :option_name3 => $option3, :option_name4 => $option4 }
    remaining_descriptor_elements = [ Rmagnets::ViewPath::Constant.new( 'path' ), Rmagnets::ViewPath::Variable.new( :part ) ]

    remaining_request_path_parts  = [ 'optional_part1', 'optional_part2', 'optional_part3', 'optional_part4', 'path', 'part' ]
    $optional_part.match_option_descriptors_for_optional_set( optional_set, remaining_descriptor_elements, remaining_request_path_parts ).should == [ 'optional_part1', 'optional_part2', 'optional_part3', 'optional_part4' ] 

  end

	###################
	#  match_request  #
	###################

  it 'can match nested optional parts' do

    remaining_descriptor_elements = [ Rmagnets::ViewPath::Constant.new( 'path' ), Rmagnets::ViewPath::Variable.new( :part ) ]

    remaining_request_path_parts  = [ 'optional_part1', 'optional_part2', 'optional_part3', 'optional_part4', 'path', 'part' ]
    $optional_part.match_request( remaining_descriptor_elements, remaining_request_path_parts ).should == [ 'optional_part1', 'optional_part2', 'optional_part3', 'optional_part4' ]
    $optional_part.named_optional_parts.should == { :option_name1 => 'optional_part1', :option_name2 => 'optional_part2', :option_name3 => 'optional_part3', :option_name4 => 'optional_part4', :option_group1 => { :option_name3 => 'optional_part3', :option_group2 => { :option_name4 => 'optional_part4' }, :option_name4 => 'optional_part4' }, :option_group2 => { :option_name4 => 'optional_part4' } }

    remaining_request_path_parts  = [ 'optional_part1', 'optional_part2', 'optional_part3', 'path', 'part' ]
    $optional_part.match_request( remaining_descriptor_elements, remaining_request_path_parts ).should == [ 'optional_part1', 'optional_part2', 'optional_part3' ] 
    $optional_part.named_optional_parts.should == { :option_name1 => 'optional_part1', :option_name2 => 'optional_part2', :option_name3 => 'optional_part3', :option_group1 => { :option_name3 => 'optional_part3' } }

    remaining_request_path_parts  = [ 'optional_part1', 'optional_part2', 'path', 'part' ]
    $optional_part.match_request( remaining_descriptor_elements, remaining_request_path_parts ).should == [ 'optional_part1', 'optional_part2' ] 
    $optional_part.named_optional_parts.should == { :option_name1 => 'optional_part1', :option_name2 => 'optional_part2' }

    remaining_request_path_parts  = [ 'optional_part1', 'optional_part2', 'optional_part3', 'optional_part4', 'part' ]
    $optional_part.match_request( remaining_descriptor_elements, remaining_request_path_parts ).should == nil
    $optional_part.named_optional_parts.should == { }

    remaining_request_path_parts  = [ 'optional_part1', 'optional_part2', 'optional_part3', 'part' ]
    $optional_part.match_request( remaining_descriptor_elements, remaining_request_path_parts ).should == nil
    $optional_part.named_optional_parts.should == { }

    remaining_request_path_parts  = [ 'optional_part1', 'optional_part2' ]
    $optional_part.match_request( remaining_descriptor_elements, remaining_request_path_parts ).should == nil
    $optional_part.named_optional_parts.should == { }

  end

end
