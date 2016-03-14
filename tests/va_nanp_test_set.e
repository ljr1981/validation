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

	nanp_selective_tests
			-- `nanp_selective_tests'
		note
			design: "[
				The idea here is not well-developed or implemented! What is really needed
				and wanted is a test that will test each rule in turn over the entire range
				of valid/invalid phone numbers (e.g. 100_000_0000 |..| 999_999_9999).
				
				What we really want is:
				
				(1) Break the {VA_NANP} class into 3 supporting variants: VA_NANP_NPA, VA_NANP_NXX, VA_NANP_SUBSCRIBER
				(2) Test each supporting variant (e.g. NPA Area-code) for its rules. This means (for example)
					The NPA tests will stabilize digits 2 and 3, while spinning through digit 1 from [0-9].
					Each digit tested will be evaluated against its validation rule and an expectation of pass-fail
					applied.
				
				The {VA_NANP_SUBSCRIBER} will be the easiest of all, while the two former will be hardest.
				However, if (especially #2 above) the tests are applied properly, the need for testing all
				possible phone numbers will be taken out of the way as the testing of individual rules is sufficient.
				]"
		local
			l_nanp: VA_NANP
			l_validator: VA_VALIDATOR
			l_start,
			l_stop,
			l_skip,
			l_fail,
			l_pass,
			l_count: INTEGER_64
		do
--			create l_validator.make_with_machine (create {VA_MACHINE})
--			create l_nanp

--				-- Test "phone numbers" in an invalid range ...
--				-- (about 10-20K instances of a "bad number")
--			l_skip := randomizer.random_integer_in_range (1_000_000 |..| 5_000_000)
--			from
----				l_count := 0
----				l_fail := 0
----				l_pass := 0
--				l_start := 100_000_0000	-- This strange notation is possible due to stripping of the underscores.
--				l_stop := 999_999_9999
--			until
--				l_start > l_stop
--			loop
----				l_count := l_count + 1
--				l_nanp.set_phone_number (l_start.out)

--				l_validator.validate.start ([l_nanp])
--				assert ("none_valid", l_validator.is_invalid)
----				if l_validator.is_valid then
----					l_pass := l_pass + 1
----				else
----					l_fail := l_fail + 1
----				end

--				l_nanp.compute_post_validation_message
--				assert ("has_message", attached l_nanp.post_validation_message)

--				l_start := l_start + 1_000_000
--			end
--				-- With the introduced notion of "random-skip", the following tests are indeterminate
--				-- (i.e. having no definite or definable value).
----			assert_integers_equal ("pass", 0, l_pass.as_integer_32)
----			assert_integers_equal ("fail", 8889, l_fail.as_integer_32)
		end

	nanp_creation_and_basic_tests
			-- `nanp_creation_and_basic_tests'
		local
			l_item: VA_NANP
			l_validator: VA_VALIDATOR
			l_message: STRING
		do
			create l_validator.make_with_machine (create {VA_MACHINE})
			create l_item
			l_item.set_phone_number ("7702951111")

			l_validator.validate.start ([l_item])
			l_item.compute_post_validation_message
			if attached l_item.post_validation_message as al_message then
				l_message := al_message
			else
				l_message := "ought_to_pass"
			end
			assert (l_message, l_validator.is_valid)

			l_item.set_phone_number ("0902951111")

				-- Test the computed post-validation message ...
			l_validator.validate.start ([l_item])
			assert ("invalid", l_validator.is_invalid)
			l_item.compute_post_validation_message
			check has_message: attached l_item.post_validation_message as al_message then
				assert_strings_equal ("valid_message", expected_message_1, al_message)
			end

				-- Test bad number length (too short) ...
			l_item.set_phone_number ("1234")
			l_validator.validate.start ([l_item])
			assert ("invalid", l_validator.is_invalid)
			l_item.compute_post_validation_message
			check has_message: attached l_item.post_validation_message as al_message then
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

]"

feature {NONE} -- Implementation: Support

	randomizer: RANDOMIZER
			-- `randomizer' for Current test set.
		once
			create Result
		end

end


