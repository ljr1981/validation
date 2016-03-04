note
	description: "[
		Abstract notion of a {VA_VALIDATOR}.
		]"
	design: "[
		A {VA_VALIDATOR} is a validator of {VA_ITEM} objects.
		The item objects have their items with their rules.
		The purpose of this class is to provide a means of having
		a single validator, which validates one-or-more items.
		
		For the {VA_VALIDATOR} to work, all it needs is a
		{SM_MACHINE} (aka VA_MACHINE) and a set of {VA_ITEM}s.
		
		A call like the following example will validate an item:
		
			l_validator.validate.start ([l_item])
		
		The only requirement before making this call is to create
		the `l_validator' with a state machine and then create the
		`l_item' {VA_ITEM} objects (one or more) and give them
		(as needed) to the `validate.start'.
		
		You may then pick-up your validation results in the
		`is_valid' or `is_invalid' queries.
		]"

class
	VA_VALIDATOR

inherit
	SM_OBJECT

create
	make_with_machine

feature {NONE} -- Initialization: FSM

	pre_make_initialization
			-- <Precursor>
		do
			create validate
		end

	initialize_state_assertions (a_machine: SM_MACHINE)
			-- <Precursor>
		do
			a_machine.add_state ([<<agent is_valid>>])
			a_machine.add_state ([<<agent is_invalid>>])
		end

	initialize_transition_operations (a_machine: SM_MACHINE)
			-- <Precursor>
		do
			a_machine.add_transitions (<<		-- From		To			set on-Trigger					do Transition ops		Post-trans ops
					create {SM_TRANSITION}.make (valid, 	invalid, 	agent validate.set, 			<<agent set_validate>>, 	<<>>),
					create {SM_TRANSITION}.make (invalid, 	valid, 		agent validate.set, 			<<agent set_validate>>, 	<<>>)
										>>)
		end

feature -- Transition Operations

	set_validate (a_validation: TUPLE [item_rules: VA_ITEM])
			-- `set_validate' of `a_validation' to Result of `is_valid' or `is_invalid'.
		do
			is_valid := a_validation.item_rules.is_valid
		end

feature -- State Assertions

	is_valid: BOOLEAN

	is_invalid: BOOLEAN
			-- `is_invalid' is not `is_valid'
		do
			Result := not is_valid
		end

feature -- Transition Triggers

	validate: SM_TRIGGER

feature {NONE} -- Implementation: Constants

	valid: INTEGER = 1
	invalid: INTEGER = 2
	validate_it: BOOLEAN = True
	invalidate_it: BOOLEAN = False

invariant
	consistent: is_valid /= is_invalid

end
