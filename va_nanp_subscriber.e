note
	description: "[
		Representation of a {VA_NANP_SUBSCRIBER} number.
		]"

class
	VA_NANP_SUBSCRIBER

inherit
	VA_NANP_HELPER
		rename
			set_item as set_subscriber_number
		redefine
			default_create,
			compute_post_validation_message,
			Default_rules_capacity,
			Default_number_capacity
		end

feature {NONE} -- Initialization

	default_create
			-- <Precursor>
		do
			Precursor
				-- Subscriber number rules
			rules.extend (agent is_subscriber_number_valid)
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
					-- Build subscriber messages (as-needed) ...
				if not is_subscriber_number_valid (item) then
					l_message.append ("Last-four must be [0000-9999].%N")
				end
			end

				-- Publish the message if we have any message ...
			if not l_message.is_empty then
				post_validation_message := l_message
			end
		ensure then
			consistent: attached post_validation_message implies not is_valid
		end

feature {NONE} -- Implementation: Subscriber number rules

	is_subscriber_number_valid (a_item: like item): BOOLEAN
			-- Allowed ranges: [0-9] for last 1-4 digits.
		do
			Result := internal_use_only_is_default_length and then
						(Digits_0_to_9.has (a_item [SUB_1].out.to_integer) and
						Digits_0_to_9.has (a_item [SUB_2].out.to_integer) and
						Digits_0_to_9.has (a_item [SUB_3].out.to_integer) and
						Digits_0_to_9.has (a_item [SUB_4].out.to_integer))
		end

feature {NONE} -- Implementation: Constants

	Default_number_capacity: INTEGER
			-- `Default_number_capacity'.
		do
			Result := 4
		end

		-- Subscriber digit constants
	SUB_1: INTEGER = 1
	SUB_2: INTEGER = 2
	SUB_3: INTEGER = 3
	SUB_4: INTEGER = 4

	Default_rules_capacity: INTEGER = 1
			-- <Precursor>

end
