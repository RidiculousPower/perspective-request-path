
#-----------------------------------------------------------------------------------------------------------#
#--------------------------------------------  String  -----------------------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

require_relative '../../../../lib/rmagnets-view-path.rb'

describe Rmagnets::ViewPath::Constant do

	###################
	#  match_request  #
	###################

  it 'can match a request path part' do

    path_part  = Rmagnets::ViewPath::Constant.new( 'path_part' )
    other_part = Rmagnets::ViewPath::Constant.new( 'other_part' )
    junk_part  = Rmagnets::ViewPath::Constant.new( 'junkpart' )
    remaining_descriptor_elements = []
    
    # one matching part
    remaining_request_path_parts  = [ path_part ]
    path_part.match_request( remaining_descriptor_elements, remaining_request_path_parts ).should == [ path_part ]

    # one non-matching part
    remaining_request_path_parts  = [ junk_part ]
    path_part.match_request( remaining_descriptor_elements, remaining_request_path_parts ).should == nil

    # no parts
    remaining_request_path_parts  = []
    path_part.match_request( remaining_descriptor_elements, remaining_request_path_parts ).should == nil
    
    # multiple remaining parts after matching part
    remaining_request_path_parts  = [ path_part, other_part ]
    path_part.match_request( remaining_descriptor_elements, remaining_request_path_parts ).should == [ path_part ]
    
  end

end
