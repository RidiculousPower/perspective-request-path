
#-----------------------------------------------------------------------------------------------------------#
#--------------------------------------------  Symbol  -----------------------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

require_relative '../../../lib/rmagnets-view-path.rb'

describe Rmagnets::ViewPath::Variable do

	###################
	#  match_request  #
	###################

  it 'can match a variable request path part' do

    variable_path_part = Rmagnets::ViewPath::Variable.new( :path_part )
    remaining_descriptor_elements = []
    
    # one matching part
    remaining_request_path_parts  = [ 'path_part' ]
    variable_path_part.match_request( remaining_descriptor_elements, remaining_request_path_parts ).should == [ 'path_part' ]

    # no part
    remaining_request_path_parts  = []
    variable_path_part.match_request( remaining_descriptor_elements, remaining_request_path_parts ).should == nil
    
    # multiple remaining parts after matching part
    remaining_request_path_parts  = [ 'path_part', 'other_part' ]
    variable_path_part.match_request( remaining_descriptor_elements, remaining_request_path_parts ).should == [ 'path_part' ]
    
  end
  
end
