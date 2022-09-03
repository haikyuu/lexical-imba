import { registerCodeHighlighting } from '@lexical/code'
import type {EditorState, LexicalEditor} from 'lexical';

tag lexical-code-highlight-plugin
	@observable editor
	def mount
		editor = #context.editor

	# usePlainTextSetup (depends on editor)
	@autorun
	def code-highlight-setup
		return unless editor
		registerCodeHighlighting editor