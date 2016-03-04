note
	description: "[
		Tests of the {VA_NANP} class.
		
		NANP = North American Numbering Plan
	]"
	testing: "type/manual"

class
	VA_NANP_TEST_SET

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

	nanp_tests
			-- `nanp_tests'
		local
			l_nanp: VA_NANP
			l_validator: VA_VALIDATOR
		do
			create l_validator.make_with_machine (create {VA_MACHINE})
			create l_nanp
			l_nanp.set_phone_number ("7702951111")

			l_validator.validate.start ([l_nanp])
			assert ("valid_number_at_first", l_validator.is_valid)
		end

end


