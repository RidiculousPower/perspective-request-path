
#-----------------------------------------------------------------------------------------------------------#
#--------------------------------------  Rmagnets View Path Regexp  ----------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

require_relative '../../../lib/rmagnets-view-path.rb'

describe Rmagnets::ViewPath::RegularExpression do

  ###################
  #  match_request  #
  ###################

  it 'can match a variable request path part' do

    regexp_path_part = Rmagnets::ViewPath::RegularExpression.new( /path_part(\d*)/ )
    remaining_descriptor_elements = []

    # one matching part
    remaining_request_path_parts  = [ 'path_part' ]
    regexp_path_part.match_request( remaining_descriptor_elements, remaining_request_path_parts ).should == [ 'path_part' ]
    remaining_request_path_parts  = [ 'path_part12' ]
    regexp_path_part.match_request( remaining_descriptor_elements, remaining_request_path_parts ).should == [ 'path_part12' ]
    remaining_request_path_parts  = [ 'path_part42' ]
    regexp_path_part.match_request( remaining_descriptor_elements, remaining_request_path_parts ).should == [ 'path_part42' ]
    remaining_request_path_parts  = [ 'path_part37' ]
    regexp_path_part.match_request( remaining_descriptor_elements, remaining_request_path_parts ).should == [ 'path_part37' ]

    # no part
    remaining_request_path_parts  = []
    regexp_path_part.match_request( remaining_descriptor_elements, remaining_request_path_parts ).should == nil
  
    # multiple remaining parts after matching part
    remaining_request_path_parts  = [ 'path_part', 'other_part' ]
    regexp_path_part.match_request( remaining_descriptor_elements, remaining_request_path_parts ).should == [ 'path_part' ]
    remaining_request_path_parts  = [ 'path_part12', 'other_part' ]
    regexp_path_part.match_request( remaining_descriptor_elements, remaining_request_path_parts ).should == [ 'path_part12' ]
    remaining_request_path_parts  = [ 'path_part42', 'other_part' ]
    regexp_path_part.match_request( remaining_descriptor_elements, remaining_request_path_parts ).should == [ 'path_part42' ]
    remaining_request_path_parts  = [ 'path_part37', 'other_part' ]
    regexp_path_part.match_request( remaining_descriptor_elements, remaining_request_path_parts ).should == [ 'path_part37' ]

    # no match
    remaining_request_path_parts  = [ 'no_match', 'path_part', 'other_part' ]
    regexp_path_part.match_request( remaining_descriptor_elements, remaining_request_path_parts ).should == nil
    remaining_request_path_parts  = [ 'no_match', 'path_part12', 'other_part' ]
    regexp_path_part.match_request( remaining_descriptor_elements, remaining_request_path_parts ).should == nil
    remaining_request_path_parts  = [ 'no_match', 'path_part42', 'other_part' ]
    regexp_path_part.match_request( remaining_descriptor_elements, remaining_request_path_parts ).should == nil
    remaining_request_path_parts  = [ 'no_match', 'path_part37', 'other_part' ]
    regexp_path_part.match_request( remaining_descriptor_elements, remaining_request_path_parts ).should == nil
  
  end

end
