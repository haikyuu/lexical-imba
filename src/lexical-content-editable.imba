tag lexical-content-editable
	ariaActiveDescendantID\string
	ariaAutoComplete\string
	ariaControls\string
	ariaDescribedBy\string
	ariaExpanded\boolean
	ariaLabel\string
	ariaLabelledBy\string
	ariaMultiline\boolean
	ariaOwneeID\string
	ariaRequired\string
	autoCapitalize\boolean
	autoComplete\boolean
	autoCorrect\boolean
	className\string
	id\string = ""
	readOnly\boolean
	role\string = 'textbox'
	spellCheck\boolean = true
	style\StyleSheetList
	tabIndex\number
	testid\string

	readonly? = true
	@observable editor = #context.editor
	
	def mount
		editor = #context.editor
	@autorun
	def read-only-listener
		return unless editor
		readonly? = editor.isReadOnly!
		editor.registerReadOnlyListener do 
			readonly? = $1
			imba.commit!
	@autorun
	def associate-content-editable-with-editor-instance
		return unless editor
		editor.setRootElement self
	def render
		<self
			aria-activedescendant=(readonly? ? null : ariaActiveDescendantID)
			aria-autocomplete=(readonly? ? null : ariaAutoComplete)
			aria-controls=(readonly? ? null : ariaControls)
			aria-describedby=(ariaDescribedBy)
			aria-expanded=(readonly? ? null : role === 'combobox' ? !!ariaExpanded : null)
			aria-label=ariaLabel
			aria-labelledby=ariaLabelledBy
			aria-multiline=ariaMultiline
			aria-owns=(readonly? ? null : ariaOwneeID)
			aria-required=ariaRequired
			autoCapitalize=autoCapitalize
			autoComplete=autoComplete
			autoCorrect=autoCorrect
			className=className
			contentEditable=!readonly?
			data-testid=testid
			id=id
			role=(readonly? ? null : role)
			spellCheck=spellCheck
			style=style
			tabIndex=tabIndex
		>


