note
	description: "[
		Representation of a {VA_NANP_NPA} Area-code item.
		]"

class
	VA_NANP_NPA

inherit
	VA_NANP_HELPER
		rename
			set_item as set_area_code
		redefine
			default_create,
			compute_post_validation_message,
			Default_rules_capacity
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
		ensure then
			rules_count: rules.count = Default_rules_capacity
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

				-- Publish the message if we have any message ...
			if not l_message.is_empty then
				post_validation_message := l_message
			end
		end

feature {NONE} -- Implementation: NPA: Area Code Rules

	is_NPA_digit_1_valid (a_item: like item): BOOLEAN
			-- Allowed ranges: [2–9] for the first digit
		do
			Result := internal_use_only_is_default_length and then
						Digits_2_to_9.has (a_item [NPA_1].out.to_integer)
		end

	is_NPA_digits_2_3_valid (a_item: like item): BOOLEAN
			-- Allowed ranges: [0-9] for the second and third digits.
		do
			Result := internal_use_only_is_default_length and then
						(Digits_0_to_9.has (a_item [NPA_2].out.to_integer) and
						Digits_0_to_9.has (a_item [NPA_3].out.to_integer))
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
			Result := internal_use_only_is_default_length and then
						a_item [NPA_2] /= '9'
		end

	is_NPA_not_n11 (a_item: like item): BOOLEAN
			-- N11: These 8 ERCs, called service codes, are not used as area codes.
		note
			EIS: "src=https://www.nationalnanpa.com/area_codes/index.html"
		do
			Result := internal_use_only_is_default_length and then
						(a_item [NPA_2] /= '1' and a_item [NPA_3] /= '1')
		end

feature {NONE} -- Implementation: Constants

		-- Area code digit constants
	NPA_1: INTEGER = 1
	NPA_2: INTEGER = 2
	NPA_3: INTEGER = 3

	Default_rules_capacity: INTEGER
			-- <Precursor>
		do
			Result := 4
		end

end
