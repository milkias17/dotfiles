return {
	s(
		"ptf",
		fmt("async def {}(update: Update, ctx: {}):\n\t{}", {
			i(1),
			c(2, {
				t("Context"),
				t("ContextTypes.DEFAULT_TYPE"),
				t("CallbackContext"),
			}),
			i(0),
		})
	),
}
