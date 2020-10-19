

	klass = Class.new(ActiveRecord::Base) do |c|
	  c.table_name = 'events'
	end
	Object.const_set('Event', klass)

