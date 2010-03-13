# TableDelegate.rb
# Servant
#
# Created by Felipe Coury on 3/12/10.
# Copyright 2010 FelipeCoury.com. All rights reserved.


class TableDelegate
	attr_accessor :parent
	
	def numberOfRowsInTableView(tableView)
		parent.servers.keys.count
	end
	
	def tableView(tableView, objectValueForTableColumn:column, row:row)
		if row <= parent.servers.keys.length - 1
			key = parent.servers.keys[row]
			return parent.servers[key][column.identifier.to_sym]
		end
		nil
	end
end