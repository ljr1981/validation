note
	description: "[
		Representation of a {VA_NANP_NXX} Exchange or Central Office
		]"

class
	VA_NANP_NXX

inherit
	VA_NANP_HELPER
		rename
			set_item as set_exchange
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
				-- Central office rules
			rules.extend (agent is_NXX_digit_1_2_to_9)
			rules.extend (agent is_NXX_digits_2_3_valid)
			rules.extend (agent is_NXX_not_N11)
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

				-- General rules messages (as-needed) ...
			if not internal_use_only_is_default_length then
				l_message.append ("Number must be " + default_number_capacity.out + " digits long.%N")
			else
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
			end

				-- Publish the message if we have any message ...
			if not l_message.is_empty then
				post_validation_message := l_message
			end
		ensure then
			consistent: attached post_validation_message implies not is_valid
		end

feature {NONE} -- Implementation: NXX: Central Office (exchange) code Rules

	is_NXX_digit_1_2_to_9 (a_item: like item): BOOLEAN
			-- Allowed ranges: [2–9] for the first digit
		do
			Result := internal_use_only_is_default_length and then
						Digits_2_to_9.has (a_item [NXX_1].out.to_integer)
		end

	is_NXX_digits_2_3_valid (a_item: like item): BOOLEAN
			-- Allowed ranges: [0-9] for the second and third digits.
		do
			Result := internal_use_only_is_default_length and then
						(Digits_0_to_9.has (a_item [NXX_2].out.to_integer) and
						Digits_0_to_9.has (a_item [NXX_3].out.to_integer))
		end

	is_NXX_not_n11 (a_item: like item): BOOLEAN
			-- N11: in geographic area codes the third digit of the
			--		exchange cannot be 1 if the second digit is also 1
		note
			EIS: "src=https://www.nationalnanpa.com/area_codes/index.html"
		do
			Result := internal_use_only_is_default_length and then
						(a_item [NXX_2] /= '1' and a_item [NXX_3] /= '1')
		end

feature {NONE} -- Implementation: Constants

		-- Central office digit constants
	NXX_1: INTEGER = 1
	NXX_2: INTEGER = 2
	NXX_3: INTEGER = 3

	Default_rules_capacity: INTEGER = 3
			-- <Precursor>

end
