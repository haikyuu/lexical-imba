import { TRANSFORMERS, registerMarkdownShortcuts } from '@lexical/markdown'
import { registerCodeHighlighting } from '@lexical/code'
import type { LexicalNode,EditorState, LexicalEditor} from 'lexical';
import type {ElementTransformer, Transformer} from '@lexical/markdown';

tag lexical-md-shortcut-plugin
	@observable editor
	@observable prop transformers\(Array<Transformer>) = TRANSFORMERS

	def mount
		editor = #context.editor

	# usePlainTextSetup (depends on editor)
	@autorun
	def md-shortcut-setup
		return unless editor
		registerMarkdownShortcuts(editor, transformers)