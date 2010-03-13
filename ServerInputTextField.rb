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
	
	def textView(textview, doCommandBySelector: selector)
		table = parent.table_view
		
    case selector
    when :"moveUp:"
			nextRow = table.selectedRow - 1	

    when :"moveDown:"
			nextRow = table.selectedRow + 1	

    else
      return
    end
		
		if nextRow >= table.numberOfRows
			nextRow = 0
		elsif nextRow < 0
			nextRow = table.numberOfRows - 1
		end
		
		# selects the row and makes it visible
		rowIndex = NSIndexSet.indexSetWithIndex(nextRow)
		table.selectRowIndexes rowIndex, byExtendingSelection:false
		table.scrollRowToVisible nextRow
		
		# sets the text to the name of the server
		key = parent.servers.keys[nextRow]
		parent.input.stringValue = parent.servers[key][:name]
  end

end