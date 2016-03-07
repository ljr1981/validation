note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	testing: "type/manual"

class
	VA_NANP_NPA_NXX_SUBSCRIBER_TEST_SET

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

	nanp_subscriber_tests
		local
			l_subscriber: VA_NANP_SUBSCRIBER
			l_number: STRING
			l_pass,
			l_fail: INTEGER
		do
			create l_subscriber
			across
				0 |..| 9_999 as ic
			from
				l_pass := 0
				l_fail := 0
			loop
				l_number := ic.item.out
				l_number.append (create {STRING}.make_filled ('0', 4 - l_number.count))
				l_subscriber.set_subscriber_number (l_number)
				if l_subscriber.is_valid then
					l_pass := l_pass + 1
				else
					l_fail := l_fail + 1
				end
			end
			assert_integers_equal ("npa_total_pass_fail", 10_000, l_pass + l_fail)
			assert_integers_equal ("npa_fail_count_all", 0, l_fail)
			assert_integers_equal ("npa_pass_count_all", 10_000, l_pass)
		end

	nanp_nxx_tests
			-- `nanp_npa_tests'
		note
			testing:  "execution/isolated"
		local
			l_nxx:VA_NANP_NXX
			l_pass,
			l_fail: INTEGER
		do
			create l_nxx
			assert ("invalid", not l_nxx.is_valid)
			l_nxx.set_exchange ("202")
			assert ("invalid", l_nxx.is_valid)
			across
				(0 |..| 9) as ic
			from
				l_pass := 0
				l_fail := 0
			loop
				l_nxx.set_exchange (ic.item.out + "70")
				if l_nxx.is_valid then
					l_pass := l_pass + 1
				else
					l_fail := l_fail + 1
				end
			end
			assert_integers_equal ("nxx_pass_count_1", 8, l_pass)
			assert_integers_equal ("nxx_fail_count_1", 2, l_fail)

				-- Digit 2
			across
				(0 |..| 9) as ic
			from
				l_pass := 0
				l_fail := 0
			loop
				l_nxx.set_exchange ("2" + ic.item.out + "2")
				if l_nxx.is_valid then
					l_pass := l_pass + 1
				else
					l_fail := l_fail + 1
				end
			end
			assert_integers_equal ("nxx_pass_count_2", 9, l_pass)
			assert_integers_equal ("nxx_fail_count_2", 1, l_fail)

				-- Digit 3
			across
				(0 |..| 9) as ic
			from
				l_pass := 0
				l_fail := 0
			loop
				l_nxx.set_exchange ("20" + ic.item.out)
				if l_nxx.is_valid then
					l_pass := l_pass + 1
				else
					l_fail := l_fail + 1
				end
			end
			assert_integers_equal ("nxx_pass_count_3", 9, l_pass)
			assert_integers_equal ("nxx_fail_count_3", 1, l_fail)

			across
				(0 |..| 9) as ic_1
			from
				l_pass := 0
				l_fail := 0
			loop
				across
					(0 |..| 9) as ic_2
				loop
					across
						(0 |..| 9) as ic_3
					loop
						l_nxx.set_exchange (ic_1.item.out + ic_2.item.out + ic_3.item.out)
						if l_nxx.is_valid then
							l_pass := l_pass + 1
						else
							l_fail := l_fail + 1
						end
					end
				end
			end
			assert_integers_equal ("nxx_pass_count_all", 648, l_pass)
			assert_integers_equal ("nxx_fail_count_all", 352, l_fail)
			assert_integers_equal ("nxx_total_pass_fail", 1_000, l_pass + l_fail)
		end

	nanp_npa_tests
			-- `nanp_npa_tests'
		note
			testing:  "execution/isolated"
		local
			l_npa:VA_NANP_NPA
			l_pass,
			l_fail: INTEGER
		do
			create l_npa
			assert ("invalid", not l_npa.is_valid)
			l_npa.set_area_code ("202")
			assert ("invalid", l_npa.is_valid)
			across
				(0 |..| 9) as ic
			from
				l_pass := 0
				l_fail := 0
			loop
				l_npa.set_area_code (ic.item.out + "02")
				if l_npa.is_valid then
					l_pass := l_pass + 1
				else
					l_fail := l_fail + 1
				end
			end
			assert_integers_equal ("npa_pass_count", 8, l_pass)
			assert_integers_equal ("npa_fail_count", 2, l_fail)

				-- Digit 2
			across
				(0 |..| 9) as ic
			from
				l_pass := 0
				l_fail := 0
			loop
				l_npa.set_area_code ("2" + ic.item.out + "2")
				if l_npa.is_valid then
					l_pass := l_pass + 1
				else
					l_fail := l_fail + 1
				end
			end
			assert_integers_equal ("npa_pass_count_2", 8, l_pass)
			assert_integers_equal ("npa_fail_count_2", 2, l_fail)

				-- Digit 3
			across
				(0 |..| 9) as ic
			from
				l_pass := 0
				l_fail := 0
			loop
				l_npa.set_area_code ("20" + ic.item.out)
				if l_npa.is_valid then
					l_pass := l_pass + 1
				else
					l_fail := l_fail + 1
				end
			end
			assert_integers_equal ("npa_pass_count_3", 9, l_pass)
			assert_integers_equal ("npa_fail_count_3", 1, l_fail)

			across
				(0 |..| 9) as ic_1
			from
				l_pass := 0
				l_fail := 0
			loop
				across
					(0 |..| 9) as ic_2
				loop
					across
						(0 |..| 9) as ic_3
					loop
						l_npa.set_area_code (ic_1.item.out + ic_2.item.out + ic_3.item.out)
						if l_npa.is_valid then
							l_pass := l_pass + 1
						else
							l_fail := l_fail + 1
						end
					end
				end
			end
			assert_integers_equal ("npa_pass_count_all", 576, l_pass)
			assert_integers_equal ("npa_fail_count_all", 424, l_fail)
			assert_integers_equal ("npa_total_pass_fail", 1_000, l_pass + l_fail)
		end

end


