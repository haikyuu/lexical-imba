import config from './rich-config'
# import './lexical-treeview-plugin'
import './lexical-toolbar-plugin'
import '../../src/index'
import { TRANSFORMERS } from "@lexical/markdown";

import {$getRoot, $getSelection} from 'lexical';

const {theme, onError, nodes} = config

tag rich-editor
	editor
	def mount
		editor = $composer.editor
		editor.registerUpdateListener do({editorState})
			editorState.read do
				let sel = $getSelection()
	def ce
		<lexical-content-editable.ContentEditable__root id="ce">
	def placeholder
		<.Placeholder__root>
			"Enter some plain text..."
	def render
		<self[bg:cooler8]>
			<lexical-composer$composer theme=theme onError=onError nodes=nodes>
				# add a plugin to index whenever it's added
				<.editor-container.tree-view>
					<lexical-toolbar-plugin>
					<.editor-inner>
						<lexical-rich-text-plugin content-editable=ce placeholder=placeholder>
						<lexical-history-plugin>
						<lexical-autofocus-plugin>
						<lexical-code-highlight-plugin>
						<lexical-list-plugin>
						<lexical-link-plugin>
						<lexical-list-max-indent-level-plugin max-depth=7>
						<lexical-md-shortcut-plugin transformers=TRANSFORMERS>
						<lexical-treeview-plugin>