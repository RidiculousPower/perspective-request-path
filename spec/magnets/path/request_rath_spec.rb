
require_relative '../../../lib/magnets-path.rb'

describe ::Magnets::Path::RequestPath do

  before :all do
    
    class ::Magnets::Path::RequestPath::MockPath
      
      def initialize( *parts )
        @parts = parts
      end
      
      def count
        return @parts.count
      end

      def []( index )
        return @parts[ index ]
      end
      
    end
    
    class ::Magnets::Path::RequestPath::MockPath::Part

      def initialize( *fragments )
        @fragments = fragments
      end

      def count
        return @fragments.count
      end
      
      def []( index )
        return @fragments[ index ]
      end

      def match( request_path )
        request_path.matched_part!
        return true
      end
      
    end
    
    class ::Magnets::Path::RequestPath::MockPath::Part::Fragment
      
      # we are mocking so we can cheat
      def initialize( index, size )
        @index = index
        @size = size
      end
      
      def look_ahead_match( request_path )
        request_path.matched_look_ahead_fragment!( @index, @size )
        return @index, @size
      end
      
    end
    
    @mock_path_part_one = ::Magnets::Path::RequestPath::MockPath::Part.new
    @mock_path_part_two = ::Magnets::Path::RequestPath::MockPath::Part.new
    @mock_path_part_three_fragment_one = ::Magnets::Path::RequestPath::MockPath::Part::Fragment.new( 0, 2 )
    @mock_path_part_three_fragment_two = ::Magnets::Path::RequestPath::MockPath::Part::Fragment.new( 2, 1 )
    @mock_path_part_three_fragment_three = ::Magnets::Path::RequestPath::MockPath::Part::Fragment.new( 3, 1 )
    @mock_path_part_three = ::Magnets::Path::RequestPath::MockPath::Part.new( @mock_path_part_three_fragment_one, @mock_path_part_three_fragment_two, @mock_path_part_three_fragment_three )
    @mock_path = ::Magnets::Path::RequestPath::MockPath.new( @mock_path_part_one, @mock_path_part_two, @mock_path_part_three )
    
  end

  ##################################################################################################
  #    private #####################################################################################
  ##################################################################################################

	###############
	#  new_frame  #
	###############
  
  it 'can create a new stack frame' do
    request_path = ::Magnets::Path::RequestPath.new( '/some/request/path/', @mock_path )
    request_path.instance_eval do
      first_frame = new_frame
      first_frame.is_a?( ::Magnets::Path::RequestPath::FrameStruct ).should == true
      first_frame.current_index.should == 0
      first_frame.current_definition_index.should == 0
      first_frame.fragment_stack.should == nil
      first_frame.matched_for_index.should == nil
      first_frame.matched_for_definition.should == nil
      # mock :current_frame method
      define_singleton_method( :current_frame ) do
        return first_frame
      end
      second_frame = new_frame( 2 )
      second_frame.is_a?( ::Magnets::Path::RequestPath::FrameStruct ).should == true
      second_frame.current_index.should == 2
      second_frame.current_definition_index.should == 2
      second_frame.fragment_stack.should == nil
      second_frame.matched_for_index.should == nil
      second_frame.matched_for_definition.should == nil
    end
  end
  
	########################
	#  new_fragment_frame  #
	########################

  it 'can create a new fragment stack frame' do
    request_path = ::Magnets::Path::RequestPath.new( '/some/request/path/', @mock_path )
    request_path.instance_eval do
      first_fragment_frame = new_fragment_frame
      first_fragment_frame.is_a?( ::Magnets::Path::RequestPath::FragmentFrameStruct ).should == true
      first_fragment_frame.current_slice_index.should == 0
      first_fragment_frame.current_definition_index.should == 0
      first_fragment_frame.matched_for_index.should == nil
      first_fragment_frame.matched_for_definition.should == nil
      # mock :current_frame method
      define_singleton_method( :current_fragment_frame ) do
        return first_fragment_frame
      end
      second_fragment_frame = new_fragment_frame( 2 )
      second_fragment_frame.is_a?( ::Magnets::Path::RequestPath::FragmentFrameStruct ).should == true
      second_fragment_frame.current_slice_index.should == 2
      second_fragment_frame.current_definition_index.should == 2
      second_fragment_frame.matched_for_index.should == nil
      second_fragment_frame.matched_for_definition.should == nil
    end
  end

	###################
	#  current_frame  #
	###################
  
  it 'can return the current stack frame' do
    request_path = ::Magnets::Path::RequestPath.new( '/some/request/path/', @mock_path )
    request_path.instance_eval do
      frame = current_frame
      frame.is_a?( ::Magnets::Path::RequestPath::FrameStruct ).should == true
      frame.current_index.should == 0
      frame.current_definition_index.should == 0
      frame.fragment_stack.should == nil
      frame.matched_for_index.should == nil
      frame.matched_for_definition.should == nil
    end
  end

	############################
	#  current_fragment_frame  #
	############################

  it 'can return the current fragment stack frame' do
    request_path = ::Magnets::Path::RequestPath.new( '/some/request/path/', @mock_path )
    request_path.instance_eval do
      frame = current_frame
      # mock setup - fragment frame has to be initialized, which happens by explicit call
      # but that is in the public interface
      frame.fragment_stack = [ new_fragment_frame ]
      fragment_frame = current_fragment_frame
      fragment_frame.is_a?( ::Magnets::Path::RequestPath::FragmentFrameStruct ).should == true
      fragment_frame.current_slice_index.should == 0
      fragment_frame.current_definition_index.should == 0
      fragment_frame.matched_for_index.should == nil
      fragment_frame.matched_for_definition.should == nil
    end
  end

  ############################################
	#  merge_matched_parts_for_fragment_frame  #
	############################################

  it 'can merge matched parts from a fragment frame into prior frame after new frame is done with successful match' do
    request_path = ::Magnets::Path::RequestPath.new( '/some/request/path/', @mock_path )
    request_path.instance_eval do
      fragment_frames = [ ]
      # mock fragment return
      define_singleton_method( :current_fragment_frame ) do
        fragment_frames[ -1 ]
      end

      # pretending we have 3 fragments for 'some' - 'so', 'm', and 'e'
      mock_path_part_one = ::Magnets::Path::RequestPath::MockPath::Part.new
      mock_path_part_two = ::Magnets::Path::RequestPath::MockPath::Part.new
      mock_path_part_three_fragment_one = ::Magnets::Path::RequestPath::MockPath::Part::Fragment.new( 0, 2 )
      mock_path_part_three_fragment_two = ::Magnets::Path::RequestPath::MockPath::Part::Fragment.new( 2, 1 )
      mock_path_part_three_fragment_three = ::Magnets::Path::RequestPath::MockPath::Part::Fragment.new( 3, 1 )
      mock_path_part_three = ::Magnets::Path::RequestPath::MockPath::Part.new( mock_path_part_three_fragment_one, mock_path_part_three_fragment_two, mock_path_part_three_fragment_three )
      mock_path = ::Magnets::Path::RequestPath::MockPath.new( mock_path_part_one, mock_path_part_two, mock_path_part_three )
      
      # first frame
      fragment_frame_one = new_fragment_frame
      fragment_frames.push( fragment_frame_one )
      current_fragment_frame.should == fragment_frame_one
    
      # second frame - like we had an optional match
      fragment_frame_two = new_fragment_frame( 0 )
      fragment_frame_two.current_slice_index = 2
      fragment_frame_two.current_definition_index = 1
      fragment_frame_two.matched_for_index = { }
      fragment_frame_two.matched_for_definition = { }
      fragment_frame_two.matched_for_index[ 0 ] = mock_path_part_three_fragment_one
      fragment_frame_two.matched_for_definition[ mock_path_part_three_fragment_one ] = 'so'
      fragment_frames.push( fragment_frame_two )
      current_fragment_frame.should == fragment_frame_two
      
      # third frame - we matched the first but we have a sub-optional match
      fragment_frame_three = new_fragment_frame( 2 )
      fragment_frame_three.current_slice_index = 4
      fragment_frame_three.current_definition_index = 3
      fragment_frame_three.matched_for_index = { }
      fragment_frame_three.matched_for_definition = { }
      fragment_frame_three.matched_for_index[ 1 ] = mock_path_part_three_fragment_two
      fragment_frame_three.matched_for_definition[ mock_path_part_three_fragment_two ] = 'm'
      fragment_frame_three.matched_for_index[ 2 ] = mock_path_part_three_fragment_three
      fragment_frame_three.matched_for_definition[ mock_path_part_three_fragment_three ] = 'e'
      fragment_frames.push( fragment_frame_three )
      current_fragment_frame.should == fragment_frame_three
      
      # we determined we matched, so now we have to merge down the fragment pieces
      
      # first merge fragment_frame_three into fragment_frame_two
      merge_matched_parts_for_fragment_frame( fragment_frame_three, fragment_frame_two )
      fragment_frame_two.matched_for_index[ 0 ].should == mock_path_part_three_fragment_one
      fragment_frame_two.matched_for_index[ 1 ].should == mock_path_part_three_fragment_two
      fragment_frame_two.matched_for_index[ 2 ].should == mock_path_part_three_fragment_three
      fragment_frame_two.matched_for_definition[ mock_path_part_three_fragment_one ].should == 'so'
      fragment_frame_two.matched_for_definition[ mock_path_part_three_fragment_two ].should == 'm'
      fragment_frame_two.matched_for_definition[ mock_path_part_three_fragment_three ].should == 'e'

      merge_matched_parts_for_fragment_frame( fragment_frame_two, fragment_frame_one )
      fragment_frame_one.matched_for_index[ 0 ].should == mock_path_part_three_fragment_one
      fragment_frame_one.matched_for_index[ 1 ].should == mock_path_part_three_fragment_two
      fragment_frame_one.matched_for_index[ 2 ].should == mock_path_part_three_fragment_three
      fragment_frame_one.matched_for_definition[ mock_path_part_three_fragment_one ].should == 'so'
      fragment_frame_one.matched_for_definition[ mock_path_part_three_fragment_two ].should == 'm'
      fragment_frame_one.matched_for_definition[ mock_path_part_three_fragment_three ].should == 'e'

    end
  end

	###################################
	#  merge_matched_parts_for_frame  #
	###################################

  it 'can merge matched parts from a frame into prior frame after new frame is done with successful match' do
    request_path = ::Magnets::Path::RequestPath.new( '/some/request/path/', @mock_path )
    request_path.instance_eval do
      frames = [ ]
      # mock fragment return
      define_singleton_method( :current_frame ) do
        frames[ -1 ]
      end
      define_singleton_method( :current_fragment_frame ) do
        fragment_frame = nil
        if frames[ -1 ].fragment_stack
          fragment_frame = frames[ -1 ].fragment_stack[ -1 ]
        end
        return fragment_frame
      end

      # pretending we have 3 fragments for 'path' - 'pa', 't', and 'h'
      mock_path_part_one = ::Magnets::Path::RequestPath::MockPath::Part.new
      mock_path_part_two = ::Magnets::Path::RequestPath::MockPath::Part.new
      mock_path_part_three_fragment_one = ::Magnets::Path::RequestPath::MockPath::Part::Fragment.new( 0, 2 )
      mock_path_part_three_fragment_two = ::Magnets::Path::RequestPath::MockPath::Part::Fragment.new( 2, 1 )
      mock_path_part_three_fragment_three = ::Magnets::Path::RequestPath::MockPath::Part::Fragment.new( 3, 1 )
      mock_path_part_three = ::Magnets::Path::RequestPath::MockPath::Part.new( mock_path_part_three_fragment_one, mock_path_part_three_fragment_two, mock_path_part_three_fragment_three )
      mock_path = ::Magnets::Path::RequestPath::MockPath.new( mock_path_part_one, mock_path_part_two, mock_path_part_three )
      
      # first frame
      frame_one = new_frame
      frames.push( frame_one )
      current_frame.should == frame_one
    
      # second frame - like we had an optional match
      frame_two = new_frame( 0 )
      frame_two.current_index = 2
      frame_two.current_definition_index = 1
      frame_two.matched_for_index = { }
      frame_two.matched_for_definition = { }
      frame_two.matched_for_index[ 0 ] = mock_path_part_one
      frame_two.matched_for_definition[ mock_path_part_one ] = 'some'
      frames.push( frame_two )
      current_frame.should == frame_two
      
      # third frame - we matched the first but we have a sub-optional match
      frame_three = new_frame( 2 )
      frame_three.current_index = 4
      frame_three.current_definition_index = 3
      frame_three.matched_for_index = { }
      frame_three.matched_for_definition = { }
      frame_three.matched_for_index[ 1 ] = mock_path_part_two
      frame_three.matched_for_definition[ mock_path_part_two ] = 'request'
      frame_three.matched_for_index[ 2 ] = mock_path_part_three
      frame_three.matched_for_definition[ mock_path_part_three ] = 'path'
      frame_three.fragment_stack = [ ]
      fragment_frame = new_fragment_frame
      fragment_frame.current_slice_index = 4
      fragment_frame.current_definition_index = 3
      fragment_frame.matched_for_index = { }
      fragment_frame.matched_for_definition = { }
      fragment_frame.matched_for_index[ 0 ] = mock_path_part_three_fragment_one
      fragment_frame.matched_for_definition[ mock_path_part_three_fragment_one ] = 'pa'
      fragment_frame.matched_for_index[ 1 ] = mock_path_part_three_fragment_two
      fragment_frame.matched_for_definition[ mock_path_part_three_fragment_two ] = 't'
      fragment_frame.matched_for_index[ 2 ] = mock_path_part_three_fragment_three
      fragment_frame.matched_for_definition[ mock_path_part_three_fragment_three ] = 'h'
      frame_three.fragment_stack.push( fragment_frame )
      frames.push( frame_three )
      current_frame.should == frame_three
      current_fragment_frame.should == fragment_frame
      
      # we determined we matched, so now we have to merge down the parts
      
      # first merge frame_three into frame_two
      merge_matched_parts_for_frame( frame_three, frame_two )
      frame_two.matched_for_index[ 0 ] = mock_path_part_one
      frame_two.matched_for_definition[ mock_path_part_one ].should == 'some'
      frame_two.matched_for_index[ 1 ] = mock_path_part_two
      frame_two.matched_for_definition[ mock_path_part_two ].should == 'request'
      frame_two.matched_for_index[ 2 ] = mock_path_part_three
      frame_two.matched_for_definition[ mock_path_part_three ].should == 'path'
      frame_two.fragment_stack[0].matched_for_index[ 0 ].should == mock_path_part_three_fragment_one
      frame_two.fragment_stack[0].matched_for_index[ 1 ].should == mock_path_part_three_fragment_two
      frame_two.fragment_stack[0].matched_for_index[ 2 ].should == mock_path_part_three_fragment_three
      frame_two.fragment_stack[0].matched_for_definition[ mock_path_part_three_fragment_one ].should == 'pa'
      frame_two.fragment_stack[0].matched_for_definition[ mock_path_part_three_fragment_two ].should == 't'
      frame_two.fragment_stack[0].matched_for_definition[ mock_path_part_three_fragment_three ].should == 'h'

      merge_matched_parts_for_frame( frame_two, frame_one )
      frame_one.matched_for_index[ 0 ] = mock_path_part_one
      frame_one.matched_for_definition[ mock_path_part_one ].should == 'some'
      frame_one.matched_for_index[ 1 ] = mock_path_part_two
      frame_one.matched_for_definition[ mock_path_part_two ].should == 'request'
      frame_one.matched_for_index[ 2 ] = mock_path_part_three
      frame_one.matched_for_definition[ mock_path_part_three ].should == 'path'
      frame_one.fragment_stack[0].matched_for_index[ 0 ].should == mock_path_part_three_fragment_one
      frame_one.fragment_stack[0].matched_for_index[ 1 ].should == mock_path_part_three_fragment_two
      frame_one.fragment_stack[0].matched_for_index[ 2 ].should == mock_path_part_three_fragment_three
      frame_one.fragment_stack[0].matched_for_definition[ mock_path_part_three_fragment_one ].should == 'pa'
      frame_one.fragment_stack[0].matched_for_definition[ mock_path_part_three_fragment_two ].should == 't'
      frame_one.fragment_stack[0].matched_for_definition[ mock_path_part_three_fragment_three ].should == 'h'

    end
  end

	##########################
	#  merge_fragment_frame  #
	##########################  

  it 'can merge a fragment frame into prior frame after new frame is done with successful match' do
    request_path = ::Magnets::Path::RequestPath.new( '/some/request/path/', @mock_path )
    request_path.instance_eval do
      fragment_frames = [ ]
      # mock fragment return
      define_singleton_method( :current_fragment_frame ) do
        fragment_frames[ -1 ]
      end

      # pretending we have 3 fragments for 'some' - 'so', 'm', and 'e'
      mock_path_part_one = ::Magnets::Path::RequestPath::MockPath::Part.new
      mock_path_part_two = ::Magnets::Path::RequestPath::MockPath::Part.new
      mock_path_part_three_fragment_one = ::Magnets::Path::RequestPath::MockPath::Part::Fragment.new( 0, 2 )
      mock_path_part_three_fragment_two = ::Magnets::Path::RequestPath::MockPath::Part::Fragment.new( 2, 1 )
      mock_path_part_three_fragment_three = ::Magnets::Path::RequestPath::MockPath::Part::Fragment.new( 3, 1 )
      mock_path_part_three = ::Magnets::Path::RequestPath::MockPath::Part.new( mock_path_part_three_fragment_one, mock_path_part_three_fragment_two, mock_path_part_three_fragment_three )
      mock_path = ::Magnets::Path::RequestPath::MockPath.new( mock_path_part_one, mock_path_part_two, mock_path_part_three )
      
      # first frame
      fragment_frame_one = new_fragment_frame
      fragment_frames.push( fragment_frame_one )
      current_fragment_frame.should == fragment_frame_one
    
      # second frame - like we had an optional match
      fragment_frame_two = new_fragment_frame( 0 )
      fragment_frame_two.current_slice_index = 2
      fragment_frame_two.current_definition_index = 1
      fragment_frame_two.matched_for_index = { }
      fragment_frame_two.matched_for_definition = { }
      fragment_frame_two.matched_for_index[ 0 ] = mock_path_part_three_fragment_one
      fragment_frame_two.matched_for_definition[ mock_path_part_three_fragment_one ] = 'so'
      fragment_frames.push( fragment_frame_two )
      current_fragment_frame.should == fragment_frame_two
      
      # third frame - we matched the first but we have a sub-optional match
      fragment_frame_three = new_fragment_frame( 2 )
      fragment_frame_three.current_slice_index = 4
      fragment_frame_three.current_definition_index = 3
      fragment_frame_three.matched_for_index = { }
      fragment_frame_three.matched_for_definition = { }
      fragment_frame_three.matched_for_index[ 1 ] = mock_path_part_three_fragment_two
      fragment_frame_three.matched_for_definition[ mock_path_part_three_fragment_two ] = 'm'
      fragment_frame_three.matched_for_index[ 2 ] = mock_path_part_three_fragment_three
      fragment_frame_three.matched_for_definition[ mock_path_part_three_fragment_three ] = 'e'
      fragment_frames.push( fragment_frame_three )
      current_fragment_frame.should == fragment_frame_three
      
      # we determined we matched, so now we have to merge down the fragment pieces
      
      # first merge fragment_frame_three into fragment_frame_two
      merge_fragment_frame( fragment_frame_three, fragment_frame_two )
      fragment_frame_two.current_slice_index.should == 4
      fragment_frame_two.current_definition_index.should == 3
      fragment_frame_two.matched_for_index[ 0 ].should == mock_path_part_three_fragment_one
      fragment_frame_two.matched_for_index[ 1 ].should == mock_path_part_three_fragment_two
      fragment_frame_two.matched_for_index[ 2 ].should == mock_path_part_three_fragment_three
      fragment_frame_two.matched_for_definition[ mock_path_part_three_fragment_one ].should == 'so'
      fragment_frame_two.matched_for_definition[ mock_path_part_three_fragment_two ].should == 'm'
      fragment_frame_two.matched_for_definition[ mock_path_part_three_fragment_three ].should == 'e'

      merge_fragment_frame( fragment_frame_two, fragment_frame_one )
      fragment_frame_one.current_slice_index.should == 4
      fragment_frame_one.current_definition_index.should == 3
      fragment_frame_one.matched_for_index[ 0 ].should == mock_path_part_three_fragment_one
      fragment_frame_one.matched_for_index[ 1 ].should == mock_path_part_three_fragment_two
      fragment_frame_one.matched_for_index[ 2 ].should == mock_path_part_three_fragment_three
      fragment_frame_one.matched_for_definition[ mock_path_part_three_fragment_one ].should == 'so'
      fragment_frame_one.matched_for_definition[ mock_path_part_three_fragment_two ].should == 'm'
      fragment_frame_one.matched_for_definition[ mock_path_part_three_fragment_three ].should == 'e'

    end
  end
    
	#################
	#  merge_frame  #
	#################

  it 'can merge a frame into prior frame after new frame is done with successful match' do
    request_path = ::Magnets::Path::RequestPath.new( '/some/request/path/', @mock_path )
    request_path.instance_eval do
      frames = [ ]
      # mock fragment return
      define_singleton_method( :current_frame ) do
        frames[ -1 ]
      end
      define_singleton_method( :current_fragment_frame ) do
        fragment_frame = nil
        if frames[ -1 ].fragment_stack
          fragment_frame = frames[ -1 ].fragment_stack[ -1 ]
        end
        return fragment_frame
      end

      # pretending we have 3 fragments for 'path' - 'pa', 't', and 'h'
      mock_path_part_one = ::Magnets::Path::RequestPath::MockPath::Part.new
      mock_path_part_two = ::Magnets::Path::RequestPath::MockPath::Part.new
      mock_path_part_three_fragment_one = ::Magnets::Path::RequestPath::MockPath::Part::Fragment.new( 0, 2 )
      mock_path_part_three_fragment_two = ::Magnets::Path::RequestPath::MockPath::Part::Fragment.new( 2, 1 )
      mock_path_part_three_fragment_three = ::Magnets::Path::RequestPath::MockPath::Part::Fragment.new( 3, 1 )
      mock_path_part_three = ::Magnets::Path::RequestPath::MockPath::Part.new( mock_path_part_three_fragment_one, mock_path_part_three_fragment_two, mock_path_part_three_fragment_three )
      mock_path = ::Magnets::Path::RequestPath::MockPath.new( mock_path_part_one, mock_path_part_two, mock_path_part_three )
      
      # first frame
      frame_one = new_frame
      frames.push( frame_one )
      current_frame.should == frame_one
    
      # second frame - like we had an optional match
      frame_two = new_frame( 0 )
      frame_two.current_index = 2
      frame_two.current_definition_index = 1
      frame_two.matched_for_index = { }
      frame_two.matched_for_definition = { }
      frame_two.matched_for_index[ 0 ] = mock_path_part_one
      frame_two.matched_for_definition[ mock_path_part_one ] = 'some'
      frames.push( frame_two )
      current_frame.should == frame_two
      
      # third frame - we matched the first but we have a sub-optional match
      frame_three = new_frame( 2 )
      frame_three.current_index = 4
      frame_three.current_definition_index = 3
      frame_three.matched_for_index = { }
      frame_three.matched_for_definition = { }
      frame_three.matched_for_index[ 1 ] = mock_path_part_two
      frame_three.matched_for_definition[ mock_path_part_two ] = 'request'
      frame_three.matched_for_index[ 2 ] = mock_path_part_three
      frame_three.matched_for_definition[ mock_path_part_three ] = 'path'
      frame_three.fragment_stack = [ ]
      fragment_frame = new_fragment_frame
      fragment_frame.current_slice_index = 4
      fragment_frame.current_definition_index = 3
      fragment_frame.matched_for_index = { }
      fragment_frame.matched_for_definition = { }
      fragment_frame.matched_for_index[ 0 ] = mock_path_part_three_fragment_one
      fragment_frame.matched_for_definition[ mock_path_part_three_fragment_one ] = 'pa'
      fragment_frame.matched_for_index[ 1 ] = mock_path_part_three_fragment_two
      fragment_frame.matched_for_definition[ mock_path_part_three_fragment_two ] = 't'
      fragment_frame.matched_for_index[ 2 ] = mock_path_part_three_fragment_three
      fragment_frame.matched_for_definition[ mock_path_part_three_fragment_three ] = 'h'
      frame_three.fragment_stack.push( fragment_frame )
      frames.push( frame_three )
      current_frame.should == frame_three
      current_fragment_frame.should == fragment_frame
      
      # we determined we matched, so now we have to merge down the parts
      
      # first merge frame_three into frame_two
      merge_frame( frame_three, frame_two )
      frame_two.current_index.should == 4
      frame_two.current_definition_index.should == 3
      frame_two.matched_for_index[ 0 ].should == mock_path_part_one
      frame_two.matched_for_definition[ mock_path_part_one ].should == 'some'
      frame_two.matched_for_index[ 1 ].should == mock_path_part_two
      frame_two.matched_for_definition[ mock_path_part_two ].should == 'request'
      frame_two.matched_for_index[ 2 ].should == mock_path_part_three
      frame_two.matched_for_definition[ mock_path_part_three ].should == 'path'
      frame_two.fragment_stack[0].matched_for_index[ 0 ].should == mock_path_part_three_fragment_one
      frame_two.fragment_stack[0].matched_for_index[ 1 ].should == mock_path_part_three_fragment_two
      frame_two.fragment_stack[0].matched_for_index[ 2 ].should == mock_path_part_three_fragment_three
      frame_two.fragment_stack[0].matched_for_definition[ mock_path_part_three_fragment_one ].should == 'pa'
      frame_two.fragment_stack[0].matched_for_definition[ mock_path_part_three_fragment_two ].should == 't'
      frame_two.fragment_stack[0].matched_for_definition[ mock_path_part_three_fragment_three ].should == 'h'

      merge_frame( frame_two, frame_one )
      frame_one.current_index.should == 4
      frame_one.current_definition_index.should == 3
      frame_one.matched_for_index[ 0 ].should == mock_path_part_one
      frame_one.matched_for_definition[ mock_path_part_one ].should == 'some'
      frame_one.matched_for_index[ 1 ].should == mock_path_part_two
      frame_one.matched_for_definition[ mock_path_part_two ].should == 'request'
      frame_one.matched_for_index[ 2 ].should == mock_path_part_three
      frame_one.matched_for_definition[ mock_path_part_three ].should == 'path'
      frame_one.fragment_stack[0].current_slice_index.should == 4
      frame_one.fragment_stack[0].current_definition_index.should == 3
      frame_one.fragment_stack[0].matched_for_index[ 0 ].should == mock_path_part_three_fragment_one
      frame_one.fragment_stack[0].matched_for_index[ 1 ].should == mock_path_part_three_fragment_two
      frame_one.fragment_stack[0].matched_for_index[ 2 ].should == mock_path_part_three_fragment_three
      frame_one.fragment_stack[0].matched_for_definition[ mock_path_part_three_fragment_one ].should == 'pa'
      frame_one.fragment_stack[0].matched_for_definition[ mock_path_part_three_fragment_two ].should == 't'
      frame_one.fragment_stack[0].matched_for_definition[ mock_path_part_three_fragment_three ].should == 'h'

    end
  end

  ##################################################################################################
  #    public ######################################################################################
  ##################################################################################################

	################
	#  initialize  #
	################
	
  it 'can initialize for a request path string and an optional first attached path' do
    request_path = ::Magnets::Path::RequestPath.new( '/some/request/path/', @mock_path )
    request_path.instance_variable_get( :@path_parts ).should == [ 'some', 'request', 'path' ]
    stack = request_path.instance_variable_get( :@stack )
    stack.is_a?( ::Array ).should == true
    stack.count.should == 1
    stack[0].current_index.should == 0
    stack[0].current_definition_index.should == 0
    stack[0].fragment_stack.should == nil
    stack[0].matched_for_index.should == nil
    stack[0].matched_for_definition.should == nil
  end

	###############################  Attaching to Path Definition  ###################################

	###############################
	#  attach_to_path_definition  #
	#  attached_path              #
	###############################
	
  it 'can attach to a path definition for match processing' do
    request_path = ::Magnets::Path::RequestPath.new( '/some/request/path/' )
    stack = request_path.instance_variable_get( :@stack )
    stack.is_a?( ::Array ).should == true
    stack.count.should == 0
    Proc.new { request_path.attached_path }.should raise_error( ::RuntimeError )
    request_path.attach_to_path_definition( @mock_path )
    stack.is_a?( ::Array ).should == true
    stack.count.should == 1
    stack[0].current_index.should == 0
    stack[0].current_definition_index.should == 0
    stack[0].fragment_stack.should == nil
    stack[0].matched_for_index.should == nil
    stack[0].matched_for_definition.should == nil
    request_path.attached_path.should == @mock_path
  end
  
	##################################  Path Definition Queries  #####################################

  ##########################
	#  has_part_definition?  #
	##########################

  it 'can return whether a part definition exists at specified index' do
    request_path = ::Magnets::Path::RequestPath.new( '/some/request/path/', @mock_path )
    request_path.has_part_definition?( 0 ).should == true
    request_path.has_part_definition?( 1 ).should == true
    request_path.has_part_definition?( 2 ).should == true
    request_path.has_part_definition?( 3 ).should == false
    request_path.instance_eval do
      current_frame.current_definition_index += 1
    end
    request_path.has_part_definition?( 0 ).should == true
    request_path.has_part_definition?( 1 ).should == true
    request_path.has_part_definition?( 2 ).should == false
    request_path.instance_eval do
      current_frame.current_definition_index += 1
    end
    request_path.has_part_definition?( 0 ).should == true
    request_path.has_part_definition?( 1 ).should == false
    request_path.instance_eval do
      current_frame.current_definition_index += 1
    end
    request_path.has_fragment_definition?( 0 ).should == false    
  end

	##############################
	#  has_fragment_definition?  #
	##############################

  it 'can return whether a fragment definition exists at specified index' do
    request_path = ::Magnets::Path::RequestPath.new( '/some/request/path/', @mock_path )
    request_path.instance_eval do
      current_frame.fragment_stack = [ new_fragment_frame ]
    end
    request_path.has_fragment_definition?( 0 ).should == false
    request_path.instance_eval do
      current_frame.current_definition_index += 1
    end
    request_path.has_fragment_definition?( 0 ).should == false
    request_path.instance_eval do
      current_frame.current_definition_index += 1
    end
    request_path.has_fragment_definition?( 0 ).should == true
    request_path.has_fragment_definition?( 1 ).should == true
    request_path.has_fragment_definition?( 2 ).should == true
    request_path.has_fragment_definition?( 3 ).should == false
  end

	#############################
	#  current_part_definition  #
	#############################
  
  it 'can return the current part definition' do
    request_path = ::Magnets::Path::RequestPath.new( '/some/request/path/', @mock_path )
    request_path.current_part_definition.should == @mock_path_part_one
    request_path.instance_eval do
      current_frame.current_definition_index += 1
    end
    request_path.current_part_definition.should == @mock_path_part_two
    request_path.instance_eval do
      current_frame.current_definition_index += 1
    end
    request_path.current_part_definition.should == @mock_path_part_three
    request_path.instance_eval do
      current_frame.current_definition_index += 1
    end
    request_path.current_part_definition.should == nil
  end
  
  #################################
	#  current_fragment_definition  #
	#################################
  
  it 'can return the current fragment definition' do
    request_path = ::Magnets::Path::RequestPath.new( '/some/request/path/', @mock_path )
    request_path.instance_eval do
      current_frame.fragment_stack = [ new_fragment_frame ]
    end
    request_path.current_fragment_definition.should == nil
    request_path.instance_eval do
      current_frame.current_definition_index += 1
    end
    request_path.current_fragment_definition.should == nil
    request_path.instance_eval do
      current_frame.current_definition_index += 1
    end
    request_path.current_fragment_definition.should == @mock_path_part_three_fragment_one
    request_path.instance_eval do
      current_fragment_frame.current_definition_index += 1
    end
    request_path.current_fragment_definition.should == @mock_path_part_three_fragment_two
    request_path.instance_eval do
      current_fragment_frame.current_definition_index += 1
    end
    request_path.current_fragment_definition.should == @mock_path_part_three_fragment_three
    request_path.instance_eval do
      current_fragment_frame.current_definition_index += 1
    end
    request_path.current_fragment_definition.should == nil
    request_path.instance_eval do
      current_frame.current_definition_index += 1
    end
    request_path.current_part_definition.should == nil
  end

  ###################################  Path Request Queries  #######################################
	
	##################
	#  current_part  #
	##################

  it 'can return the current part definition' do
    request_path = ::Magnets::Path::RequestPath.new( '/some/request/path/', @mock_path )
    request_path.current_part.should == 'some'
    request_path.instance_eval do
      current_frame.current_index += 1
    end
    request_path.current_part.should == 'request'
    request_path.instance_eval do
      current_frame.current_index += 1
    end
    request_path.current_part.should == 'path'
    request_path.instance_eval do
      current_frame.current_index += 1
    end
    request_path.current_part.should == nil
  end
  
	###############
	#  next_part  #
	###############

  it 'can advance to the next part definition' do
    request_path = ::Magnets::Path::RequestPath.new( '/some/request/path/', @mock_path )
    request_path.current_part.should == 'some'
    request_path.next_part
    request_path.current_part.should == 'request'
    request_path.next_part
    request_path.current_part.should == 'path'
    request_path.next_part
    request_path.current_part.should == nil
  end

	#########################################
	#  declare_current_frame_has_fragments!  #
	#########################################

  it 'can declare that this frame has fragments (creating a fragment frame)' do
    request_path = ::Magnets::Path::RequestPath.new( '/some/request/path/', @mock_path )
    request_path.instance_eval do
      current_frame.should_not == nil
      current_fragment_frame.should == nil
    end
    request_path.declare_current_frame_has_fragments!
    request_path.instance_eval do
      current_fragment_frame.should_not == nil
      current_fragment_frame.current_slice_index.should == 0
      current_fragment_frame.current_definition_index.should == 0
      current_fragment_frame.matched_for_index.should == nil
      current_fragment_frame.matched_for_definition.should == nil
    end
  end

	######################
	#  current_fragment  #
	######################
  
  it 'can return the current fragment' do
    request_path = ::Magnets::Path::RequestPath.new( '/some/request/path/', @mock_path )
    request_path.current_fragment.should == nil
    request_path.instance_eval do
      current_frame.current_index += 1
    end
    request_path.current_fragment.should == nil
    request_path.instance_eval do
      current_frame.current_index += 1
    end
    request_path.declare_current_frame_has_fragments!
    request_path.current_fragment.should == 'path'
    request_path.instance_eval do
      current_fragment_frame.current_slice_index += 2
    end
    request_path.current_fragment.should == 'th'
    request_path.instance_eval do
      current_fragment_frame.current_slice_index += 2
    end
    request_path.current_fragment.should == nil
  end
  
  #############################
	#  has_remaining_fragment?  #
	#############################
  
  it 'can report whether it has a fragment definition remaining' do
    request_path = ::Magnets::Path::RequestPath.new( '/some/request/path/', @mock_path )
    request_path.has_remaining_fragment?.should == false
    request_path.instance_eval do
      current_frame.current_definition_index += 1
    end
    request_path.has_remaining_fragment?.should == false
    request_path.instance_eval do
      current_frame.current_definition_index += 1
    end
    request_path.declare_current_frame_has_fragments!
    request_path.has_remaining_fragment?.should == true
    request_path.instance_eval do
      current_fragment_frame.current_definition_index += 1
    end
    request_path.has_remaining_fragment?.should == true
    request_path.instance_eval do
      current_fragment_frame.current_definition_index += 1
    end
    request_path.has_remaining_fragment?.should == true
    request_path.instance_eval do
      current_fragment_frame.current_definition_index += 1
    end
    request_path.has_remaining_fragment?.should == false
  end
	
	###########################
	#  count_remaining_parts  #
	###########################
  
  it 'can count remaining parts' do
    request_path = ::Magnets::Path::RequestPath.new( '/some/request/path/', @mock_path )
    request_path.count_remaining_parts.should == 3
    request_path.instance_eval do
      current_frame.current_index += 1
      current_frame.current_definition_index += 1
    end
    request_path.count_remaining_parts.should == 2
    request_path.instance_eval do
      current_frame.current_index += 1
      current_frame.current_definition_index += 1
    end
    request_path.count_remaining_parts.should == 1
    request_path.declare_current_frame_has_fragments!
    request_path.instance_eval do
      current_fragment_frame.current_slice_index += 2
      current_fragment_frame.current_definition_index += 1
    end
    request_path.count_remaining_parts.should == 1
    request_path.instance_eval do
      current_fragment_frame.current_slice_index += 1
      current_fragment_frame.current_definition_index += 1
    end
    request_path.count_remaining_parts.should == 1
    request_path.instance_eval do
      current_fragment_frame.current_slice_index += 1
      current_fragment_frame.current_definition_index += 1
      current_frame.current_index += 1
      current_frame.current_definition_index += 1
    end
    request_path.count_remaining_parts.should == 0
  end
  
  ###############################
	#  count_remaining_fragments  #
	###############################
	
  it 'can count remaining fragments in this part' do
    request_path = ::Magnets::Path::RequestPath.new( '/some/request/path/', @mock_path )
    request_path.count_remaining_fragments.should == 0
    request_path.instance_eval do
      current_frame.current_definition_index += 1
    end
    request_path.count_remaining_fragments.should == 0
    request_path.instance_eval do
      current_frame.current_definition_index += 1
    end
    request_path.declare_current_frame_has_fragments!
    request_path.count_remaining_fragments.should == 3
    request_path.instance_eval do
      current_fragment_frame.current_definition_index += 1
    end
    request_path.count_remaining_fragments.should == 2
    request_path.instance_eval do
      current_fragment_frame.current_definition_index += 1
    end
    request_path.count_remaining_fragments.should == 1
    request_path.instance_eval do
      current_fragment_frame.current_definition_index += 1
    end
    request_path.count_remaining_fragments.should == 0
  end

	#########################################  Matching  #############################################

	######################
	#  matched_fragment  #
	######################

  it 'can return matched fragment for index (if a fragment has been matched)' do
    request_path = ::Magnets::Path::RequestPath.new( '/some/request/path/', @mock_path )
    request_path.declare_current_frame_has_fragments!
    request_path.instance_eval do
      current_fragment_frame.matched_for_definition = [ 'so' ]
    end
    request_path.matched_fragment( 0 ).should == 'so'
  end
  
	##################
	#  matched_part  #
	##################

  it 'can return matched part for index (if a part has been matched)' do
    request_path = ::Magnets::Path::RequestPath.new( '/some/request/path/', @mock_path )
    request_path.instance_eval do
      current_frame.matched_for_definition = [ 'some' ]
    end
    request_path.matched_part( 0 ).should == 'some'
  end
  
	###################
	#  matched_part!  #
	###################

  it 'can declare a path part to match' do
    request_path = ::Magnets::Path::RequestPath.new( '/some/request/path/', @mock_path )
    request_path.matched_part!
    mock_path_part_one = @mock_path_part_one
    mock_path_part_two = @mock_path_part_two
    mock_path_part_three = @mock_path_part_three
    request_path.instance_eval do
      current_frame.matched_for_index[0].should == mock_path_part_one
      current_frame.matched_for_definition[ mock_path_part_one ].should == 'some'
    end
    request_path.matched_part!
    request_path.instance_eval do
      current_frame.matched_for_index[0].should == mock_path_part_one
      current_frame.matched_for_definition[ mock_path_part_one ].should == 'some'
      current_frame.matched_for_index[1].should == mock_path_part_two
      current_frame.matched_for_definition[ mock_path_part_two ].should == 'request'
    end
    request_path.matched_part!
    request_path.instance_eval do
      current_frame.matched_for_index[0].should == mock_path_part_one
      current_frame.matched_for_definition[ mock_path_part_one ].should == 'some'
      current_frame.matched_for_index[1].should == mock_path_part_two
      current_frame.matched_for_definition[ mock_path_part_two ].should == 'request'
      current_frame.matched_for_index[2].should == mock_path_part_three
      current_frame.matched_for_definition[ mock_path_part_three ].should == 'path'
    end
  end

	###################
	#  next_fragment  #
	###################

  it 'can advance to the next fragment definition' do
    request_path = ::Magnets::Path::RequestPath.new( '/some/request/path/', @mock_path )
    request_path.next_part
    request_path.next_part
    request_path.declare_current_frame_has_fragments!
    request_path.current_fragment_definition.should == @mock_path_part_three_fragment_one
    request_path.next_fragment
    request_path.current_fragment_definition.should == @mock_path_part_three_fragment_two
    request_path.next_fragment
    request_path.current_fragment_definition.should == @mock_path_part_three_fragment_three
    request_path.next_fragment
    request_path.current_fragment_definition.should == nil
  end

	#######################
	#  matched_fragment!  #
	#######################

  it 'can declare a fragment to match' do
    request_path = ::Magnets::Path::RequestPath.new( '/some/request/path/', @mock_path )
    request_path.next_part
    request_path.next_part
    request_path.declare_current_frame_has_fragments!
    mock_path_part_three_fragment_one = @mock_path_part_three_fragment_one
    mock_path_part_three_fragment_two = @mock_path_part_three_fragment_two
    mock_path_part_three_fragment_three = @mock_path_part_three_fragment_three
    request_path.matched_fragment!( 2 )
    request_path.instance_eval do
      current_fragment_frame.matched_for_index[0].should == mock_path_part_three_fragment_one
      current_fragment_frame.matched_for_definition[ mock_path_part_three_fragment_one ].should == 'pa'
    end
    request_path.matched_fragment!( 1 )
    request_path.instance_eval do
      current_fragment_frame.matched_for_index[0].should == mock_path_part_three_fragment_one
      current_fragment_frame.matched_for_definition[ mock_path_part_three_fragment_one ].should == 'pa'
      current_fragment_frame.matched_for_index[1].should == mock_path_part_three_fragment_two
      current_fragment_frame.matched_for_definition[ mock_path_part_three_fragment_two ].should == 't'
    end
    request_path.matched_fragment!( 1 )
    request_path.instance_eval do
      current_fragment_frame.matched_for_index[0].should == mock_path_part_three_fragment_one
      current_fragment_frame.matched_for_definition[ mock_path_part_three_fragment_one ].should == 'pa'
      current_fragment_frame.matched_for_index[1].should == mock_path_part_three_fragment_two
      current_fragment_frame.matched_for_definition[ mock_path_part_three_fragment_two ].should == 't'
      current_fragment_frame.matched_for_index[2].should == mock_path_part_three_fragment_three
      current_fragment_frame.matched_for_definition[ mock_path_part_three_fragment_three ].should == 'h'
    end
  end

	###################
	#  match_failed!  #
	###################

  it 'can declare that the path match failed' do
    request_path = ::Magnets::Path::RequestPath.new( '/some/request/path/', @mock_path )
    mock_path_part_one = @mock_path_part_one
    mock_path_part_two = @mock_path_part_two
    mock_path_part_three = @mock_path_part_three
    mock_path_part_three_fragment_one = @mock_path_part_three_fragment_one
    mock_path_part_three_fragment_two = @mock_path_part_three_fragment_two
    mock_path_part_three_fragment_three = @mock_path_part_three_fragment_three
    request_path.matched_part!
    request_path.matched_part!
    request_path.declare_current_frame_has_fragments!
    request_path.matched_fragment!( 2 )
    request_path.matched_fragment!( 1 )
    request_path.matched_fragment!( 1 )
    request_path.matched_part!
    
    # we've verified in other tests everything we set up here
    # now we declare a fail and see that it's all reset
    
    request_path.match_failed!
    request_path.instance_eval do
      current_frame.should == nil
      @stack.should == [ ]
      @attached_path.should == nil
    end
    
  end

	#####################################  Optional Matching  ########################################

  #############################
	#  begin_optional_match     #
	#  failed_optional_match!   #
	#  matched_optional_match!  #
	#############################
	
  it 'can open an optional match with optional rollback and merge upon success' do
    request_path = ::Magnets::Path::RequestPath.new( '/some/request/path/', @mock_path )
    stack = request_path.instance_variable_get( :@stack )
    stack.count.should == 1
    stack[0].current_index.should == 0
    stack[0].current_definition_index.should == 0
    stack[0].fragment_stack.should == nil
    stack[0].matched_for_index.should == nil
    stack[0].matched_for_definition.should == nil
    
    # first an optional match
    request_path.begin_optional_match
    stack.count.should == 2
    stack[0].current_index.should == 0
    stack[0].current_definition_index.should == 0
    stack[0].fragment_stack.should == nil
    stack[0].matched_for_index.should == nil
    stack[0].matched_for_definition.should == nil
    stack[1].current_index.should == 0
    stack[1].current_definition_index.should == 0
    stack[1].fragment_stack.should == nil
    stack[1].matched_for_index.should == nil
    stack[1].matched_for_definition.should == nil
    
    # with a failing nested match
    request_path.begin_optional_match
    stack.count.should == 3
    stack[2].current_index.should == 0
    stack[2].current_definition_index.should == 0
    stack[2].fragment_stack.should == nil
    stack[2].matched_for_index.should == nil
    stack[2].matched_for_definition.should == nil
    
    # advance a match
    request_path.matched_part!
    stack[0].current_index.should == 0
    stack[0].current_definition_index.should == 0
    stack[0].fragment_stack.should == nil
    stack[0].matched_for_index.should == nil
    stack[0].matched_for_definition.should == nil
    stack[2].current_index.should == 1
    stack[2].current_definition_index.should == 1
    stack[2].fragment_stack.should == nil
    stack[2].matched_for_index[0].should == @mock_path_part_one
    stack[2].matched_for_definition[ @mock_path_part_one ].should == 'some'
    
    # but now we fail
    request_path.failed_optional_match!
    stack.count.should == 2
    stack[0].current_index.should == 0
    stack[0].current_definition_index.should == 0
    stack[0].fragment_stack.should == nil
    stack[0].matched_for_index.should == nil
    stack[0].matched_for_definition.should == nil
    stack[1].current_index.should == 0
    stack[1].current_definition_index.should == 0
    stack[1].fragment_stack.should == nil
    stack[1].matched_for_index.should == nil
    stack[1].matched_for_definition.should == nil

    # we are still in our first optional (non-nested) match
    
    # match two parts
    request_path.matched_part!
    request_path.matched_part!
    stack[0].current_index.should == 0
    stack[0].current_definition_index.should == 0
    stack[0].fragment_stack.should == nil
    stack[0].matched_for_index.should == nil
    stack[0].matched_for_definition.should == nil
    stack[1].current_index.should == 2
    stack[1].current_definition_index.should == 2
    stack[1].fragment_stack.should == nil
    stack[1].matched_for_index[0].should == @mock_path_part_one
    stack[1].matched_for_index[1].should == @mock_path_part_two
    stack[1].matched_for_definition[ @mock_path_part_one ].should == 'some'
    stack[1].matched_for_definition[ @mock_path_part_two ].should == 'request'
    
    # match the base option
    
    request_path.matched_optional_match!
    
    # that should cause a merge downward
    
    stack.count.should == 1
    stack[0].current_index.should == 2
    stack[0].current_definition_index.should == 2
    stack[0].fragment_stack.should == nil
    stack[0].matched_for_index[0].should == @mock_path_part_one
    stack[0].matched_for_index[1].should == @mock_path_part_two
    stack[0].matched_for_definition[ @mock_path_part_one ].should == 'some'
    stack[0].matched_for_definition[ @mock_path_part_two ].should == 'request'
    
  end

  ######################################
	#  begin_optional_fragment_match     #
	#  failed_optional_fragment_match!   #
	#  matched_optional_fragment_match!  #
	######################################
	
  it 'can open an optional fragment match with optional rollback and merge upon success' do
    
    request_path = ::Magnets::Path::RequestPath.new( '/some/request/path/', @mock_path )
    stack = request_path.instance_variable_get( :@stack )
    stack.count.should == 1
    stack[0].current_index.should == 0
    stack[0].current_definition_index.should == 0
    stack[0].fragment_stack.should == nil
    stack[0].matched_for_index.should == nil
    stack[0].matched_for_definition.should == nil
    
    # match the first two parts    
    request_path.matched_part!
    request_path.matched_part!
    
    # now deal with fragments
    request_path.declare_current_frame_has_fragments!
    
    # first an optional match
    request_path.begin_optional_fragment_match
    stack.count.should == 1
    stack[0].current_index.should == 2
    stack[0].current_definition_index.should == 2
    stack[0].matched_for_index[0].should == @mock_path_part_one
    stack[0].matched_for_index[1].should == @mock_path_part_two
    stack[0].matched_for_definition[ @mock_path_part_one ].should == 'some'
    stack[0].matched_for_definition[ @mock_path_part_two ].should == 'request'
    stack[0].fragment_stack.is_a?( ::Array ).should == true
    stack[0].fragment_stack.count.should == 2
    stack[0].fragment_stack[0].current_slice_index.should == 0
    stack[0].fragment_stack[0].current_definition_index.should == 0
    stack[0].fragment_stack[0].matched_for_index.should == nil
    stack[0].fragment_stack[0].matched_for_definition.should == nil
    stack[0].fragment_stack[1].current_slice_index.should == 0
    stack[0].fragment_stack[1].current_definition_index.should == 0
    stack[0].fragment_stack[1].matched_for_index.should == nil
    stack[0].fragment_stack[1].matched_for_definition.should == nil
    
    # with a failing nested match
    request_path.begin_optional_fragment_match
    stack.count.should == 1
    stack[0].current_index.should == 2
    stack[0].current_definition_index.should == 2
    stack[0].matched_for_index[0].should == @mock_path_part_one
    stack[0].matched_for_index[1].should == @mock_path_part_two
    stack[0].matched_for_definition[ @mock_path_part_one ].should == 'some'
    stack[0].matched_for_definition[ @mock_path_part_two ].should == 'request'
    stack[0].fragment_stack.is_a?( ::Array ).should == true
    stack[0].fragment_stack.count.should == 3
    stack[0].fragment_stack[0].current_slice_index.should == 0
    stack[0].fragment_stack[0].current_definition_index.should == 0
    stack[0].fragment_stack[0].matched_for_index.should == nil
    stack[0].fragment_stack[0].matched_for_definition.should == nil
    stack[0].fragment_stack[1].current_slice_index.should == 0
    stack[0].fragment_stack[1].current_definition_index.should == 0
    stack[0].fragment_stack[1].matched_for_index.should == nil
    stack[0].fragment_stack[1].matched_for_definition.should == nil
    stack[0].fragment_stack[2].current_slice_index.should == 0
    stack[0].fragment_stack[2].current_definition_index.should == 0
    stack[0].fragment_stack[2].matched_for_index.should == nil
    stack[0].fragment_stack[2].matched_for_definition.should == nil

    # advance a match
    request_path.matched_fragment!( 2 )
    stack.count.should == 1
    stack[0].current_index.should == 2
    stack[0].current_definition_index.should == 2
    stack[0].matched_for_index[0].should == @mock_path_part_one
    stack[0].matched_for_index[1].should == @mock_path_part_two
    stack[0].matched_for_definition[ @mock_path_part_one ].should == 'some'
    stack[0].matched_for_definition[ @mock_path_part_two ].should == 'request'
    stack[0].fragment_stack.is_a?( ::Array ).should == true
    stack[0].fragment_stack.count.should == 3
    stack[0].fragment_stack[0].current_slice_index.should == 0
    stack[0].fragment_stack[0].current_definition_index.should == 0
    stack[0].fragment_stack[0].matched_for_index.should == nil
    stack[0].fragment_stack[0].matched_for_definition.should == nil
    stack[0].fragment_stack[1].current_slice_index.should == 0
    stack[0].fragment_stack[1].current_definition_index.should == 0
    stack[0].fragment_stack[1].matched_for_index.should == nil
    stack[0].fragment_stack[1].matched_for_definition.should == nil
    stack[0].fragment_stack[2].current_slice_index.should == 2
    stack[0].fragment_stack[2].current_definition_index.should == 1
    stack[0].fragment_stack[2].matched_for_index[ 0 ].should == @mock_path_part_three_fragment_one
    stack[0].fragment_stack[2].matched_for_definition[ @mock_path_part_three_fragment_one ].should == 'pa'

    # but now we fail
    request_path.failed_optional_fragment_match!
    stack.count.should == 1
    stack[0].current_index.should == 2
    stack[0].current_definition_index.should == 2
    stack[0].matched_for_index[0].should == @mock_path_part_one
    stack[0].matched_for_index[1].should == @mock_path_part_two
    stack[0].matched_for_definition[ @mock_path_part_one ].should == 'some'
    stack[0].matched_for_definition[ @mock_path_part_two ].should == 'request'
    stack[0].fragment_stack.is_a?( ::Array ).should == true
    stack[0].fragment_stack.count.should == 2
    stack[0].fragment_stack[0].current_slice_index.should == 0
    stack[0].fragment_stack[0].current_definition_index.should == 0
    stack[0].fragment_stack[0].matched_for_index.should == nil
    stack[0].fragment_stack[0].matched_for_definition.should == nil
    stack[0].fragment_stack[1].current_slice_index.should == 0
    stack[0].fragment_stack[1].current_definition_index.should == 0
    stack[0].fragment_stack[1].matched_for_index.should == nil
    stack[0].fragment_stack[1].matched_for_definition.should == nil

    # we are still in our first optional (non-nested) match
    
    # match two fragments
    request_path.matched_fragment!( 2 )
    request_path.matched_fragment!( 1 )
    stack[0].current_index.should == 2
    stack[0].current_definition_index.should == 2
    stack[0].fragment_stack.is_a?( ::Array ).should == true
    stack[0].fragment_stack.count.should == 2
    stack[0].fragment_stack[0].current_slice_index.should == 0
    stack[0].fragment_stack[0].current_definition_index.should == 0
    stack[0].fragment_stack[0].matched_for_index.should == nil
    stack[0].fragment_stack[0].matched_for_definition.should == nil
    stack[0].fragment_stack[1].current_slice_index.should == 3
    stack[0].fragment_stack[1].current_definition_index.should == 2
    stack[0].fragment_stack[1].matched_for_index[0].should == @mock_path_part_three_fragment_one
    stack[0].fragment_stack[1].matched_for_index[1].should == @mock_path_part_three_fragment_two
    stack[0].fragment_stack[1].matched_for_definition[ @mock_path_part_three_fragment_one ].should == 'pa'
    stack[0].fragment_stack[1].matched_for_definition[ @mock_path_part_three_fragment_two ].should == 't'
    stack[0].matched_for_index[0].should == @mock_path_part_one
    stack[0].matched_for_index[1].should == @mock_path_part_two
    stack[0].matched_for_definition[ @mock_path_part_one ].should == 'some'
    stack[0].matched_for_definition[ @mock_path_part_two ].should == 'request'
    
    # match the base option
    
    request_path.matched_optional_fragment_match!
    
    # that should cause a merge downward
    
    stack[0].current_index.should == 2
    stack[0].current_definition_index.should == 2
    stack[0].fragment_stack.is_a?( ::Array ).should == true
    stack[0].fragment_stack.count.should == 1
    stack[0].fragment_stack[0].current_slice_index.should == 3
    stack[0].fragment_stack[0].current_definition_index.should == 2
    stack[0].fragment_stack[0].matched_for_index[0].should == @mock_path_part_three_fragment_one
    stack[0].fragment_stack[0].matched_for_index[1].should == @mock_path_part_three_fragment_two
    stack[0].fragment_stack[0].matched_for_definition[ @mock_path_part_three_fragment_one ].should == 'pa'
    stack[0].fragment_stack[0].matched_for_definition[ @mock_path_part_three_fragment_two ].should == 't'
    stack[0].matched_for_index[0].should == @mock_path_part_one
    stack[0].matched_for_index[1].should == @mock_path_part_two
    stack[0].matched_for_definition[ @mock_path_part_one ].should == 'some'
    stack[0].matched_for_definition[ @mock_path_part_two ].should == 'request'
    
  end

	####################################  Look-Ahead Matching  #######################################

	############################
	#  begin_look_ahead_match  #
	#  end_look_ahead_match    #
	############################
  
  it 'can open a look-ahead match with optional rollback and merge upon success' do
    request_path = ::Magnets::Path::RequestPath.new( '/some/request/path/', @mock_path )
    stack = request_path.instance_variable_get( :@stack )
    stack.count.should == 1
    stack[0].current_index.should == 0
    stack[0].current_definition_index.should == 0
    stack[0].fragment_stack.should == nil
    stack[0].matched_for_index.should == nil
    stack[0].matched_for_definition.should == nil
    
    # begin look-ahead match
    request_path.begin_look_ahead_match( 1 )
    stack.count.should == 2
    stack[0].current_index.should == 0
    stack[0].current_definition_index.should == 0
    stack[0].fragment_stack.should == nil
    stack[0].matched_for_index.should == nil
    stack[0].matched_for_definition.should == nil
    stack[1].current_index.should == 1
    stack[1].current_definition_index.should == 1
    stack[1].fragment_stack.should == nil
    stack[1].matched_for_index.should == nil
    stack[1].matched_for_definition.should == nil
    
    # advance a match
    request_path.matched_part!
    stack[0].current_index.should == 0
    stack[0].current_definition_index.should == 0
    stack[0].fragment_stack.should == nil
    stack[0].matched_for_index.should == nil
    stack[0].matched_for_definition.should == nil
    stack[1].current_index.should == 2
    stack[1].current_definition_index.should == 2
    stack[1].fragment_stack.should == nil
    stack[1].matched_for_index[1].should == @mock_path_part_two
    stack[1].matched_for_definition[ @mock_path_part_two ].should == 'request'
    
    # done with look-ahead
    
    request_path.end_look_ahead_match
    
    # that should cause a merge downward of matches but not position
    
    stack.count.should == 1
    stack[0].current_index.should == 0
    stack[0].current_definition_index.should == 0
    stack[0].fragment_stack.should == nil
    stack[0].matched_for_index[1].should == @mock_path_part_two
    stack[0].matched_for_definition[ @mock_path_part_two ].should == 'request'
    
    request_path.matched_part!
    stack.count.should == 1
    stack[0].current_index.should == 1
    stack[0].current_definition_index.should == 1
    stack[0].fragment_stack.should == nil
    stack[0].matched_for_index[0].should == @mock_path_part_one
    stack[0].matched_for_definition[ @mock_path_part_one ].should == 'some'
    stack[0].matched_for_index[1].should == @mock_path_part_two
    stack[0].matched_for_definition[ @mock_path_part_two ].should == 'request'
    
  end

	######################
	#  look_ahead_match  #
	######################

  it 'can open and close a look-ahead match, performing single match between' do
    request_path = ::Magnets::Path::RequestPath.new( '/some/request/path/', @mock_path )
    stack = request_path.instance_variable_get( :@stack )
    stack.count.should == 1
    stack[0].current_index.should == 0
    stack[0].current_definition_index.should == 0
    stack[0].fragment_stack.should == nil
    stack[0].matched_for_index.should == nil
    stack[0].matched_for_definition.should == nil
    
    # begin look-ahead match
    request_path.look_ahead_match( 1 ).should == true

    stack.count.should == 1
    stack[0].current_index.should == 0
    stack[0].current_definition_index.should == 0
    stack[0].fragment_stack.should == nil
    stack[0].matched_for_index[1].should == @mock_path_part_two
    stack[0].matched_for_definition[ @mock_path_part_two ].should == 'request'
    
    request_path.matched_part!
    stack.count.should == 1
    stack[0].current_index.should == 1
    stack[0].current_definition_index.should == 1
    stack[0].fragment_stack.should == nil
    stack[0].matched_for_index[0].should == @mock_path_part_one
    stack[0].matched_for_definition[ @mock_path_part_one ].should == 'some'
    stack[0].matched_for_index[1].should == @mock_path_part_two
    stack[0].matched_for_definition[ @mock_path_part_two ].should == 'request'
    
  end

  ##################################
	#  matched_look_ahead_fragment!  #
	##################################
  
  it 'can declare match for a fragment that is not anchored to the left side of path part' do
    
    request_path = ::Magnets::Path::RequestPath.new( '/some/request/path/', @mock_path )
    
    stack = request_path.instance_variable_get( :@stack )
    
    request_path.matched_part!
    request_path.matched_part!
    
    request_path.declare_current_frame_has_fragments!
    
    stack.count.should == 1
    stack[0].current_index.should == 2
    stack[0].current_definition_index.should == 2
    stack[0].fragment_stack[0].current_slice_index.should == 0
    stack[0].fragment_stack[0].current_definition_index.should == 0
    stack[0].fragment_stack[0].matched_for_index.should == nil
    stack[0].fragment_stack[0].matched_for_definition.should == nil
    stack[0].matched_for_index[0].should == @mock_path_part_one
    stack[0].matched_for_definition[ @mock_path_part_one ].should == 'some'
    stack[0].matched_for_index[1].should == @mock_path_part_two
    stack[0].matched_for_definition[ @mock_path_part_two ].should == 'request'
    
    # mock advance in fragment number from look-ahead
    request_path.instance_eval do
      current_fragment_frame.current_definition_index = 1
    end
    request_path.matched_look_ahead_fragment!( 2, 1 )

    stack.count.should == 1
    stack[0].current_index.should == 2
    stack[0].current_definition_index.should == 2
    # slice get changed back
    stack[0].fragment_stack[0].current_slice_index.should == 0
    # definition does not
    stack[0].fragment_stack[0].current_definition_index.should == 2
    stack[0].fragment_stack[0].matched_for_index[1].should == @mock_path_part_three_fragment_two
    stack[0].fragment_stack[0].matched_for_definition[ @mock_path_part_three_fragment_two ].should == 't'
    stack[0].matched_for_index[0].should == @mock_path_part_one
    stack[0].matched_for_definition[ @mock_path_part_one ].should == 'some'
    stack[0].matched_for_index[1].should == @mock_path_part_two
    stack[0].matched_for_definition[ @mock_path_part_two ].should == 'request'
    
  end

  ##################################
	#  look_ahead_fragment_match  #
	##################################
	
  it 'can attempt to match a fragment that is not anchored to the left side of path part' do
    
    request_path = ::Magnets::Path::RequestPath.new( '/some/request/path/', @mock_path )
    
    stack = request_path.instance_variable_get( :@stack )
    
    request_path.matched_part!
    request_path.matched_part!
    
    request_path.declare_current_frame_has_fragments!
    
    stack.count.should == 1
    stack[0].current_index.should == 2
    stack[0].current_definition_index.should == 2
    stack[0].fragment_stack[0].current_slice_index.should == 0
    stack[0].fragment_stack[0].current_definition_index.should == 0
    stack[0].fragment_stack[0].matched_for_index.should == nil
    stack[0].fragment_stack[0].matched_for_definition.should == nil
    stack[0].matched_for_index[0].should == @mock_path_part_one
    stack[0].matched_for_definition[ @mock_path_part_one ].should == 'some'
    stack[0].matched_for_index[1].should == @mock_path_part_two
    stack[0].matched_for_definition[ @mock_path_part_two ].should == 'request'
    
    request_path.look_ahead_fragment_match.should == 2
    
    stack.count.should == 1
    stack[0].current_index.should == 2
    stack[0].current_definition_index.should == 2
    # slice get changed back
    stack[0].fragment_stack[0].current_slice_index.should == 0
    # so does definition
    stack[0].fragment_stack[0].current_definition_index.should == 0
    stack[0].fragment_stack[0].matched_for_index[1].should == @mock_path_part_three_fragment_two
    stack[0].fragment_stack[0].matched_for_definition[ @mock_path_part_three_fragment_two ].should == 't'
    stack[0].matched_for_index[0].should == @mock_path_part_one
    stack[0].matched_for_definition[ @mock_path_part_one ].should == 'some'
    stack[0].matched_for_index[1].should == @mock_path_part_two
    stack[0].matched_for_definition[ @mock_path_part_two ].should == 'request'
    
  end

end
