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

	nanp_random_tests
			-- `nanp_random_tests'
		local
			l_nanp: VA_NANP
			l_validator: VA_VALIDATOR
			l_start,
			l_stop,
			l_skip: INTEGER
		do
			create l_validator.make_with_machine (create {VA_MACHINE})
			create l_nanp

				-- Test "phone numbers" in an invalid range ...
				-- (about 10-20K instances of a "bad number")
			l_start := randomizer.random_integer_in_range (1 |..| 100)
			l_stop := 9_999_999
			l_skip := randomizer.random_integer_in_range (500 |..| 1_000)
			across
				(l_start |..| l_stop).new_cursor + l_skip as ic
			loop
				l_nanp.set_phone_number (ic.item.out)

				l_validator.validate.start ([l_nanp])
				assert ("none_valid", l_validator.is_invalid)

				l_nanp.compute_post_validation_message
				assert ("has_message", attached l_nanp.post_validation_message)
			end
		end

	nanp_creation_and_basic_tests
			-- `nanp_creation_and_basic_tests'
		local
			l_nanp: VA_NANP
			l_validator: VA_VALIDATOR
		do
			create l_validator.make_with_machine (create {VA_MACHINE})
			create l_nanp
			l_nanp.set_phone_number ("7702951111")

			l_validator.validate.start ([l_nanp])
			assert ("valid_number_at_first", l_validator.is_valid)

			l_nanp.set_phone_number ("0902951111")

				-- Test the computed post-validation message ...
			l_validator.validate.start ([l_nanp])
			assert ("invalid", l_validator.is_invalid)
			l_nanp.compute_post_validation_message
			check has_message: attached l_nanp.post_validation_message as al_message then
				assert_strings_equal ("valid_message", expected_message_1, al_message)
			end

				-- Test bad number length (too short) ...
			l_nanp.set_phone_number ("1234")
			l_validator.validate.start ([l_nanp])
			assert ("invalid", l_validator.is_invalid)
			l_nanp.compute_post_validation_message
			check has_message: attached l_nanp.post_validation_message as al_message then
				assert_strings_equal ("valid_message", expected_message_2, al_message)
			end
		end

feature {NONE} -- Implementation: Support

	expected_message_1: STRING = "[
First digit must be [2-9].
2nd digit cannot be a [9].

]"

	expected_message_2: STRING = "[
Number must be 10 digits long.
First digit must be [2-9].
2nd/3rd digits must be [0-9].
2nd digit cannot be a [9].
2nd/3rd digits cannot be N11.
First Area-code digit must be [2-9].
2nd/3rd Area-code digits must be [0-9].
2nd/3rd Area-code digits must not be N11.
Last-four must be [0000-9999].

]"

feature {NONE} -- Implementation: Support

	randomizer: RANDOMIZER
			-- `randomizer' for Current test set.
		once
			create Result
		end

end


