# ServantController.rb
# Servant
#
# Created by Felipe Coury on 3/12/10.
# Copyright 2010 FelipeCoury.com. All rights reserved.

class ServantController < NSWindowController
	# text input
	attr_accessor :input
	
	# confirmation label
	attr_accessor :label
	
	# table view
	attr_accessor :table_view
	
	# server list
	attr_accessor :servers
	
	# delegate methods
	
	def initialize
		@servers = {}
		@server_list = {}
	end
	
	def applicationDidFinishLaunching(notification)
		NSLog "Notification: #{notification.inspect}"
	end

	def textDidChange(notification)
		NSLog "Notification: #{notification.inspect}"
	end
	
	def awakeFromNib
		@servers = {}
		@server_list = {}

		category = "No Category"
		files = File.open("#{ENV['HOME']}/.servers").readlines
		files.each do |line|
			if line =~ /^-- (.*)$/
				category = $1
			else
				command, name = line.split(',')
				@server_list[name] = { :category => category, :name => name, :command => command }
			end
		end
		
		@servers = @server_list
		NSLog "Populated @server_list = #{@server_list.inspect}"
	end
	
	def button_clicked(sender)
		selected = filter_and_rank_by(@server_list.keys, @input.stringValue).compact
		NSLog "Selected servers by rank: #{selected.inspect}"
		
		if selected and name = selected.first
			NSLog "Name: #{name.inspect}"
			server = @server_list[name]
			NSLog "Selected server (for label): #{selected.inspect}"
			
			@label.stringValue = "#{server[:category]} > #{server[:name]}"
			@servers = @server_list.select { |s| NSLog "Server: #{s.inspect} => #{selected.include?(s)}"; selected.include? s }
			NSLog "@servers => #{@servers.inspect}"
		else
			@label.stringValue = "--- No Match ---"
			@servers = {}
		end
		
		table_view.reloadData
	end
	
	def textDidChange(notification)
		puts notification.inspect
	end
	
	private

	# Helper method for fuzzily filtering a list
	#
	# @param [Array<A>]     list        the list to filter
	# @param [String]       query       the fuzzy string to match on
	# @param [Integer]      max_length  the length of the resulting list (default 20)
	# @block A -> String    turns an element from the list into a string to match on
	def filter_and_rank_by(list, query, max_length=20)
		re = make_regex(query)
		score_match_pairs = []
		cutoff = 100000000
		results = list.each do |element|
			if block_given?
				bit = yield(element) 
			else
				bit = element
			end
			
			if m = bit.match(re)
				cs = []
				m.captures.each_with_index do |_, i|
					prev = cs.last
					if prev and m.begin(i + 1) == prev[0] - prev[1]
						cs.last[1] -= 1
					else
						cs << [m.begin(i + 1), m.begin(i + 1) - m.end(i + 1)]
					end
				end

				if cs.first.first < cutoff
					score_match_pairs << [cs, element]
					score_match_pairs = score_match_pairs.sort_by {|a| a.first }
					if score_match_pairs.length == max_length
						cutoff = score_match_pairs.last.first.first.first
						score_match_pairs.pop
					end
				end
			end
		end

		puts score_match_pairs.inspect
		score_match_pairs.map {|a| a.last }
	end

	def make_regex(text)
		re_src = "(" + text.split(//).map{|l| Regexp.escape(l) }.join(").*?(") + ")"
		Regexp.new(re_src, :options => Regexp::IGNORECASE)
	end
end