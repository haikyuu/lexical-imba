import type {EditorThemeClasses, LexicalEditor, LexicalNode} from 'lexical';
import {createEditor} from 'lexical';
import type {LexicalComposerContextType, LexicalComposerContextWithEditor} from './types'

export def create-lexical-composer-context(parent\(LexicalComposerContextWithEditor | null), theme\(EditorThemeClasses | null))
	let parentContext = null;
	if parent != null
		parentContext = parent[1];

	def getTheme
		if theme != null
			theme 
		elif parentContext != null
			parentContext.getTheme()
		else 
			null
	return {getTheme}

tag lexical-composer
	namespace\(string)
	nodes\(Array<Class<LexicalNode>>)
	onError\((error: Error, editor: LexicalEditor) => void)
	readonly?\(boolean) = false
	theme\(EditorThemeClasses)

	context
	def setup
		editor = createEditor({
			namespace,
			nodes,
			onError: (do(error) onError(error, editor)),
			readOnly: yes,
			theme,
		})
		editor.setReadOnly readonly?

	def render
		<self>
			<slot>

