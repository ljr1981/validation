note
	description: "[
		Representation of a {VA_EV_TEXT_COMPONENT_VALIDATOR}.
		]"

class
	VA_EV_TEXT_COMPONENT_VALIDATOR [G -> VA_ITEM]

create
	make

feature {NONE} -- Initialization

	make (a_widget: like widget; a_item: like item)
			-- `make' with `a_widget' text component and validation `a_item'.
		do
			create validator.make_with_machine (create {VA_MACHINE})
			widget := a_widget
			item := a_item

			on_validation
			widget.focus_in_actions.extend (agent on_validation)
			widget.focus_out_actions.extend (agent on_validation)
			widget.change_actions.extend (agent on_validation)
		end

feature {NONE} -- Implementation

	widget: EV_TEXT_COMPONENT
			-- {EV_TEXT_COMPONENT} `widget' of Current {VA_EV_TEXT_COMPONENT_VALIDATOR}.

	item: G
			-- `item' being validated.

	validator: VA_VALIDATOR
			-- `validator' of `item' in `widget' of Current {VA_EV_TEXT_COMPONENT_VALIDATOR}.

	on_validation
			-- `on_validation' set new `item' value from `widget' text and start `validator'.
			-- Colorize based on outcome.
		do
			item.set_item (widget.text.out)
			validator.validate.start ([item])
			if validator.is_invalid then
				widget.set_foreground_color (create {EV_COLOR}.make_with_rgb (1.0, 0, 0))
			else
				widget.set_foreground_color (create {EV_COLOR}.make_with_rgb (0, 0, 1.0))
			end
		end

end
