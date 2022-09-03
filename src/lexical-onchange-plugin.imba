import type {EditorState, LexicalEditor} from 'lexical';

tag lexical-onchange-plugin
	@observable prop ignoreInitialChange = true
	@observable prop ignoreSelectionChange = false
	@observable prop onChange\Function
	
	@observable editor
	def mount
		editor = #context.editor
	@observable _decorators = []

	# usePlainTextSetup (depends on editor)
	@autorun
	def onchange-setup
		return unless editor
		editor.registerUpdateListener do({editorState, dirtyElements, dirtyLeaves, prevEditorState})
			return if ignoreSelectionChange and dirtyElements.size === 0 and dirtyLeaves.size === 0
			return if ignoreInitialChange and prevEditorState.isEmpty()
			onChange(editorState, editor)
			# imba.commit!