note
	description: "[
		Representation of a {VA_EV_CHECKABLE_LIST_VALIDATOR}.
		]"

class
	VA_EV_CHECKABLE_LIST_VALIDATOR [G -> VA_ITEM]

inherit
	VA_VALIDATOR

create
	make

feature {NONE} -- Initialization

	make (a_widget: like widget; a_item: like item)
			-- `make' with `a_widget' text component and validation `a_item'.
		do
			make_with_machine (create {VA_MACHINE})
			widget := a_widget
			item := a_item

			on_validation (Void)
			widget.check_actions.extend (agent on_check_validation)
			widget.uncheck_actions.extend (agent on_check_validation)
		end

feature {NONE} -- Implementation

	widget: EV_CHECKABLE_LIST
			-- {EV_CHECKABLE_LIST} `widget' of Current {VA_EV_TEXT_COMPONENT_VALIDATOR}.

	item: G
			-- `item' being validated.

	on_check_validation (a_item: EV_LIST_ITEM)
			-- `on_check_validation'.
		do
			on_validation (Void)
		end

	on_validation (a_item: detachable EV_LIST_ITEM)
			-- `on_validation' set new `item' value from `widget' text and start `validator'.
			-- Colorize based on outcome.
		do
			item.set_item (widget.checked_items)
			validate.start ([item])
			if is_invalid then
				widget.set_foreground_color (create {EV_COLOR}.make_with_rgb (1.0, 0, 0))
			else
				widget.set_foreground_color (create {EV_COLOR}.make_with_rgb (0, 0, 1.0))
			end
		end

end
