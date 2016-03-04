note
	description: "[
		Representation of a {VA_ITEM}.
		]"
	design: "[
		A validation item--that is--an item which has its
		rules which can be validated by a {VA_VALIDATOR}.
		
		Give special attention to: 
			
			function_agent_anchor: detachable PREDICATE [ANY, TUPLE]
		
		The PREDICATE class is especially designed for the notion of
		BOOLEAN query agents held in a list and then checked either
		one-by-one or together as a group Result (which is what happens
		here in this class).
		]"

class
	VA_ITEM

feature -- Access

	item: detachable ANY

	rules: ARRAYED_LIST [attached like function_agent_anchor]
			-- `rules' of Current {VA_ITEM}.
		attribute
			create Result.make (10)
		end

feature -- Status Report

	is_valid: BOOLEAN
			-- `is_valid' Current?
		do
			check has_rules: attached rules as al_rules then
				Result := across
					al_rules as ic_rules
				all
					ic_rules.item ([item])
				end
			end
		end

feature -- Settings

	set_item (a_item: attached like item)
			-- `set_item' with `a_item'.
		do
			item := a_item
		ensure
			set: item ~ a_item
		end

	add_rule (a_rule: attached like function_agent_anchor)
		do
			check has_rules: attached rules as al_rules then
				al_rules.extend (a_rule)
			end
		end

feature {NONE} -- Implementation: Constants

	function_agent_anchor: detachable PREDICATE [ANY, TUPLE]

end
