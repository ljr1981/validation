note
	description: "[
		Representation of a {VA_NANP} U.S. Phone Number {VA_ITEM}.
		]"
	design: "[

		]"
	define: "NANP", "[
				North American Numbering Plan. The NANP number format may be 
				summarized in the notation NPA-NXX-xxxx
				]"
	EIS: "src=https://en.wikipedia.org/wiki/North_American_Numbering_Plan"

class
	VA_NANP

inherit
	VA_ITEM
		rename
			set_item as set_phone_number
		redefine
			default_create,
			item,
			compute_post_validation_message
		end

feature {NONE} -- Initialization

	default_create
			-- <Precursor>
		do
			Precursor
				-- NPA Rules (area code)
			rules.extend (agent is_NPA_digit_1_valid)
			rules.extend (agent is_NPA_digits_2_3_valid)
			rules.extend (agent is_NPA_not_n9x)
			rules.extend (agent is_NPA_not_n11)
				-- Central office rules
			rules.extend (agent is_NXX_digit_1_2_to_9)
			rules.extend (agent is_NXX_digits_2_3_valid)
			rules.extend (agent is_NXX_not_N11)
				-- Subscriber number rules
			rules.extend (agent is_subscriber_number_valid)
		end

feature -- Access

	item: STRING
			-- <Precursor>
			-- NPA-NXX-xxxx (without "-" characters)
		note
			design: "[
				NPA-NXX-xxxx (without "-" characters)
				]"
		attribute
			create Result.make (default_number_capacity)
		end

feature -- Basic Operations

	compute_post_validation_message
			-- <Precursor>
		local
			l_message: STRING
		do
			post_validation_message := Void
			create l_message.make_empty

				-- Build NPA messages (as-needed) ...
			if not is_npa_digit_1_valid (item) then
				l_message.append ("First digit must be [2-9].%N")
			end

			if not is_NPA_digits_2_3_valid (item) then
				l_message.append ("2nd/3rd digits must be [0-9].%N")
			end

			if not is_NPA_not_n9x (item) then
				l_message.append ("2nd digit cannot be a [9].%N")
			end

			if not is_npa_not_n11 (item) then
				l_message.append ("2nd/3rd digits cannot be N11.%N")
			end

				-- Build NXX messages (as-needed) ...
			if not is_nxx_digit_1_2_to_9 (item) then
				l_message.append ("First Area-code digit must be [2-9].%N")
			end

			if not is_nxx_digits_2_3_valid (item) then
				l_message.append ("2nd/3rd Area-code digits must be [0-9].%N")
			end

			if not is_nxx_not_n11 (item) then
				l_message.append ("2nd/3rd Area-code digits must not be N11.%N")
			end

				-- Build subscriber messages (as-needed) ...
			if not is_subscriber_number_valid (item) then
				l_message.append ("Last-four must be [0000-9999].%N")
			end

				-- Publish the message if we have any message ...
			if not l_message.is_empty then
				post_validation_message := l_message
			end
		ensure then
			consistent: attached post_validation_message implies not is_valid
		end

feature {NONE} -- Implementation: NPA: Area Code Rules

	is_NPA_digit_1_valid (a_item: like item): BOOLEAN
			-- Allowed ranges: [2–9] for the first digit
		do
			Result := Digits_2_to_9.has (a_item [NPA_1].out.to_integer)
		end

	is_NPA_digits_2_3_valid (a_item: like item): BOOLEAN
			-- Allowed ranges: [0-9] for the second and third digits.
		do
			Result := Digits_0_to_9.has (a_item [NPA_2].out.to_integer) and
						Digits_0_to_9.has (a_item [NPA_3].out.to_integer)
		end

	is_NPA_not_n9x (a_item: like item): BOOLEAN
			-- The NANP is not assigning area codes with 9 as the second digit.
		note
			specification: "[
				The 80 codes in this format, called expansion codes, 
				have been reserved for use during the period when the 
				current 10-digit NANP number format undergoes expansion.
				]"
			EIS: "src=https://www.nationalnanpa.com/area_codes/index.html"
		do
			Result := a_item [NPA_2] /= '9'
		end

	is_NPA_not_n11 (a_item: like item): BOOLEAN
			-- N11: These 8 ERCs, called service codes, are not used as area codes.
		note
			EIS: "src=https://www.nationalnanpa.com/area_codes/index.html"
		do
			Result := a_item [NPA_2] /= '1' and a_item [NPA_3] /= '1'
		end

feature {NONE} -- Implementation: NXX: Central Office (exchange) code Rules

	is_NXX_digit_1_2_to_9 (a_item: like item): BOOLEAN
			-- Allowed ranges: [2–9] for the first digit
		do
			Result := Digits_2_to_9.has (a_item [NXX_1].out.to_integer)
		end

	is_NXX_digits_2_3_valid (a_item: like item): BOOLEAN
			-- Allowed ranges: [0-9] for the second and third digits.
		do
			Result := Digits_0_to_9.has (a_item [NXX_2].out.to_integer) and
						Digits_0_to_9.has (a_item [NXX_3].out.to_integer)
		end

	is_NXX_not_n11 (a_item: like item): BOOLEAN
			-- N11: in geographic area codes the third digit of the
			--		exchange cannot be 1 if the second digit is also 1
		note
			EIS: "src=https://www.nationalnanpa.com/area_codes/index.html"
		do
			Result := a_item [NXX_2] /= '1' and a_item [NXX_3] /= '1'
		end

feature {NONE} -- Implementation: Subscriber number rules

	is_subscriber_number_valid (a_item: like item): BOOLEAN
			-- Allowed ranges: [0-9] for last 1-4 digits.
		do
			Result := Digits_0_to_9.has (a_item [SUB_1].out.to_integer) and
						Digits_0_to_9.has (a_item [SUB_2].out.to_integer) and
						Digits_0_to_9.has (a_item [SUB_3].out.to_integer) and
						Digits_0_to_9.has (a_item [SUB_4].out.to_integer)
		end

feature {NONE} -- Implementation: Constants

	default_number_capacity: INTEGER = 10

		-- Area code digit constants
	NPA_1: INTEGER = 1
	NPA_2: INTEGER = 2
	NPA_3: INTEGER = 3

		-- Central office digit constants
	NXX_1: INTEGER = 4
	NXX_2: INTEGER = 5
	NXX_3: INTEGER = 6

		-- Subscriber digit constants
	SUB_1: INTEGER = 7
	SUB_2: INTEGER = 8
	SUB_3: INTEGER = 9
	SUB_4: INTEGER = 10

	Digits_2_to_9: INTEGER_INTERVAL
			-- `Digits_2_to_9' for testing.
		once
			Result := (2 |..| 9)
		end

	Digits_0_to_9: INTEGER_INTERVAL
			-- `Digits_0_to_9' for testing.
		once
			Result := (0 |..| 9)
		end

invariant
	digit_count: item.count = 0 xor item.count = default_number_capacity

end
