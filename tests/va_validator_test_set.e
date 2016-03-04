note
	description: "[
		Tests of {VA_VALIDATOR}
		]"
	testing: "type/manual"

class
	VA_VALIDATOR_TEST_SET

inherit
	EQA_TEST_SET

feature -- Test routines

	validator_creation_tests
			-- `validator_creation_tests'
		local
			l_validator: VA_VALIDATOR
			l_item: VA_ITEM
		do
			create l_validator.make_with_machine (create {VA_MACHINE})
			assert ("start_at_invalid", l_validator.is_invalid)

				-- Bring in an item
			create l_item
			l_item.set_item ("First M Last Suffix")
			l_item.add_rule (agent not_empty)

				-- Now, start validating the `l_item'
			l_validator.validate.start ([l_item])
			assert ("is_now_valid", l_validator.is_valid)

				-- Again, empty the string and validate again ...
			l_item.set_item ("")
			l_validator.validate.start ([l_item])
			assert ("empty_is_invalid", l_validator.is_invalid)
		end

feature {NONE} -- Implementation

	not_empty (a_string: STRING): BOOLEAN
		do
			Result := not a_string.is_empty
		end

end


