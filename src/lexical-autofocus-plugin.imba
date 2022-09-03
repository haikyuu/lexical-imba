import type {LexicalEditor} from 'lexical'

tag lexical-autofocus-plugin
	@observable editor\LexicalEditor
	def mount
		editor = #context.editor
	@autorun
	def autofocus-effect
		return unless editor
		setTimeout(&, 1) do
			editor.focus!
			imba.commit!
		