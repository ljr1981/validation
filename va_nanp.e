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
		redefine
			default_create,
			item
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
