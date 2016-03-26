note
	description: "[
		Representation of a {VA_ITEM}.
		]"
	design: "See notes at end of class."

class
	VA_ITEM

inherit
	VA_ANY

feature -- Access

	item: detachable ANY
			-- `item' of Current {VA_ITEM}.

	rules: ARRAYED_LIST [attached like function_agent_anchor]
			-- `rules' of Current {VA_ITEM}.
		attribute
			create Result.make (Default_rules_capacity)
		end

	post_validation_message: detachable STRING
			-- `post_validation_message' populated after validate.start on `item'.

feature -- Basic Operations

	compute_post_validation_message
			-- `compute_post_validation_message' (if any).
			-- Redefine in descendents as-needed ...
		do
			do_nothing -- Until redefinition ...
		end

feature -- Status Report

	is_valid: BOOLEAN
			-- `is_valid' Current {VA_ITEM} by the `rules'?
		do
			Result := across
							rules as ic_rules
						all
							ic_rules.item ([item])
						end
		end

feature -- Settings

	set_item (a_item: attached like item)
			-- `set_item' with `a_item' into `item'.
		do
			item := a_item
		ensure
			set: item ~ a_item
		end

	add_rule (a_rule: attached like function_agent_anchor)
			-- `add_rule' `a_rule' into `rules' of Current {VA_ITEM}.
		do
			rules.extend (a_rule)
		ensure
			extended: rules.has (a_rule)
		end

feature {NONE} -- Implementation: Constants

	function_agent_anchor: detachable PREDICATE [ANY, TUPLE]
			-- `function_agent_anchor' of Current {VA_ITEM}.

	Default_rules_capacity: INTEGER
			-- `Default_rules_capacity' of Current {VA_ITEM}.
		note
			design: "[
				Normally, we would make this a constant or just
				remove the "do .. end" (below). However, for type
				conformance rules about feature redefinition, we
				have this as a "do .. end", which can later be redefined
				to a constant in descendent classes without compiler
				complaint.
				]"
		do
			Result := 0
		end

note
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

end
