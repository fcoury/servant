# ServantDelegate.rb
# Servant
#
# Created by Felipe Coury on 3/12/10.
# Copyright 2010 FelipeCoury.com. All rights reserved.


class ServantDelegate
	def applicationDidFinishLaunching(notification)
		NSLog "Notification: #{notification.inspect}"
	end

	def textDidChange(notification)
		NSLog "Notification: #{notification.inspect}"
	end
end