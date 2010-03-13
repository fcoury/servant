# ServerInputDelegate.rb
# Servant
#
# Created by Felipe Coury on 3/12/10.
# Copyright 2010 FelipeCoury.com. All rights reserved.

class ServerInputTextField < NSTextField
	attr_accessor :parent

	def textDidChange(notification)
		parent.filter
	end
end