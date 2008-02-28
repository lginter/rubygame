#--
#	Rubygame -- Ruby code and bindings to SDL to facilitate game creation
#	Copyright (C) 2004-2008  John Croisant
#
#	This library is free software; you can redistribute it and/or
#	modify it under the terms of the GNU Lesser General Public
#	License as published by the Free Software Foundation; either
#	version 2.1 of the License, or (at your option) any later version.
#
#	This library is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#	Lesser General Public License for more details.
#
#	You should have received a copy of the GNU Lesser General Public
#	License along with this library; if not, write to the Free Software
#	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#++

require 'rubygame/event'

module Rubygame

	class CollisionHandler
		def initialize
			@collisions = {}
			@old = {}
			@outbox = []
		end
		
		def flush
			_check_old
			
			out = @outbox
			@outbox = []
			return out
		end
		
		def register( a, b, contacts )
			@collisions[ [a,b] ] = contacts
			
			if( @old[ [a,b] ] )
				@outbox << CollisionEvent.new( a, b, contacts )
			else
				@outbox << CollisionStartEvent.new( a, b, contacts )
			end
		end
		
		private
		
		def _check_old
			ended = @old.keys - @collisions.keys
			
			ended.each { |pair|
				a, b = pair
				@outbox << CollisionEndEvent.new( a, b, @old[ pair ] )
			}
			
			@old = @collisions
			@collisions = {}
		end
		
	end

end
