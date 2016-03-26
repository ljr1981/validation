note
	description: "[
		Abstract Helper features for {VA_NANP_*} Descendents.
		]"

deferred class
	VA_NANP_HELPER

inherit
	VA_ITEM
		redefine
			item
		end

feature -- Access

	item: STRING
			-- <Precursor>
			-- NPA
		attribute
			create Result.make (default_number_capacity)
		end

feature {NONE} -- Implementation: General Rules

	is_default_digits_long (a_item: like item): BOOLEAN
			-- `is_default_digits_long' (see `default_number_capacity')?
		do
			Result := item.count = default_number_capacity
		end

	internal_use_only_is_default_length: BOOLEAN
			-- `internal_use_only_is_default_length'.
		do
			Result := is_default_digits_long (item)
		end

feature {NONE} -- Implementation: Constants

	Digits_2_to_9: INTEGER_INTERVAL
			-- `Digits_2_to_9' for testing.
		once
			Result := 2 |..| 9
		end

	Digits_0_to_9: INTEGER_INTERVAL
			-- `Digits_0_to_9' for testing.
		once
			Result := 0 |..| 9
		end

	Default_number_capacity: INTEGER
			-- `Default_number_capacity' for most.
		do
			Result := 3
		end

end
