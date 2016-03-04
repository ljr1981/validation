note
	description: "[
		Tests of {VA_VALIDATOR}
		]"
	testing: "type/manual"

class
	VA_VALIDATOR_TEST_SET

inherit
	EQA_TEST_SET
		rename
			assert as assert_old
		end

	EQA_COMMONLY_USED_ASSERTIONS
		undefine
			default_create
		end

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
			l_item.add_rule (agent is_not_empty (?))
			l_item.add_rule (agent has_four_names (?))

				-- Now, start validating the `l_item'
			l_validator.validate.start ([l_item])
			assert ("is_now_valid", l_validator.is_valid)

				-- Again, empty the string and validate again ...
			l_item.set_item ("")
			l_validator.validate.start ([l_item])
			assert ("empty_is_invalid", l_validator.is_invalid)

				-- Finally, we will do a name without four names ...
			l_item.set_item ("one two three four")
			l_validator.validate.start ([l_item])
			assert ("four_is_valid", l_validator.is_valid)

			l_item.set_item ("one three four")
			l_validator.validate.start ([l_item])
			assert ("three_is_invalid", l_validator.is_invalid)
		end

feature {NONE} -- Implementation

	is_not_empty (a_string: STRING): BOOLEAN
			-- `a_string' `is_not_empty'?
		do
			Result := not a_string.is_empty
		end

	has_four_names (a_string: STRING): BOOLEAN
			-- `a_string' `has_four_names'?
		local
			l_list: LIST [STRING]
		do
			l_list := a_string.split (' ')
			Result := l_list.count = 4
		end

end


