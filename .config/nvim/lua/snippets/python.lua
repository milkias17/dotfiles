return {
	s(
		"ptf",
		fmt("async def {}(update: Update, context: {}):\n\t{}", {
			i(1),
			c(2, {
				t("ContextTypes.DEFAULT_TYPE"),
				t("CallbackContext"),
			}),
			i(0),
		})
	),
}
