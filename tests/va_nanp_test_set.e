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

			l_nanp.set_phone_number ("0902951111")

				-- Test the computed post-validation message ...
			l_validator.validate.start ([l_nanp])
			assert ("invalid", l_validator.is_invalid)
			l_nanp.compute_post_validation_message
			check has_message: attached l_nanp.post_validation_message as al_message then
				assert_strings_equal ("valid_message", expected_message_1, al_message)
			end

				-- Test bad number length ...
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



end


