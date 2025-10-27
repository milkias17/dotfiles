return {

	s("kitComp", fmt('<script lang="ts">\n{}\n</script>\n\n{}', { i(0), i(1) })),
	s("kitLayout", fmt("<script>\n\t{}\n</script>\n\n<main>\n\t<slot/>\n</main>\n\n", { i(0) })),

	s("kitEach", fmt("{{#each {1} as {2} }}\n\t{3}\n{{/each}}", { i(1, "array"), i(2, "element"), i(3, "") })),

	s("kitIf", fmt("{{#if {1} }}\n\t{2}\n{{/if}}", { i(1, "condition"), i(2, "") })),

	s(
		"kitAwait",
		fmt("{{#await {1} }}\n\t{2}\n{{:then {3} }}\n\t{4}\n{{:catch {5} }}\n\t{6}\n{{/await}}", {
			i(1, "expression"),
			i(2, ""), -- pending block
			i(3, "value"),
			i(4, ""), -- then block
			i(5, "error"),
			i(6, ""), -- catch block
		})
	),

	s("kitKey", fmt("{{#key {1} }}\n\t{2}\n{{/key}}", { i(1, "expression"), i(2, "") })),

	s("kitTitle", fmt("<svelte:head>\n\t<title>{1}</title>\n</svelte:head>", { i(1, "TM_FILENAME_BASE") })),
}
