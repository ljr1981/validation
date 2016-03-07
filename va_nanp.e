note
	description: "[
		Representation of a {VA_NANP} U.S. Phone Number {VA_ITEM}.
		]"
	design: "[
		North American phone numbers (including the U.S. system) are based
		on a specification, which has grown in detail with technologies over
		the last 100+ years. This class represents a validation item that
		attempts to comprehensively cover all of the meaningful rules
		governing the validation of arbitrary phone numbers supplied to it.
		]"
	example: "[
		Given: A {VA_VALIDATOR} with a {VA_MACHINE}, create a {VA_ITEM} and
		assign it a "phone-number" (usually 10 digits). Once assigned, call
		for the validator to validate.start ([item]) to prove if the item
		is or is not a valid phone number. If not, then call the compute
		post-validation message feature to discover a human-readable message
		detailing what the validator found wrong with the phone number item.
		]"
	define: "NANP", "[
				North American Numbering Plan. The NANP number format may be 
				summarized in the notation NPA-NXX-xxxx
				
				Where:
					
					NPA = Area-code
					NXX = Central office (exchange) code
					XXXX = Subscriber number
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
			compute_post_validation_message,
			Default_rules_capacity,
			set_phone_number
		end

feature {NONE} -- Initialization

	default_create
			-- <Precursor>
		do
			Precursor
			create area_code
			create exchange_code
			create subscriber_number

			rules.extend (agent is_default_digits_long)
			rules.extend (agent area_code.is_valid)
			rules.extend (agent exchange_code.is_valid)
			rules.extend (agent subscriber_number.is_valid)
		ensure then
			rules_count: rules.count = Default_rules_capacity
		end

feature -- Access

	item: STRING
			-- <Precursor>
			-- NPA-NXX-xxxx (without "-" characters)
		attribute
			create Result.make (default_number_capacity)
		end

	area_code: VA_NANP_NPA

	exchange_code: VA_NANP_NXX

	subscriber_number: VA_NANP_SUBSCRIBER

feature -- Settings

	set_phone_number (a_number: like item)
			-- `set_phone_number' with `a_number'.
		do
			item := a_number
			if a_number.count >= area_code_stop then
				area_code.set_area_code (a_number.substring (area_code_start, area_code_stop))
			end
			if a_number.count >= exchange_stop then
				exchange_code.set_exchange (a_number.substring (exchange_start, exchange_stop))
			end
			if a_number.count = subscriber_stop then
				subscriber_number.set_subscriber_number (a_number.substring (subscriber_start, subscriber_stop))
			end
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
					-- Build NPA messages (as-needed) ...
				if not area_code.is_valid then
					area_code.compute_post_validation_message
					if attached area_code.post_validation_message as al_message then
						l_message.append_string (al_message)
					end
				end

					-- Build NXX messages (as-needed) ...
				if not exchange_code.is_valid then
					exchange_code.compute_post_validation_message
					if attached exchange_code.post_validation_message as al_message then
						l_message.append_string (al_message)
					end
				end
			end

				-- Publish the message if we have any message ...
			if not l_message.is_empty then
				post_validation_message := l_message
			end
		ensure then
			consistent: attached post_validation_message implies not is_valid
		end

feature {NONE} -- Implementation: General Rules

	is_default_digits_long (a_item: like item): BOOLEAN
			-- `is_default_digits_long' (see `default_number_capacity')?
		do
			Result := item.count = default_number_capacity
		end

	internal_use_only_is_default_length: BOOLEAN
			-- `internal_use_only_is_default_length'?
		do
			Result := is_default_digits_long (item)
		end

feature {NONE} -- Implementation: Constants

	default_number_capacity: INTEGER = 10
			-- `default_number_capacity' for Current {VA_NANP} Number.

	Default_rules_capacity: INTEGER = 4
			-- <Precursor>

	area_code_start: INTEGER = 1
	area_code_stop: INTEGER = 3
	exchange_start: INTEGER = 4
	exchange_stop: INTEGER = 6
	subscriber_start: INTEGER = 7
	subscriber_stop: INTEGER = 10

end
